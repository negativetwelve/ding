//
//  DNRequestFacebookManager.m
//  Ding
//
//  Created by Mark Miyashita on 4/6/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNRequestFacebookManager.h"
#import "DNAuthFacebookManager.h"
#import "DNFacebookAPIController.h"
#import "DNSocialRequestBaseClient.h"

@implementation DNRequestFacebookManager

- (NSDictionary *)createParamsForCurrentSession {
    NSDictionary *jsonDictionary2 = @{@"access_token":[[DNFacebookAPIController sharedInstance] authFacebookManager].facebook.accessToken};
    return jsonDictionary2;
}

- (void)requestGraphMeWithCompletion:(CompletionBlock)completion {
    [[DNSocialRequestBaseClient sharedClient] getPath:@"me"
                                           parameters:[self createParamsForCurrentSession]
                                              success:^(AFHTTPRequestOperation *opertaion, id response){
                                                  NSLog(@"%@",response);
                                                  if (completion) {
                                                      completion(response, nil);
                                                  }
                                              }
                                              failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
                                                  NSLog(@"%@",error);
                                                  if (completion) {
                                                      completion(nil, error);
                                                  }
                                              }];
}

- (void)requestGraphFriendsWithCompletion:(CompletionBlock)completion {
    [[DNSocialRequestBaseClient sharedClient] getPath:@"me/friends"
                                           parameters:[self createParamsForCurrentSession]
                                              success:^(AFHTTPRequestOperation *opertaion, id response){
                                                  NSLog(@"%@",response);
                                                  NSArray *friends = [response objectForKey:@"data"];
                                                  if (completion) {
                                                      completion(friends, nil);
                                                  }
                                              }
                                              failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
                                                  NSLog(@"%@",error);
                                                  if (completion) {
                                                      completion(nil, error);
                                                  }
                                              }];
}


@end
