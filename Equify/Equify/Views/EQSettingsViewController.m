//
//  EQSettingsViewController.m
//  Equify
//
//  Created by Abdullah Karacabey on 15.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#define RESET_STATS_APPROVE_ALERT_TAG 35

#import "EQSettingsViewController.h"
#import "EQStatistic.h"
#import "EQScore.h"

@interface EQSettingsViewController ()

@end

@implementation EQSettingsViewController{
    CGFloat buttonWidth;
    CGFloat buttonHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGFloat winWidth = [[UIScreen mainScreen] bounds].size.height;
    CGFloat winHeight = [[UIScreen mainScreen] bounds].size.width;
    buttonWidth=175;
    buttonHeight=40;
    UIView *seperator1 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2-55, 175, 2.0)];
    [seperator1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"single_line.png"]]];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn_pressed.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeSettings) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(winWidth-45.0, 5.0, 35.0, 35.0);
    
    
    UIButton * btnReset=[self makeButton:CGRectMake((winWidth-175)/2, (winHeight-40)/2-50, 175, 40) title:NSLocalizedString(@"RESET", nil)];

    [btnReset addTarget:self action:@selector(resetStatsApprove) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2-5, 175, 2.0)];
    [seperator2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"single_line.png"]]];

    UIButton * btnAbout=[self makeButton:CGRectMake((winWidth-175)/2, (winHeight-40)/2, 175, 40) title:NSLocalizedString(@"ABOUT", nil)];

    UIView *seperator3 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2+45, 175, 2.0)];
    [seperator3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"single_line.png"]]];

    UIButton * btnMoreGames=[self makeButton:CGRectMake((winWidth-175)/2, (winHeight-40)/2+50, 175, 40) title:NSLocalizedString(@"MOREGAMES", nil)];
    
    UIView *seperator4 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2+95, 175, 2.0)];
    [seperator4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"single_line.png"]]];

    [self.view addSubview:closeButton];
    [self.view addSubview:seperator1];
    [self.view addSubview:btnReset];
    [self.view addSubview:seperator2];
    [self.view addSubview:btnAbout];
    [self.view addSubview:seperator3];
    [self.view addSubview:btnMoreGames];
    [self.view addSubview:seperator4];
    
    [self setBackgrounds];
    
}
-(void)resetStatsApprove {
    UIAlertView *resetStatsApprove = [[UIAlertView alloc] initWithTitle:@""
                                                              message:NSLocalizedString(@"RESET_STATS_APPROVE", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                                    otherButtonTitles:NSLocalizedString(@"OK", nil),nil];
    [resetStatsApprove setTag:RESET_STATS_APPROVE_ALERT_TAG];
    [resetStatsApprove show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == RESET_STATS_APPROVE_ALERT_TAG){
        if (buttonIndex != [alertView cancelButtonIndex]){
            [self resetStats];
        }
    }
}
- (void) resetStats {
    [EQStatistic resetStatistics];
    [EQScore cleanAllScores];
}
-(void) setBackgrounds{
    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.png"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    }
}

-(UIButton *) makeButton:(CGRect)frame title:(NSString *) title{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    UILabel * lblReset=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    UIFont * font=[UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
    
    [lblReset setText:title];
    [lblReset setFont:font];
    [lblReset setBackgroundColor:[UIColor clearColor]];
    [lblReset setTextColor:[UIColor blackColor]];
    [lblReset setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
    [lblReset setShadowOffset:CGSizeMake(0.0, 1.0)];
    [lblReset setTextAlignment:NSTextAlignmentCenter];
    [btn addSubview:lblReset];
    
    return btn;
    
}

- (void) closeSettings {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
