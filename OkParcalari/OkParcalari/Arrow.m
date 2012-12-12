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
    endLocation = [self projectedLocation:endLocation];
    
    Location savedEndLocation = self.endLocation;
    _endLocation = endLocation;
    
    BOOL applyChanges = YES;
    
    if([self getSize] > [self.base size]){
        applyChanges = NO;
    }
    
    for(int i=1;i<[self getSize];i++){
        NSArray* entities = [[self.map entitiesAtLocation:[self locationAtOrder:i]] allObjects];
        if([entities count] == 0)
            continue;
        else if([entities count] == 1 ){
            if((Arrow*)[entities objectAtIndex:0] == self)
                break;
            else
                applyChanges = NO;
        }
        else
            applyChanges = NO;
        
    }
    
    if(applyChanges == NO){
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
            
            CCSprite* back = [CCSprite spriteWithFile:@"tile_flower.png"];
            back.position = [self pointFromLocation:LocationMake(self.location.x + size, self.location.y)];

            [self addChild:back];
            [self addChild:sprite];
            
            for (int i = 1; i < size; i++) {
                CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_horizontal.png"];
                sprite.position = [self pointFromLocation:LocationMake(self.location.x + i, self.location.y)];
                
                CCSprite *back = [CCSprite spriteWithFile:@"tile_flower.png"];
                back.position = [self pointFromLocation:LocationMake(self.location.x + i, self.location.y)];
                
                [self addChild:back];
                [self addChild:sprite];
            }
        }
            break;
        case LEFT:{
            CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_left_start.png"];
            sprite.position = [self pointFromLocation:LocationMake(self.location.x - size, self.location.y)];
            
            CCSprite *back = [CCSprite spriteWithFile:@"tile_flower.png"];
            back.position = [self pointFromLocation:LocationMake(self.location.x - size, self.location.y)];
            
            [self addChild:back];
            [self addChild:sprite];
            
            for (int i = 1; i < size; i++) {
                CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_horizontal.png"];
                sprite.position = [self pointFromLocation:LocationMake(self.location.x - i, self.location.y)];
                
                CCSprite *back = [CCSprite spriteWithFile:@"tile_flower.png"];
                back.position = [self pointFromLocation:LocationMake(self.location.x - i, self.location.y)];
                
                [self addChild:back];
                [self addChild:sprite];
            }
        }
            break;
        case DOWN:{
            CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_down_start.png"];
            sprite.position = [self pointFromLocation:LocationMake(self.location.x, self.location.y - size)];
            
            CCSprite *back = [CCSprite spriteWithFile:@"tile_flower.png"];
            back.position = [self pointFromLocation:LocationMake(self.location.x, self.location.y - size)];
            
            [self addChild:back];
            [self addChild:sprite];
            
            for (int i = 1; i < size; i++) {
                CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_vertical.png"];
                sprite.position = [self pointFromLocation:LocationMake(self.location.x, self.location.y - i)];
                
                CCSprite *back = [CCSprite spriteWithFile:@"tile_flower.png"];
                back.position = [self pointFromLocation:LocationMake(self.location.x, self.location.y - i)];
                
                [self addChild:back];
                [self addChild:sprite];
            }
        }
            break;
        case UP:{
            CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_up_start.png"];
            sprite.position = [self pointFromLocation:LocationMake(self.location.x, self.location.y + size)];
            
            CCSprite *back = [CCSprite spriteWithFile:@"tile_flower.png"];
            back.position = [self pointFromLocation:LocationMake(self.location.x, self.location.y + size)];
            
            [self addChild:back];
            [self addChild:sprite];
            
            for (int i = 1; i < size; i++) {
                CCSprite *sprite = [CCSprite spriteWithFile:@"arrow_vertical.png"];
                sprite.position = [self pointFromLocation:LocationMake(self.location.x, self.location.y + i)];
                
                CCSprite *back = [CCSprite spriteWithFile:@"tile_flower.png"];
                back.position = [self pointFromLocation:LocationMake(self.location.x, self.location.y + i)];
                
                [self addChild:back];
                [self addChild:sprite];
            }
        }
            break;
        case NONE:
        default:
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
        case NONE:
        default:
            break;
    }
    return NO;
}

- (Location) projectedLocation:(Location) location
{
    location = LocationMake(location.x - self.location.x,location.y - self.location.y);
    switch (self.direction) {
        case UP:
        case DOWN:
            location = LocationMake(0, location.y);
            break;
        case LEFT:
        case RIGHT:
            location = LocationMake(location.x, 0);
            break;
        default:
            break;
    }
    return LocationMake(location.x + self.location.x, location.y + self.location.y);
}

- (Location) locationAtOrder:(int)order
{
    if(order > 0) {
        int x;int y;
        switch (self.direction) {
            case DOWN:
                x = self.location.x;
                y = self.location.y - order;
                break;
                
            case UP:
                x = self.location.x;
                y = self.location.y + order;
                break;
            
            case LEFT:
                x = self.location.x - order;
                y = self.location.y;
                break;
                
            case RIGHT:
                x = self.location.x + order;
                y = self.location.y;
                break;
                
            default:
                break;
        }
        return LocationMake(x, y);
    }

}

@end
