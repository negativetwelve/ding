//
//  DNHomeViewController.h
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNViewController.h"
#import "DNHomeNavigationController.h"

#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

@interface DNHomeViewController : DNViewController {
    MMDrawerController *drawerController;
    DNHomeNavigationController *homeNavigationController;
}
- (void) setClientControl;

@property (nonatomic, retain) MMDrawerController *drawerController;
@property (nonatomic, retain) DNHomeNavigationController *homeNavigationController;
@end
