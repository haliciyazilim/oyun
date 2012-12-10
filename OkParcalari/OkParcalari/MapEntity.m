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

@implementation MapEntity

- (id)init
{
    self = [super init];
    if (self) {
        self.location = LocationMake(0, 0);
    }
    return self;
}

- (id)initWithLocation:(Location)location {
    self = [super init];
    if (self) {
        self.location = location;
    }
    return self;
}

- (void)setMap:(GameMap *)map {
    _map = map;
    self.position = CGPointMake(self.location.x * self.map.tileSize.width, self.location.y * self.map.tileSize.height);
}

- (void)setLocation:(Location)location {
    _location = location;
    
    self.position = CGPointMake(self.location.x * self.map.tileSize.width, self.location.y * self.map.tileSize.height);
}

@end
