//
//  EQBundleInitializer.m
//  Equify
//
//  Created by Alperen Kavun on 11.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQBundleInitializer.h"
#import "EQDatabaseManager.h"
#import "EQQuestion.h"
#import "EQStatistic.h"
#import "EQMetadata.h"

@implementation EQBundleInitializer

+ (void) initializeBundle {
    if([[EQDatabaseManager sharedInstance] isEmpty]){
        [EQStatistic initializeStatistics];
        [EQMetadata initializeMetadata];
    }
    [EQBundleInitializer loadQuestionsWithDifficulty:1];
    [EQBundleInitializer loadQuestionsWithDifficulty:2];
    [EQBundleInitializer loadQuestionsWithDifficulty:3];
}
+ (void) loadQuestionsWithDifficulty:(int)difficulty {
    NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"standard-3000-%d",difficulty] ofType:@"questionpack"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];

    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *questionPack = [parser objectWithString:content];
    
    if ( [(NSNumber*)[questionPack valueForKey:@"version"] intValue] == 1) {
        for (NSDictionary *question in [questionPack objectForKey:@"questions"]) {
            [EQQuestion EQQuestionWithWholeQuestion:[question valueForKey:@"wholeQuestion"] andAnswer:[question valueForKey:@"answer"] andId:[[question valueForKey:@"questionId"] intValue] andDifficulty:difficulty];
        }
    }
}
@end
