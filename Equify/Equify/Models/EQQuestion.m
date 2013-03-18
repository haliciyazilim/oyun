//
//  EQQuestionWD.m
//  Equify
//
//  Created by Alperen Kavun on 18.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQQuestion.h"
#import "EQMetadata.h"

@implementation EQQuestion

static NSMutableArray* allQuestions = nil;

+(NSMutableArray *)getAllQuestions {
    return allQuestions;
}

-(void)addQuestionToAllQuestions:(EQQuestion*)question {
    if (!allQuestions) {
        allQuestions = [[NSMutableArray alloc] initWithCapacity:100];
    }
    [allQuestions addObject:question];
}

- (EQQuestion*)getQuestionWithId:(int)questionId {
    return [allQuestions objectAtIndex:questionId];
}

+(EQQuestion*)EQQuestionWDwithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId {
    return [[EQQuestion alloc] initWithWholeQuestion:wholeQuestion andAnswer:answer andId:questionId];
}

- (id)initWithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId {
    if (self = [super init]) {
        _wholeQuestion = wholeQuestion;
        _answer = answer;
        _questionId = questionId;
        [self addQuestionToAllQuestions:self];
    }
    return self;
}
+(EQQuestion*)getNextQuestion {
    int questionId = [EQMetadata getCurrentQuestion];
    return [allQuestions objectAtIndex:questionId];
}

- (void) createQuestionArray {
    self.questionArray = [NSMutableArray arrayWithCapacity:[self.wholeQuestion length]];
    for (int i = 0; i < [self.wholeQuestion length]; i++) {
        [self.questionArray addObject:[NSString stringWithFormat:@"%c",[self.wholeQuestion characterAtIndex:i]]];
    }
}
- (BOOL) isCorrect:(NSString *)checkedAnswer {
    return [self.answer isEqualToString:checkedAnswer];
}

@end
