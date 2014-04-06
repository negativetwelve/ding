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

#import "GVoiceGroup.h"

@implementation GVoiceGroup

@synthesize id = _id;
@synthesize name = _name;
@synthesize customForwarding = _customForwarding;
@synthesize disabledForwardingIds = _disabledForwardingIds;
@synthesize customDirectConnect = _customDirectConnect;
@synthesize directConnect = _directConnect;
@synthesize customGreeting = _customGreeting;
@synthesize greetingId = _greetingId;

#pragma mark - Memory Management Methods
- (void)dealloc {	
    [_id release], _id = nil;
    [_name release], _name = nil;
    [_disabledForwardingIds release], _disabledForwardingIds = nil;
	
	[super dealloc];
}

#pragma marl - Init Methods
- (id) initWithDictionary: (NSDictionary *) dict {
	self = [super init];
	
	if (self) {
		// self.phoneList = [dict objectForKey: @"phoneList"];
		self.id = [dict objectForKey: @"id"];
		self.name = [dict objectForKey: @"name"];
		self.customForwarding = [[dict objectForKey: @"isCustomForwarding"] boolValue];
		self.customGreeting = [[dict objectForKey: @"isCustomGreeting"] boolValue];
		self.customDirectConnect = [[dict objectForKey: @"isCustomDirectConnect"] boolValue];
		self.directConnect = [[dict objectForKey: @"directConnect"] boolValue];
		self.greetingId = [[dict objectForKey: @"greetingId"] integerValue];
		self.disabledForwardingIds = [dict objectForKey: @"disabledForwardingIds"];
	}
	
	return self;
}

- (NSString *) description {
	NSString *desc = [NSString stringWithFormat: @"Group %@, Name: %@", self.id, self.name];
	
	return desc;
}

+ (id) groupWithGroup:(GVoiceGroup *)group {
	GVoiceGroup *newGroup = [[[GVoiceGroup alloc] init] autorelease];
	
	newGroup.id = group.id;
	newGroup.name = group.name;
	newGroup.customForwarding = group.customForwarding;
	newGroup.customGreeting = group.customGreeting;
	newGroup.customDirectConnect = group.customDirectConnect;
	newGroup.directConnect = group.directConnect;
	
	NSDictionary *disGroups = [group.disabledForwardingIds copy];
	
	newGroup.disabledForwardingIds = disGroups;
	
	[disGroups release];
	
	return newGroup;
}

@end
