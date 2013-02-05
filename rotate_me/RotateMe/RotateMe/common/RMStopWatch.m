//
//  RMStopWatch.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMStopWatch.h"

@implementation RMStopWatch
{
    NSTimer *timer;
    int seconds;
    int minutes;
    int miliseconds;
    BOOL isPaused;
    IteratorBlock updateBlock;
    
}

- (id) init {
    if(self = [super init]){
        seconds = 0;
        minutes = 0;
        isPaused = NO;
        return self;
    }
    return nil;
}

- (void) startTimerWithRepeatBlock:(IteratorBlock)block
{
//    NSLog(@"startTimerWithRepaetBlock");
    isPaused = NO;
    updateBlock = block;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
}

- (void) updateTimer:(NSTimer*)timer
{
    if(isPaused)
        return;
//    NSLog(@"%@",[self toString]);
    miliseconds++;
    if(miliseconds == 100){
        miliseconds = 0;
        seconds++;
    }
    if(seconds == 60){
        seconds = 0;
        minutes++;
    }
    updateBlock();
}

-(void)resumeTimer
{
    isPaused = NO;
}

-(void) pauseTimer
{
    isPaused = YES;
}

-(void)resetTimer
{
    minutes = 0;
    seconds = 0;
    miliseconds = 0;
    [self startTimerWithRepeatBlock:updateBlock];
}

-(void) stopTimer
{
    [timer invalidate];
    timer = nil;
}

- (NSString *)toString
{
    NSString* minutesString = minutes < 10 ? [NSString stringWithFormat:@"0%d",minutes] : [NSString stringWithFormat:@"%d",minutes];
    
    NSString* secondsString = seconds < 10 ? [NSString stringWithFormat:@"0%d",seconds] : [NSString stringWithFormat:@"%d",seconds];
    
//    NSString* milisecondsString = miliseconds < 10 ? [NSString stringWithFormat:@"0%d",miliseconds] : [NSString stringWithFormat:@"%d",miliseconds];
    
    NSString* milisecondsString = [NSString stringWithFormat:@"%d",miliseconds/10];
    
    return [NSString stringWithFormat:@"%@:%@.%@",minutesString,secondsString,milisecondsString];
}

- (int) getElapsedMiliseconds
{
    return minutes * 60 * 100 + seconds * 100 + miliseconds;
}

- (int) getElapsedSeconds
{
    return minutes * 60 + seconds;
}

@end
