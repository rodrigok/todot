//
//  TDTAppDelegate.h
//  todot
//
//  Created by Rodrigo K on 2/22/14.
//  Copyright (c) 2014 Rodrigo Krummenauer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
