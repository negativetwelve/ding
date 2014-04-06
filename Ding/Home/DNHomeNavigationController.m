//
//  DNHomeNavigationController.m
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNHomeNavigationController.h"

@interface DNHomeNavigationController ()

@end

@implementation DNHomeNavigationController
@synthesize clientControl = _clientControl;
@synthesize chatViewController = _chatViewController;
@synthesize fBChatViewController = _fBChatViewController;
@synthesize voiceViewController = _voiceViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    DNVoiceViewController *voiceView = [[DNVoiceViewController alloc] init];
    DNChatViewController *chatView = [[DNChatViewController alloc] init];
    DNFBChatViewController *fBChatView = [[DNFBChatViewController alloc] init];
        
    
    [self setChatViewController:chatView];
    [self setFBChatViewController:fBChatView];
    [self setVoiceViewController:voiceView];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
