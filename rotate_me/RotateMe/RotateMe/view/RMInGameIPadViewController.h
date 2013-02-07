//
//  RMInGameIPadViewController.h
//  RotateMe
//
//  Created by Eren Halici on 07.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMStopWatch.h"
#import "RMCroppedImageView.h"

@interface RMInGameIPadViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoHolder;

@property UIImageView* grids;

@property (weak, nonatomic) IBOutlet UILabel *stopWatchLabel;

- (IBAction)displayMenu:(id)sender;

- (IBAction)displayHelp:(id)sender;

@property NSArray* croppedImages;

@property RMStopWatch* stopWatch;

+(RMInGameIPadViewController*)lastInstance;

- (void) setImage:(UIImage*)image;

- (BOOL) isGameFinished;

- (void) endGame;

- (BOOL) canGameFinish;

@end

