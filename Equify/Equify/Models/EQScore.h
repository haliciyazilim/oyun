//
//  EQScore.h
//  Equify
//
//  Created by Alperen Kavun on 12.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EQScore : NSManagedObject

@property int elapsedSeconds;
@property NSDate* scoreDate;
@property int difficulty;

+(void)addScore:(int)score withDifficulty:(int)difficulty;
+(void)cleanAllScores;
+(NSMutableArray *)getAllScoresWithDifficulty:(int)difficulty;
+(int)getAverageWithDifficulty:(int)difficulty;

@end
