//
//  WaterSpray.m
//  OkParcalari
//
//  Created by Alperen Kavun on 02.01.2013.
//
//

#import "WaterSpray.h"
#import "CCBReader.h"

@implementation WaterSpray
{
    BOOL isCalled;
}
- (id) initWithPoint:(CGPoint)point {
    if (self = [super init]) {
        self.position = point;
        isCalled = NO;
    }
    return self;
}

- (void) scheduleSpraying {
    [self unschedule:@selector(scheduleSpraying)];
    if(isCalled == NO){
        _squirt1 = (Squirt *) [CCBReader nodeGraphFromFile:@"Squirt.ccbi"];
        _squirt2 = (Squirt *) [CCBReader nodeGraphFromFile:@"Squirt.ccbi"];
        _squirt3 = (Squirt *) [CCBReader nodeGraphFromFile:@"Squirt.ccbi"];
        [self addChild:_squirt1];
        [self addChild:_squirt2];
        [self addChild:_squirt3];
        isCalled = YES;
    }
    [_squirt1 runAnimationWithSequenceNamed:@"Timeline1"];
    [_squirt2 runAnimationWithSequenceNamed:@"Timeline2"];
    [_squirt3 runAnimationWithSequenceNamed:@"Timeline3"];
    
    CGFloat randomTime = arc4random_uniform(45 )+30;
    [self schedule:@selector(scheduleSpraying) interval:0 repeat:1 delay:randomTime];
}

-(void) callScheduleSprayingWithDelay:(ccTime)delay
{
    [self schedule:@selector(scheduleSpraying) interval:0 repeat:1 delay:delay];
}

- (void) markWateredLocationsIn:(NSMutableDictionary*) bitMap
{
}
@end
