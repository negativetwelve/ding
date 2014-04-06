//
//  DNHomeNavigationController.h
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNChatViewController.h"
#import "DNVoiceViewController.h"
#import "DNFBChatViewController.h"

@interface DNHomeNavigationController : UINavigationController {
    DNChatViewController *chatViewController;
    DNFBChatViewController *fBChatViewController;
    DNVoiceViewController *voiceViewController;
}

@property (nonatomic, retain) UISegmentedControl *clientControl;
@property (nonatomic, retain) DNChatViewController *chatViewController;
@property (nonatomic, retain) DNFBChatViewController *fBChatViewController;
@property (nonatomic, retain) DNVoiceViewController *voiceViewController;

@end
