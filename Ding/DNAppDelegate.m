//
//  DNAppDelegate.m
//  Ding
//
//  Created by Mark Miyashita on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNAppDelegate.h"

#import "DNHomeNavigationController.h"
#import "DNHomeViewController.h"
#import "DNSettingsNavigationController.h"
#import "DNSettingsViewController.h"
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

@implementation DNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"starting app");
    
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSLog(@"Device is iPad");
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        self.window.rootViewController = splitViewController;
    } else {
        NSLog(@"Device is iPhone");
        DNHomeViewController *homeViewController = [[DNHomeViewController alloc] init];
        DNSettingsViewController *settingsViewController = [[DNSettingsViewController alloc] init];
        DNFriendsViewController *friendsViewController = [[DNFriendsViewController alloc] init];
        
        DNSettingsNavigationController *settingsNavigationController = [[DNSettingsNavigationController alloc] initWithRootViewController:settingsViewController];
        DNHomeNavigationController *homeNavigationController = [[DNHomeNavigationController alloc] initWithRootViewController:homeViewController];
        DNFriendsNavigationController *friendsNavigationController = [[DNFriendsNavigationController alloc] initWithRootViewController:friendsViewController];
        
        MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:homeNavigationController leftDrawerViewController:settingsNavigationController rightDrawerViewController:friendsNavigationController];
        
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningCenterView];
        
        [homeViewController setDrawerController:drawerController];
        [homeViewController setHomeNavigationController:homeNavigationController];
        
        [self.window setRootViewController:drawerController];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)checkUser {
    if (!self.user) {
        NSLog(@"User not logged in");
        
        if ([self.window.rootViewController.presentedViewController isMemberOfClass:NSClassFromString(@"DNLoginNavigationController")]) {
            NSLog(@"In Login nav controller");
            DNLoginNavigationController *loginNavigationController = (DNLoginNavigationController *)self.window.rootViewController.presentedViewController;
            
        } else {
            DNLoginViewController *loginViewController = [[DNLoginViewController alloc] init];
            DNLoginNavigationController *loginNavigationController = [[DNLoginNavigationController alloc] initWithRootViewController:loginViewController];
            [self.window.rootViewController presentViewController:loginNavigationController animated:YES completion:nil];
        }
    }
}
							
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
