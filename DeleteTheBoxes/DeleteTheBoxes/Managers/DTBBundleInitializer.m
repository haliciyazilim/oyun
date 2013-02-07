//
//  DTBBundleInitializer.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 06.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "DTBBundleInitializer.h"
#import "DTBDatabaseManager.h"
#import "DTBQuestion.h"
@implementation DTBBundleInitializer

+ (void)initializeBundle
{
    if([[DTBDatabaseManager sharedInstance] isEmpty]){
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
                [DTBQuestion createQuestionWithWholeQuestion:[jsonQuestion valueForKey:@"wholeQuestion"] andAnswer:[jsonQuestion valueForKey:@"answer"]  andOrder:[[jsonQuestion valueForKey:@"order"] intValue]];
                
            }
        }
    }
}
@end
