//
//  DNAppDelegate.h
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"
#import "FBConnect.h"

#import "DNUser.h"

extern NSString *const kXMPPmyGoogleJID;
extern NSString *const kXMPPmyGooglePassword;

@interface DNAppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate, FBSessionDelegate> {
	XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
	
	UIWindow *window;
	UINavigationController *homeNavigationController;
    UIBarButtonItem *loginButton;
    
    ///////////////////
    XMPPStream *fbxmppStream;
	XMPPReconnect *fbxmppReconnect;
    XMPPRoster *fbxmppRoster;
	XMPPRosterCoreDataStorage *fbxmppRosterStorage;
    XMPPvCardCoreDataStorage *fbxmppvCardStorage;
	XMPPvCardTempModule *fbxmppvCardTempModule;
	XMPPvCardAvatarModule *fbxmppvCardAvatarModule;
	XMPPCapabilities *fbxmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *fbxmppCapabilitiesStorage;
    
    BOOL fballowSelfSignedCertificates;
	BOOL fballowSSLHostNameMismatch;
	
	BOOL fbisXmppConnected;
    Facebook *facebook;
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *homeNavigationController;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *loginButton;

@property (strong, nonatomic) DNUser *user;

@property (nonatomic, strong, readonly) XMPPStream *fbxmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *fbxmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *fbxmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *fbxmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *fbxmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *fbxmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *fbxmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *fbxmppCapabilitiesStorage;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (NSManagedObjectContext *)managedObjectContext_rosterFacebook;

- (BOOL)connect;
- (void)disconnect;

@end
