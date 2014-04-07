//
//  DNBaseChatRequestManager.h
//  Ding
//
//  Created by Mark Miyashita on 4/6/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface DNBaseChatRequestManager : NSObject
@property (readonly, nonatomic, strong) XMPPStream *xmppStream;

- (void)sendMessageToFacebook:(NSString*)textMessage
         withFriendFacebookID:(NSString*)friendID;
@end
