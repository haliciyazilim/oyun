//
//  RMPhotoSelectionIPadViewController.h
//  RotateMe
//
//  Created by Eren Halici on 06.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Config.h"

@interface RMPhotoSelectionIPadViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)difficultyChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedButtons;
@property (weak, nonatomic) IBOutlet UILabel *galleryNameLabel;
- (IBAction)backButtonClicked:(id)sender;

+ (RMPhotoSelectionIPadViewController*) lastInstance;

@end
