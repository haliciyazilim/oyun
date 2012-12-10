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

@interface MapEntity : CCNode

@property (weak, nonatomic) GameMap* map;
@property (nonatomic) Location location;

- (id) initWithLocation:(Location)location;

@end
