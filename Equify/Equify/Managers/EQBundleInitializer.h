//
//  EQBundleInitializer.h
//  Equify
//
//  Created by Alperen Kavun on 11.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface EQBundleInitializer : NSObject

+ (void) initializeBundle;
+ (void) loadQuestionsWithDifficulty:(int)difficulty;

@end
