//
//  GameMap.h
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "MapEntity.h"

@interface GameMap : CCNode

@property CGSize tileSize;

@property NSMutableSet* entities;

@property int rows,cols;

+ (GameMap*) loadFromFile:(NSString*)fileName;

+ (GameMap*) sharedInstance;

- (void) addEntity:(MapEntity *)entity;

- (Location) convertAbsolutePointToGridPoint:(CGPoint) absolutePoint;

- (MapEntity*)entityAtLocation:(Location) location;

- (NSSet*)entitiesAtLocation:(Location) location;

@end
