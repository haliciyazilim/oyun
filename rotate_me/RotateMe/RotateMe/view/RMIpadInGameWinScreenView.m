//
//  RMIpadInGameWinScreenView.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 3/1/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMIpadInGameWinScreenView.h"

@implementation RMIpadInGameWinScreenView

+ (RMInGameWinScreenView*) showWinScreenWithScore:(NSString*)score forInGameViewController:(RMInGameViewController*) inGameViewController
{
    return [[RMIpadInGameWinScreenView alloc] initWithScore:score andInGameViewController:inGameViewController];
}

- (CGRect) hiddenImageTargetFrame
{
    return  CGRectMake(0, 0, 740, 580);
}
- (CGRect) newPhotoHolderImageFrame
{
    return CGRectMake(-11, -10, 771, 670);
}

- (CGRect) restartButtonFrame
{
    return CGRectMake(840, 300, 154, 36);
}
- (CGRect) menuButtonFrame
{
    return CGRectMake(840, 240, 154, 36);
}
-(void) appendNewViewControllerBackground
{
    [self setControllerBackground:[UIImage imageNamed:@"inapp_bg_ipad.jpg"]];
}
- (CGRect)scoreFrame
{
    return CGRectMake(60, 630, 150, 40);
}
-(CGFloat) scoreFontSize
{
    return 40.0;
}

-(CGFloat) imageRadius
{
    return 10.0;
}

@end
