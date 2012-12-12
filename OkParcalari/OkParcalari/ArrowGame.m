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
    Direction lastDirection;
}
- (id)init
{
    self = [super init];
    if (self) {
        
        [self addChild:self.map];
        
        ArrowBase *arrowBase = [[ArrowBase alloc] initWithLocation:LocationMake(1, 1) andSize:10];
        [self.map addChild:arrowBase];
    
        ArrowBase *arrowBase2 = [[ArrowBase alloc] initWithLocation:LocationMake(3, 2) andSize:10];
        [self.map addChild:arrowBase2];
        
        ArrowBase *arrowBase3 = [[ArrowBase alloc] initWithLocation:LocationMake(0, 0) andSize:10];
        [self.map addChild:arrowBase3];
        ArrowBase * base;
        base = [[ArrowBase alloc] initWithLocation:LocationMake(9, 0) andSize:10];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(0, 9) andSize:10];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(9, 9) andSize:10];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(0, 5) andSize:10];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(5, 0) andSize:10];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(9, 5) andSize:10];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(5, 9) andSize:10];
        [self.map addChild:base];
        
        
        lastDirection = NONE;
        
        
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
    NSLog(@"%@",[currentEntity class]);
    
}

- (void) touchMoved:(Location) location
{
    BOOL isInTheSameLocation = NO;
    if(startLocation.x != location.x || startLocation.y != location.y){
        lastDirection = DirectionFromTwoLocations(startLocation, location);
    }else
        isInTheSameLocation = YES;
    
    if(currentEntity.class == [Arrow class]){
        
        ((Arrow*)currentEntity).endLocation = location;
        
    }
    else if(currentEntity.class == [ArrowBase class]){
        ArrowBase* base = (ArrowBase*) currentEntity;
        if(isInTheSameLocation && lastDirection != NONE){
            [base compressArrowAtDirection:lastDirection];
        }
        else{
            [base extendArrowWithEndLocation:location];
        }
                
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
