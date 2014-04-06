//
//  DNAppDelegate.m
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNAppDelegate.h"

#import "DNHomeNavigationController.h"
#import "DNFacebookFriendsNavigationController.h"
#import "DNFacebookFriendsViewController.h"
#import "DNFriendsNavigationController.h"
#import "DNFriendsViewController.h"
#import "DNLoginNavigationController.h"
#import "DNLoginViewController.h"

#import "MMDrawerController.h"

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"


NSString *const kXMPPmyGoogleJID = @"kXMPPmyGoogleJID";
NSString *const kXMPPmyGooglePassword = @"kXMPPmyGooglePassword";

NSString *const kXMPPmyFBJID = @"kXMPPmyFBJID";
NSString *const kXMPPmyFBPassword = @"kXMPPmyFBPassword";

#define FACEBOOK_APP_ID @"124242144347927"

@interface DNAppDelegate()

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end

@implementation DNAppDelegate

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

@synthesize fbxmppStream;
@synthesize fbxmppReconnect;
@synthesize fbxmppRoster;
@synthesize fbxmppRosterStorage;
@synthesize fbxmppvCardTempModule;
@synthesize fbxmppvCardAvatarModule;
@synthesize fbxmppCapabilities;
@synthesize fbxmppCapabilitiesStorage;

@synthesize window;
@synthesize homeNavigationController;
@synthesize loginButton;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"starting app");
    
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    
    // Setup the XMPP stream
	[self setupStream];
    //[self setupFBStream];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSLog(@"Device is iPad");
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        self.window.rootViewController = splitViewController;
    } else {
        NSLog(@"Device is iPhone");
        DNFacebookFriendsViewController *facebookFriendsViewController = [[DNFacebookFriendsViewController alloc] init];
        DNFriendsViewController *friendsViewController = [[DNFriendsViewController alloc] init];
        
        DNFacebookFriendsNavigationController *facebookFriendsNavigationController = [[DNFacebookFriendsNavigationController alloc] initWithRootViewController:facebookFriendsViewController];
        DNHomeNavigationController *homeNavigation = [[DNHomeNavigationController alloc] init];
        DNFriendsNavigationController *friendsNavigationController = [[DNFriendsNavigationController alloc] initWithRootViewController:friendsViewController];
        
        [self setHomeNavigationController:homeNavigation];
        
        MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.homeNavigationController leftDrawerViewController:friendsNavigationController rightDrawerViewController:facebookFriendsNavigationController];
        
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningCenterView];

        [friendsViewController setAppDelegate:self];
        
        [self.window setRootViewController:drawerController];
        

    }
    
    [self.window makeKeyAndVisible];
    
    //[self fbAuthorize];

    return YES;
}

