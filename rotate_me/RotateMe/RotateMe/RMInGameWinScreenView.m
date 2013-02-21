//
//  RMInGameWinScreenView.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/19/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMInGameWinScreenView.h"
#import "RMInGameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#import "RMPhotoSelectionViewController.h"


@implementation RMInGameWinScreenView
{
    NSString* score;
    RMInGameViewController* inGameViewController;
    CGRect hiddenImageTargetFrame;
    CGFloat rotationAmount;
}
+ (RMInGameWinScreenView*) showWinScreenWithScore:(NSString*)score forInGameViewController:(RMInGameViewController*) inGameViewController
{
    return [[RMInGameWinScreenView alloc] initWithScore:score andInGameViewController:inGameViewController];
}

- initWithScore:(NSString*) _score andInGameViewController:(RMInGameViewController*) _inGameViewController
{
    if(self = [super init]){
        score = _score;
        inGameViewController = _inGameViewController;
        rotationAmount = -M_PI*0.044;
        [self cleanViewControllerImagesWithAnimation];
    }
    return self;
}

- (void) cleanViewControllerImagesWithAnimation
{
    
    hiddenImageTargetFrame = CGRectMake(0, 0, 248, 200);
    [inGameViewController.hiddenImage setClipsToBounds:NO];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        inGameViewController.hiddenImage.frame = CGRectMake(
                    -inGameViewController.photoHolder.frame.origin.x,
                    -inGameViewController.photoHolder.frame.origin.y,
                    [[UIScreen mainScreen] bounds].size.height,
                    [[UIScreen mainScreen] bounds].size.width);
        [inGameViewController.menuButton setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self appendNewPhotoHolderImage];
        [inGameViewController.stopWatchLabel setAlpha:0.0];
        [inGameViewController.timerHolder setAlpha:0.0];
        [inGameViewController.menuButton setAlpha:0.0];
        [self appendNewViewControllerBackground];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            inGameViewController.hiddenImage.frame = hiddenImageTargetFrame;
            inGameViewController.hiddenImage.transform = CGAffineTransformRotate(inGameViewController.hiddenImage.transform, rotationAmount);
            inGameViewController.photoHolder.transform = CGAffineTransformMakeTranslation(20, 20);
            
        } completion:^(BOOL finished) {
            [inGameViewController.hiddenImage.layer setCornerRadius:3.0];
            [inGameViewController.hiddenImage.layer setBorderWidth:0.1];
            [inGameViewController.hiddenImage.layer setBorderColor:[UIColor whiteColor].CGColor];
            [inGameViewController.hiddenImage setClipsToBounds:YES];
            [self showButtons];
        }];
    }];
}

-(void) appendNewViewControllerBackground
{
    if([[UIScreen mainScreen] bounds].size.height == 568){
        [inGameViewController.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inapp_bg-568h.png"]]];
    }
    else{
        [inGameViewController.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inapp_bg.png"]]];
        
    }
   
}

-(void) appendNewPhotoHolderImage
{
    inGameViewController.photoHolder.image = nil;
    UIImageView* newPhotoHolderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_photo_bg.png"]];
    CGRect frame = CGRectMake(-5, -5, 262, 240);
    newPhotoHolderImage.frame = frame;
    [inGameViewController.photoHolder addSubview:newPhotoHolderImage];
    
    [inGameViewController.photoHolder insertSubview:newPhotoHolderImage belowSubview:inGameViewController.hiddenImage];
    newPhotoHolderImage.transform = CGAffineTransformRotate(newPhotoHolderImage.transform, rotationAmount);
    [self appendScore];
}

-(void) showButtons{
    UIButton* menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menuButton setTitle:@"Main Menu" forState:UIControlStateNormal];
    [self stylizeButton:menuButton];
    [menuButton addTarget:inGameViewController action:@selector(returnToMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [inGameViewController.view addSubview:menuButton];
    
    UIButton* restartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [restartButton setTitle:@"Restart" forState:UIControlStateNormal];
    [self stylizeButton:restartButton];
    
    [restartButton addTarget:inGameViewController action:@selector(restartGame:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        [restartButton setFrame:CGRectMake(360, 160, 150, 30)];
        [menuButton setFrame:CGRectMake(360, 120, 150, 30)];
    }
    else{
        [restartButton setFrame:CGRectMake(320, 160, 150, 30)];
        [menuButton setFrame:CGRectMake(320, 120, 150, 30)];
    }
    
    [inGameViewController.view addSubview:restartButton];
}

-(void) stylizeButton:(UIButton*)button
{
    [button.titleLabel setFont:[UIFont fontWithName:@"TRMcLeanBold" size:16.0]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setTitleColor:BROWN_TEXT_COLOR forState:UIControlStateNormal];
    [button setTitleColor:BROWN_TEXT_COLOR forState:UIControlStateHighlighted];
    [button setTitleColor:BROWN_TEXT_COLOR forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"youwin_btn_bg.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"youwin_btn_bg_hover.png"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"youwin_btn_bg_hover.png"] forState:UIControlStateSelected];
}

-(void) appendScore
{
    UILabel* label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(30, 205, 150, 30)];
    [label setFont:[UIFont fontWithName:@"TRMcLeanBold" size:20.0]];
    [label setText:score];
    [label setTextColor:BROWN_TEXT_COLOR];
    [label setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
    [label setShadowOffset:CGSizeMake(0.0, 1.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.transform = CGAffineTransformRotate(label.transform, rotationAmount);
    [inGameViewController.photoHolder addSubview:label];
    [inGameViewController.photoHolder insertSubview:label belowSubview:inGameViewController.hiddenImage];
    [label setAlpha:0.0];
    [UIView animateWithDuration:1.0 animations:^{
        [label setAlpha:1.0];
    }];
}


@end
