//
//  EQStatistic.m
//  Equify
//
//  Created by Alperen Kavun on 12.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQStatistic.h"
#import "EQDatabaseManager.h"
#import "EQMetadata.h"

@implementation EQStatistic

@dynamic minTime;
@dynamic maxTime;
@dynamic totalSolvedQuestion;
@dynamic totalSkippedQuestion;
@dynamic allTimeAverage;
@dynamic difficulty;

+ (void)initializeStatistics {
    for (int i = 1; i < 4; i++) {
        EQStatistic* statistic = (EQStatistic*)[[EQDatabaseManager sharedInstance] createEntity:@"Statistic"];
        statistic.minTime = INT32_MAX;
        statistic.maxTime = INT32_MIN;
        statistic.difficulty = i;
        statistic.totalSkippedQuestion = 0;
        statistic.totalSolvedQuestion = 0;
        statistic.allTimeAverage = 0;
        
        [[EQDatabaseManager sharedInstance] saveContext];
    }
}
+ (void)resetStatistics {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSMutableArray* statistics = [[EQDatabaseManager sharedInstance] entitiesWithRequest:request forName:@"Statistic"];
    for(EQStatistic* statistic in statistics){
        [[EQDatabaseManager sharedInstance] deleteObject:statistic];
    }
    [EQStatistic initializeStatistics];
}
+ (void)updateStatisticsWithTime:(int)elapsedTime andDifficulty:(int)difficulty {
    EQStatistic* currentStats = [EQStatistic getStatisticsWithDifficulty:difficulty];
    currentStats.minTime = MIN(currentStats.minTime, elapsedTime);
    currentStats.maxTime = MAX(currentStats.maxTime, elapsedTime);
    
    int currentTotalTime = currentStats.allTimeAverage*currentStats.totalSolvedQuestion;
    currentTotalTime += elapsedTime;
    
    currentStats.totalSolvedQuestion += 1;
    currentStats.allTimeAverage = currentTotalTime/currentStats.totalSolvedQuestion;
    [[EQDatabaseManager sharedInstance] saveContext];
    
    [EQMetadata incrementQuestionIdWithDifficulty:difficulty];
}
+ (void)updateStatisticsWithSkippedGameAndDifficulty:(int)difficulty {
    EQStatistic* currentStats = [EQStatistic getStatisticsWithDifficulty:difficulty];
    currentStats.totalSkippedQuestion += 1;
    [[EQDatabaseManager sharedInstance] saveContext];
    
    [EQMetadata incrementQuestionIdWithDifficulty:difficulty];
}
+ (EQStatistic *)getStatisticsWithDifficulty:(int)difficulty {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"difficulty == %d", difficulty];
    
    [request setPredicate:predicate];
    
    return (EQStatistic *)[[EQDatabaseManager sharedInstance] entityWithRequest:request forName:@"Statistic"];
}

@end
