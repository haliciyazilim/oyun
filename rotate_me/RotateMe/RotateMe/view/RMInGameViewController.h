//
//  RMInGameViewController.h
//  RotateMe
//
//  Created by Yunus Eren Guzel on 1/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMStopWatch.h"
#import "RMCroppedImageView.h"

@interface RMInGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoHolder;

@property UIImageView* grids;

@property (weak, nonatomic) IBOutlet UILabel *stopWatchLabel;

- (IBAction)displayMenu:(id)sender;

@property NSArray* croppedImages;

@property RMStopWatch* stopWatch;

+(RMInGameViewController*)lastInstance;

- (void) setImage:(UIImage*)image;

- (BOOL) isGameFinished;

- (void) endGame;

- (BOOL) canGameFinish;

@end
