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
    
    Direction direction = DirectionFromTwoLocations(self.location, endLocation);
    if(direction != NONE && direction != self.direction)
        return;

    endLocation = [self projectedLocation:endLocation];
    
    Location savedEndLocation = self.endLocation;
    _endLocation = endLocation;
    
    BOOL applyChanges = YES;
    
//    if([self getSize] > [self.base size]){
//        applyChanges = NO;
//    }
    
    ArrowBase *base = self.base;
    
    if ([base.upArrow getSize] + [base.downArrow getSize] + [base.leftArrow getSize] + [base.rightArrow getSize] > base.size) {
        applyChanges = NO;
    }
    
    for(int i=1;i<=[self getSize];i++){
        NSArray* entities = [[self.map entitiesAtLocation:[self locationAtOrder:i]] allObjects];
        if([entities count] > 1)
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
    
    Location location;
    
    CCSprite *sprite;
    CCSprite *back;
    
    switch ([self getDirection]) {
        case RIGHT:
            location = LocationMake(self.location.x + size, self.location.y);
            sprite = [CCSprite spriteWithFile:@"arrow_right_start.png"];
            break;
        case LEFT:
            location = LocationMake(self.location.x - size, self.location.y);
            sprite = [CCSprite spriteWithFile:@"arrow_left_start.png"];
            break;
        case DOWN:
            location = LocationMake(self.location.x, self.location.y - size);
            sprite = [CCSprite spriteWithFile:@"arrow_down_start.png"];
            break;
        case UP:
            location = LocationMake(self.location.x, self.location.y + size);
            sprite = [CCSprite spriteWithFile:@"arrow_up_start.png"];
            break;
        case NONE:
        default:
            break;
            
    }
    
//    if ([self.map getRandomNumberForLocation:location] % 2) {
//        back = [CCSprite spriteWithFile:@"tile_flower.png"];
//    } else {
//        back = [CCSprite spriteWithFile:@"tile_grass.png"];
//    }
    
    sprite.position = [self pointFromLocation:location];
    back.position = [self pointFromLocation:location];
    
//    [self addChild:back];
    [self addChild:sprite];
    
    for (int i = 1; i < size; i++) {
        Location location;
        
        CCSprite *sprite;
        CCSprite *back;
        
        switch ([self getDirection]) {
            case RIGHT:
                sprite = [CCSprite spriteWithFile:@"arrow_horizontal.png"];
                location = LocationMake(self.location.x + i, self.location.y);
                break;
            case LEFT:
                sprite = [CCSprite spriteWithFile:@"arrow_horizontal.png"];
                location = LocationMake(self.location.x - i, self.location.y);
                break;
            case DOWN:
                sprite = [CCSprite spriteWithFile:@"arrow_vertical.png"];
                location = LocationMake(self.location.x, self.location.y - i);
                break;
            case UP:
                sprite = [CCSprite spriteWithFile:@"arrow_vertical.png"];
                location = LocationMake(self.location.x, self.location.y + i);
                break;
            case NONE:
            default:
                break;
        }
        
//        if ([self.map getRandomNumberForLocation:location] % 2) {
//            back = [CCSprite spriteWithFile:@"tile_flower.png"];
//        } else {
//            back = [CCSprite spriteWithFile:@"tile_grass.png"];
//        }
        
        sprite.position = [self pointFromLocation:location];
        back.position = [self pointFromLocation:location];
    
//        [self addChild:back];
        [self addChild:sprite];
    }
}

- (void) animateBackgrounds{
    for(int i = 0; i < [self getSize]; i++){
        CCSprite *backSprite = [CCSprite spriteWithFile:@"tile_0a.png"];
        backSprite.position = [self pointFromLocation:[self locationAtOrder:i+1]];
        [self addChild:backSprite];
        [self reorderChild:backSprite z:-3];
        backSprite.opacity = 0;
        
        CCSequence *mySeq = [CCSequence actions:[CCDelayTime actionWithDuration:0.0f+i*0.2f],[CCFadeIn actionWithDuration:0.5f], nil];
        
        [backSprite runAction:mySeq];
        
        CCSprite *backSprite2 = [CCSprite spriteWithFile:@"tile_0b.png"];
        backSprite2.position = [self pointFromLocation:[self locationAtOrder:i+1]];
        [self addChild:backSprite2];
        [self reorderChild:backSprite2 z:-3];
        backSprite2.opacity = 0;
        
        CCSequence *mySeq2 = [CCSequence actions:[CCDelayTime actionWithDuration:0.5f+i*0.2f],[CCFadeIn actionWithDuration:0.5f], nil];
        
        [backSprite2 runAction:mySeq2];
        
        CCSprite *backSprite3 = [CCSprite spriteWithFile:@"tile_0c.png"];
        backSprite3.position = [self pointFromLocation:[self locationAtOrder:i+1]];
        [self addChild:backSprite3];
        [self reorderChild:backSprite3 z:-3];
        backSprite3.opacity = 0;
        
        CCSequence *mySeq3 = [CCSequence actions:[CCDelayTime actionWithDuration:1.0f+i*0.2f],[CCFadeIn actionWithDuration:0.5f],nil];
        
        [backSprite3 runAction:mySeq3];
       
        
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
    return LocationMake(0, 0);
}

- (void)markWateredLocationsIn:(NSMutableDictionary *)bitMap
{
    for(int i=1; i<=[self getSize];i++)
       [bitMap setValue:@"1" forKey:LocationToString([self locationAtOrder:i])];
}

@end
