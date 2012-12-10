//
//  GameMap.h
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@class MapEntity;

@interface GameMap : CCNode

@property NSMutableSet *entities;

@property CGSize tileSize;

- (void) addEntity:(MapEntity *)entity;

@end
