//
//  DNVoiceViewController.m
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNVoiceViewController.h"
#import "DNHomeNavigationController.h"

@interface DNVoiceViewController ()

@end

@implementation DNVoiceViewController
@synthesize homeNavigationController = _homeNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.homeNavigationController.clientControl setSelectedSegmentIndex:1];
    NSLog(@"hi mark voice");
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
