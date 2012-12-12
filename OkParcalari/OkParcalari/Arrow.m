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
        self.endLocation = location;
        self.base = base;
        self.direction = direction;
        self.position = CGPointMake(0, 0);
        [self createSprites];
    }
    return self;
}

- (void)setEndLocation:(Location)endLocation {
    
    
    //izdusum hesaplanacak
//    if(DirectionFromTwoLocations(self.location, endLocation) != self.direction)
//        return;
    
    Location savedEndLocation = self.endLocation;
    _endLocation = endLocation;
    
    if([self getSize] > [self.base size]){
        _endLocation = savedEndLocation;
        return;
    }
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
        case UP:
            return yDiff;
        case LEFT:
            return -xDiff;
        case DOWN:
            return -yDiff;
        default:
            return 0;
    }
}

- (void) createSprites {
    [self removeAllChildrenWithCleanup:YES];
    
    int size = [self getSize];
    
    if(size <= 0)
        return;
    
    switch ([self getDirection]) {
        case RIGHT:{
            CCSprite* sprite = [CCSprite spriteWithFile:@"arrow_right_start.png"];
            sprite.position = [self pointFromLocation:LocationMake(self.location.x + size, self.location.y)];
            
            CCSprite* back = [CCSprite spriteWithFile:@"tile_grass.png"];
            back.position = [self pointFromLocation:LocationMake(self.location.x + size, self.location.y)];

            [self addChild:back];
            [self addChild:sprite];
            
            for (int i = 1; i < size; i++) {
                CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_horizontal.png"];
                sprite.position = [self pointFromLocation:LocationMake(self.location.x + i, self.location.y)];
                
                CCSprite *back = [CCSprite spriteWithFile:@"tile_grass.png"];
                back.position = [self pointFromLocation:LocationMake(self.location.x + i, self.location.y)];
                
                [self addChild:back];
                [self addChild:sprite];
            }
        }
            break;
        case LEFT:{
            CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_left_start.png"];
            sprite.position = [self pointFromLocation:LocationMake(self.location.x - size, self.location.y)];
            
            CCSprite *back = [CCSprite spriteWithFile:@"tile_grass.png"];
            back.position = [self pointFromLocation:LocationMake(self.location.x - size, self.location.y)];
            
            [self addChild:back];
            [self addChild:sprite];
            
            for (int i = 1; i < size; i++) {
                CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_horizontal.png"];
                sprite.position = [self pointFromLocation:LocationMake(self.location.x - i, self.location.y)];
                
                CCSprite *back = [CCSprite spriteWithFile:@"tile_grass.png"];
                back.position = [self pointFromLocation:LocationMake(self.location.x - i, self.location.y)];
                
                [self addChild:back];
                [self addChild:sprite];
            }
        }
            break;
        case DOWN:
            break;
        case UP:
            break;
            
    }
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
