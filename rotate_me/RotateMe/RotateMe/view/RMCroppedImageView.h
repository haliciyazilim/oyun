//
//  RMCroppedImageView.h
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMInGameViewController;

@interface RMCroppedImageView : UIImageView

@property RMInGameViewController* parent;
- (void) rotateToAngle:(float)angle;
- (void) setRotationStateTo:(int)state;
- (int) getCurrentRotationState;
@end
