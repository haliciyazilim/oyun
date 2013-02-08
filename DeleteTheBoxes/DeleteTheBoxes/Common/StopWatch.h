//
//  RMStopWatch.h
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDefs.h"

@interface StopWatch : NSObject

- (void) pauseTimer;
- (void) resumeTimer;
- (void) resetTimer;
- (void) startTimerWithRepeatBlock:(IteratorBlock)block;
- (void) stopTimer;
- (void) updateTimer:(NSTimer*)timer;
- (int)  getElapsedMiliseconds;

- (NSString*) toString;
- (NSString*) toStringWithoutMiliseconds;
- (NSString*) toStringMiliseconds;
+ (NSString*) textWithMiliseconds:(int)miliseconds;

@end
