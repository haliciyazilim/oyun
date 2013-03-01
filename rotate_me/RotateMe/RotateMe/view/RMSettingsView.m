//
//  RMSettingsView.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/25/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMSettingsView.h"
#import "Config.h"
#import "Score.h"
#import "RotateMeIAPHelper.h"

@implementation RMSettingsView
{
    UIButton *restoreButton;
}
- (id) init{
    if(self = [super init]){
        [self setBackground];
        [self setFrame];
        [self setButtons];
        [self setAlpha:0.0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRestore) name:IAPHelperEnableBuyButtonNotification object:nil];
        [UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{
            [self setAlpha:1.0];
        } completion:nil];
    }
    return self;
}

-(void) setFrame
{
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
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

-(void) setButtons
{
    NSMutableArray* buttons = [[NSMutableArray alloc] init];
    UIButton* button;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Return" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeSettings) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    button = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"About Us" forState:UIControlStateNormal];
    [buttons addObject:button];
    button = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Reset Scores" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resetScores) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    button = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Restore Purchases" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(restorePurchases) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    restoreButton = button;
    button = nil;
    
    int index = 0;
    CGSize buttonSize = [self getButtonSize];
    CGFloat margin = [self getMargin];
    for(UIButton* button in buttons){
        button.frame = CGRectMake(
                          self.frame.size.width*0.5 - buttonSize.width*0.5,
                          self.frame.size.height*0.5 - [buttons count]*(margin+buttonSize.height)*0.5 + margin*0.5 + index * (buttonSize.height+margin),
                          buttonSize.width,
                          buttonSize.height);
        [self addSubview:button];
        [self stylizeButton:button];
        index++;
    }
}
- (void) disableRestore {
    [restoreButton setEnabled:NO];
}
- (void) enableRestore {
    [restoreButton setEnabled:YES];
}
- (void) restorePurchases {
    [self disableRestore];
    [[RotateMeIAPHelper sharedInstance] addActivityToView:restoreButton withFrame:CGRectMake(0.0, 0.0, restoreButton.frame.size.width, restoreButton.frame.size.height)];
    [[RotateMeIAPHelper sharedInstance] restoreCompletedTransactions];
}
-(void) stylizeButton:(UIButton*) button
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

- (CGSize) getButtonSize
{
    return CGSizeMake(166, 53);
}

- (CGFloat) getMargin
{
    return 20;
}

- (void) closeSettings
{
    [UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) resetScores
{
    [[[UIAlertView alloc] initWithTitle:@"Reset Scores" message:@"Are you sure you want to reset scores?"  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure",nil] show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [Score cleanAllScores];
        [[[UIAlertView alloc] initWithTitle:@"Scores cleaned" message:@"Your all scores were cleaned"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    
}
@end
