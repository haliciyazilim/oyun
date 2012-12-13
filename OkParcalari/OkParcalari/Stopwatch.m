//
//  Stopwatch.m
//  OkParcalari
//
//  Created by Alperen Kavun on 13.12.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Stopwatch.h"


@implementation Stopwatch

+ (id) StopwatchWithMinutes:(int)minutes andSeconds:(int)seconds {
    return [[Stopwatch alloc] initWithMinutes:minutes andSeconds:seconds];
}

- (id) initWithMinutes:(int)minutes andSeconds:(int)seconds {
    if(self = [super init]){
        _seconds = seconds;
        _minutes = minutes;
        _isPaused = 0;
//        self.position = CGPointMake(330, 20);
        [self initializeTimerSprites];
        return self;
    }
    return nil;
}

- (id) init {
    if(self = [super init]){
        _seconds = 0;
        _minutes = 0;
        _isPaused = 0;
        return self;
    }
    return nil;
}

- (void) updateStopwatch:(ccTime)dt {
    if (!_isPaused) {
//        if([_lastUpdated timeIntervalSinceNow] <= -1 ){
//            _seconds++;
//            if (_seconds == 60) {
//                _seconds = 0;
//                _minutes++;
//            }
//            [self updateTimerSprites];
//            _lastUpdated = [NSDate date];
//        }
        int interval = (int)[[NSDate date] timeIntervalSinceDate:_startTime];
        _seconds = interval % 60;
        _minutes = interval / 60;
        [self updateTimerSprites];
    }
}

- (void) startTimer {
    [self schedule:@selector(updateStopwatch:)];
    _startTime = [NSDate date];
    _isPaused = 0;
}

- (void) pauseTimer {
    [self unschedule:@selector(updateStopwatch:)];
    _isPaused = 1;
}

- (void) resumeTimer {
    _isPaused = 0;
    [self schedule:@selector(updateStopwatch:)];
}

- (void) resetTimer {
    _seconds = 0;
    _minutes = 0;
    _isPaused = 0;
    [self unschedule:@selector(updateStopwatch:)];
    [self schedule:@selector(updateStopwatch:)];
}

- (void) stopTimer {
    [self unschedule:@selector(updateStopwatch:)];
}

- (void) initializeTimerSprites {
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCSprite *timerNum1 = [CCSprite spriteWithFile:@"timer_num_0.png"];
    timerNum1.position = ccp(size.width * 0.817, size.height * 0.5445);
    
    CCSprite *timerNum2 = [CCSprite spriteWithFile:@"timer_num_0.png"];
    timerNum2.position = ccp(size.width * 0.847, size.height * 0.5445);

    CCSprite *timerNum3 = [CCSprite spriteWithFile:@"timer_num_0.png"];
    timerNum3.position = ccp(size.width * 0.889, size.height * 0.5445);

    CCSprite *timerNum4 = [CCSprite spriteWithFile:@"timer_num_0.png"];
    timerNum4.position = ccp(size.width * 0.919, size.height * 0.5445);

    CCSprite *timerDot = [CCSprite spriteWithFile:@"timer_num_nokta.png"];
    timerDot.position = ccp(size.width * 0.867, size.height * 0.5445);
    
    [self addChild:timerNum1];
    [self addChild:timerNum2];
    [self addChild:timerDot];
    [self addChild:timerNum3];
    [self addChild:timerNum4];

}

- (void) updateTimerSprites {
    [self removeAllChildrenWithCleanup:YES];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    NSString *fileName1,*fileName2,*fileName3,*fileName4;
    
    
    if (_minutes < 10) {
        fileName1 = @"timer_num_0.png";
        fileName2 = [NSString stringWithFormat:@"timer_num_%d.png",_minutes];
    }
    else {
        fileName1 = [NSString stringWithFormat:@"timer_num_%d.png",_minutes/10];
        fileName2 = [NSString stringWithFormat:@"timer_num_%d.png",_minutes%10];
    }

    if (_seconds < 10) {
        fileName3 = @"timer_num_0.png";
        fileName4 = [NSString stringWithFormat:@"timer_num_%d.png",_seconds];
    }
    else {
        fileName3 = [NSString stringWithFormat:@"timer_num_%d.png",_seconds/10];
        fileName4 = [NSString stringWithFormat:@"timer_num_%d.png",_seconds%10];
    }
    
    CCSprite *timerNum1 = [CCSprite spriteWithFile:fileName1];
    timerNum1.position = ccp(size.width * 0.818, size.height * 0.5445);
    
    CCSprite *timerNum2 = [CCSprite spriteWithFile:fileName2];
    timerNum2.position = ccp(size.width * 0.848, size.height * 0.5445);
    
    CCSprite *timerNum3 = [CCSprite spriteWithFile:fileName3];
    timerNum3.position = ccp(size.width * 0.890, size.height * 0.5445);
    
    CCSprite *timerNum4 = [CCSprite spriteWithFile:fileName4];
    timerNum4.position = ccp(size.width * 0.920, size.height * 0.5445);
    
    CCSprite *timerDot = [CCSprite spriteWithFile:@"timer_num_nokta.png"];
    timerDot.position = ccp(size.width * 0.868, size.height * 0.5445);
    
    [self addChild:timerNum1];
    [self addChild:timerNum2];
    [self addChild:timerDot];
    [self addChild:timerNum3];
    [self addChild:timerNum4];
}

@end
