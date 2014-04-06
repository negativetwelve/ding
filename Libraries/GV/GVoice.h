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

#import <Foundation/Foundation.h>
#import "GVoiceGroup.h"

@class GVoiceAllSettings;

// Important Constants
#define SERVICE @"grandcentral"

#define MAX_REDIRECTS 5
#define USER_AGENT @"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.A.B.C Safari/525.13"

#define RAW_DATA @"RAW_DATA"

// HTTP Headers
#define AUTHORIZATION_HEADER @"Authorization"
#define USER_AGENT_HEADER @"User-agent"

// The URLs that lead to various parts of Google Voice.
#define GENERAL_URL_STRING @"https://www.google.com/voice/b/0/"
#define LOGIN_URL_STRING @"https://www.google.com/accounts/ClientLogin"
#define INBOX_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/inbox/"
#define STARRED_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/starred/"
#define RECENT_ALL_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/all/"
#define SPAM_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/spam/"
#define TRASH_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/trash/"
#define VOICE_MAIL_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/voicemail/"
#define SMS_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/sms/"
#define RECORDED_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/recorded/"
#define PLACED_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/placed/"
#define RECEIVED_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/received/"
#define MISSED_URL_STRING @"https://www.google.com/voice/b/0/inbox/recent/missed/"
#define PHONE_ENABLE_URL_STRING @"https://www.google.com/voice/b/0/settings/editDefaultForwarding/"
#define GENERAL_SETTING_URL_STRING @"https://www.google.com/voice/b/0/settings/editGeneralSettings/"
#define PHONES_INFO_URL_STRING @"https://www.google.com/voice/b/0/settings/tab/phones"
#define GROUPS_INFO_URL_STRING @"https://www.google.com/voice/b/0/settings/tab/groups"
#define VOICE_MAIL_INFO_URL_STRING @"https://www.google.com/voice/b/0/settings/tab/voicemailsettings"
#define GROUPS_SETTINGS_URL_STRING @"https://www.google.com/voice/b/0/settings/editGroup/"
#define SMS_SEND_URL_STRING @"https://www.google.com/voice/b/0/sms/send/"
#define CALL_URL_STRING @"https://www.google.com/voice/b/0/call/connect/"
#define CANCEL_CALL_URL_STRING @"https://www.google.com/voice/b/0/call/cancel/"

/**
 * Error codes that can come back from Google Voice.
 */
typedef enum {
	NoError,
	BadAuthentication,
	NotVerified,
	TermsNotAgreed,
	CaptchaRequired,
	Unknown,
	AccountDeleted,
	AccountDisabled,
	ServiceDisabled,
	ServiceUnavailable,
	TooManyRedirects
} GVoiceErrorCode;

/**
 * Types of Google Voice accounts.
 *
 * It's better to use either GOOGLE or HOSTED, but not the 
 * combined HOSTED_OR_GOOGLE.
 */
typedef enum {
	GOOGLE,
	HOSTED,
	HOSTED_OR_GOOGLE
} GVoiceAccountType;

/**
 * @author Joey Gibson <joey@joeygibson.com>
 * @since 04/11/2011
 *
 * @mainpage
 * This is an iOS library in Objective-C for interacting with Google Voice.
 *
 * I borrowed liberally from <a href="http://code.google.com/p/google-voice-java/">google-voice-java</a> which, as its name implies, 
 * was written in Java. This is not a direct port of google-voice-java, however. I made changes that made sense for Objective-C, 
 * and took several of the methods farther than they had been, returning NSDictionary objects with useful contents, instead of just raw strings.
 *
 * It also makes use of <a href="http://code.google.com/p/json-framework/">json-framework</a> for dealing with the <tt>JSON</tt> responses from Google Voice. 
 *
 * <strong>Note: This library is not affiliated with Google in any way.</strong>
 *
 * This class provides methods to do most of what you'd want to
 * do with Google Voice. You can send SMS messages, initiate calls, enable/disable phones, change 
 * various settings, and download messages. Among other things.
 */
