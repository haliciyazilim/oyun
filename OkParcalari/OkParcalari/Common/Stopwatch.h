//
//  Stopwatch.h
//  OkParcalari
//
//  Created by Alperen Kavun on 13.12.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Stopwatch : CCNode

@property int isPaused;

@property long long int seconds;
@property long long int minutes;

@property NSDate *startTime;
@property NSDate *lastPausedTime;
@property long long int totalPausedTimeInterval;

@property NSString *sprite1File;
@property NSString *sprite2File;
@property NSString *sprite3File;
@property NSString *sprite4File;
@property NSString *dotFile;


+ (id)StopwatchWithMinutes:(int)minutes andSeconds:(int)seconds;

- (id)initWithMinutes:(int)minutes andSeconds:(int)seconds;

- (void) pauseTimer;
- (void) resumeTimer;
- (void) resetTimer;
- (void) startTimer;
- (void) stopTimer;
- (void) initializeTimerSprites;
- (void) updateTimerSprites;
- (int)  getElapsedSeconds;

@end
