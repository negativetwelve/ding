//
//  DNGoogleLoginViewController.h
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNViewController.h"

#import "DNAppDelegate.h"

@interface DNGoogleLoginViewController : DNViewController <UITextFieldDelegate> {
    UITextField *emailTextField;
    UITextField *passwordTextField;
}

@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;


@end
