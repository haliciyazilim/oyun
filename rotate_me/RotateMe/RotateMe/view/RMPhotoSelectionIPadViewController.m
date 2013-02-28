//
//  RMPhotoSelectionIPadViewController.m
//  RotateMe
//
//  Created by Eren Halici on 06.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMPhotoSelectionIPadViewController.h"
#import "RMCustomImageView.h"
#import "RMInGameIPadViewController.h"
#import "RMImage.h"
#import "Photo.h"
#import "UIView+Util.h"

@interface RMPhotoSelectionIPadViewController ()

@end

@implementation RMPhotoSelectionIPadViewController
{
    
}

static RMPhotoSelectionIPadViewController* lastInstance = nil;

+ (RMPhotoSelectionIPadViewController*) lastInstance
{
    return lastInstance;
}
- (int) leftMargin
{
    return 40;
}

- (int) topMargin
{
    return 15;
}

- (CGSize) size
{
    return CGSizeMake(204+30, 158+30);
}

- (CGSize) photoSize
{
    return CGSizeMake(204, 158);
}

-(void) setBackground
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selection_bg_ipad.jpg"]]];
}
- (int) shadowRadius
{
    return 3;
}

- (CGSize) shadowOffset
{
    return CGSizeMake(2, 5);
}

-(CGFloat) galleryNameLabelFontSize
{
    return 30.0;
}
- (CGFloat) photoSelectionScoreFontSize
{
    return 21.0;
}
- (int) rowCount
{
    return 3;
}
@end


