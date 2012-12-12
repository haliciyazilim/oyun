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

@interface ArrowGameLayer : CCLayer

+(CCScene *) scene;

@property ArrowGame *arrowGame;

- (void) gameEnded;

@end
