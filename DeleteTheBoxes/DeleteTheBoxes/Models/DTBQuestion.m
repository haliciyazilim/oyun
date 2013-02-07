//
//  DTBQuestion.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 05.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

//#define UNSOLVED_QUESTION_SCORE INT

#import "DTBDatabaseManager.h"
#import "DTBQuestion.h"
#import "DTBAppSpecificValues.h"

@implementation DTBQuestion

@dynamic wholeQuestion;
@dynamic answer;
@dynamic score;
@dynamic questionOrder;
@dynamic isPurchased;
@synthesize questionArray;

+ (DTBQuestion *)createQuestionWithWholeQuestion:(NSString *)question andAnswer:(NSString *)answer andOrder:(int) order {
    DTBQuestion* quest = (DTBQuestion*)[[DTBDatabaseManager sharedInstance] createEntity:@"Question"];
    quest.wholeQuestion = question;
    quest.answer = answer;
    quest.score = INT32_MAX;
    quest.questionOrder = order;
    if (order <= kFreeQuestionCount) {
        NSLog(@"is purchased");
        quest.isPurchased = YES;
    }
    else{
        NSLog(@"it is not purchased");
        quest.isPurchased = NO;
    }
    
    [[DTBDatabaseManager sharedInstance] saveContext];
    return quest;
}
+ (NSArray*) getAllQuestions
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSArray* result =  [[DTBDatabaseManager sharedInstance] entitiesWithRequest:request forName:@"Question"];
    result = [result sortedArrayUsingComparator:^NSComparisonResult(DTBQuestion *obj1, DTBQuestion *obj2) {
        return obj1.questionOrder - obj2.questionOrder;
    }];
    return result;
}
- (void) createQuestionArray {
    self.questionArray = [NSMutableArray arrayWithCapacity:[self.wholeQuestion length]];
    for (int i = 0; i < [self.wholeQuestion length]; i++) {
        [self.questionArray addObject:[NSString stringWithFormat:@"%c",[self.wholeQuestion characterAtIndex:i]]];
    }
}
- (void) updateScore:(int)elapsedTime {
    if (self.score > elapsedTime) {
        self.score = elapsedTime;
    }
    [[DTBDatabaseManager sharedInstance] saveContext];
}
//+ (id) QuestionWithQuestion:(NSString *)question andAnswer:(NSString *)answer {
//    return [[DTBQuestion alloc] initWithQuestion:question andAnswer:answer];
//}
//
//- (id) initWithQuestion:(NSString *)question andAnswer:(NSString *)answer {
//    if (self = [super init]) {
//        self.wholeQuestion = [NSString stringWithString:question];
//        self.answer = [NSString stringWithString:answer];
//        
//        self.questionArray = [NSMutableArray arrayWithCapacity:[self.wholeQuestion length]];
//        for (int i = 0; i < [self.wholeQuestion length]; i++) {
//            [self.questionArray addObject:[NSString stringWithFormat:@"%c",[self.wholeQuestion characterAtIndex:i]]];
//        }
//    }
//    return self;
//}

- (BOOL) isCorrect:(NSString *)checkedAnswer {
    return [self.answer isEqualToString:checkedAnswer];
}

@end
