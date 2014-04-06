//
//  DNFriendsViewController.h
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNViewController.h"
#import "DNTableViewController.h"
#import "DNMessageViewController.h"
#import "DNHomeNavigationController.h"

#import "DNAppDelegate.h"

#import <CoreData/CoreData.h>

@interface DNFriendsViewController : DNTableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) DNAppDelegate *appDelegate;
@property (nonatomic, retain) DNHomeNavigationController *homeNavigationController;

@end
