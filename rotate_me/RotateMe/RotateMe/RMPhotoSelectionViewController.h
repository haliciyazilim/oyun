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

@interface RMPhotoSelectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)difficultyChanged:(id)sender;

+ (RMPhotoSelectionViewController*) lastInstance;


@end
