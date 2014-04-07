//
//  DNFacebookAPIController.h
//  Ding
//
//  Created by Mark Miyashita on 4/6/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNUser.h"

#define kFCMessageDidComeNotification @"kFCMessageDidComeNotification"

@class DNChatDataStoreManager;
@class DNBaseChatRequestManager;
@class DNAuthFacebookManager;
@class DNRequestFacebookManager;

@interface DNFacebookAPIController : NSObject

+ (DNFacebookAPIController *)sharedInstance;

@property (nonatomic, strong) DNUser *currentUser;
@property (readonly, nonatomic, strong) DNChatDataStoreManager *chatDataStoreManager;
@property (readonly, nonatomic, strong) DNBaseChatRequestManager *chatRequestManager;
@property (readonly, nonatomic, strong) DNAuthFacebookManager *authFacebookManager;
@property (readonly, nonatomic, strong) DNRequestFacebookManager *requestFacebookManager;

@end
