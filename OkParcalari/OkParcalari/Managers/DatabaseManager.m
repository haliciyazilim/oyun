//
//  DatabaseManager.m
//  PixelScanner
//
//  Created by Eren HALICI on 16.03.2012.
//  Copyright (c) 2012 Aurvis. All rights reserved.
//

#import "DatabaseManager.h"

#import "Scene.h"
#import "Video.h"

static DatabaseManager *sharedInstance = nil;

@implementation DatabaseManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Singleton and init methods

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (DatabaseManager *)sharedInstance
{
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark - Migrations

- (void)performInitialMigration {
    Scene *aScene;
    aScene = [NSEntityDescription insertNewObjectForEntityForName:@"Scene" inManagedObjectContext:self.managedObjectContext];
    [aScene setName:@"Fountain"];
    [aScene setOwner_name:@"etola"];

    aScene = [NSEntityDescription insertNewObjectForEntityForName:@"Scene" inManagedObjectContext:self.managedObjectContext];
    [aScene setName:@"Marble"];
    [aScene setOwner_name:@"etola"];
    
    [self saveContext];
}

#pragma mark -

- (NSArray *)loadSceneArray {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Scene" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    
//    [mutableFetchResults enumerateObjectsUsingBlock:^(id aScene, NSUInteger idx, BOOL *stop) {
//        [(Scene*)aScene initialize];
//    }];
    
    return mutableFetchResults;
}

- (Video *)creatVideoWithPath:(NSString *)filename forScene:(Scene *)scene {
    Video *aVideo = [NSEntityDescription insertNewObjectForEntityForName:@"Video"
                                                  inManagedObjectContext:self.managedObjectContext];
    aVideo.scene = scene;
    aVideo.name = [NSString stringWithFormat:@"%@_%d", scene.name, aVideo.id];
    aVideo.metadata = @"Video created by PixelScanner";
    aVideo.path = filename;
    
    [self saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSceneNotificationSceneUpdated object:scene];
    
    return aVideo;
}

- (void)deleteVideo:(Video *)aVideo {
    Scene *aScene = (Scene*)aVideo.scene;
    [self.managedObjectContext deleteObject:aVideo];
    [self saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSceneNotificationSceneUpdated object:aScene];
}

- (void)saveContext {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Handle the error.
    }
}

- (Scene *)getSceneWithID:(NSString *)id {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Scene" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"scene_id == %@", id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
        return nil;
    } else {
        if (mutableFetchResults.count == 0) {    
            Scene *aScene = [NSEntityDescription insertNewObjectForEntityForName:@"Scene"
                                                          inManagedObjectContext:self.managedObjectContext];
            aScene.scene_id = id;
            aScene.infoLevel = kInfoLevelNone;
            [self saveContext];
            return aScene;
        } else {
            return [mutableFetchResults objectAtIndex:0];
        }
    }
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PixelScanner.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

@end
