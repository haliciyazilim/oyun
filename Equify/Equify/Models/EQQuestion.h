//
//  EQQuestionWD.h
//  Equify
//
//  Created by Alperen Kavun on 18.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EQQuestion : NSObject

@property NSString *wholeQuestion;
@property NSString *answer;
@property int questionId;
@property NSMutableArray *questionArray;

+(NSMutableArray *)getAllQuestions;

+(EQQuestion*)EQQuestionWDwithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId;

- (id)initWithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId;

- (EQQuestion*)getQuestionWithId:(int)questionId;
+ (EQQuestion *) getNextQuestion;

- (void) createQuestionArray;
- (BOOL) isCorrect:(NSString *)checkedAnswer;
@end
