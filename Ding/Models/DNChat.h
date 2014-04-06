//
//  DNChat.h
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Message;
@interface DNChat : NSManagedObject {
    
}

@property (nonatomic, retain) id lastMessage;
@property (nonatomic, retain) NSSet *messages;

@end
