//
//  MapEntity.h
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import "CCNode.h"

#import "cocos2d.h"

@class GameMap;

typedef struct {
    int x;
    int y;
} Location;

Location LocationMake(int x, int y);

typedef enum {LEFT,RIGHT,UP,DOWN,NONE} Direction;

Direction DirectionFromTwoLocations(Location start, Location end);

NSString* StringFromDirection(Direction direction);

@interface MapEntity : CCNode

@property (nonatomic) GameMap *map;

@property (nonatomic) Location location;

@property NSMutableSet* entities;

- (id) initWithLocation:(Location)location;

- (BOOL)hitTestWithLocation:(Location) location;

- (MapEntity*)entityAtLocation:(Location)location;

- (NSSet*)entitiesAtLocation:(Location)location;

- (CGPoint) pointFromLocation:(Location)location;

@end
