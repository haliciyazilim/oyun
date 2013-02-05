//
//  DTBQuestion.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 05.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "DTBQuestion.h"

@implementation DTBQuestion

+ (id) QuestionWithQuestion:(NSString *)question andAnswer:(NSString *)answer {
    return [[DTBQuestion alloc] initWithQuestion:question andAnswer:answer];
}

- (id) initWithQuestion:(NSString *)question andAnswer:(NSString *)answer {
    if (self = [super init]) {
        self.wholeQuestion = [NSString stringWithString:question];
        self.answer = [NSString stringWithString:answer];
        
        self.questionArray = [NSMutableArray arrayWithCapacity:[self.wholeQuestion length]];
        for (int i = 0; i < [self.wholeQuestion length]; i++) {
            [self.questionArray addObject:[NSString stringWithFormat:@"%c",[self.wholeQuestion characterAtIndex:i]]];
        }
    }
    return self;
}

- (BOOL) isCorrect:(NSString *)checkedAnswer {
    return [self.answer isEqualToString:checkedAnswer];
}

@end
