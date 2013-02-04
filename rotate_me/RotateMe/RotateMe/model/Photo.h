//
//  Photo.h
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Gallery.h"

@class Score;

@interface Photo : NSManagedObject
@property NSString* filename;
@property Gallery* gallery;
@property Score* score;
+ (Photo*)createPhotoWithFileName:(NSString*)fileName andGallery:(Gallery*)gallery;
@end
