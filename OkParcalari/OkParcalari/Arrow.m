//
//  Arrow.m
//  OkParcalari
//
//  Created by Eren Halici on 10.12.2012.
//
//

#import "Arrow.h"

#define DELAY_ACTION_TAG 141
#define ACTION_TAG 142

@implementation Arrow
{
    int lastSize;
    BOOL isActionWaiting;
    
    int actionCount;
}

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
        lastSize = 0;
        isActionWaiting = NO;
        [self createSprites];
        actionCount = 0;
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


- (int)getSize {
    int xDiff = self.endLocation.x - self.location.x;
    int yDiff = self.endLocation.y - self.location.y;
    
    switch ([self direction]) {
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

-(NSArray*) childrenByTag:(NSInteger)tag
{
    NSMutableArray* childrenForTag = [[NSMutableArray alloc] init];
    for(int i=0; i< [[self children] count];i++){
        if([[[self children] objectAtIndex:i] tag] == tag){
            [childrenForTag addObject:[[self children] objectAtIndex:i]];
        }
    }
    
    return (NSArray*)childrenForTag;
}

-(void) removeChildrenByTag:(NSInteger)tag cleanup:(BOOL)cleanup
{
    NSArray* willRemove = [self childrenByTag:tag];
    for(int i=0;i<[willRemove count];i++){
        [self removeChild:[willRemove objectAtIndex:i] cleanup:cleanup];
    }
}

- (void) createSprites {
    [self removeChildrenByTag:40 cleanup:YES];
    int size = [self getSize];
    
    if(size <= 0)
        return;
    
    Location location;
    CCSprite *sprite;
    
    switch ([self direction]) {
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
    
    sprite.tag = 40;
    sprite.position = [self pointFromLocation:location];
    [self addChild:sprite];
    
    for (int i = 1; i < size; i++) {
        Location location;
        
        CCSprite *sprite;
        switch ([self direction]) {
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
        
        sprite.tag = 40;
        sprite.position = [self pointFromLocation:location];
        [self addChild:sprite];
    }
}

- (void) animateBackgrounds{
    
    if(actionCount > 0){
        isActionWaiting = YES;
        return;
    }
    [self removeChildrenByTag:41 cleanup:YES];
    int max = lastSize > [self getSize] ? lastSize : [self getSize];
    int min = lastSize < [self getSize] ? lastSize : [self getSize];
    
    
    for(int i=0;i<max;i++){
        if(i < min){
            [self backgroundAtOrder:i+1 withDuration:0.0f withDelay:0.0f];
        }
        else {
            float delayConstant = lastSize < [self getSize] ? (i-min) : (max-i);
            [self backgroundAtOrder:i+1 withDuration:0.5f withDelay:delayConstant*0.2f];
            
        }
        
    }
    
    lastSize = [self getSize];
}

-(void) backgroundAtOrder:(int)order withDuration:(float)duration withDelay:(float)delay
{
    
    CCSprite *backSprite = [CCSprite spriteWithFile:@"tile_0a.png"];
    backSprite.tag = 41;
    backSprite.position = [self pointFromLocation:[self locationAtOrder:order]];
    [self addChild:backSprite];
    [self reorderChild:backSprite z:-3];
        
    CCSprite *backSprite2 = [CCSprite spriteWithFile:@"tile_0b.png"];
    backSprite2.tag = 41;
    backSprite2.position = [self pointFromLocation:[self locationAtOrder:order]];
    [self addChild:backSprite2];
    [self reorderChild:backSprite2 z:-3];
    
    CCSprite *backSprite3 = [CCSprite spriteWithFile:@"tile_0c.png"];
    backSprite3.tag = 41;
    backSprite3.position = [self pointFromLocation:[self locationAtOrder:order]];
    [self addChild:backSprite3];
    [self reorderChild:backSprite3 z:-3];
    
    if(duration > 0 ){
        if(order > lastSize){
            backSprite.opacity = 0;
            [backSprite runAction:[self fadeInSequenceWithDelay:duration*0.0f+delay withDuration:duration]];
            backSprite2.opacity = 0;
            [backSprite2 runAction:[self fadeInSequenceWithDelay:duration*1.0f*delay withDuration:duration]];
            backSprite3.opacity = 0;
            [backSprite3 runAction:[self fadeInSequenceWithDelay:duration*2.0f+delay withDuration:duration]];
        }
        else {
            [backSprite runAction:[self fadeOutSequenceWithDelay:duration*2.0f+delay withDuration:duration]];
            [backSprite2 runAction:[self fadeOutSequenceWithDelay:duration*1.0f+delay withDuration:duration]];
            [backSprite3 runAction:[self fadeOutSequenceWithDelay:duration*0.0f+delay withDuration:duration]];
        }
    }

}

- (void) incrementActionCount
{
    actionCount++;
}

-(void) decrementActionCount
{
    actionCount--;
    if(actionCount == 0 && isActionWaiting == YES)
        [self animateBackgrounds];
}


- (CCSequence*) fadeOutSequenceWithDelay:(float)delay withDuration:(float) duration
{
    CCDelayTime* delayAction = [CCDelayTime actionWithDuration:delay];
    CCFadeOut*  action = [CCFadeOut actionWithDuration:duration];
    delayAction.tag = DELAY_ACTION_TAG;
    action.tag = ACTION_TAG;
        
    return [CCSequence actions:
            [CCCallFuncN actionWithTarget:self selector:@selector(incrementActionCount)],
            delayAction,
            action,
            [CCCallFuncN actionWithTarget:self selector:@selector(decrementActionCount)], nil];
}

- (CCSequence*) fadeInSequenceWithDelay:(float)delay withDuration:(float) duration
{
    CCDelayTime* delayAction = [CCDelayTime actionWithDuration:delay];
    CCFadeIn*  action = [CCFadeIn actionWithDuration:duration];
    delayAction.tag = DELAY_ACTION_TAG;
    action.tag = ACTION_TAG;
    return [CCSequence actions:
            [CCCallFuncN actionWithTarget:self selector:@selector(incrementActionCount)],
            delayAction,
            action,
            [CCCallFuncN actionWithTarget:self selector:@selector(decrementActionCount)], nil];
}

- (BOOL)hitTestWithLocation:(Location) location
{
    
    switch([self direction]){
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
        switch ([self direction]) {
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
    return LocationMake(-1, -1);
}

- (void)markWateredLocationsIn:(NSMutableDictionary *)bitMap
{
    for(int i=1; i<=[self getSize];i++)
       [bitMap setValue:@"1" forKey:LocationToString([self locationAtOrder:i])];
}

@end