@interface GVoice : NSObject {
    @private
	GVoiceAccountType _accountType;
	NSString *_source;
	NSString *_user;
	NSString *_password;
	NSString *_authToken;
	NSString *_captchaToken;
	NSString *_captchaUrl;
	NSString *_captchaUrl2;
	NSInteger _redirectCounter;
	GVoiceErrorCode _errorCode;
	BOOL _logToConsole;
	
	NSString *_general;
	NSString *_rnrSe;
	GVoiceAllSettings *_allSettings;
	NSString *_rawErrorText;
}

/**
 * What type of Google Voice account we are working with.
 */
@property (nonatomic, assign) GVoiceAccountType accountType;

/**
 * Source is required by Google. 
 *
 * It should be of the form company-product-version
 *
 * @see http://code.google.com/apis/accounts/docs/AuthForInstalledApps.html#Request
 */
@property (nonatomic, retain) NSString *source;

/**
 * The username that will be used for GV access.
 */
@property (nonatomic, retain) NSString *user;

/**
 * The password that will be used for GV access.
 */
@property (nonatomic, retain) NSString *password;

/**
 * The result of some sort of error from GV. 
 */
@property (nonatomic, assign) GVoiceErrorCode errorCode;

/**
 * Whether to log output using NSLog(). 
 *
 * Default is NO.
 */
@property (nonatomic, assign) BOOL logToConsole;

/**
 * The top-level settings for GV. 
 */
@property (nonatomic, retain) GVoiceAllSettings *allSettings;

/**
 * Convenience access to allSettings.settings.defaultGreetingId
 */
@property (readonly) NSInteger defaultGreetingId;

/**
 * Convenience access to allSettings.settings.directConnect
 */
@property (readonly) BOOL directConnectEnabled;

/**
 * Convenience access to allSettings.settings.doNotDisturb
 */
@property (readonly) BOOL doNotDisturbEnabled;

/**
 * If an error of type Unknown occurrs, we will stick whatever we got back 
 * from GV here as a debugging aid.
 */
@property (nonatomic, retain) NSString *rawErrorText;

/**
 * Convenience access to allSettings.settings.groupList
 */
@property (readonly) NSArray *groupList;

/**
 * Convenience access to allSettings.settings.groups
 */
@property (readonly) NSDictionary *groups;

/**
 * The designated initializer.
 *
 * This creates a GVoice object that is ready for use, though it has NOT been logged-in yet.
 * @param user the user's GV username
 * @param password the user's GV password
 * @param source the parameter required by GV for logging
 * @param accountType what type of account we are working with
 *
 * @see GVoiceAccountType
 * @see http://code.google.com/apis/accounts/docs/AuthForInstalledApps.html#Request
 */
- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (GVoiceAccountType) accountType;

/**
 * Logs in to Google Voice. The username and password were set during initialization, so there are no parameters needed here.
 */
- (BOOL) login;

/**
 * Logs in to Google Voice, including a CAPTCHA response. This will only be necessary if you had enough 
 * failed login attempts that Google threw back a CAPTCHA challenge.
 */
- (BOOL) loginWithCaptchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken;

/**
 * Provides an English explanation of the value in errorCode.
 */
- (NSString *) errorDescription;

/**
 * Fetches all the settings from Google Voice.
 *
 * This will ONLY fetch them if we don't have them yet.
 */
- (GVoiceAllSettings *) fetchSettings;

/**
 * Fetches all the settings from Google Voice.
 *
 * This will fetch them if we haven't yet, or if force is YES.
 * @param force should we force a reload or not - default is NO.
 */
- (GVoiceAllSettings *) forceFetchSettings: (BOOL) force;

/**
 * Tests whether the phone with the given id is enabled to receive calls.
 * @param phoneId the id assigned by GV for a given phone
 * @returns YES or NO
 */
- (BOOL) isPhoneEnabled: (NSInteger) phoneId;

