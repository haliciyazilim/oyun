//
//  ArrowBase.m
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import "ArrowBase.h"

#import "GameMap.h"

@interface ArrowBase()

@property Arrow* upArrow;
@property Arrow* downArrow;
@property Arrow* leftArrow;
@property Arrow* rightArrow;

@end


@implementation ArrowBase
+ (id) ArrowBaseWithLocation:(Location)location andSize:(int)size {
    return [[ArrowBase alloc] initWithLocation:location andSize:size];
}

- (id) initWithLocation:(Location)location andSize:(int)size {
    self = [super initWithLocation:location];
    
    if (self) {
        self.size = size;
        
        self.upArrow    = [[Arrow alloc] initWithLocation:self.location andDirection:UP forBase:self];
        self.downArrow  = [[Arrow alloc] initWithLocation:self.location andDirection:DOWN forBase:self];
        self.rightArrow = [[Arrow alloc] initWithLocation:self.location andDirection:RIGHT forBase:self];
        self.leftArrow  = [[Arrow alloc] initWithLocation:self.location andDirection:LEFT forBase:self];
        
        [self addChild:self.upArrow];
        [self addChild:self.downArrow];
        [self addChild:self.leftArrow];
        [self addChild:self.rightArrow];
        
        [self createSprite];
    }
    
    return self;
}


- (void) createSprite {
    CCSprite *sprite = [CCSprite spriteWithFile:@"pepper.png"];
//    player.position = CGPointMake(self.map.tileSize.width/2, self.map.tileSize.height/2);
    sprite.position = CGPointMake(32, 32);
    [self addChild:sprite];
}

- (BOOL) isCorrect {
//    return (self.leftArrowSize + self.rightArrowSize + self.upArrowSize + self.downArrowSize == self.size);
    return NO;
}

- (Arrow *) arrowAtDirection:(Direction) direction
{
    switch (direction) {
        case UP:
            return self.upArrow;
        case DOWN:
            return self.downArrow;
        case LEFT:
            return self.leftArrow;
        case RIGHT:
            return self.rightArrow;
    }
}

- (Arrow *) extendArrowWithEndLocation:(Location) endLocation
{
    NSLog(@"%@",StringFromDirection(DirectionFromTwoLocations(self.location, endLocation)));
    Arrow* arrow = [self arrowAtDirection:DirectionFromTwoLocations(self.location, endLocation)];
    arrow.endLocation = endLocation;
    return arrow;
}

@end
