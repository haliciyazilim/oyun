//
//  Map.m
//  GreenTheGarden
//
//  Created by Yunus Eren Guzel on 1/10/13.
//
//

#import "Map.h"


@implementation MapPackage

@end

@implementation Map

@dynamic mapId;
@dynamic packageId;
@dynamic score;
@dynamic isFinished;
@dynamic difficulty;
@dynamic stepCount;
@dynamic tileCount;
@dynamic order;

@synthesize isPurchased;
@synthesize isLocked;
@synthesize starCount;
@synthesize package;
@synthesize isNotPlayedActiveGame;


-(id)init
{
    if(self = [super init]){
        self.isLocked = NO;
    }
    return self;
}

MAP_DIFFICULTY difficultyFromString(NSString* string){
    if([string compare:@"easy"] == 0){
        return EASY;
    }
    else if([string compare:@"normal"] == 0){
        return NORMAL;
    }
    else if([string compare:@"hard"] == 0){
        return HARD;
    }
    else if([string compare:@"insane"] == 0){
        return INSANE;
    }
    return -1;
}
NSString* stringOfDifficulty(MAP_DIFFICULTY difficulty){
    switch (difficulty) {
        case EASY:
            return @"easy";
        case NORMAL:
            return @"normal";
        case HARD:
            return @"hard";
        case INSANE:
            return @"insane";
        default:
            return nil;
    }
}
@end
