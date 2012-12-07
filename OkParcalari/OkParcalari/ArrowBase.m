//
//  ArrowBase.m
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import "ArrowBase.h"


Location LocationMake(int x, int y) {
    Location loc;
    loc.x = x;
    loc.y = y;
    return loc;
}


@implementation ArrowBase

+ (id) ArrowBaseWithLocation:(Location)location andSize:(int)size {
    return [[ArrowBase alloc] initWithLocation:location andSize:size];
}

- (id) initWithLocation:(Location)location andSize:(int)size {
    self = [super init];
    
    if (self) {
        self.size = size;
        
        self.upArrowSize = 0;
        self.downArrowSize = 0;
        self.leftArrowSize = 0;
        self.rightArrowSize = 0;
        
        self.location = location;
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    
    if (self) {
        self.size = 0;
        
        self.upArrowSize = 0;
        self.downArrowSize = 0;
        self.leftArrowSize = 0;
        self.rightArrowSize = 0;

        self.location = LocationMake(0, 0);
    }
    
    return self;
}

- (BOOL) isCorrect {
    return (self.leftArrowSize + self.rightArrowSize + self.upArrowSize + self.downArrowSize == self.size);
}

@end
