//
//  GameMap.m
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import "GameMap.h"

#import "MapEntity.h"

@implementation GameMap

- (id)init
{
    self = [super init];
    if (self) {
        self.entities = [NSMutableSet setWithCapacity:50];
        self.tileSize = CGSizeMake(64, 64);
        self.position = CGPointMake(100, 50);
        
        for (int i = 0; i < 10; i++) {
            for (int j = 0; j < 10; j++) {
                CCSprite *tile = [CCSprite spriteWithFile:@"tile.png"];
                tile.position = CGPointMake((i+0.5) * self.tileSize.width, (j+0.5) * self.tileSize.height);
                [self addChild:tile];
            }
        }
    }
    return self;
}

- (void) addEntity:(MapEntity *)entity {
    [self.entities addObject:entity];
    [self addChild:entity];
    entity.map = self;
}



@end
