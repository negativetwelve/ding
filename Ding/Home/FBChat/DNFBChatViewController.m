//
//  DNFBChatViewController.m
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNFBChatViewController.h"
#import "DNHomeNavigationController.h"

@interface DNFBChatViewController ()

@end

@implementation DNFBChatViewController

@synthesize homeNavigationController = _homeNavigationController;
@synthesize names;
@synthesize msgs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.homeNavigationController.clientControl setSelectedSegmentIndex:2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *wonj = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:CellIdentifier];
    wonj.textLabel.text = @"Wonjun Jeong";
    UITableViewCell *tony = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:CellIdentifier];
    tony.textLabel.text = @"Tony Wu";
    UITableViewCell *nish = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:CellIdentifier];
    nish.textLabel.text = @"Nishant Desai";
    UITableViewCell *howard = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:CellIdentifier];
    howard.textLabel.text = @"Howard Chen";
    UITableViewCell *john = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:CellIdentifier];
    john.textLabel.text = @"John Du";
    
    wonj.detailTextLabel.text = @"get the house";
    tony.detailTextLabel.text = @"whooooooo";
    nish.detailTextLabel.text = @"where are your glasses?";
    howard.detailTextLabel.text = @"Hi Howie";
    john.detailTextLabel.text = @"Nice sweatshirt.";
    
    names = [[NSMutableArray alloc] init];
    msgs = [[NSMutableArray alloc] init];
    [names addObject:@"Wonjun Jeong"];
    [names addObject:@"Tony Wu"];
    [names addObject:@"Nishant Desai"];
    [names addObject:@"Howard Chen"];
    [names addObject:@"John Du"];
    
    [msgs addObject:@"get the house"];
    [msgs addObject:@"whooooooo"];
    [msgs addObject:@"where are your glasses?"];
    [msgs addObject:@"Hi Howie"];
    [msgs addObject:@"Nice sweatshirt."];
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //    // TODO: Add transient attributes (title & lastMessage) to Conversation.
    //    Conversation *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
    //    cell.textLabel.text = conversation.title;
    //    cell.detailTextLabel.text = conversation.lastMessage.text;
    /*XMPPMessageArchiving_Contact_CoreDataObject *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = conversation.bareJidStr;
    cell.detailTextLabel.text = conversation.mostRecentMessageBody;
    NSLog(@"OHHEY:%@", conversation.mostRecentMessageBody);*/
    cell.textLabel.text = [names objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [msgs objectAtIndex:indexPath.row];
    NSLog(@"in config: %@", cell.textLabel.text);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    //[self configureCell:cell atIndexPath:indexPath];
    cell.textLabel.text = [names objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [msgs objectAtIndex:indexPath.row];
    NSLog(@"after config: %@", cell.textLabel.text);

    return cell;
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*XMPPMessageArchiving_Contact_CoreDataObject *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
    DNVoiceMessageViewController *messageViewController = [[DNVoiceMessageViewController alloc] init];
    messageViewController.conversation = conversation;
    messageViewController.managedObjectContext = managedObjectContext;
    [self.navigationController pushViewController:messageViewController animated:YES];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
