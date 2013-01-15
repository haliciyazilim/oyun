//
//  Map.h
//  GreenTheGarden
//
//  Created by Yunus Eren Guzel on 1/10/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MapPackage

@property NSString* name;
@property int packageId;
@property NSArray* maps;

@end

@interface Map : NSManagedObject

@property NSString *mapId;
@property NSString *packageId;
@property NSNumber *score;
@property BOOL isFinished;

@property BOOL isPurchased;
@property BOOL isLocked;
@property int  starCount;
@property MapPackage* package;
@property BOOL isNotPlayedActiveGame;

@end
