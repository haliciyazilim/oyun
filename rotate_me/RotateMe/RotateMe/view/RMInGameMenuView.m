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
//        [self setFrame:frame];
        [self setBackground];
        [self showButtons];
        self.alpha = 0.0;
        
        
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        }];
        
    }
    return self;
}

-(void) showButtons
{
    CGSize buttonSize = CGSizeMake(150, 30);
    UIButton* mainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton* restart = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton* resume = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [mainMenu setTitle:@"Main Menu" forState:UIControlStateNormal];
    [restart setTitle:@"Restart" forState:UIControlStateNormal];
    [resume setTitle:@"Resume" forState:UIControlStateNormal];
    
    mainMenu.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height*0.5 - buttonSize.width*0.5,
                                [[UIScreen mainScreen] bounds].size.width*0.70, buttonSize.width, buttonSize.height);
    restart.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height*0.5 - buttonSize.width*0.5,
                                [[UIScreen mainScreen] bounds].size.width*0.50, buttonSize.width, buttonSize.height);
    resume.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height*0.5 - buttonSize.width*0.5,
                                [[UIScreen mainScreen] bounds].size.width*0.30, buttonSize.width, buttonSize.height);
    
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
    [button setBackgroundImage:[UIImage imageNamed:@"youwin_btn_bg.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"youwin_btn_bg_hover.png"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"youwin_btn_bg_hover.png"] forState:UIControlStateSelected];
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
    [UIView animateWithDuration:0.3 delay:0.2 options:0 animations:^{
        self.alpha = 0.0;
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        block();
    }];
    
}

@end
