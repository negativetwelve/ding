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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"hi mark chat");
    [self.homeNavigationController.clientControl setSelectedSegmentIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
