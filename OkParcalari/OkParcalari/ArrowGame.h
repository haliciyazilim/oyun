//
//  ArrowGame.h
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "ArrowBase.h"

@class GameMap;

@interface ArrowGame : CCNode

@property NSMutableDictionary *gameTable;
@property NSMutableArray *arrowBases;
@property GameMap *map;

@end
