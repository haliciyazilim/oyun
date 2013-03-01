//
//  RMGallerySelectionIPadViewController.m
//  RotateMe
//
//  Created by Eren Halici on 06.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMGallerySelectionIPadViewController.h"
#import "RMIpadGallerySelectionItemView.h"
#import "RMIpadSettingsView.h"

@interface RMGallerySelectionIPadViewController ()

@end

@implementation RMGallerySelectionIPadViewController

- (CGSize) scrollViewItemSize{
    return CGSizeMake(350,200);
}

-(void) setBackground
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selection_bg_ipad.jpg"]]];	
}

- (RMGallerySelectionItemView*) generateGallerySelectionItemViewWithGallery:(Gallery*)gallery animate:(BOOL)animate
{
    return [[RMIpadGallerySelectionItemView alloc] initWithGallery:gallery animate:YES];
}
- (IBAction)openSettings:(id)sender {
    RMSettingsView* settings = [[RMIpadSettingsView alloc] init];
    [self.view addSubview:settings];
}

@end
