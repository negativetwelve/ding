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
        self.view.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"hi mark chat");
    [self.homeNavigationController.clientControl setSelectedSegmentIndex:0];
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
    cell.textLabel.text = @"Melissa Huang";
    cell.detailTextLabel.text = @"hi mark <3";
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DNMessageViewController *messageViewController = [[DNMessageViewController alloc] init];
    messageViewController.managedObjectContext = managedObjectContext;
    [self.navigationController pushViewController:messageViewController animated:YES];
}

- (void)fetchResults {
    if (fetchedResultsController) return;
    
    // Create and configure a fetch request.
    
    id delegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"hey%@%@", managedObjectContext, delegate);

    managedObjectContext = [delegate managedObjectContext_roster];
    
    NSLog(@"hi%@,%@", managedObjectContext, delegate);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DNChat"
                                              inManagedObjectContext:managedObjectContext];
    
    NSLog(@"bye%@,entity%@", managedObjectContext, entity);

    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    
    //    // TODO: Sort by sentDate of last message. Add lastMessage as transient attribute.
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastMessage.sentDate"
    //                                                                   ascending:NO];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastMessage.sentDate"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    // Create and initialize the fetchedResultsController.
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:managedObjectContext
                                sectionNameKeyPath:nil /* one section */ cacheName:@"DNChat"];
    NSLog(@"past fetchrequest");

    fetchedResultsController.delegate = self;
    
    NSError *error;
    /*if (![fetchedResultsController performFetch:&error]) {
        // TODO: Handle the error appropriately.
        NSLog(@"fetchMessages error %@, %@", error, [error userInfo]);
    }*/
}

@end
