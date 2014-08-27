//
//  BLESAppDelegate.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.11..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreData/CoreData.h>
#import "BLESDemoSession.h"

#define myAppDelegate ((BLESAppDelegate *)[[UIApplication sharedApplication] delegate])

@interface BLESAppDelegate : UIResponder <UIApplicationDelegate, WhereAmINotificationDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

//- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) BLESDemoSession *mySession;

@end
