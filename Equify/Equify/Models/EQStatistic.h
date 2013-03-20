//
//  EQStatistic.h
//  Equify
//
//  Created by Alperen Kavun on 12.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EQStatistic : NSManagedObject

@property int minTime;
@property int maxTime;
@property int totalSolvedQuestion;
@property int totalSkippedQuestion;
@property int allTimeAverage;
@property int difficulty;

+ (void)initializeStatistics;
+ (void)resetStatistics;
+ (void)updateStatisticsWithTime:(int)elapsedTime andDifficulty:(int)difficulty;
+ (void)updateStatisticsWithSkippedGameAndDifficulty:(int)difficulty;
+ (EQStatistic *)getStatisticsWithDifficulty:(int)difficulty;

@end
