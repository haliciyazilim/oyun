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
@property int difficulty;

+(NSMutableArray *)getAllQuestionsWithDifficulty:(int)difficulty;

+(EQQuestion*)EQQuestionWithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId andDifficulty:(int)difficulty;

- (id)initWithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId andDifficulty:(int)difficulty;

+ (EQQuestion *) getNextQuestionWithDifficulty:(int)difficulty;

- (void) createQuestionArray;
- (BOOL) isCorrect:(NSString *)checkedAnswer;
@end
