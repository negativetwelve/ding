//
//  DNAuthFacebookManager.h
//  Ding
//
//  Created by Mark Miyashita on 4/6/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "FBConnect.h"
#import "BlocksTypedefs.h"

#define FACEBOOK_APP_ID @"124242144347927"

@interface DNAuthFacebookManager : NSObject

@property (readonly, nonatomic, strong) Facebook *facebook;
@property (readwrite, nonatomic, copy) CompletionBlock facebookAuthHandler;

- (BOOL)handleOpenURL:(NSURL *)url;
- (void)authorize;
- (void)logOut;

@end
