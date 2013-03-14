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

+(void)initializeMetadata{
    EQMetadata* metadata = (EQMetadata*)[[EQDatabaseManager sharedInstance] createEntity:@"Metadata"];
    metadata.versionNumber = @"1.0";
    metadata.currentQuestionId = arc4random() % TOTAL_QUESTION_COUNT + 1;
    
    [[EQDatabaseManager sharedInstance] saveContext];
}
+(void)incrementQuestionId{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSArray* result =  [[EQDatabaseManager sharedInstance] entitiesWithRequest:request forName:@"Metadata"];
    
    EQMetadata* meta = [result objectAtIndex:0];
    
    meta.currentQuestionId = (meta.currentQuestionId%TOTAL_QUESTION_COUNT)+1;
    
    [[EQDatabaseManager sharedInstance] saveContext];
    
}
+(int)getCurrentQuestion{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSArray* result =  [[EQDatabaseManager sharedInstance] entitiesWithRequest:request forName:@"Metadata"];
    
    EQMetadata* meta = [result objectAtIndex:0];
    
    return meta.currentQuestionId;
}

@end
