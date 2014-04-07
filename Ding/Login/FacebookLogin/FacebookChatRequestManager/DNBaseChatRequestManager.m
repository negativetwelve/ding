//
//  DNBaseChatRequestManager.m
//  Ding
//
//  Created by Mark Miyashita on 4/6/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import "DNBaseChatRequestManager.h"
#import "DNFacebookAPIController.h"
#import "DNAuthFacebookManager.h"

@interface DNBaseChatRequestManager ()
@end

@implementation DNBaseChatRequestManager

- (id)init {
    if (self = [super init]) {
        _xmppStream = [[XMPPStream alloc] initWithFacebookAppId:FACEBOOK_APP_ID];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}


#pragma mark XMPPStream Delegate methods
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    if (![self.xmppStream isSecure]) {
        NSLog(@"XMPP STARTTLS...");
        NSError *error = nil;
        BOOL result = [self.xmppStream secureConnection:&error];
        
        if (result == NO) {
            NSLog(@"XMPP STARTTLS failed: %@", error);
        }
    } else {
        NSLog(@"XMPP X-FACEBOOK-PLATFORM SASL...");
        NSError *error = nil;
        BOOL result = [self.xmppStream authenticateWithFacebookAccessToken:[[DNFacebookAPIController sharedInstance] authFacebookManager].facebook.accessToken
                                                                     error:&error];
        
        if (result == NO) {
            NSLog(@"Error in xmpp auth: %@", error);
            NSLog(@"XMPP authentication failed");
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
	if (NO) {
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (NO) {
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	} else {
		NSString *expectedCertName = [sender hostName];
		if (expectedCertName == nil) {
			expectedCertName = [[sender myJID] domain];
		}
        
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender {
    NSLog(@"XMPP STARTTLS...");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"XMPP authenticated");
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    NSLog(@"XMPP authentication failed: %@", error);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"XMPP disconnected");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    // we recived message
    [[NSNotificationCenter defaultCenter] postNotificationName:kFCMessageDidComeNotification
                                                        object:message];
}

#pragma mark send message to Facebook.
- (void)sendMessageToFacebook:(NSString*)textMessage withFriendFacebookID:(NSString*)friendID {
    if([textMessage length] > 0) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:textMessage];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        //[message addAttributeWithName:@"xmlns" stringValue:@"http://www.facebook.com/xmpp/messages"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"-%@@chat.facebook.com",friendID]];
        [message addChild:body];
        [self.xmppStream sendElement:message];
    }
}

@end
