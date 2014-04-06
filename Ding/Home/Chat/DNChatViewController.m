//
//  DNChatViewController.m
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNChatViewController.h"
#import "DNHomeNavigationController.h"

@interface DNChatViewController ()

@end

@implementation DNChatViewController
@synthesize homeNavigationController = _homeNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    //Create a Segmented Control tab
    UISegmentedControl *clientControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"gChat", @"Voice", @"fb", nil]];
    
    [self.homeNavigationController setClientControl:clientControl];
    [self.homeNavigationController.clientControl setSelectedSegmentIndex:0];
    
    NSLog(@"%@", self.homeNavigationController);
    //set target for clientControl
    [self.homeNavigationController.clientControl addTarget:self action:@selector(diffClientClicked:) forControlEvents:UIControlEventValueChanged];
    
    
    //fire an action when selection changes
    [self.homeNavigationController.clientControl sendActionsForControlEvents:UIControlEventValueChanged];
    
    
    
    //Array of NavBar buttons
    NSMutableArray *titleButtonArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [titleButtonArray addObject:flexibleSpace];
    [titleButtonArray addObject:[[UIBarButtonItem alloc] initWithCustomView:clientControl]];
    [titleButtonArray addObject:flexibleSpace];
    
    self.navigationItem.leftBarButtonItems = titleButtonArray;
}
-(void)diffClientClicked:(id)sender {
    NSLog(@"diff client clicked");
    UIViewController *nextViewController;
    NSUInteger index = self.homeNavigationController.clientControl.selectedSegmentIndex;
    if (index == 0) {
        nextViewController = self.homeNavigationController.chatViewController;
    } else if (index == 1) {
        nextViewController = self.homeNavigationController.voiceViewController;
    } else if (index == 2) {
        nextViewController = self.homeNavigationController.fBChatViewController;
    } else {
        NSLog(@"No Segment Cell above 2 Exists");
    }
    NSLog(@"%@", nextViewController);
    NSArray *nextViewControllers = [NSArray arrayWithObject:nextViewController];
    [self.homeNavigationController setViewControllers:nextViewControllers animated:NO];
    NSLog(@"changed client");
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
