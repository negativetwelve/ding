//
//  DNMessage.h
//  Ding
//
//  Created by Melissa on 4/5/14.
//  Copyright (c) 2014 Mark Miyashita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface DNMessage : NSManagedObject {

}

@property (nonatomic, retain) NSDate *sentDate;
@property (nonatomic, retain) NSNumber *read;
@property (nonatomic, retain) NSString *text;

@end
