//
//  DNHomeViewController.h
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNViewController.h"

#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

@interface DNHomeViewController : DNViewController {
    MMDrawerController *drawerController;
}

@property (nonatomic, retain) MMDrawerController *drawerController;

@end
