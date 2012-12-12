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
        
        ArrowBase *arrowBase = [[ArrowBase alloc] initWithLocation:LocationMake(1, 1) andSize:16];
        [self.map addChild:arrowBase];
    
        ArrowBase *arrowBase2 = [[ArrowBase alloc] initWithLocation:LocationMake(3, 2) andSize:15];
        [self.map addChild:arrowBase2];
        
        ArrowBase *arrowBase3 = [[ArrowBase alloc] initWithLocation:LocationMake(0, 0) andSize:7];
        [self.map addChild:arrowBase3];
        ArrowBase * base;
        base = [[ArrowBase alloc] initWithLocation:LocationMake(9, 0) andSize:19];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(0, 9) andSize:14];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(9, 9) andSize:7];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(0, 5) andSize:13];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(5, 0) andSize:9];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(9, 5) andSize:5];
        [self.map addChild:base];
        base = [[ArrowBase alloc] initWithLocation:LocationMake(5, 9) andSize:4];
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
    if([self.map isLocationInsideMap:location] == NO)
        return;
    currentEntity = [GameMap.sharedInstance entityAtLocation:location];
    startLocation = location;
    NSLog(@"%@",[currentEntity class]);
    
}

- (void) touchMoved:(Location) location
{
    if([self.map isLocationInsideMap:location] == NO)
        return;
    
    BOOL isInTheSameLocation = NO;
    Direction currentDirection = DirectionFromTwoLocations(startLocation, location);
    if(startLocation.x != location.x || startLocation.y != location.y){
        if(lastDirection == NONE)
            lastDirection = currentDirection;
    }else
        isInTheSameLocation = YES;
    
    if(currentEntity.class == [Arrow class]){
        
        ((Arrow*)currentEntity).endLocation = location;
        
    }
    else if(currentEntity.class == [ArrowBase class]){
        ArrowBase* base = (ArrowBase*) currentEntity;
        if(lastDirection != NONE && (lastDirection == currentDirection || currentDirection == NONE)){
            if(isInTheSameLocation){
                [base compressArrowAtDirection:lastDirection];
            }
            else{
                [base extendArrowWithEndLocation:location];
            }
            
        }
                
    }
}

- (void) touchEnded:(Location) location
{
    
    
    isHoldingArrow      = NO;
    isHoldingArrowBase  = NO;
    currentEntity       = nil;
    lastDirection       = NONE;
    
    
}

- (void) newGame:(GameMap*) map
{
    
}




- (GameMap*) map
{
    return [GameMap sharedInstance];
}



@end
