//
//  RMPhotoSelectionViewController.h
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/1/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
@class Gallery;

@interface RMPhotoSelectionViewController : UIViewController <UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)difficultyChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedButtons;
@property (weak, nonatomic) IBOutlet UILabel *galleryNameLabel;
- (IBAction)backButtonClicked:(id)sender;

+ (RMPhotoSelectionViewController*) lastInstance;
- (void) setGallery:(Gallery*)gallery;


@end
