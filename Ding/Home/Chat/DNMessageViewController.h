//
//  DNMessageViewController.h
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPMessageArchivingCoreDataStorage.h"

@class DNMessage;
@interface DNMessageViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIActionSheetDelegate> {
    
}

@property (nonatomic, retain) UITableView *chatContent;

@property (nonatomic, retain) UIImageView *chatBar;
@property (nonatomic, retain) UITextView *chatInput;
@property (nonatomic, assign) CGFloat previousContentHeight;
@property (nonatomic, retain) UIButton *sendButton;

@property (nonatomic, copy) NSMutableArray *cellMap;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) XMPPMessageArchiving_Contact_CoreDataObject *conversation;

- (void)enableSendButton;
- (void)disableSendButton;
- (void)resetSendButton;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)resizeViewWithOptions:(NSDictionary *)options;
- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)sendMessage;
- (void)clearChatInput;
- (NSUInteger)addMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message;
- (NSUInteger)removeMessageAtIndex:(NSUInteger)index;
- (void)clearAll;

- (void)fetchResults;


@end
