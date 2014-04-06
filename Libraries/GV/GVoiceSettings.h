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

/**
 * @author Joey Gibson <joey@joeygibson.com>
 * @since 04/11/2011
 *
 * Detailed account settings for the Google Voice account.
 *
 * These settings are not specific to a single phone.
 */
@interface GVoiceSettings : NSObject {
	@private
	NSArray *_activeForwardingList;
	NSString *_baseUrl;
	NSInteger _credits;
	NSInteger _defaultGreetingId;
	NSArray *_didInfos;
	BOOL _directConnect;
	NSDictionary *_disabledIds;
    BOOL _doNotDisturb;
    NSArray *_emailAddresses;
	BOOL _emailNotificationActive;
    NSString *_emailNotificationAddress;
	NSArray *_greetings;
    NSArray *_groupList;
	NSDictionary *_groups;
	NSString *_language;
	NSString *_primaryDid;
	NSInteger _screenBehavior;
	BOOL _showTranscripts;
	NSArray *_smsNotifications;
	BOOL _smsToEmailActive;
	BOOL _smsToEmailSubject;
	NSInteger _spam;
	NSString *_timezone;
	BOOL _useDidAsCallerId;
	BOOL _useDidAsSource;
}

@property (nonatomic, retain) NSArray *activeForwardingList;
@property (nonatomic, retain) NSString *baseUrl;
@property (nonatomic, assign) NSInteger credits;
@property (nonatomic, assign) NSInteger defaultGreetingId;
@property (nonatomic, retain) NSArray *didInfos;
@property (nonatomic, assign) BOOL directConnect;
@property (nonatomic, retain) NSDictionary *disabledIds;
@property (nonatomic, assign) BOOL doNotDisturb;
@property (nonatomic, retain) NSArray *emailAddresses;
@property (nonatomic, assign) BOOL emailNotificationActive;
@property (nonatomic, retain) NSString *emailNotificationAddress;
@property (nonatomic, retain) NSArray *greetings;
@property (nonatomic, retain) NSArray *groupList;
@property (nonatomic, retain) NSDictionary *groups;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *primaryDid;
@property (nonatomic, assign) NSInteger screenBehavior;
@property (nonatomic, assign) BOOL showTranscripts;
@property (nonatomic, retain) NSArray *smsNotifications;
@property (nonatomic, assign) BOOL smsToEmailActive;
@property (nonatomic, assign) BOOL smsToEmailSubject;
@property (nonatomic, assign) NSInteger spam;
@property (nonatomic, retain) NSString *timezone;
@property (nonatomic, assign) BOOL useDidAsCallerId;
@property (nonatomic, assign) BOOL useDidAsSource;

/**
 * Initialize this object, using the contents of the supplied NSDictionary.
 *
 * The assumption is that the dictionary was created from JSON output, but 
 * this is not required.
 * @param dict the dictionary to initialize this object with
 */
- (id) initWithDictionary: (NSDictionary *) dict;
@end
