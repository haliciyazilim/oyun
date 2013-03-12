//
//  EQQuestion.m
//  Equify
//
//  Created by Alperen Kavun on 11.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQDatabaseManager.h"
#import "EQQuestion.h"

@implementation EQQuestion

@dynamic wholeQuestion;
@dynamic answer;
@dynamic questionId;
@synthesize questionArray;

+ (EQQuestion *)createQuestionWithWholeQuestion:(NSString *)question andAnswer:(NSString *)answer andId:(int)questionId {
    EQQuestion* quest = (EQQuestion*)[[EQDatabaseManager sharedInstance] createEntity:@"Question"];
    quest.wholeQuestion = question;
    quest.answer = answer;
    quest.questionId = questionId;
    
    [[EQDatabaseManager sharedInstance] saveContext];
    return quest;
}
+ (NSArray*) getAllQuestions
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSArray* result =  [[EQDatabaseManager sharedInstance] entitiesWithRequest:request forName:@"Question"];
    result = [result sortedArrayUsingComparator:^NSComparisonResult(EQQuestion *obj1, EQQuestion *obj2) {
        return obj1.questionId - obj2.questionId;
    }];
    return result;
}
+ (EQQuestion*) getQuestionWithId:(int)questionId
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"questionId == %d ", questionId];
    [request setPredicate:predicate];
    return (EQQuestion *)[[EQDatabaseManager sharedInstance] entityWithRequest:request forName:@"Question"];
    
}
- (void) createQuestionArray {
    self.questionArray = [NSMutableArray arrayWithCapacity:[self.wholeQuestion length]];
    for (int i = 0; i < [self.wholeQuestion length]; i++) {
        [self.questionArray addObject:[NSString stringWithFormat:@"%c",[self.wholeQuestion characterAtIndex:i]]];
    }
}

- (BOOL) isCorrect:(NSString *)checkedAnswer {
    NSLog(@"isCorrect: %@==%@ ",self.answer,checkedAnswer);
    return [self.answer isEqualToString:checkedAnswer];
}

@end
