//
//  DNVoiceViewController.m
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNVoiceViewController.h"
#import "DNHomeNavigationController.h"
#import "DNAppDelegate.h"
#import "DNVoiceMessageViewController.h"

@interface DNVoiceViewController ()
- (void)fetchResults;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation DNVoiceViewController
@synthesize homeNavigationController = _homeNavigationController;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.homeNavigationController.clientControl setSelectedSegmentIndex:1];
    NSLog(@"hi mark voice");
}

- (void) pushComposeViewController {
    DNVoiceMessageViewController *chatViewController = [[DNVoiceMessageViewController alloc] init];
    chatViewController.managedObjectContext = managedObjectContext;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (void) pushEditViewController {
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Should set edit and compose buttons
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                      target:self action:@selector(pushEditViewController)];

    self.navigationItem.leftBarButtonItem = editButton;
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
     target:self action:@selector(pushComposeViewController)];
     self.navigationItem.rightBarButtonItem = composeButton;
    [self fetchResults];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //    // TODO: Add transient attributes (title & lastMessage) to Conversation.
    //    Conversation *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
    //    cell.textLabel.text = conversation.title;
    //    cell.detailTextLabel.text = conversation.lastMessage.text;
    XMPPMessageArchiving_Contact_CoreDataObject *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = conversation.bareJidStr;
    cell.detailTextLabel.text = conversation.mostRecentMessageBody;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Contact_CoreDataObject *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
    DNVoiceMessageViewController *messageViewController = [[DNVoiceMessageViewController alloc] init];
    messageViewController.conversation = conversation;
    messageViewController.managedObjectContext = managedObjectContext;
    [self.navigationController pushViewController:messageViewController animated:YES];
}

- (void)fetchResults {
    return;
    if (fetchedResultsController) {
        return;
    }
    
    XMPPMessageArchivingCoreDataStorage *storage = [[XMPPMessageArchivingCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                              inManagedObjectContext:moc];
    
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"bareJidStr" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:@"MessagesContactListCache"];
    
    NSError *error;
    BOOL rval = [fetchedResultsController performFetch:&error];
    
    if (!rval) {
        NSLog(@"error: %@", error);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
