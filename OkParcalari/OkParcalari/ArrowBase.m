//
//  ArrowBase.m
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import "ArrowBase.h"

#import "GameMap.h"

@implementation ArrowBase

+ (id) ArrowBaseWithLocation:(Location)location andSize:(int)size {
    return [[ArrowBase alloc] initWithLocation:location andSize:size];
}

- (id) initWithLocation:(Location)location andSize:(int)size {
    self = [super initWithLocation:location];
    
    if (self) {
        self.size = size;
        
        self.upArrowSize = 0;
        self.downArrowSize = 0;
        self.leftArrowSize = 0;
        self.rightArrowSize = 0;
        
        [self createSprite];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.size = 0;
        
        self.upArrowSize = 0;
        self.downArrowSize = 0;
        self.leftArrowSize = 0;
        self.rightArrowSize = 0;
        
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
    return (self.leftArrowSize + self.rightArrowSize + self.upArrowSize + self.downArrowSize == self.size);
}

@end
