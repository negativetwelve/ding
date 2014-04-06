//
//  DNChatViewController.h
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNHomeNavigationController;
@interface DNChatViewController : UIViewController {
    DNHomeNavigationController *homeNavigationController;

}

@property (nonatomic, retain) DNHomeNavigationController *homeNavigationController;
@end
