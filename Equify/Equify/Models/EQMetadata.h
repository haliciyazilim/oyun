//
//  EQMetadata.h
//  Equify
//
//  Created by Alperen Kavun on 13.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EQMetadata : NSManagedObject

@property int currentQuestionId;
@property NSString* versionNumber;
@property int difficulty;

+(void)initializeMetadata;
+(void)incrementQuestionIdWithDifficulty:(int)difficulty;
+(int)getCurrentQuestionWithDifficulty:(int)difficulty;

@end