- (void)checkUser {
    NSLog(@"Check user");
    if (![self connect]) {
        NSLog(@"Google account not signed in");
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			
            DNLoginViewController *loginViewController = [[DNLoginViewController alloc] init];
            DNLoginNavigationController *loginNavigationController = [[DNLoginNavigationController alloc] initWithRootViewController:loginViewController];
			[self.window.rootViewController presentViewController:loginNavigationController animated:YES completion:NULL];
		});
	} else {
        NSLog(@"Connected to Google");
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster {
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities {
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_rosterFacebook {
    NSLog(@"fbnxppspspsps: %@", fbxmppRosterStorage);
	return [fbxmppRosterStorage mainThreadManagedObjectContext];
}

- (void)dealloc {
	[self teardownStream];
}

- (void)setupGoogleVoice: (NSString *)username and:(NSString *)passwordEntry {
    NSLog(@"setup google voice");
    GVoice *voice = [[GVoice alloc] initWithUser: username password: passwordEntry source: @"com.markmiyashita.ding"
								  accountType: GOOGLE];
    
    // This causes some logging to happen.
    voice.logToConsole = YES;
    
    BOOL res = [voice login];
    
    if (!res) {
        NSLog(@"not logged into voice");
    }
    
    // Send an SMS. Replace TEXT_PHONE_NUMBER with a proper 10-digit phone number
    // capable of receiving SMS messages
    // res = [voice sendSmsText: @"Testing 1, 2, 3" toNumber: @"9164204682"];
    
    if (!res) {
        NSLog(@"did not send message");
    }
}

- (void)setupFBStream {
    NSLog(@"set up FB stream");
    // it is also possible to use init, but then we need to also set xmppStream.appId and xmppStream.hostName
	fbxmppStream = [[XMPPStream alloc] initWithFacebookAppId:FACEBOOK_APP_ID];
	
	[fbxmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:self];
    
    [xmppRoster activate:fbxmppStream];
    [xmppReconnect activate:fbxmppStream];
	
    //self.viewController.statusLabel.text = @"Starting Facebook Authentication";
    
	// Note: Be sure to invoke this AFTER the [self.window makeKeyAndVisible] method call above,
	//       or nothing will happen.
}

- (void)fbAuthorize {
    [facebook authorize:[NSArray arrayWithObject:@"xmpp_login"]];
}

- (void)setupStream {
    NSLog(@"set up stream called");
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
	[xmppStream setHostName:@"talk.google.com"];
	[xmppStream setHostPort:5222];
    
    // Message storing
    xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingStorage];
    
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [xmppMessageArchivingModule activate:xmppStream];
    [xmppMessageArchivingModule  addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream {
    NSLog(@"teardown called");
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}


- (void)goOnline {
    NSLog(@"go online called");
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    // Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"] || [domain isEqualToString:@"gtalk.com"] || [domain isEqualToString:@"talk.google.com"]) {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    NSLog(@"go offline called");
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect {
	if (![xmppStream isDisconnected]) {
        NSLog(@"stream is not disconnected");
		return YES;
	}
    
	NSString *myGoogleJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyGoogleJID];
	NSString *myGooglePassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyGooglePassword];
    NSLog(@"my google id: %@", myGoogleJID);
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myGoogleJID == nil || myGooglePassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myGoogleJID]];
	password = myGooglePassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		NSLog(@"Error connecting: %@", error);
		return NO;
	}
    NSLog(@"success logging in with google");
    [self setupGoogleVoice:myGoogleJID and:password];

	return YES;
}

- (void)disconnect {
	[self goOffline];
	[xmppStream disconnect];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
	if (allowSelfSignedCertificates) {
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch) {
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	} else {
		NSString *expectedCertName = [xmppStream.myJID domain];
        
		if (expectedCertName) {
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender {
    NSLog(@"secure");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"stream connected");
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error]) {
		NSLog(@"Error authenticating: %@", error);
	}
    
    // Facebook
    /*
    if (![fbxmppStream isSecure]) {
        NSError *error = nil;
        BOOL result = [fbxmppStream secureConnection:&error];
        
        if (result == NO) {
            NSLog(@"Error in xmpp STARTTLS: %@", error);
        }
    } else {
        NSError *error = nil;
        BOOL result = [fbxmppStream authenticateWithFacebookAccessToken:facebook.accessToken error:&error];
        
        if (result == NO) {
            NSLog(@"Error in xmpp auth: %@", error);
        }
    }
     */
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSLog(@"received message");
	// A simple example of inbound message handling.
    
	if ([message isChatMessageWithBody]) {
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];
		
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [user displayName];
        
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                                message:body
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
			[alertView show];
		} else {
			// We are not active, so use a local notification instead
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error {
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    NSLog(@"sent message");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
	if (!isXmppConnected) {
		NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence {
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare]) {
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	} else {
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	} else {
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
}

////////////////////////////////////////////////////
// FACEBOOK
////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Facebook Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url];
}

- (void)fbDidLogin {
	NSLog(@"Facebook login successful!");
	
	NSLog(@"facebook.accessToken: %@", facebook.accessToken);
	NSLog(@"facebook.expirationDate: %@", facebook.expirationDate);
	
    //self.viewController.statusLabel.text = @"XMPP connecting...";
    
	NSError *error = nil;
	if (![fbxmppStream connectWithTimeout:5 error:&error]) {
		NSLog(@"Error in xmpp connection: %@", error);
        //self.viewController.statusLabel.text = @"XMPP connect failed";
	}
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"fb did not log in");
    //self.viewController.statusLabel.text = @"Facebook login failed";
}

- (void)fbDidLogout {
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
}

- (void)fbSessionInvalidated {
}


// Built in.
- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self checkUser];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
