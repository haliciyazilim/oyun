//
//  EQScore.m
//  Equify
//
//  Created by Alperen Kavun on 12.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQScore.h"
#import "EQDatabaseManager.h"

@implementation EQScore

@dynamic elapsedSeconds;
@dynamic scoreDate;
@dynamic difficulty;

+(void)addScore:(int)score withDifficulty:(int)difficulty {
    EQScore* createdScore = (EQScore *)[[EQDatabaseManager sharedInstance] createEntity:@"Score"];
    createdScore.elapsedSeconds = score;
    createdScore.scoreDate = [NSDate date];
    createdScore.difficulty = difficulty;
    [[EQDatabaseManager sharedInstance] saveContext];
    
    NSMutableArray *allScores = [EQScore getAllScoresWithDifficulty:difficulty];
    if ([allScores count] > 15) {
        [[EQDatabaseManager sharedInstance] deleteObject:[allScores objectAtIndex:0]];
    }
}
+(NSMutableArray *)getAllScoresWithDifficulty:(int)difficulty {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"difficulty == %d", difficulty];
    [request setPredicate:predicate];

    
    NSMutableArray* scores = [[EQDatabaseManager sharedInstance] entitiesWithRequest:request forName:@"Score"];
    return scores;
}
+ (void) cleanAllScores
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSMutableArray* scores = [[EQDatabaseManager sharedInstance] entitiesWithRequest:request forName:@"Score"];
    for(EQScore* score in scores){
        [[EQDatabaseManager sharedInstance] deleteObject:score];
    }
}

+(int)getAverageWithDifficulty:(int)difficulty {
    NSMutableArray *allScores = [EQScore getAllScoresWithDifficulty:difficulty];
    if ([allScores count] < 15) {
        return -1;
    }
    int totalTime = 0;
    for (EQScore* score in allScores) {
        totalTime += score.elapsedSeconds;
    }
    return totalTime/[allScores count];
}

@end
