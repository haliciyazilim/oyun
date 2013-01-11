//
//  DatabaseManager.h
//  GreenTheGarden
//
//  Created by Eren Halici on 11.01.2013.
//
//

#import <Foundation/Foundation.h>

#import "Map.h"

@interface DatabaseManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DatabaseManager *)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (BOOL)isEmpty;
- (void)insertMaps:(NSArray *)maps forPackage:(NSString *)packageId;
- (Map *)getMapWithID:(NSString *)mapId;

@end