/**
 * Disables a phone from receiving calls.
 * @param phoneId the id assigned by GV for a given phone
 * @returns YES or NO if it worked or not
 */
- (BOOL) disablePhone: (NSInteger) phoneId;

/**
 * Enables a phone to receiving calls.
 * @param phoneId the id assigned by GV for a given phone
 * @returns YES or NO if it worked or not
 */
- (BOOL) enablePhone: (NSInteger) phoneId;

/**
 * Allows you to disable several phones at once.
 *
 * This method just loops over each id in the passed-in array, and calls GVoice#disablePhone
 * @param phones an NSArray of phoneIds
 * @returns an NSArray of BOOL indicating the success or failure of each operation
 */
- (NSArray *) disablePhones: (NSArray*) phones;

/**
 * Allows you to enable several phones at once.
 *
 * This method just loops over each id in the passed-in array, and calls GVoice#enablePhone
 * @param phones an NSArray of phoneIds
 * @returns an NSArray of BOOL indicating the success or failure of each operation
 */
- (NSArray *) enablePhones: (NSArray*) phones;

/**
 * Fetches the Inbox from GV, storing the results in an NSDictionary.
 * @returns NSDictionary of Inbox contents
 */
- (NSDictionary *) fetchInbox;

/**
 * Fetches the specified page of the Inbox from GV, storing the results in an NSDictionary.
 * @param page the page number, starting at 1
 * @returns NSDictionary of Inbox contents
 */
- (NSDictionary *) fetchInboxPage: (NSInteger) page;

/**
 * Fetches the Missed calls from GV, storing the results in an NSDictionary.
 * @returns NSDictionary of Missed calls contents
 */
- (NSDictionary *) fetchMissed;

/**
 * Fetches the specified page of the Missed calls from GV, storing the results in an NSDictionary.
 * @param page the page number, starting at 1
 * @returns NSDictionary of Missed calls contents
 */
- (NSDictionary *) fetchMissedPage: (NSInteger) page;

/**
 * Fetches the Placed calls from GV, storing the results in an NSDictionary.
 * @returns NSDictionary of Placed calls contents
 */
- (NSDictionary *) fetchPlaced;

/**
 * Fetches the specified page of the Placed calls from GV, storing the results in an NSDictionary.
 * @param page the page number, starting at 1
 * @returns NSDictionary of Placed calls contents
 */
- (NSDictionary *) fetchPlacedPage: (NSInteger) page;


- (NSDictionary *) fetchRawPhonesInfo;

/**
 * Fetches the Received calls from GV, storing the results in an NSDictionary.
 * @returns NSDictionary of Received calls contents
 */
- (NSDictionary *) fetchReceived;

/**
 * Fetches the specified page of the Received calls from GV, storing the results in an NSDictionary.
 * @param page the page number, starting at 1
 * @returns NSDictionary of Received calls contents
 */
- (NSDictionary *) fetchReceivedPage: (NSInteger) page;

/**
 * Fetches the Recent calls from GV, storing the results in an NSDictionary.
 * @returns NSDictionary of Recent calls contents
 */
- (NSDictionary *) fetchRecent;

/**
 * Fetches the specified page of the Recent calls from GV, storing the results in an NSDictionary.
 * @param page the page number, starting at 1
 * @returns NSDictionary of Recent calls contents
 */
- (NSDictionary *) fetchRecentPage: (NSInteger) page;

/**
 * Fetches the Recorded calls from GV, storing the results in an NSDictionary.
 * @returns NSDictionary of Recorded calls contents
 */
- (NSDictionary *) fetchRecorded;

/**
 * Fetches the specified page of the Recorded calls from GV, storing the results in an NSDictionary.
 * @param page the page number, starting at 1
 * @returns NSDictionary of Recorded calls contents
 */
- (NSDictionary *) fetchRecordedPage: (NSInteger) page;

