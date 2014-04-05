//
//  DNAppDelegate.h
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DNUser.h"

@interface DNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DNUser *user;

@end
