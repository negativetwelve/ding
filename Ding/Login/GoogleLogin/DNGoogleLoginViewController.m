//
//  DNGoogleLoginViewController.m
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNGoogleLoginViewController.h"

@interface DNGoogleLoginViewController ()

@end

@implementation DNGoogleLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Login with Google"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLoginFields];
}

- (void)submitAction: (id)selector {
    NSLog(@"submit action called");
}

- (void)setLoginFields {
    UITextField *emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 280, 31)];
    [emailTextField setPlaceholder:@"Email"];
    [emailTextField setReturnKeyType:UIReturnKeyNext];
    [emailTextField setTag:1];
    [emailTextField setDelegate:self];
    [emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.view addSubview:emailTextField];
    
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 180, 280, 31)];
    [passwordTextField setPlaceholder:@"Password"];
    [passwordTextField setReturnKeyType:UIReturnKeyNext];
    [passwordTextField setTag:2];
    [passwordTextField setDelegate:self];
    [passwordTextField setSecureTextEntry:YES];
    [self.view addSubview:passwordTextField];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setFrame:CGRectMake(70, 220, 180, 50)];
    [submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
