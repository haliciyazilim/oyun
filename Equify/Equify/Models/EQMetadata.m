//
//  EQMetadata.m
//  Equify
//
//  Created by Alperen Kavun on 13.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQMetadata.h"
#import "EQDatabaseManager.h"
#import "EQAppConfigValues.h"

@implementation EQMetadata

@dynamic currentQuestionId;
@dynamic versionNumber;
@dynamic difficulty;

+(void)initializeMetadata{
    for (int i = 1; i < 4; i++) {
        EQMetadata* metadata = (EQMetadata*)[[EQDatabaseManager sharedInstance] createEntity:@"Metadata"];
        metadata.versionNumber = @"1.0";
        metadata.difficulty = i;
        metadata.currentQuestionId = arc4random() % TOTAL_QUESTION_COUNT + 1;
        
        [[EQDatabaseManager sharedInstance] saveContext];
    }
}
+(void)incrementQuestionIdWithDifficulty:(int)difficulty{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"difficulty == %d", difficulty];
    [request setPredicate:predicate];
    
    EQMetadata *currentMeta = (EQMetadata *)[[EQDatabaseManager sharedInstance] entityWithRequest:request forName:@"Metadata"];
    
    currentMeta.currentQuestionId = (currentMeta.currentQuestionId%TOTAL_QUESTION_COUNT)+1;
    
    [[EQDatabaseManager sharedInstance] saveContext];
    
}
+(int)getCurrentQuestionWithDifficulty:(int)difficulty{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"difficulty == %d", difficulty];
    [request setPredicate:predicate];
    
    EQMetadata *currentMeta = (EQMetadata *)[[EQDatabaseManager sharedInstance] entityWithRequest:request forName:@"Metadata"];
    
    return currentMeta.currentQuestionId;
}

@end
