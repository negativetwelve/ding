//
//  DNFacebookAPIController.m
//  Ding
//
//  Created by Mark Miyashita on 4/6/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNFacebookAPIController.h"
#import "Singleton.h"
#import "DNChatDataStoreManager.h"
#import "DNBaseChatRequestManager.h"

#import "DNAuthFacebookManager.h"
#import "DNRequestFacebookManager.h"

@interface DNFacebookAPIController()
@property (nonatomic, strong) DNChatDataStoreManager *chatDataStoreManager;
@property (nonatomic, strong) DNBaseChatRequestManager *chatRequestManager;
@property (nonatomic, strong) DNAuthFacebookManager *authFacebookManager;
@property (nonatomic, strong) DNRequestFacebookManager *requestFacebookManager;
@end


@implementation DNFacebookAPIController
SINGLETON_GCD(DNFacebookAPIController);

- (DNAuthFacebookManager *)authFacebookManager {
    if (!_authFacebookManager) {
        _authFacebookManager = [DNAuthFacebookManager new];
    }
    return _authFacebookManager;
}

- (DNRequestFacebookManager *)requestFacebookManager {
    if (!_requestFacebookManager) {
        _requestFacebookManager = [DNRequestFacebookManager new];
    }
    return _requestFacebookManager;
}

- (DNChatDataStoreManager *)chatDataStoreManager {
    if (!_chatDataStoreManager) {
        _chatDataStoreManager = [DNChatDataStoreManager new];
    }
    return _chatDataStoreManager;
}


- (DNBaseChatRequestManager *)chatRequestManager {
    if (!_chatRequestManager) {
        _chatRequestManager = [DNBaseChatRequestManager new];
    }
    return _chatRequestManager;
}

@end
