/*
 Copyright (c) 2011, Joey Gibson <joey@joeygibson.com>
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, 
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, 
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 * Neither the name of the author nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "GVoice.h"
#import "NSString-GVoice.h"
#import "ParsingUtils.h"
#import "GVoiceAllSettings.h"
#import "JSON.h"

#pragma mark - Private Properties
@interface GVoice ()
@property (nonatomic, retain) NSString *general;
@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, retain) NSString *captchaToken;
@property (nonatomic, retain) NSString *captchaUrl;
@property (nonatomic, retain) NSString *captchaUrl2;
@property (nonatomic, assign) NSInteger redirectCounter;
@property (nonatomic, retain) NSString *rnrSe;

- (NSString *) discoverRNRSE;
- (NSDictionary *) fetchGeneral;
@end

@implementation GVoice

#pragma mark - Public Properties
@synthesize accountType = _accountType;
@synthesize source = _source;
@synthesize user = _user;
@synthesize password = _password;
@synthesize authToken = _authToken;
@synthesize captchaToken = _captchaToken;
@synthesize captchaUrl = _captchaUrl;
@synthesize captchaUrl2 = _captchaUrl2;
@synthesize redirectCounter = _redirectCounter;
@synthesize errorCode = _errorCode;
@synthesize logToConsole = _logToConsole;
@synthesize general = _general;
@synthesize rnrSe = _rnrSe;
@synthesize allSettings = _allSettings;
@synthesize rawErrorText = _rawErrorText;

#pragma mark - Utility Methods
- (void) setErrorCodeFromReturnValue: (NSString *) retValue {
	if ([retValue isEqualToString: @"BadAuthentication"]) {
		self.errorCode = BadAuthentication;
	} else if ([retValue isEqualToString: @"NotVerified"]) {
		self.errorCode = NotVerified;
	} else if ([retValue isEqualToString: @"TermsNotAgreed"]) {
		self.errorCode = TermsNotAgreed;
	} else if ([retValue isEqualToString: @"CaptchaRequired"]) {
		self.errorCode = CaptchaRequired;
	} else if ([retValue isEqualToString: @"Unknown"]) {
		self.errorCode = Unknown;
	} else if ([retValue isEqualToString: @"AccountDeleted"]) {
		self.errorCode = AccountDeleted;
	} else if ([retValue isEqualToString: @"AccountDisabled"]) {
		self.errorCode = AccountDisabled;
	} else if ([retValue isEqualToString: @"ServiceDisabled"]) {
		self.errorCode = ServiceDisabled;
	} else if ([retValue isEqualToString: @"ServiceUnavailable"]) {
		self.errorCode = ServiceUnavailable;
	}
}

- (NSString *) accountTypeAsString {
	NSString *string;
	
	switch (self.accountType) {
		case GOOGLE:
			string = @"GOOGLE";
			break;
		case HOSTED:
			string = @"HOSTED";
			break;
		case HOSTED_OR_GOOGLE:
			string = @"HOSTED_OR_GOOGLE";
			break;
	}
	
	return string;
}

- (NSString *) errorDescription {
	NSString *retString;
	
	switch (self.errorCode) {
		case NoError:
			retString = @"";
			break;
		case BadAuthentication:
			retString = @"Wrong username or password.";
			break;
		case NotVerified:
			retString = @"The account email address has not been verified. You need to access your Google account directly to resolve the issue before logging in using google-voice-java.";
			break;
		case TermsNotAgreed:
			retString = @"You have not agreed to terms. You need to access your Google account directly to resolve the issue before logging in using google-voice-java.";
			break;
		case CaptchaRequired:
			retString = @"A CAPTCHA is required. (A response with this error code will also contain an image URL and a CAPTCHA token.)";
			break;
		case Unknown:
			retString = @"Unknown or unspecified error; the request contained invalid input or was malformed.";
			break;
		case AccountDeleted:
			retString = @"The user account has been deleted.";
			break;
		case AccountDisabled:
			retString = @"The user account has been disabled.";
			break;
		case ServiceDisabled:
			retString = @"Your access to the voice service has been disabled. (Your user account may still be valid.)";
			break;
		case ServiceUnavailable:
			retString = @"The service is not available; try again later.";
			break;
		case TooManyRedirects:
			retString = @"Too many redirects to handle.";
			break;
	}
	
	return retString;
}

#pragma mark - Initialization Methods
- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (GVoiceAccountType) accountType {
	self = [super init];
	
	if (self) {
		self.user = user;
		self.password = password;
		self.source = source;
		self.accountType = accountType;
	}
	
	return self;
}

#pragma mark - Login Methods
- (BOOL) login {
	return [self loginWithCaptchaResponse: nil captchaToken: nil];
}

- (BOOL) loginWithCaptchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken {
	BOOL ok = NO;
	
	NSString *data = [NSString stringWithFormat: @"accountType=%@&Email=%@&Passwd=%@&service=%@&source=%@", 
					  self.accountTypeAsString,
					  self.user.urlEncoded,
					  self.password.urlEncoded,
					  SERVICE.urlEncoded,
					  self.source.urlEncoded];
	
	if (captchaResponse && captchaToken) {
		data = [data stringByAppendingFormat: @"&logintoken=%@&logincaptcha=%@",
				captchaToken.urlEncoded, 
				captchaResponse.urlEncoded];
	}
	
	NSData *requestData = [NSData dataWithBytes: [data UTF8String] length: [data length]];
	
	NSURL *url = [NSURL URLWithString: LOGIN_URL_STRING];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
	
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: requestData];
	[request setValue: USER_AGENT forHTTPHeaderField: USER_AGENT_HEADER];

	NSURLResponse *resp = nil;
	NSError *err = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
	
	if (err) {
		if (self.logToConsole) {
			NSLog(@"GVoice Login Error: %@", err);
		}
		
		self.errorCode = Unknown;
		
		ok = NO;
	} else {
		NSString *retString = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
		
		NSArray *lines = [retString componentsSeparatedByString: @"\n"];
		
		for (NSString *line in lines) {
			NSRange errorRange = [line rangeOfString: @"Error"];
			
			if (errorRange.location != NSNotFound) {
				NSArray *tokens = [line componentsSeparatedByString: @"="];
				
				[self setErrorCodeFromReturnValue: [tokens objectAtIndex: 1]];
				ok = NO;
				
				break;
			} else {			
				NSRange textRange = [line rangeOfString: @"Auth"];
				
				if (textRange.location != NSNotFound) {
					NSArray *tokens = [line componentsSeparatedByString: @"="];
					self.authToken = [tokens objectAtIndex: 1];
					break;
				}
			}
		}

		if (self.authToken) {
			ok = YES;
		}
				
		[retString release];		
	}
	
	[request release];
	
	if (ok) {
		NSDictionary *dict = [self fetchGeneral];
		
		self.general = [dict objectForKey: RAW_DATA];
		
		if (self.general) {
			self.rnrSe = [self discoverRNRSE];
		}
		
		[self fetchSettings];
	}
	
	return ok;
}

#pragma mark - Private Methods
- (NSString *) fullAuthString {
	return [NSString stringWithFormat: @"GoogleLogin auth=%@", self.authToken];	
}

- (void) clearError {
	self.errorCode = NoError;
	self.rawErrorText = nil;
}

- (void) signalError: (NSDictionary *) dict {
	self.errorCode = Unknown;
	self.rawErrorText = [NSString stringWithFormat: @"%@", dict];
}

- (NSDictionary *) fetchPage: (NSInteger) page fromUrl: (NSString *) urlString asDictionary: (BOOL) asDictionary {
	[self clearError];
	
	NSString *fullUrlString;
	
	if (page == 0) {
		fullUrlString = urlString;
	} else {
		fullUrlString = [urlString stringByAppendingFormat: @"?page=p%d", page];
	}
	
	NSURL *url = [NSURL URLWithString: fullUrlString];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
		
	[request setValue: [self fullAuthString] forHTTPHeaderField: AUTHORIZATION_HEADER];
	[request setValue: USER_AGENT forHTTPHeaderField: USER_AGENT_HEADER];

	NSHTTPURLResponse *resp = nil;
	NSError *err = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
	NSString *retString = nil;
	NSDictionary *dict = nil;
	
	if (err) {
		if (self.logToConsole) {
			NSLog(@"GVoice Fetch Error: %@", err);
		}
		
		self.errorCode = Unknown;
	} else {
		NSInteger statusCode = resp.statusCode;
		
		if (statusCode == 200) {
			retString = [[[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding] autorelease];
			
			if (retString) {
				if (asDictionary) {
					NSString *jsonSubStr = [ParsingUtils removeTextSurrounding: retString
																  startingWith: @"<json><![CDATA["
																	endingWith: @"]]></json>"
															   includingTokens: NO];
					
					SBJsonParser *json = [[SBJsonParser alloc] init];
					dict = [json objectWithString: jsonSubStr];
					
					[json release];
				} else {
					dict = [NSDictionary dictionaryWithObject: retString forKey: RAW_DATA];
				}
			}
		} else if (statusCode == 301 ||
				   statusCode == 302 ||
				   statusCode == 303 ||
				   statusCode == 307) {
			self.redirectCounter++;
			
			if (self.redirectCounter > MAX_REDIRECTS) {
				self.redirectCounter = 0;
				
				self.errorCode = TooManyRedirects;
			}
			
			// Need to handle redirect
		}
	}
	
	[request release];
	
	if (!dict || [dict count] == 0) {
		self.errorCode = Unknown;
		self.rawErrorText = retString;
	}
	
	return dict;
}

- (NSDictionary *) fetchPage: (NSInteger) page fromUrl: (NSString *) urlString {
	return [self fetchPage: page fromUrl: urlString asDictionary: YES];
}

- (NSDictionary *) fetchFromUrl: (NSString *) urlString asDictionary: (BOOL) asDictionary {
	return [self fetchPage: 0 fromUrl: urlString asDictionary: asDictionary];
}

- (NSDictionary *) fetchFromUrl: (NSString *) urlString {
	return [self fetchPage: 0 fromUrl: urlString asDictionary: YES];
}

- (NSDictionary *) postParameters: (NSString *) params toUrl: (NSString *) urlString {
	[self clearError];
	
	NSData *requestData = [NSData dataWithBytes: [params UTF8String] length: [params length]];
	
	NSURL *url = [NSURL URLWithString: urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
	
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: requestData];
	
	[request setValue: [self fullAuthString] forHTTPHeaderField: AUTHORIZATION_HEADER];
	[request setValue: USER_AGENT forHTTPHeaderField: USER_AGENT_HEADER];
	
	NSURLResponse *resp = nil;
	NSError *err = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
	NSString *retString = nil;
	
	if (err) {
		if (self.logToConsole) {
			NSLog(@"GVoice POST Error: %@", err);
		}
		
		self.errorCode = Unknown;
	} else {
		retString = [[[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding] autorelease];
	}
	
	[request release];
	
	NSString *jsonSubStr = [ParsingUtils removeTextSurrounding: retString
												  startingWith: @"<json><![CDATA["
													endingWith: @"]]></json>"
											   includingTokens: NO];

	SBJsonParser *json = [[SBJsonParser alloc] init];
	NSDictionary *dict = [json objectWithString: jsonSubStr];
	
	[json release];
	
	if (!dict || [dict count] == 0) {
		self.errorCode = Unknown;
		self.rawErrorText = retString;
	}
	
	return dict;
}

- (NSString *) discoverRNRSE {
	NSString *rnr = nil;
	
	if (self.general) {
		NSArray *chunks = [self.general componentsSeparatedByString: @"'_rnr_se': '"];
		
		if (chunks && [chunks count] >= 2) {
			NSString *rnrSsMajor = [chunks objectAtIndex: 1];
			NSArray *rnrChunks = [rnrSsMajor componentsSeparatedByString: @"',"];
			
			if (rnrChunks && [rnrChunks count] > 0) {
				rnr = [rnrChunks objectAtIndex: 0];
			}
		}
	}

	return rnr;
}

- (NSArray *) enableOrDisable: (BOOL) enabled phones: (NSArray *) phones  {
	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
	
	for (int i = 0; i < [phones count]; i++) {
		NSInteger phoneId = [[phones objectAtIndex: i] integerValue];
		
		BOOL res;
		
		if (enabled) {
			res = [self enablePhone: phoneId];	
		} else {
			res = [self disablePhone: phoneId];
		}
		
		[results addObject: [NSNumber numberWithBool: res]];
	}
	
	return results;
}

- (BOOL) isPhoneEnabled: (NSInteger) phoneId {
	BOOL found = NO;
	
	for (NSNumber *num in self.allSettings.settings.disabledIds) {
		if ([num integerValue] == phoneId) {
			found = YES;
			break;
		}
	}
	
	// If the id IS found, that means it it disabled.
	return !found;
}

#pragma mark - Life Cycle Methods
- (void)dealloc {	
    [_source release], _source = nil;
    [_user release], _user = nil;
    [_password release], _password = nil;
    [_authToken release], _authToken = nil;
    [_captchaToken release], _captchaToken = nil;
    [_captchaUrl release], _captchaUrl = nil;
    [_captchaUrl2 release], _captchaUrl2 = nil;
    [_general release], _general = nil;
    [_rnrSe release], _rnrSe = nil;	
    [_allSettings release], _allSettings = nil;
	[_rawErrorText release], _rawErrorText = nil;
	
	[super dealloc];
}

#pragma mark - Google Voice Methods
- (GVoiceAllSettings *) fetchSettings {
	return [self forceFetchSettings: NO];
}

- (GVoiceAllSettings *) forceFetchSettings: (BOOL) force {
	if (!self.allSettings || force) {
		NSDictionary *dict = [self fetchFromUrl: GROUPS_INFO_URL_STRING];

		GVoiceAllSettings *settings = [[GVoiceAllSettings alloc] initWithDictionary: dict];
		
		self.allSettings = settings;
		
		[settings release];
	}
	
	return self.allSettings;
}

- (NSDictionary *) fetchGeneral {
	return [self fetchFromUrl: GENERAL_URL_STRING asDictionary: NO];
}

- (BOOL) disablePhone: (NSInteger) phoneId {
	NSString *paramString = [NSString stringWithFormat: @"enabled=0&phoneId=%d&_rnr_se=%@", phoneId, [self.rnrSe urlEncoded]];
	
	NSDictionary *resDict = [self postParameters: paramString toUrl: PHONE_ENABLE_URL_STRING];
	
	BOOL res = [[resDict objectForKey: @"ok"] boolValue];
	
	if (res) {
		NSMutableDictionary *disabledPhones = [self.allSettings.settings.disabledIds mutableCopy];
		[disabledPhones setValue: [NSNumber numberWithBool: YES] forKey: [NSString stringWithFormat: @"%d", phoneId]];
		
		self.allSettings.settings.disabledIds = disabledPhones;
		
		[disabledPhones release];
	} else {
		[self signalError: resDict];
	}
	
	return res;
}

- (BOOL) enablePhone: (NSInteger) phoneId {
	NSString *paramString = [NSString stringWithFormat: @"enabled=1&phoneId=%d&_rnr_se=%@", phoneId, [self.rnrSe urlEncoded]];

	NSDictionary *resDict = [self postParameters: paramString toUrl: PHONE_ENABLE_URL_STRING];
	
	BOOL res = [[resDict objectForKey: @"ok"] boolValue];
	
	if (res) {
		NSMutableDictionary *disabledPhones = [self.allSettings.settings.disabledIds mutableCopy];
		NSString *num = [NSString stringWithFormat: @"%d", phoneId];
		
		[disabledPhones removeObjectForKey: num];
		
		self.allSettings.settings.disabledIds = disabledPhones;
		
		[disabledPhones release];
	} else {
		[self signalError: resDict];
	}
	
	return res;
}

- (NSArray *) disablePhones: (NSArray*) phones {
	return [self enableOrDisable: NO phones: phones];
}

- (NSArray *) enablePhones: (NSArray*) phones {
	return [self enableOrDisable: YES phones: phones];	
}

- (NSDictionary *) fetchInbox {
	return [self fetchInboxPage: 0];
}

- (NSDictionary *) fetchInboxPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: INBOX_URL_STRING];
}

- (NSDictionary *) fetchMissed {
	return [self fetchMissedPage: 0];
}

- (NSDictionary *) fetchMissedPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: MISSED_URL_STRING];
}

- (NSDictionary *) fetchPlaced {
	return [self fetchPlacedPage: 0];
}

- (NSDictionary *) fetchPlacedPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: PLACED_URL_STRING];
}

- (NSDictionary *) fetchRawPhonesInfo {
	return [self fetchFromUrl: PHONES_INFO_URL_STRING];
}

- (NSDictionary *) fetchReceived {
	return [self fetchReceivedPage: 0];
}

- (NSDictionary *) fetchReceivedPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: RECEIVED_URL_STRING];
}

- (NSDictionary *) fetchRecent {
	return [self fetchRecentPage: 0];
}

- (NSDictionary *) fetchRecentPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: RECENT_ALL_URL_STRING];
}

- (NSDictionary *) fetchRecorded {
	return [self fetchRecordedPage: 0];
}

- (NSDictionary *) fetchRecordedPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: RECORDED_URL_STRING];
}

- (NSDictionary *) fetchSms {
	return [self fetchSmsPage: 0];
}

- (NSDictionary *) fetchSmsPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: SMS_URL_STRING];
}

- (NSDictionary *) fetchSpam {
	return [self fetchSpamPage: 0];
}

- (NSDictionary *) fetchSpamPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: SPAM_URL_STRING];
}

- (NSDictionary *) fetchStarred {
	return [self fetchStarredPage: 0];
}

- (NSDictionary *) fetchStarredPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: STARRED_URL_STRING];
}

- (BOOL) sendSmsText: (NSString *) text toNumber: (NSString *) number {
	NSString *params = [NSString stringWithFormat: @"phoneNumber=%@&text=%@&_rnr_se=%@",
						[number urlEncoded],
						[text urlEncoded],
						[self.rnrSe urlEncoded]];
	
	NSDictionary *dict = [self postParameters: params toUrl: SMS_SEND_URL_STRING];
	
	BOOL res = [[dict objectForKey: @"ok"] boolValue];
	
	if (!res) {
		[self signalError: dict];
	}
	
	return res;
}

// "Call Presentation" is the pretty name for "directConnect". So, if directConnect is YES,
// then calls will NOT be presented (i.e. you won't get an announcement, and ask if you want 
// to take the call). If it is NO, then you WILL be asked if you want to take the call.
- (BOOL) enableCallPresentation: (BOOL) enable {
	NSString *params = [NSString stringWithFormat: @"directConnect=%d&_rnr_se=%@",
						(enable ? 0 : 1),
						[self.rnrSe urlEncoded]];
	
	NSDictionary *dict = [self postParameters: params toUrl: GENERAL_SETTING_URL_STRING];
	
	BOOL res = [[dict objectForKey: @"ok"] boolValue];
	
	if (res) {
		self.allSettings.settings.directConnect = enable;
	} else {
		[self signalError: dict];
	}
	
	return res;
}

- (BOOL) enableDoNotDisturb: (BOOL) doNotDisturb {
	NSString *params = [NSString stringWithFormat: @"doNotDisturb=%d&_rnr_se=%@",
						(doNotDisturb ? 1 : 0),
						[self.rnrSe urlEncoded]];
	
	NSDictionary *dict = [self postParameters: params toUrl: GENERAL_SETTING_URL_STRING];
	
	BOOL res = [[dict objectForKey: @"ok"] boolValue];
	
	if (res) {
		self.allSettings.settings.doNotDisturb = doNotDisturb;
	} else {
		[self signalError: dict];
	}
	
	return res;
}

- (BOOL) doNotDisturbEnabled {
	return self.allSettings.settings.doNotDisturb;
}

- (BOOL) selectGreeting: (NSInteger) greetingId {
	NSString *params = [NSString stringWithFormat: @"greetingId=%d&_rnr_se=%@",
						greetingId,
						[self.rnrSe urlEncoded]];
	
	NSDictionary *dict = [self postParameters: params toUrl: GENERAL_SETTING_URL_STRING];
	
	BOOL res = [[dict objectForKey: @"ok"] boolValue];
	
	if (res) {
		self.allSettings.settings.defaultGreetingId = greetingId;
	} else {
		[self signalError: dict];
	}
	
	return res;
}

// "Call Presentation" is the pretty name for "directConnect". So, if directConnect is YES,
// then calls will NOT be presented (i.e. you won't get an announcement, and ask if you want 
// to take the call). If it is NO, then you WILL be asked if you want to take the call.
- (BOOL) directConnectEnabled {
	return self.allSettings.settings.directConnect;
}

- (NSInteger) defaultGreetingId {
	return self.allSettings.settings.defaultGreetingId;
}

- (NSArray *) greetings {
	return self.allSettings.settings.greetings;
}

- (NSArray *) groupList {
	return [NSArray arrayWithArray: self.allSettings.settings.groupList];
}

- (NSDictionary *) groups {
	return [NSDictionary dictionaryWithDictionary: self.allSettings.settings.groups];
}

- (GVoiceGroup *) group: (NSString *) groupId {
	GVoiceGroup *groupCopy = nil;
	GVoiceGroup *group = [self.allSettings.settings.groups objectForKey: groupId];
	
	if (group) {
		groupCopy = [GVoiceGroup groupWithGroup: group];
	}
	
	return groupCopy;
}

- (BOOL) callNumber: (NSString *) destinationNumber fromPhoneId: (NSInteger) phoneId {
	NSString *idString = [NSString stringWithFormat: @"%d", phoneId];
	
	NSDictionary *dict = [self.allSettings.phones objectForKey: idString];
	
	if (!dict) {
		// Set some error value
		return NO;
	}
	
	NSString *originPhoneNumber = [dict objectForKey: @"phoneNumber"];
	NSString *phoneType = [NSString stringWithFormat: @"%d", [[dict objectForKey: @"type"] intValue]];
	
	NSString *params = [NSString stringWithFormat: @"outgoingNumber=%@&forwardingNumber=%@"
						"&subscriberNumber=undefined&phoneType=%@&remember=0&_rnr_se=%@",
						[destinationNumber urlEncoded],
						[originPhoneNumber urlEncoded],
						[phoneType urlEncoded],
						[self.rnrSe urlEncoded]];
	
	NSDictionary *resDict = [self postParameters: params toUrl: CALL_URL_STRING];
	
	BOOL res = [[resDict objectForKey: @"ok"] boolValue];
	
	if (!res) {
		[self signalError: resDict];
	}
	
	return res;
}

- (BOOL) cancelCallToNumber: (NSString *) destinationNumber fromPhoneId: (NSInteger) phoneId {
	NSString *params = [NSString stringWithFormat: @"outgoingNumber=undefined&forwardingNumber=undefined&cancelType=%@&_rnr_se=%@",
						[@"C2C" urlEncoded],
						[self.rnrSe urlEncoded]];

	NSDictionary *dict = [self postParameters: params toUrl: CANCEL_CALL_URL_STRING];
	
	BOOL res = [[dict objectForKey: @"ok"] boolValue];
	
	if (!res) {
		[self signalError: dict];
	}
	
	return res;
}

- (BOOL) saveSettingsForGroup: (GVoiceGroup *) group {
	NSString *disabledPhoneIds = [[group.disabledForwardingIds allKeys] componentsJoinedByString: @"&disabledPhoneIds="];
	
	if (disabledPhoneIds) {
		disabledPhoneIds = [NSString stringWithFormat: @"&disabledPhoneIds=%@", disabledPhoneIds];
	}
	
	NSString *paramString = [NSString stringWithFormat: @"isCustomGreeting=%d&greetingId=%d%@&directConnect=%d"
							 "&isCustomDirectConnect=%d&isCustomForwarding=%d&id=%@&_rnr_se=%@",
							 group.customGreeting,
							 group.greetingId,
							 disabledPhoneIds,
							 group.directConnect,
							 group.customDirectConnect,
							 group.customForwarding,
							 [group.id urlEncoded],
							 [self.rnrSe urlEncoded]];
	
	
	NSDictionary *dict = [self postParameters: paramString toUrl: GROUPS_SETTINGS_URL_STRING];
	
	BOOL res = [[dict objectForKey: @"ok"] boolValue];
	
	if (res) {
		NSMutableDictionary *groups = [self.allSettings.settings.groups mutableCopy];
		[groups setValue: group forKey: group.id];
		
		self.allSettings.settings.groups = groups;
		
		[groups release];
	} else {
		[self signalError: dict];
	}
	
	return res;	 
}

- (BOOL) isLoggedIn {
	NSDictionary *dict = [self fetchRecent];

	return dict != nil;
}

@end
