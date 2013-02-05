//
//  Photo.h
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Gallery.h"
#import "TypeDefs.h"
#import "Score.h"

@interface Photo : NSManagedObject
@property NSString* filename;
@property Gallery* gallery;
@property NSSet* score;
+ (Photo*)createPhotoWithFileName:(NSString*)fileName andGallery:(Gallery*)gallery;
- (void) setScore:(int)elapsedTime forDifficulty:(DIFFICULTY)difficulty;
- (Score*) getScoreForDifficulty:(DIFFICULTY)difficulty;

@end
