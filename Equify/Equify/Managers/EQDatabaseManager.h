//
//  EQDatabaseManager.h
//  Equify
//
//  Created by Alperen Kavun on 11.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EQDatabaseManager : NSObject


@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (EQDatabaseManager *)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (BOOL)isEmpty;
- (NSManagedObject*) createEntity:(NSString*)entityName;

- (NSMutableArray *)entitiesWithRequest:(NSFetchRequest *)request forName:(NSString*)entitiyName;
- (NSManagedObject *)entityWithRequest:(NSFetchRequest *)request forName:(NSString*)entitiyName;

-(void)deleteObject:(NSManagedObject*)managedObject;

@end
