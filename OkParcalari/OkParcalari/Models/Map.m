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

@synthesize isPurchased;
@synthesize isLocked;
@synthesize starCount;
@synthesize package;

-(id)init
{
    if(self = [super init]){
        self.isLocked = NO;
    }
    return self;
}

@end
