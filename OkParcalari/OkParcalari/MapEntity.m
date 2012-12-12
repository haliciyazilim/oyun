//
//  MapEntity.m
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import "MapEntity.h"
#import "GameMap.h"

Location LocationMake(int x, int y) {
    Location loc;
    loc.x = x;
    loc.y = y;
    return loc;
}

Direction DirectionFromTwoLocations(Location start, Location end){
    if(start.x == end.x && start.y > end.y)
        return DOWN;
    if(start.x == end.x && start.y < end.y)
        return UP;
    if(start.x < end.x && start.y == end.y)
        return RIGHT;
    if(start.x > end.x && start.y == end.y)
        return LEFT;
    return -999999999;
}

NSString* StringFromDirection(Direction direction){
    switch (direction) {
        case UP:
            return @"UP";
        case DOWN:
            return @"DOWN";
        case LEFT:
            return @"LEFT";
        case RIGHT:
            return @"RIGHT";
        default:
            return @"-999999999";
    }
    return nil;
}

@implementation MapEntity

- (id)init
{
    return [self initWithLocation:LocationMake(0, 0)];
}

- (id)initWithLocation:(Location)location {
    self = [super init];
    if (self) {
        _location = location;
        self.entities = [[NSMutableSet alloc] init];
        self.position = [self pointFromLocation:location];
    }
    return self;
}

- (GameMap*)map {
    return [GameMap sharedInstance];
}

-(void) setMap:(GameMap *)map
{
    
}

- (void)setLocation:(Location)location {
    _location = location;
    
    self.position = [self pointFromLocation:location];
}

- (BOOL)hitTestWithLocation:(Location) location
{
    if(self.location.x == location.x && self.location.y == location.y){
        return YES;
    }
    else{
        return NO;
    }
}

- (MapEntity*) entityAtLocation:(Location)location
{
    return [[[self entitiesAtLocation:location] allObjects] objectAtIndex:0];
        
}

- (NSSet*) entitiesAtLocation:(Location)location
{
    
    NSMutableSet* set = [[NSMutableSet alloc] init];
    
    [self.entities enumerateObjectsUsingBlock:^(MapEntity *entity, BOOL *stop) {
        [set addObjectsFromArray:[[entity entitiesAtLocation:location] allObjects]];
    }];
    NSLog(@"%d,%d,%d,%d",self.location.x,self.location.y,location.x,location.y);
    if ([self hitTestWithLocation:location] == YES) {
        NSLog(@"I'mhere");
        [set addObject:self];
    }
    NSLog(@"arrow base set count %d",[[set allObjects] count]);
    return set;
}

- (CGPoint) pointFromLocation:(Location)location
{
    Location parentLocation = LocationMake(0, 0);
    if([self.parent isKindOfClass:[MapEntity class]]) {
        parentLocation = ((MapEntity*)self.parent).location;
    }
    
    float x = (location.x - parentLocation.x) * self.map.tileSize.width;
    float y = (location.y - parentLocation.y) * self.map.tileSize.height;
    
    return CGPointMake(x,y);
}

@end
