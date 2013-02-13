//
//  RMGallerySegue.m
//  RotateMe
//
//  Created by Eren Halici on 13.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMGallerySegue.h"

#import "RMGallerySelectionViewController.h"
#import "RMPhotoSelectionViewController.h"

#import "RMGallerySelectionItemView.h"

@implementation RMGallerySegue

- (void)perform {
    RMGallerySelectionViewController *sourceViewController = self.sourceViewController;
    RMPhotoSelectionViewController *destinationViewController = self.destinationViewController;
    
    
    RMGallerySelectionItemView *galleryItemView = [sourceViewController getTouchedGallerySelectionItemView];
    NSMutableArray *imageViews = galleryItemView.imageViews;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         int index = 0;
                         for (UIImageView *imageView in imageViews) {
                             galleryItemView.frame = destinationViewController.scrollView.frame;
                             imageView.transform = CGAffineTransformIdentity;
                             imageView.frame = CGRectMake(index*150 + 10, 20, 100, 100);
                             index++;
                         }
                     } completion:^(BOOL finished) {
                         [sourceViewController presentViewController:self.destinationViewController
                                                            animated:NO
                                                          completion:^{

                                                          }];

                     }];
}

@end
