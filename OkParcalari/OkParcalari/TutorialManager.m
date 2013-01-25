//
//  TutorialManager.m
//  GreenTheGarden
//
//  Created by Yunus Eren Guzel on 1/25/13.
//
//

#import "TutorialManager.h"

@implementation TutorialManager
{
    NSString* mapId;
}

+(TutorialManager *)sharedInstance
{
    static TutorialManager* currentInstance = nil;
    if(currentInstance == nil){
        currentInstance = [[TutorialManager alloc] init];
    }
    return currentInstance;
}

-(id)init
{
    if(self = [super init]){
        mapId = @"10000";
        
    }
    return self;
}

-(BOOL)isTutorialEnabled
{
    return NO;
}

-(void)setTutorialEnabled
{
    
}

-(void)setTutorialDisabled
{
    
}

-(BOOL)isTutoringMap:(NSString*)mapFileName
{
    return NO;
}

-(BOOL)shouldDisableOtherEntities
{
    return NO;
}

-(BOOL)isCorrectEntitity:(MapEntity*)entity
{
    return NO;
}

-(BOOL)checkEntity:(MapEntity*)entity
{
    return NO;
}

-(void)showDialogMessage
{
    
}


@end