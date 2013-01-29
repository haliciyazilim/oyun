//
//  TutorialManager.h
//  GreenTheGarden
//
//  Created by Yunus Eren Guzel on 1/25/13.
//
//

#import <Foundation/Foundation.h>
#import "MapEntity.h"
#import "Map.h"
#import "GameMap.h"
#import "ArrowBase.h"

@interface TutorialManager : NSObject

+(TutorialManager*)sharedInstance;

-(BOOL)isTutorialEnabled;

-(void)setTutorialEnabled;

-(void)setTutorialDisabled;

-(BOOL)isTutoringMap:(NSString*)mapFileName;

-(void)startTutorial;

-(void)skipTutorial;

-(BOOL)isTutorialActive;

-(BOOL)shouldDisableOtherEntities;

-(BOOL)isCorrectEntitity:(MapEntity*)entity;

-(BOOL)checkEntity:(MapEntity*)entity;

@end
