//
//  DNHomeViewController.m
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNHomeViewController.h"

@interface DNHomeViewController ()

@end

@implementation DNHomeViewController
@synthesize drawerController = _drawerController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    //Create a Segmented Control tab
    UISegmentedControl *clientControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"gChat", @"Voice", @"fb", nil]];
    
    //Array of NavBar buttons
    NSMutableArray *titleButtonArray = [[NSMutableArray alloc] init];
     UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     [titleButtonArray addObject:flexibleSpace];
     [titleButtonArray addObject:[[UIBarButtonItem alloc] initWithCustomView:clientControl]];
     [titleButtonArray addObject:flexibleSpace];
     
     self.navigationItem.leftBarButtonItems = titleButtonArray;
    
    
}

-(void)setupLeftMenuButton {
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //[self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton {
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    //[self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender {
    NSLog(@"Left drawer button pressed");
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender {
    NSLog(@"right drawer button pressed");
    [self.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
