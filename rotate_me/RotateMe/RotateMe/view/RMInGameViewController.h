//
//  RMInGameViewController.h
//  RotateMe
//
//  Created by Yunus Eren Guzel on 1/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMInGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoHolder;

@property UIImageView* grids;

@property NSArray* croppedImages;

+(RMInGameViewController*)lastInstance;
- (void) setImage:(UIImage*)image;
- (IBAction)returnToPhotoSelection:(id)sender;

- (BOOL) isGameFinished;

- (void) endGame;

@end
