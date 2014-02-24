//
//  Tasks.h
//  todot
//
//  Created by Rodrigo Nascimento on 24/02/14.
//  Copyright (c) 2014 Rodrigo Krummenauer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tasks : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * color;

@end
