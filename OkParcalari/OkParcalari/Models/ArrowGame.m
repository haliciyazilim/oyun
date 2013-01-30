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
#import "ArrowGameLayer.h"

#import "AchievementManager.h"
#import "GreenTheGardenGCSpecificValues.h"

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

static ArrowGame* __lastInstance;

+(ArrowGame*)lastInstance
{
    return __lastInstance;
}

+(void)cleanLastInstance
{
    __lastInstance = nil;
}

- (id)initWithFile:(NSString*)fileName
{
    self = [super init];
    if (self) {
        __lastInstance = self;
        
        [self addChild:self.map];
        
        [ArrowGameMap loadFromFile:fileName];
        currentGameMapFileName = fileName;
        lastDirection = NONE;
        
        _gameTimer = [Stopwatch StopwatchWithMinutes:0 andSeconds:0];
        [_gameTimer startTimer];
        [self addChild:_gameTimer];
        _isGamePaused = NO;
        _isGameRunning = YES;
        
        if([[TutorialManager sharedInstance] isTutorialEnabled] && [[TutorialManager sharedInstance] isTutoringMap:fileName]){
            [[TutorialManager sharedInstance] startTutorial];
//            [[TutorialManager sharedInstance] performSelector:@selector(startTutorial) withObject:nil afterDelay:0.01];
        }
        
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
    
    [_gameTimer stopTimer];
    //save game
    Map* map = [[DatabaseManager sharedInstance] getMapWithID:currentGameMapFileName];
    if([map.score intValue] > [self.gameTimer getElapsedSeconds] || map.isFinished == NO){
        map.score  = [NSNumber numberWithInt:[self.gameTimer getElapsedSeconds]];
        map.isFinished = YES;
        [[DatabaseManager sharedInstance] saveContext];
    }
    
    //Achievement Check
    [[AchievementManager sharedAchievementManager]checkAchievementFastMindQuickHands:map];
    [[AchievementManager sharedAchievementManager]checkAchievementMapsStars:map];
    
    if([map.mapId isEqual:@"1000"])
        [[AchievementManager sharedAchievementManager] submitAchievement:kAchievementWarmingUp percentComplete:100];
    
    // submit Score
    NSArray *allMaps=[[DatabaseManager sharedInstance] getAllMaps];
//    NSLog(@"All MAps Count: %i",allMaps.count);
    
    int starCount=0;
    for (Map * map in allMaps)
        starCount+=map.getStarCount;
    NSLog(@"StarCount: %i",starCount);
        
    [[GameCenterManager sharedInstance] submitScore:starCount category:[[GameCenterManager sharedInstance]leaderboardCategories][0]];

    
    [[ArrowGameLayer lastInstance] gameEnded:[Map starCountForScore:[self.gameTimer getElapsedSeconds] andDifficulty:map.difficulty] andElapsedSeconds:[self.gameTimer getElapsedSeconds]];
    _isGameRunning = NO;
    [ArrowGame cleanLastInstance];
    return YES;
}
- (void) pauseGame {
    _isGamePaused = YES;
    _isGameRunning = NO;
    [_gameTimer pauseTimer];
    [[TutorialManager sharedInstance] pauseTutorial];
}
- (void) resumeGame {
    _isGamePaused = NO;
    _isGameRunning = YES;
    [_gameTimer resumeTimer];
    [[TutorialManager sharedInstance] resumeTutorial];
}

- (void) pauseTimer
{
    [_gameTimer pauseTimer];
}

- (void) resumeTimer
{
    [_gameTimer resumeTimer];
    
}

- (void) touchBegan:(Location) location
{
    if([self.map isLocationInsideMap:location] == NO){
        return;
    }
    currentEntity = [GameMap.sharedInstance entityAtLocation:location];
    startLocation = location;
    if([[TutorialManager sharedInstance] isTutorialActive]){
        ArrowBase* base = ([currentEntity class] == [ArrowBase class]) ? (ArrowBase*)currentEntity : ((Arrow*)currentEntity).base;
        if(![[TutorialManager sharedInstance] isCorrectEntitity:(ArrowBase*)base]){
            currentEntity = nil;
        }
    }
    
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
    }else{
        isInTheSameLocation = YES;
    }
    
    if(currentEntity.class == [Arrow class]){
        Arrow* arrow = (Arrow*)currentEntity;
        arrow.endLocation = location;
        [arrow removeSquirts];
        
        if([[TutorialManager sharedInstance] isTutorialActive]){
            [[TutorialManager sharedInstance] updateForMovedBase:arrow.base];
        }
    }
    else if(currentEntity.class == [ArrowBase class]){
        ArrowBase* base = (ArrowBase*) currentEntity;
        
        if([[TutorialManager sharedInstance] isTutorialActive]){
            [[TutorialManager sharedInstance] updateForMovedBase:base];
        }
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


- (void) touchEnded:(Location) location
{
    if(currentEntity != nil){
        if([currentEntity class] == [Arrow class]){
            [(Arrow *)currentEntity animateBackgrounds];
            if([[TutorialManager sharedInstance] isTutorialActive]){
                [[TutorialManager sharedInstance] checkEntity:((Arrow *)currentEntity).base];
            }
            
        }
        else if([currentEntity class] == [ArrowBase class] && lastDirection != NONE){
            Arrow *arrow = [(ArrowBase *)currentEntity arrowAtDirection:lastDirection];
            [arrow animateBackgrounds];
            if([[TutorialManager sharedInstance] isTutorialActive]){
                [[TutorialManager sharedInstance] checkEntity:(ArrowBase *)currentEntity];
            }
        }
        [self isGameFinished];
    }
    
    isHoldingArrow      = NO;
    isHoldingArrowBase  = NO;
    currentEntity       = nil;
    lastDirection       = NONE;
    
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


- (void) cleanMap {
    [[TutorialManager sharedInstance] finishTutorial];
    [self.map removeAllChildrenWithCleanup:YES];
    [self removeAllChildrenWithCleanup:YES];
    [self.map removeFromParentAndCleanup:YES];
}



- (GameMap*) map
{
    return [GameMap sharedInstance];
}

@end
