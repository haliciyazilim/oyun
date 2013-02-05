//
//  Score.h
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TypeDefs.h"
#import "Photo.h"

@interface Score : NSManagedObject
@property int elapsedSeconds;
@property Photo* photo;
@property DIFFICULTY difficulty;
- (NSString*) toText;
@end
