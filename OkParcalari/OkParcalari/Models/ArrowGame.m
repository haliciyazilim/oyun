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
#import "Stopwatch.h"
#import "WaterSpray.h"
#import "InAppPurchaseManager.h"

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
    NSString* currentGameMapFileName;
}

- (id)initWithFile:(NSString*)fileName
{
    self = [super init];
    if (self) {
        
        [self addChild:self.map];
        
        [ArrowGameMap loadFromFile:fileName];
        currentGameMapFileName = fileName;
        lastDirection = NONE;
        
        _gameTimer = [Stopwatch StopwatchWithMinutes:0 andSeconds:0];
        [_gameTimer startTimer];
        [self addChild:_gameTimer];
        
        [GameHistory saveScore:35 forMap:@"xcvxcv"];
        [GameHistory readScoresFromFile];
        NSLog(@"[GameHistory scores].count = %d",[[GameHistory scores] count]);
        [GameHistory saveScore:12 forMap:@"hfdsgd"];
        [GameHistory readScoresFromFile];
        NSLog(@"[GameHistory scores].count = %d",[[GameHistory scores] count]);
        [GameHistory saveScore:54 forMap:@"sdfsdf"];
        [GameHistory readScoresFromFile];
        NSLog(@"[GameHistory scores].count = %d",[[GameHistory scores] count]);
        [GameHistory saveScore:22 forMap:@"zxc"];
        [GameHistory readScoresFromFile];
        NSLog(@"[GameHistory scores].count = %d",[[GameHistory scores] count]);
        [GameHistory saveScore:87 forMap:@"xcvxcv"];
        [GameHistory readScoresFromFile];
        NSLog(@"[GameHistory scores].count = %d",[[GameHistory scores] count]);
        
    }
    return self;
}


- (BOOL) isGameFinished
{
    //create empty bitmap
    NSMutableDictionary* bitMap = [[NSMutableDictionary alloc] init];
    for(int i=0;i<self.map.rows;i++){
        for(int j=0;j<self.map.cols;j++){
            [bitMap setValue:@"0" forKey:LocationToString(LocationMake(i, j))];
        }
    }
    
    //ask all the arrow bases if they are correct.
    NSSet* set = [self.map allEntries];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        MapEntity* entity = (MapEntity*)obj;
        [entity markWateredLocationsIn:bitMap];
    }];
    
    for(int i=0;i<self.map.rows;i++){
        for(int j=0;j<self.map.cols;j++){
            NSString* value = (NSString*)[bitMap valueForKey:LocationToString(LocationMake(i, j))];
            if([value compare:@"0"] == 0)
                return NO;
        }
    }
    NSLog(@"***GAME IS FINISHED***");
    
    [_gameTimer stopTimer];
    [[GameCenterManager sharedInstance] saveScore:[_gameTimer getElapsedSeconds] category:[currentGameMapFileName lastPathComponent]];
    
    return YES;
}

- (void) touchBegan:(Location) location
{
    if([self.map isLocationInsideMap:location] == NO)
        return;
    currentEntity = [GameMap.sharedInstance entityAtLocation:location];

    startLocation = location;
    
}

- (void) touchMoved:(Location) location
{
    location = [self projectedLocation:location];
    
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
        Arrow* arrow = (Arrow*)currentEntity;
        arrow.endLocation = location;
        
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
            
        }else if(lastDirection != NONE && (lastDirection != currentDirection) && currentDirection != NONE){
            [base compressArrowAtDirection:lastDirection];
            [base extendArrowWithEndLocation:location];
            lastDirection = currentDirection;
        }
                
    }
}

- (Location) projectedLocation:(Location) location
{
    location = LocationMake(location.x - startLocation.x,location.y - startLocation.y);
    if(abs(location.x) > abs(location.y))
        location = LocationMake(location.x, 0);
    else
        location = LocationMake(0, location.y);
    
    return LocationMake(location.x + startLocation.x, location.y + startLocation.y);
}

- (void) touchEnded:(Location) location
{
    if(currentEntity != nil){
        if([currentEntity class] == [Arrow class]){
            [(Arrow *)currentEntity animateBackgrounds];
            
        }
        else if([currentEntity class] == [ArrowBase class] && lastDirection != NONE){
            Arrow *arrow = [(ArrowBase *)currentEntity arrowAtDirection:lastDirection];
            [arrow animateBackgrounds];
        }
        [self isGameFinished];
    }
    
    
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
