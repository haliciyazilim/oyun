//
//  GameMap.m
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import "GameMap.h"

@implementation GameMap

static GameMap *sharedInstance = nil;

- (id)init
{
    self = [super init];
    if (self) {
        self.entities = [NSMutableSet setWithCapacity:50];
        self.tileSize = CGSizeMake(70, 70);
        self.position = CGPointMake(100, 50);
        
        self.rows = 10;
        self.cols = 10;
        
        for (int i = 0; i < self.rows; i++) {
            for (int j = 0; j < self.cols; j++) {
                CCSprite *tile = [CCSprite spriteWithFile:@"tile.png"];
                tile.position = CGPointMake((i+0.5) * self.tileSize.width, (j+0.5) * self.tileSize.height);
                [self addChild:tile];
            }
        }
    }
    return self;
}
+ (GameMap *)loadFromFile:(NSString *)fileName
{
    return nil;
}

+ (GameMap *)sharedInstance {
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

- (void) addEntity:(MapEntity *)entity {
    [self addChild:entity];
    [self.entities addObject:entity];
}

-(Location) convertAbsolutePointToGridPoint:(CGPoint) absolutePoint
{
    int x = (absolutePoint.x - self.position.x) / self.tileSize.width;
    int y = (absolutePoint.y - self.position.y) / self.tileSize.height;
    
    return LocationMake(x,y);
    
}

-(CGPoint) pointFromGridLocation:(Location) location
{
    return CGPointMake(location.x*self.tileSize.width, location.y*self.tileSize.height);
}


- (MapEntity*) entityAtLocation:(Location)location
{
    if([[[self entitiesAtLocation:location] allObjects] count] == 0)
        return nil;
    return [[[self entitiesAtLocation:location] allObjects] objectAtIndex:0];
    
}

- (NSSet*) entitiesAtLocation:(Location)location
{
    NSMutableSet* set = [[NSMutableSet alloc] init];
    
    [self.entities enumerateObjectsUsingBlock:^(MapEntity *entity, BOOL *stop) {
        [set addObjectsFromArray:[[entity entitiesAtLocation:location] allObjects]];
    }];
    
    return set;
}





@end
