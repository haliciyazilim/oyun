//
//  DTBQuestion.h
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 05.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTBQuestion : NSObject

@property NSString *wholeQuestion;
@property NSString *answer;
@property NSString *leftHandside; // delete if unneccessary
@property NSString *rightHandside; // delete if unneccessary
@property NSMutableArray *questionArray;

+ (id) QuestionWithQuestion:(NSString *)question andAnswer:(NSString *)answer;

- (id) initWithQuestion:(NSString *)question andAnswer:(NSString *)answer;

- (BOOL) isCorrect:(NSString *)checkedAnswer;

@end
