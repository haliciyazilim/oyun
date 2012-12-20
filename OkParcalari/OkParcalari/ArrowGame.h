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

#import "ArrowGameMap.h"

@class GameMap;
@class Stopwatch;

@interface ArrowGame : CCNode

@property NSMutableArray *arrowBases;
@property Stopwatch *gameTimer;

- (BOOL) isGameFinished;

- (void) touchBegan:(Location) location;

- (void) touchMoved:(Location) location;

- (void) touchEnded:(Location) location;

- (void) newGame:(GameMap*) map;




@end
