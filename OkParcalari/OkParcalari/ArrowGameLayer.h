//
//  ArrowGameLayer.h
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#import "cocos2d.h"
#import "ArrowGame.h"
#import "ArrowBase.h"

@class Stopwatch;

@interface ArrowGameLayer : CCLayer

+(CCScene *) scene;

@property ArrowGame *arrowGame;
@property Stopwatch *gameTimer;

- (void) gameEnded;

@end
