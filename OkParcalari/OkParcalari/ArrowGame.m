//
//  ArrowGame.m
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#import "ArrowGame.h"

#import "GameMap.h"
#import "ArrowBase.h"
#import "Arrow.h"

@interface ArrowGame()
@property (readonly) GameMap* map;
@end


@implementation ArrowGame
{
    MapEntity* currentEntity;
    BOOL isHoldingArrowBase;
    BOOL isHoldingArrow;
    Location startLocation;
    Location endLocation;
    Location currentLocation;
}
- (id)init
{
    self = [super init];
    if (self) {
        
        self.gameTable = [NSMutableDictionary dictionaryWithCapacity:100];
        [self addChild:self.map];
        
        ArrowBase *arrowBase = [[ArrowBase alloc] initWithLocation:LocationMake(1, 1) andSize:10];
        [self.map addEntity:arrowBase];
    
        ArrowBase *arrowBase2 = [[ArrowBase alloc] initWithLocation:LocationMake(3, 2) andSize:10];
        [self.map addEntity:arrowBase2];
        
        ArrowBase *arrowBase3 = [[ArrowBase alloc] initWithLocation:LocationMake(0, 0) andSize:10];
        [self.map addEntity:arrowBase3];
    }

    return self;
}


- (BOOL) isGameFinished
{
    return NO;
}

- (void) touchBegan:(Location) location
{
    currentEntity = [GameMap.sharedInstance entityAtLocation:location];
    startLocation = location;
    
}

- (void) touchMoved:(Location) location
{
    if(startLocation.x == location.x && startLocation.y == location.y)
        return;
    
    if(currentEntity.class == [Arrow class]){
        
        ((Arrow*)currentEntity).endLocation = location;
        
    }
    else if(currentEntity.class == [ArrowBase class]){
        ArrowBase* base = (ArrowBase*) currentEntity;
        [base extendArrowWithEndLocation:location];
    }
}

- (void) touchEnded:(Location) location
{
    isHoldingArrow      = NO;
    isHoldingArrowBase  = NO;
    currentEntity       = nil;
}

- (void) newGame:(GameMap*) map
{
    
}




- (GameMap*) map
{
    return [GameMap sharedInstance];
}



@end
