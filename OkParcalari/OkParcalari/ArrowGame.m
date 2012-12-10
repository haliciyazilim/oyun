//
//  ArrowGame.m
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#import "ArrowGame.h"

#import "GameMap.h"
#import "ArrowBase.h"
#import "Arrow.h"

@implementation ArrowGame

- (id)init
{
    self = [super init];
    if (self) {
        self.gameTable = [NSMutableDictionary dictionaryWithCapacity:100];
        self.map = [[GameMap alloc] init];
        [self addChild:self.map];
        
        ArrowBase *arrowBase = [[ArrowBase alloc] initWithLocation:LocationMake(1, 1) andSize:10];
        [self.map addEntity:arrowBase];
        
        Arrow *arrow1 = [[Arrow alloc] initWithLocation:LocationMake(1, 1)];
        arrow1.endLocation = LocationMake(4,1);
        [arrowBase addChild:arrow1];
        
        ArrowBase *arrowBase2 = [[ArrowBase alloc] initWithLocation:LocationMake(3, 2) andSize:10];
        [self.map addEntity:arrowBase2];
        
        ArrowBase *arrowBase3 = [[ArrowBase alloc] initWithLocation:LocationMake(9, 9) andSize:10];
        [self.map addEntity:arrowBase3];
    }

    return self;
}

@end
