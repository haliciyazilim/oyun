//
//  Arrow.m
//  OkParcalari
//
//  Created by Eren Halici on 10.12.2012.
//
//

#import "Arrow.h"

@implementation Arrow

- (id)init
{
    return [self initWithLocation:LocationMake(0, 0)];
}

- (id)initWithLocation:(Location)location
{
    self = [super initWithLocation:location];
    if (self) {
        self.isSelected = NO;
        [self createSprites];
    }
    return self;
}

- (void)setEndLocation:(Location)endLocation {
    _endLocation = endLocation;
    
    [self createSprites];
}

- (int)getDirection {
    int xDiff = self.endLocation.x - self.location.x;
    int yDiff = self.endLocation.y - self.location.y;
    
    if (yDiff == 0) {
        if (xDiff > 0) {
            return 1;
        } else if (xDiff < 0) {
            return 3;
        } else {
            return 0;
        }
    } else if (yDiff > 0) {
        if (xDiff == 0) {
            return 2;
        } else {
            return 0;
        }
    } else {
        if (xDiff == 0) {
            return 4;
        } else {
            return 0;
        }
    }
}

- (int)getSize {
    int xDiff = self.endLocation.x - self.location.x;
    int yDiff = self.endLocation.y - self.location.y;
    
    switch ([self getDirection]) {
        case 1:
            return xDiff;
            break;
        case 2:
            return yDiff;
            break;
        case 3:
            return -xDiff;
            break;
        case 4:
            return -yDiff;
            break;
        default:
            return 0;
            break;
    }
}

- (void) createSprites {
    [self removeAllChildrenWithCleanup:YES];
    
    int size = [self getSize];
    
    CCSprite* sprite;
    
    switch ([self getDirection]) {
        case 1:
            sprite = [CCSprite spriteWithFile:@"arrow_right_butt.png"];
            sprite.position = CGPointMake(32, 32);
            [self addChild:sprite];
            
            CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_right_head.png"];
            sprite.position = CGPointMake(32 + size*64, 32);
            [self addChild:sprite];
            
            for (int i = 1; i < size; i++) {
                CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_right_middle.png"];
                sprite.position = CGPointMake(32 + i*64, 32);
                [self addChild:sprite];
            }
            
            break;
    }
}


@end
