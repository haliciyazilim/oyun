//
//  EQBundleInitializer.m
//  Equify
//
//  Created by Alperen Kavun on 11.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQBundleInitializer.h"
#import "EQDatabaseManager.h"
#import "EQQuestion.h"

@implementation EQBundleInitializer

+ (void)initializeBundle
{
    if([[EQDatabaseManager sharedInstance] isEmpty]){
        NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"standart" ofType:@"packageinfo"]
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary* package = [parser objectWithString:content];
        
        if( [(NSNumber*)[package valueForKey:@"version"] intValue] == 1){
            for(NSString* questionName in [package objectForKey:@"questions"]){
                NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:questionName ofType:@"question"]
                                                              encoding:NSUTF8StringEncoding
                                                                 error:NULL];
                SBJsonParser *parser = [[SBJsonParser alloc] init];
                NSDictionary* jsonQuestion = [parser objectWithString:content];
                [EQQuestion createQuestionWithWholeQuestion:[jsonQuestion valueForKey:@"wholeQuestion"] andAnswer:[jsonQuestion valueForKey:@"answer"]  andId:[[jsonQuestion valueForKey:@"questionId"] intValue]];
                
            }
        }
    }
}
@end
