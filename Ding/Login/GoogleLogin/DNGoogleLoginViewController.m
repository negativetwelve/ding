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
@synthesize emailTextField;
@synthesize passwordTextField;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    emailTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyGoogleJID];
    passwordTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyGooglePassword];
}

- (void)submitAction: (id)selector {
    NSLog(@"submit action called");
    [self setField:emailTextField forKey:kXMPPmyGoogleJID];
    [self setField:passwordTextField forKey:kXMPPmyGooglePassword];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setLoginFields {
    UITextField *emailField = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 280, 31)];
    [emailField setPlaceholder:@"Email"];
    [emailField setReturnKeyType:UIReturnKeyNext];
    [emailField setTag:1];
    [emailField setDelegate:self];
    [emailField setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.view addSubview:emailField];
    
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 180, 280, 31)];
    [passwordField setPlaceholder:@"Password"];
    [passwordField setReturnKeyType:UIReturnKeyDone];
    [passwordField setTag:2];
    [passwordField setDelegate:self];
    [passwordField setSecureTextEntry:YES];
    [passwordField addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:passwordField];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setFrame:CGRectMake(70, 220, 180, 50)];
    [submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    [self setEmailTextField:emailField];
    [self setPasswordTextField:passwordField];
}

- (void)setField:(UITextField *)field forKey:(NSString *)key {
    if (field.text != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
