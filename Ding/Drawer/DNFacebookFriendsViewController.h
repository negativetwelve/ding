//
//  DNFacebookFriendsViewController.h
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNViewController.h"
#import "DNTableViewController.h"

#import <CoreData/CoreData.h>

@interface DNFacebookFriendsViewController : DNTableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
}

@end
