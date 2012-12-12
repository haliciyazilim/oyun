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

- (id)initWithLocation:(Location)location andDirection:(Direction)direction forBase:(ArrowBase*)base
{
    self = [super initWithLocation:location];
    if (self) {
        self.isSelected = NO;
        self.base = base;
        self.direction = direction;
        [self createSprites];
    }
    return self;
}

- (void)setEndLocation:(Location)endLocation {
    _endLocation = endLocation;
    NSLog(@"arrow can only go towards direction");
    [self createSprites];
}

- (Direction)getDirection {
    return DirectionFromTwoLocations(self.location, self.endLocation);
}

- (int)getSize {
    int xDiff = self.endLocation.x - self.location.x;
    int yDiff = self.endLocation.y - self.location.y;
    
    switch ([self getDirection]) {
        case RIGHT:
            return xDiff;
            break;
        case UP:
            return yDiff;
            break;
        case LEFT:
            return -xDiff;
            break;
        case DOWN:
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
    
    if(size <= 0)
        return;
    
    
    
    CCSprite* sprite;
    
    switch ([self getDirection]) {
        case RIGHT:
                        
            sprite = [CCSprite spriteWithFile:@"arrow_right_start.png"];
            sprite.position = [self pointFromLocation:LocationMake(self.location.x + size, self.location.y)];
            [self addChild:sprite];
            
            for (int i = 1; i < size; i++) {
                sprite = [CCSprite spriteWithFile:@"arrow_horizontal.png"];
                sprite.position = [self pointFromLocation:LocationMake(self.location.x + i, self.location.y)];
                [self addChild:sprite];
            }
            
            break;
        case LEFT:
            break;
        case DOWN:
            break;
        case UP:
            break;
            
    }
}

- (CGPoint) pointFromLocation:(Location)location
{
    float yOffset = -self.map.tileSize.height * 1.5;
    float xOffset = -self.map.tileSize.width * 1.5;
    return CGPointMake(location.x*self.map.tileSize.width + xOffset, location.y*self.map.tileSize.height+yOffset);
}

- (BOOL)hitTestWithLocation:(Location) location
{
    switch([self getDirection]){
        case RIGHT:
            return (self.location.y == location.y && self.location.x < location.x && self.endLocation.x >= location.x);
        case LEFT:
            return (self.location.y == location.y && self.location.x > location.x && self.endLocation.x <= location.x);
        case UP:
            return (self.location.x == location.x && self.location.y < location.y && self.endLocation.y >= location.y);
        case DOWN:
            return (self.location.x == location.x && self.location.y > location.y && self.endLocation.y <= location.y);
    }
    return NO;
}





@end