/**
 * Fetches the SMS messages from GV, storing the results in an NSDictionary.
 * @returns NSDictionary of SMS messages contents
 */
- (NSDictionary *) fetchSms;

/**
 * Fetches the specified page of the SMS messages from GV, storing the results in an NSDictionary.
 * @param page the page number, starting at 1
 * @returns NSDictionary of SMS messages contents
 */
- (NSDictionary *) fetchSmsPage: (NSInteger) page;

/**
 * Fetches the Spam calls from GV, storing the results in an NSDictionary.
 * @returns NSDictionary of Spam calls contents
 */
- (NSDictionary *) fetchSpam;

/**
 * Fetches the specified page of the Spam calls from GV, storing the results in an NSDictionary.
 * @param page the page number, starting at 1
 * @returns NSDictionary of Spam calls contents
 */
- (NSDictionary *) fetchSpamPage: (NSInteger) page;

/**
 * Fetches the Starred calls from GV, storing the results in an NSDictionary.
 * @returns NSDictionary of Starred calls contents
 */
- (NSDictionary *) fetchStarred;

/**
 * Fetches the specified page of the Starred calls from GV, storing the results in an NSDictionary.
 * @param page the page number, starting at 1
 * @returns NSDictionary of Starred calls contents
 */
- (NSDictionary *) fetchStarredPage: (NSInteger) page;

/**
 * Sends an SMS message to the specified mobile phone.
 * @param text the text of the message to send
 * @param number the mobile phone number to send the message to
 * @returns YES or NO, whether it sent the message or not
 */
- (BOOL) sendSmsText: (NSString *) text toNumber: (NSString *) number;

/**
 * Causes Google Voice to ask if you want to accept the call or not.
 *
 * The actual property at GV is called directConnect. Calling it "call presentation" 
 * is sort of backward, but that's how they do it. If you enable call presentation, 
 * then when you answer a call, you hear a message asking you to press 1 to accept. If
 * you disable call presentation, then the call comes straight through.
 * @param enable YES to turn it on, NO to turn it off
 * @param YES or NO, if the change was made
 */
- (BOOL) enableCallPresentation: (BOOL) enable;

/**
 * Turn DoNotDisturb on or off.
 * @param doNotDisturb YES to enable, NO to disable
 * @returns YES or NO, if the change was made
 */
- (BOOL) enableDoNotDisturb: (BOOL) doNotDisturb;

/**
 * Specify which voicemail greeting you want callers to hear.
 * @param greetingId the id assigned to a given greeting by GV
 * @returns YES or NO, if the change was made
 */
- (BOOL) selectGreeting: (NSInteger) greetingId;

/**
 * Call a phone, attaching it to the specified phoneId.
 * @param destinationNumber the phone number to call
 * @param phoneId the Google Voice id of the phone you want to use for the call
 * @returns YES or NO, if the operation succeeded or not
 */
- (BOOL) callNumber: (NSString *) destinationNumber fromPhoneId: (NSInteger) phoneId;

/**
 * Cancel a call between the destination number and the specified phoneId, that was begun
 * with callNumber:fromPhoneId.
 * @param destinationNumber the phone number to call
 * @param phoneId the Google Voice id of the phone you want to use for the call
 * @returns YES or NO, if the operation succeeded or not
 */
- (BOOL) cancelCallToNumber: (NSString *) destinationNumber fromPhoneId: (NSInteger) phoneId;

/**
 * Sends local group changes to the server.
 * @param group the group to update
 * @returns YES or NO, if the operation succeded or not
 */
- (BOOL) saveSettingsForGroup: (GVoiceGroup *) group;

/**
 * Returns an immutable copy of the requested group.
 * @param groupId the id of the group to fetch
 * @returns an imutable copy of the reqested group
 */
- (GVoiceGroup *) group: (NSString *) groupId;

/**
 * Checks to see if the user is currently logged in ot not.
 * @returns YES or NO, if they are logged in or not.
 */
- (BOOL) isLoggedIn;

@end
