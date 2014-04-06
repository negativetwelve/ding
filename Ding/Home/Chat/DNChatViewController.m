//
//  DNChatViewController.m
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNChatViewController.h"
#import "DNHomeNavigationController.h"
#import "DNChatViewController.h"
#import "DNMessageViewController.h"
#import "DNChat.h"
#import "DNAppDelegate.h"

@interface DNChatViewController ()
- (void)fetchResults;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation DNChatViewController
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
    NSLog(@"hi mark chat");
    [self.homeNavigationController.clientControl setSelectedSegmentIndex:0];
    [self.tableView reloadData];
}

- (void) pushComposeViewController {
    DNMessageViewController *chatViewController = [[DNMessageViewController alloc] init];
    chatViewController.managedObjectContext = managedObjectContext;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Should set edit and compose buttons
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    /*UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                      target:self action:@selector(pushComposeViewController)];
    self.navigationItem.rightBarButtonItem = composeButton;*/
    [self fetchResults];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //    // TODO: Add transient attributes (title & lastMessage) to Conversation.
    //    Conversation *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
    //    cell.textLabel.text = conversation.title;
    //    cell.detailTextLabel.text = conversation.lastMessage.text;
    DNMessageViewController *messageViewController = [[DNMessageViewController alloc] init];
    XMPPMessageArchiving_Contact_CoreDataObject *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
    messageViewController.conversation = conversation;
    [messageViewController loadMessages];
    cell.textLabel.text = conversation.bareJidStr;
    cell.detailTextLabel.text = conversation.mostRecentMessageBody;
    NSLog(@"OHHEY:%@", conversation.mostRecentMessageBody);
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.fetchedResultsController = nil;
    // Leave managedObjectContext since it's not recreated in viewDidLoad.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    DNMessageViewController *messageViewController = [[DNMessageViewController alloc] init];
    messageViewController.conversation = conversation;
    messageViewController.managedObjectContext = managedObjectContext;
    [self.navigationController pushViewController:messageViewController animated:YES];
}

- (void)fetchResults {
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
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
    [self.tableView reloadData];
}

@end
