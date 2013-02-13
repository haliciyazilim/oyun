//
//  DTBQuestion.h
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 05.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DTBQuestion : NSManagedObject

@property NSString *wholeQuestion;
@property NSString *answer;
@property int score;
@property int questionOrder;
@property NSMutableArray *questionArray;

+ (DTBQuestion*)createQuestionWithWholeQuestion:(NSString *)question andAnswer:(NSString *)answer andOrder:(int)order;

+ (NSArray *)getAllQuestions;

- (void) updateScore:(int)elapsedTime;

- (void) createQuestionArray;
- (BOOL) isCorrect:(NSString *)checkedAnswer;

@end
