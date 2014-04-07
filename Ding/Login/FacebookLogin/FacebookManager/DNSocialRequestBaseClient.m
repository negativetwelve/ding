//
//  DNSocialRequestBaseClient.m
//  Ding
//
//  Created by Mark Miyashita on 4/6/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNSocialRequestBaseClient.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"

static NSString *const kAPIBaseURLString = @"https://graph.facebook.com";

@implementation DNSocialRequestBaseClient
+ (DNSocialRequestBaseClient *)sharedClient {
    static  DNSocialRequestBaseClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DNSocialRequestBaseClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
        [_sharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    });
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return _sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}

@end
