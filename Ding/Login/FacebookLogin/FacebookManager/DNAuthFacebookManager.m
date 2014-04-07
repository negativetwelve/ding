//
//  DNAuthFacebookManager.m
//  Ding
//
//  Created by Mark Miyashita on 4/6/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNAuthFacebookManager.h"
#import "DNFacebookAPIController.h"
#import "DNBaseChatRequestManager.h"

@interface DNAuthFacebookManager()<FBSessionDelegate>
@end

@implementation DNAuthFacebookManager

- (id)init {
    if (self = [super init]) {
        _facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:self];
    }
    return self;
}

- (void)authorize {
    NSLog(@"Starting Facebook Authentication");
    [self.facebook authorize:[NSArray arrayWithObject:@"xmpp_login"]];
}

- (void)logOut {
    [self.facebook logout];
    [self fbDidLogoutFromSafari];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (void)fbDidLogoutFromSafari {
    //    NSLog(@"Logged out of facebook");
    //    NSHTTPCookie *cookie;
    //    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //    for (cookie in [storage cookies])
    //    {
    //        NSString* domainName = [cookie domain];
    //        NSRange domainRange = [domainName rangeOfString:@"facebook"];
    //        if(domainRange.length > 0)
    //        {
    //            [storage deleteCookie:cookie];
    //        }
    //    }
    
    //    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://login.facebook.com"]];
    //
    //    for (NSHTTPCookie* cookie in facebookCookies) {
    //        [cookies deleteCookie:cookie];
    //    }
}


#pragma mark FBSessionDelegate Delegate methods
- (void)fbDidLogin {
	NSLog(@"Facebook login successful!");
	NSLog(@"facebook.accessToken: %@", self.facebook.accessToken);
	NSLog(@"facebook.expirationDate: %@", self.facebook.expirationDate);
	
    NSLog(@"XMPP connecting...");
	NSError *error = nil;
	if (![[[DNFacebookAPIController sharedInstance] chatRequestManager].xmppStream connect:&error]) {
		NSLog(@"Error in xmpp connection: %@", error);
        NSLog(@"XMPP connect failed");
        if (self.facebookAuthHandler) {
            self.facebookAuthHandler(nil, error);
        }
	}
    
    if (self.facebookAuthHandler) {
        self.facebookAuthHandler(@(YES), nil);
    }
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"Facebook login failed");
}

- (void)fbDidLogout {
}

- (void)fbSessionInvalidated {
}

@end
