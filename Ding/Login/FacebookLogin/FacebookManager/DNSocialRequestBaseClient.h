//
//  DNSocialRequestBaseClient.h
//  Ding
//
//  Created by Mark Miyashita on 4/6/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFHTTPClient.h"

@interface DNSocialRequestBaseClient : AFHTTPClient
+ (DNSocialRequestBaseClient *)sharedClient;

@end
