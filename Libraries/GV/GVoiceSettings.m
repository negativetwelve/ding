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

#import "GVoiceSettings.h"
#import "GVoiceGroup.h"

@implementation GVoiceSettings

@synthesize activeForwardingList = _activeForwardingList;
@synthesize baseUrl = _baseUrl;
@synthesize credits = _credits;
@synthesize defaultGreetingId = _defaultGreetingId;
@synthesize didInfos = _didInfos;
@synthesize directConnect = _directConnect;
@synthesize disabledIds = _disabledIds;
@synthesize doNotDisturb = _doNotDisturb;
@synthesize emailAddresses = _emailAddresses;
@synthesize emailNotificationActive = _emailNotificationActive;
@synthesize emailNotificationAddress = _emailNotificationAddress;
@synthesize greetings = _greetings;
@synthesize groupList = _groupList;
@synthesize groups = _groups;
@synthesize language = _language;
@synthesize primaryDid = _primaryDid;
@synthesize screenBehavior = _screenBehavior;
@synthesize showTranscripts = _showTranscripts;
@synthesize smsNotifications = _smsNotifications;
@synthesize smsToEmailActive = _smsToEmailActive;
@synthesize smsToEmailSubject = _smsToEmailSubject;
@synthesize spam = _spam;
@synthesize timezone = _timezone;
@synthesize useDidAsCallerId = _useDidAsCallerId;
@synthesize useDidAsSource = _useDidAsSource;

#pragma mark - Life Cycle Methods
- (id) initWithDictionary: (NSDictionary *) dict {
	self = [super init];
	
	if (self) {
		self.activeForwardingList = [dict objectForKey: @"activeForwardingIds"];
		self.baseUrl = [dict objectForKey: @"baseUrl"];
		self.credits = [[dict objectForKey: @"credits"] integerValue];
		self.defaultGreetingId = [[dict objectForKey: @"defaultGreetingId"] integerValue];
		self.didInfos = [dict objectForKey: @"didInfos"];
 		self.directConnect = [[dict objectForKey: @"directConnect"] boolValue];
		self.disabledIds = [dict objectForKey: @"disabledIdMap"];
		self.doNotDisturb = [[dict objectForKey: @"doNotDisturb"] boolValue];
		self.emailAddresses = [dict objectForKey: @"emailAddresses"];
		self.emailNotificationActive = [[dict objectForKey: @"emailNotificationActive"] boolValue];
		self.emailNotificationAddress = [dict objectForKey: @"emailNotificationAddress"];
		self.greetings = [dict objectForKey: @"greetings"];
		self.groupList = [dict objectForKey: @"groupList"];
		self.language = [dict objectForKey: @"language"];
		self.primaryDid = [dict objectForKey: @"primaryDid"];
		self.screenBehavior = [[dict objectForKey: @"screenBehavior"] integerValue];
		self.showTranscripts = [[dict objectForKey: @"showTranscripts"] boolValue];
		self.smsNotifications = [dict objectForKey: @"smsNotifications"];
		self.smsToEmailActive = [[dict objectForKey: @"smsToEmailActive"] boolValue];
		self.smsToEmailSubject = [[dict objectForKey: @"smsToEmailSubject"] boolValue];
		self.spam = [[dict objectForKey: @"spam"] integerValue];
		self.timezone = [dict objectForKey: @"timezone"];
		self.useDidAsCallerId = [[dict objectForKey: @"useDidAsCallerId"] boolValue];
		self.useDidAsSource = [[dict objectForKey: @"useDidAsSource"] boolValue];
		
		NSMutableDictionary *groups = [NSMutableDictionary dictionary];
		NSDictionary *rawGroups = [dict objectForKey: @"groups"];
		
		for (NSString *key in rawGroups) {
			NSDictionary *groupDict = [rawGroups objectForKey: key];
			
			GVoiceGroup *group = [[GVoiceGroup alloc] initWithDictionary: groupDict];
			[groups setValue: group forKey: key];
			
			[group release];
		}
		
		self.groups = groups;
	}
	
	return self;
}

- (void)dealloc {	
    [_activeForwardingList release], _activeForwardingList = nil;
    [_baseUrl release], _baseUrl = nil;
    [_didInfos release], _didInfos = nil;
    [_disabledIds release], _disabledIds = nil;
    [_emailAddresses release], _emailAddresses = nil;
    [_emailNotificationAddress release], _emailNotificationAddress = nil;
    [_greetings release], _greetings = nil;
    [_groupList release], _groupList = nil;
    [_groups release], _groups = nil;
    [_language release], _language = nil;
    [_primaryDid release], _primaryDid = nil;
    [_smsNotifications release], _smsNotifications = nil;
    [_timezone release], _timezone = nil;
	
	[super dealloc];
}
@end
