//
//  RMInGameMenuView.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/20/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMInGameMenuView.h"
#import "Config.h"
#import "RMInGameViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation RMInGameMenuView

-(id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setBackground];
        [self showButtons];
        self.alpha = 0.0;
        
        CGRect buttonFrame = [RMInGameViewController lastInstance].menuButton.frame;

        int x = buttonFrame.origin.x - frame.size.width/2 + buttonFrame.size.width/2;
        int y = buttonFrame.origin.y - frame.size.height/2 + buttonFrame.size.height/2;
        
        CATransform3D transform = CATransform3DMakeTranslation(x, y, 1000);
        transform = CATransform3DScale(transform, 0.1, 0.1, 1);
        transform.m34 = 1.0 / -500;
        transform = CATransform3DRotate(transform, 10.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
        
        self.layer.transform = transform;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        [UIView animateWithDuration:0.15 animations:^{
            self.alpha = 1.0;
        }];
    }
    return self;
}

-(void) showButtons
{
    CGSize buttonSize = CGSizeMake(166, 53);
    UIButton* mainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton* restart = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton* resume = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [mainMenu setTitle:@"Main Menu" forState:UIControlStateNormal];
    [restart setTitle:@"Restart" forState:UIControlStateNormal];
    [resume setTitle:@"Resume" forState:UIControlStateNormal];
    
    mainMenu.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height*0.5 - buttonSize.width*0.5,
                                [[UIScreen mainScreen] bounds].size.width*0.65, buttonSize.width, buttonSize.height);
    restart.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height*0.5 - buttonSize.width*0.5,
                                [[UIScreen mainScreen] bounds].size.width*0.45, buttonSize.width, buttonSize.height);
    resume.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height*0.5 - buttonSize.width*0.5,
                                [[UIScreen mainScreen] bounds].size.width*0.25, buttonSize.width, buttonSize.height);
    
    [mainMenu addTarget:[RMInGameViewController lastInstance] action:@selector(returnToMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [restart addTarget:[RMInGameViewController lastInstance] action:@selector(restartGame:) forControlEvents:UIControlEventTouchUpInside];
    [resume addTarget:[RMInGameViewController lastInstance] action:@selector(resumeGame:) forControlEvents:UIControlEventTouchUpInside];

    
    
    [self stylizeButton:mainMenu];
    [self stylizeButton:restart];
    [self stylizeButton:resume];
    
    [self addSubview:mainMenu];
    [self addSubview:restart];
    [self addSubview:resume];
    
}


-(void) stylizeButton:(UIButton*)button
{
    [button.titleLabel setFont:[UIFont fontWithName:@"TRMcLeanBold" size:16.0]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setTitleColor:BROWN_TEXT_COLOR forState:UIControlStateNormal];
    [button setTitleColor:BROWN_TEXT_COLOR forState:UIControlStateHighlighted];
    [button setTitleColor:BROWN_TEXT_COLOR forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"ingame_btn_bg.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ingame_btn_bg_hover.png"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"ingame_btn_bg_hover.png"] forState:UIControlStateSelected];
}

-(void) setBackground
{
    if([[UIScreen mainScreen] bounds].size.height == 568){
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inapp_bg-568h.png"]]];
    }
    else{
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inapp_bg.png"]]];
        
    }
    
}
-(void )removeFromSuperviewOnCompletion:(IteratorBlock)block
{
    [UIView animateWithDuration:0.15 delay:0.10 options:0 animations:^{
        self.alpha = 0.0;
    } completion:nil];
    [UIView animateWithDuration:0.25 delay:0.0 options:0 animations:^{
        CGRect buttonFrame = [RMInGameViewController lastInstance].menuButton.frame;
        
        int x = buttonFrame.origin.x - self.frame.size.width/2 + buttonFrame.size.width/2;
        int y = buttonFrame.origin.y - self.frame.size.height/2 + buttonFrame.size.height/2;
        
        CATransform3D transform = CATransform3DMakeTranslation(x, y, 1000);
        transform = CATransform3DScale(transform, 0.1, 0.1, 1);
        transform.m34 = 1.0 / -500;
        transform = CATransform3DRotate(transform, 3.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
        
        self.layer.transform = transform;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        block();
    }];
    
}

@end
