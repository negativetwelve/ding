//
//  DNFBChatViewController.m
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNFBChatViewController.h"
#import "DNHomeNavigationController.h"

@interface DNFBChatViewController ()

@end

@implementation DNFBChatViewController

@synthesize homeNavigationController = _homeNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.homeNavigationController.clientControl setSelectedSegmentIndex:2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITableViewCell *wonj = [[UITableViewCell alloc] init];
    wonj.text = @"Wonjun Jeong";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
