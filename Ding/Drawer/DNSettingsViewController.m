//
//  DNSettingsViewController.m
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNSettingsViewController.h"

@interface DNSettingsViewController ()

@end

@implementation DNSettingsViewController
@synthesize appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Settings"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setupLeftMenuButton {
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:signOutButton animated:YES];
}

- (void)signOutButtonPressed: (id)selector {
    NSLog(@"Sign Out called");
    [self.appDelegate disconnect];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyGoogleJID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyGooglePassword];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
