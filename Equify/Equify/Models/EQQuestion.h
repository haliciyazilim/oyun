//
//  EQQuestion.h
//  Equify
//
//  Created by Alperen Kavun on 11.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EQQuestion : NSManagedObject

@property NSString *wholeQuestion;
@property NSString *answer;
@property int questionId;
@property NSMutableArray *questionArray;

+ (EQQuestion*)createQuestionWithWholeQuestion:(NSString *)question andAnswer:(NSString *)answer andId:(int)questionId;

+ (NSArray *)getAllQuestions;
+ (EQQuestion*) getQuestionWithId:(int)questionId;
+ (EQQuestion *) getRandomQuestion;
+ (EQQuestion *) getNextQuestion;
- (void) createQuestionArray;
- (BOOL) isCorrect:(NSString *)checkedAnswer;

@end
