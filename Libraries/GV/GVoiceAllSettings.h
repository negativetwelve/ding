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
#import "GVoiceSettings.h"

/**
 * @author Joey Gibson <joey@joeygibson.com>
 * @since 04/11/2011
 *
 * Top-level settings for GV.
 */
@interface GVoiceAllSettings : NSObject {
	@private
    NSArray *_phoneList;
	NSDictionary *_phones;
	GVoiceSettings *_settings;
}

/**
 * An NSArray of phoneIds, one for each phone registered with the GV account.
 */
@property (nonatomic, retain) NSArray *phoneList;

/**
 * An NSDictionary containing detailed settings for each phone registered with the GV account.
 *
 * If there are four phones listed in GVoiceAllSettings#phoneList, there will be four entries
 * in this dictionary.
 */
@property (nonatomic, retain) NSDictionary *phones;

/**
 * Settings that apply to the GV account as a whole, not to a specific phone.
 */
@property (nonatomic, retain) GVoiceSettings *settings;

/**
 * Initialize this object, using the contents of the supplied NSDictionary.
 *
 * The assumption is that the dictionary was created from JSON output, but 
 * this is not required.
 * @param dict the dictionary to initialize this object with
 */
- (id) initWithDictionary: (NSDictionary *) dict;
@end
