//
//  DNLoginViewController.m
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNLoginViewController.h"

@interface DNLoginViewController ()

@end

@implementation DNLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Login"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCloseButton];
    [self setLoginButtons];
}

- (void)setCloseButton {
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeLogin:)];
    [self.navigationItem setRightBarButtonItem:closeButton animated:YES];
}

- (void)setLoginButtons {
    UIButton *googleLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [googleLoginButton.layer setBorderWidth:1.0f];
    [googleLoginButton.layer setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [googleLoginButton setFrame:CGRectMake(30, 100, 260, 60)];
    [googleLoginButton addTarget:self action:@selector(googleLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [googleLoginButton setTitle:@"Login with Google" forState:UIControlStateNormal];
    [self.view addSubview:googleLoginButton];
    
    UIButton *facebookLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [facebookLoginButton.layer setBorderWidth:1.0f];
    [facebookLoginButton.layer setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [facebookLoginButton setFrame:CGRectMake(30, 190, 260, 60)];
    [facebookLoginButton addTarget:self action:@selector(facebookLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [facebookLoginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [self.view addSubview:facebookLoginButton];
}

// Buttons with actions
- (void)closeLogin: (id)selector {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)googleLoginButtonPressed: (id)selector {
    NSLog(@"google login button pressed");
    DNGoogleLoginViewController *googleLoginViewController = [[DNGoogleLoginViewController alloc] init];
    [self.navigationController pushViewController:googleLoginViewController animated:YES];
}

- (void)facebookLoginButtonPressed: (id)selector {
    NSLog(@"facebook login button pressed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
