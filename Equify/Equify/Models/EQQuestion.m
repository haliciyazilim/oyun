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

static NSMutableDictionary* allQuestions = nil;

+(NSMutableArray *)getAllQuestionsWithDifficulty:(int)difficulty {
    return [allQuestions objectForKey:[NSString stringWithFormat:@"%d",difficulty]];
}

-(void)addQuestionToAllQuestions:(EQQuestion*)question {
    if (!allQuestions) {
        allQuestions = [[NSMutableDictionary alloc] initWithCapacity:3];
        [allQuestions setObject:[NSMutableArray arrayWithCapacity:100] forKey:@"1"];
        [allQuestions setObject:[NSMutableArray arrayWithCapacity:100] forKey:@"2"];
        [allQuestions setObject:[NSMutableArray arrayWithCapacity:100] forKey:@"3"];
    }
    [[allQuestions objectForKey:[NSString stringWithFormat:@"%d",question.difficulty]] addObject:question];
}


+(EQQuestion*)EQQuestionWithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId andDifficulty:(int)difficulty {
    return [[EQQuestion alloc] initWithWholeQuestion:wholeQuestion andAnswer:answer andId:questionId andDifficulty:difficulty];
}

- (id)initWithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId andDifficulty:(int)difficulty {
    if (self = [super init]) {
        _wholeQuestion = wholeQuestion;
        _answer = answer;
        _questionId = questionId;
        _difficulty = difficulty;
        [self addQuestionToAllQuestions:self];
    }
    return self;
}
+(EQQuestion*)getNextQuestionWithDifficulty:(int)difficulty {
    int questionId = [EQMetadata getCurrentQuestionWithDifficulty:difficulty];
    return [[allQuestions objectForKey:[NSString stringWithFormat:@"%d",difficulty]] objectAtIndex:questionId];
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
