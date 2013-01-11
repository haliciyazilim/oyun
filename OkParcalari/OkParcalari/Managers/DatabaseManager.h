//
//  DatabaseManager.h
//  PixelScanner
//
//  Created by Eren HALICI on 16.03.2012.
//  Copyright (c) 2012 Aurvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Scene.h"

@interface DatabaseManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DatabaseManager *)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;

- (void)performInitialMigration;

- (NSArray *)loadSceneArray;
- (void)saveContext;

- (Video *)creatVideoWithPath:(NSString *)filename forScene:(Scene *)scene;
- (void)deleteVideo:(Video *)aVideo;


- (Scene *)getSceneWithID:(NSString *)id;

@end
