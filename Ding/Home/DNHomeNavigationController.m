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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DNVoiceViewController *voiceView = [[DNVoiceViewController alloc] init];
    DNChatViewController *chatView = [[DNChatViewController alloc] init];
    DNFBChatViewController *fBChatView = [[DNFBChatViewController alloc] init];
    
    voiceView.homeNavigationController = self;
    chatView.homeNavigationController = self;
    fBChatView.homeNavigationController = self;
    
    [self setChatViewController:chatView];
    [self setFBChatViewController:fBChatView];
    [self setVoiceViewController:voiceView];
    
    NSLog(@"set client control");
    //Create a Segmented Control tab
    UISegmentedControl *clientControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"gChat", @"Voice", @"fb", nil]];
    [clientControl setSelectedSegmentIndex:0];
    //set target for clientControl
    [clientControl addTarget:self action:@selector(diffClientClicked:) forControlEvents:UIControlEventValueChanged];
    //fire an action when selection changes
    [clientControl sendActionsForControlEvents:UIControlEventValueChanged];
    
    [self setClientControl:clientControl];
    
    //Array of NavBar buttons
    NSMutableArray *titleButtonArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [titleButtonArray addObject:flexibleSpace];
    [titleButtonArray addObject:[[UIBarButtonItem alloc] initWithCustomView:clientControl]];
    [titleButtonArray addObject:flexibleSpace];

    [chatView.navigationItem setLeftBarButtonItems:titleButtonArray];
    [voiceView.navigationItem setLeftBarButtonItems:titleButtonArray];
    [fBChatView.navigationItem setLeftBarButtonItems:titleButtonArray];
    
    [chatView.navigationItem setHidesBackButton:YES];
    [voiceView.navigationItem setHidesBackButton:YES];
    [fBChatView.navigationItem setHidesBackButton:YES];
}

- (void)diffClientClicked:(id)sender {
    NSLog(@"**************************************");
    NSLog(@"diff client clicked");
    UIViewController *nextViewController;
    NSUInteger index = self.clientControl.selectedSegmentIndex;
    NSLog(@"index: %d", index);
    if (index == 0) {
        nextViewController = self.chatViewController;
    } else if (index == 1) {
        nextViewController = self.voiceViewController;
    } else if (index == 2) {
        nextViewController = self.fBChatViewController;
    } else {
        NSLog(@"No Segment Cell above 2 Exists");
    }
    NSLog(@"%@", nextViewController);
    NSArray *nextViewControllers = [NSArray arrayWithObject:nextViewController];
    [self setViewControllers:nextViewControllers animated:NO];
    NSLog(@"changed client");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
