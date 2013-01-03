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
        long long int interval = (long long int)[[NSDate date] timeIntervalSinceDate:_startTime];
        interval -= _totalPausedTimeInterval;
        _seconds = interval % 60;
        _minutes = interval / 60;
        [self updateTimerSprites];
    }
}

- (void) startTimer {
    [self schedule:@selector(updateStopwatch:)];
    _startTime = [NSDate date];
    _totalPausedTimeInterval = 0;
    _isPaused = 0;
}

- (void) pauseTimer {
    _isPaused = 1;
    [self unschedule:@selector(updateStopwatch:)];
    _lastPausedTime = [NSDate date];
}

- (void) resumeTimer {
    _totalPausedTimeInterval += (long long int)[[NSDate date] timeIntervalSinceDate:_lastPausedTime];
    [self schedule:@selector(updateStopwatch:)];
    _isPaused = 0;
}

- (void) resetTimer {
    _seconds = 0;
    _minutes = 0;
    _isPaused = 0;
    [self unschedule:@selector(updateStopwatch:)];
    [self schedule:@selector(updateStopwatch:)];
}

-(int)getElapsedSeconds
{
    return _seconds + (_minutes*60);
}

- (void) stopTimer {
    [self unschedule:@selector(updateStopwatch:)];
}

- (void) initializeTimerSprites {
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    _sprite1File = @"timer_num_0.png";
    _sprite2File = @"timer_num_0.png";
    _sprite3File = @"timer_num_0.png";
    _sprite4File = @"timer_num_0.png";
    _dotFile = @"timer_num_nokta.png";
    
    CCSprite *timerNum1 = [CCSprite spriteWithFile:_sprite1File];
    timerNum1.position = ccp(size.width * 0.817, size.height * 0.5445);
    timerNum1.tag = 11;
    
    CCSprite *timerNum2 = [CCSprite spriteWithFile:_sprite2File];
    timerNum2.position = ccp(size.width * 0.847, size.height * 0.5445);
    timerNum2.tag = 22;

    CCSprite *timerNum3 = [CCSprite spriteWithFile:_sprite3File];
    timerNum3.position = ccp(size.width * 0.889, size.height * 0.5445);
    timerNum3.tag = 33;

    CCSprite *timerNum4 = [CCSprite spriteWithFile:_sprite4File];
    timerNum4.position = ccp(size.width * 0.919, size.height * 0.5445);
    timerNum4.tag = 44;

    CCSprite *timerDot = [CCSprite spriteWithFile:_dotFile];
    timerDot.position = ccp(size.width * 0.867, size.height * 0.5445);
    timerDot.tag = 55;
    
    [self addChild:timerNum1];
    [self addChild:timerNum2];
    [self addChild:timerDot];
    [self addChild:timerNum3];
    [self addChild:timerNum4];

}

- (void) updateTimerSprites {
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    NSString *fileName1,*fileName2,*fileName3,*fileName4;
    
    if (_minutes < 10) {
        fileName1 = @"timer_num_0.png";
        fileName2 = [NSString stringWithFormat:@"timer_num_%lld.png",_minutes];
    }
    else {
        fileName1 = [NSString stringWithFormat:@"timer_num_%lld.png",_minutes/10];
        fileName2 = [NSString stringWithFormat:@"timer_num_%lld.png",_minutes%10];
    }

    if (_seconds < 10) {
        fileName3 = @"timer_num_0.png";
        fileName4 = [NSString stringWithFormat:@"timer_num_%lld.png",_seconds];
    }
    else {
        fileName3 = [NSString stringWithFormat:@"timer_num_%lld.png",_seconds/10];
        fileName4 = [NSString stringWithFormat:@"timer_num_%lld.png",_seconds%10];
    }
    if(![_sprite1File  isEqualToString:fileName1]){
        [self removeChildByTag:11 cleanup:YES];
        CCSprite *timerNum1 = [CCSprite spriteWithFile:fileName1];
        timerNum1.position = ccp(size.width * 0.818, size.height * 0.5445);
        timerNum1.tag = 11;
        [self addChild:timerNum1];
        _sprite1File = fileName1;
    }
    if(![_sprite2File isEqualToString:fileName2]){
        [self removeChildByTag:22 cleanup:YES];
        CCSprite *timerNum2 = [CCSprite spriteWithFile:fileName2];
        timerNum2.position = ccp(size.width * 0.848, size.height * 0.5445);
        timerNum2.tag = 22;
        [self addChild:timerNum2];
        _sprite2File = fileName2;
    }
    if(![_sprite3File isEqualToString:fileName3]){
        [self removeChildByTag:33 cleanup:YES];
        CCSprite *timerNum3 = [CCSprite spriteWithFile:fileName3];
        timerNum3.position = ccp(size.width * 0.890, size.height * 0.5445);
        timerNum3.tag = 33;
        [self addChild:timerNum3];
        _sprite3File = fileName3;
    }
    if(![_sprite4File isEqualToString:fileName4]){
        [self removeChildByTag:44 cleanup:YES];
        CCSprite *timerNum4 = [CCSprite spriteWithFile:fileName4];
        timerNum4.position = ccp(size.width * 0.920, size.height * 0.5445);
        timerNum4.tag = 44;
        [self addChild:timerNum4];
        _sprite4File = fileName4;
    }
}

@end
