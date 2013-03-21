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
#import "StopWatch.h"

@interface EQSettingsViewController ()

@end

@implementation EQSettingsViewController{
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    CGFloat winWidth;
    CGFloat winHeight;
    UIView * aboutScreen;
    UIScrollView * credits;
    StopWatch * stopWatch;
    int didScrolled;
    
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
    
    
    winWidth = [[UIScreen mainScreen] bounds].size.height;
    winHeight = [[UIScreen mainScreen] bounds].size.width;
    
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
    [btnAbout addTarget:self action:@selector(showAboutScreen) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void) closeAbout {
    [aboutScreen removeFromSuperview];
}

-(void) showAboutScreen{
    
    aboutScreen=[[UIView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        aboutScreen.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.png"]];
    }
    else{
        aboutScreen.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    }
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake((winWidth-(winWidth-35.0))/2, 0.0, winWidth-35.0, 45.0)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30.0]];
    [headerLabel setTextColor:[UIColor colorWithRed:0.463 green:0.365 blue:0.227 alpha:1.0]];
    [headerLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [headerLabel setShadowColor:[UIColor whiteColor]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setText:NSLocalizedString(@"ABOUT", nil)];
    
    UIView *headerDoubleLine = [[UIView alloc] initWithFrame:CGRectMake((winWidth-(winWidth/3))/2, 45.0, winWidth/3, 3.0)];
    [headerDoubleLine setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"double_line.png"]]];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn_pressed.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeAbout) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(winWidth-45.0, 5.0, 35.0, 35.0);
    
    UIView * mask=[[UIView alloc]initWithFrame:CGRectMake(20, 60, winWidth-40, winHeight-60)];
    [mask setBackgroundColor:[UIColor clearColor]];
    mask.clipsToBounds=YES;
    
    credits=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, winWidth, winHeight-60)];
    [credits setBackgroundColor:[UIColor clearColor]];
//    [credits setUserInteractionEnabled:NO];
    [credits setContentSize:CGSizeMake(winWidth-40, 700)];
    [credits setShowsHorizontalScrollIndicator:NO];
    [credits setShowsVerticalScrollIndicator:NO];
        
    float fontSizeL = 22.0;
    float fontSizeM = 20.0;
    NSString *fontHeader = @"HelveticaNeue-Medium";
    NSString *font = @"HelveticaNeue-Light";
    UIColor *color = [UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0];
    
    // Company Name
    UILabel * cName=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0, mask.frame.size.width, 40.0)];
    [cName setFont:[UIFont fontWithName:fontHeader size:fontSizeL]];
    [cName setTextColor:color];
    [cName setTextAlignment:NSTextAlignmentCenter];
    [cName setBackgroundColor:[UIColor clearColor]];
    [cName setText:@"HALICI BİLGİ İŞLEM A.Ş."];
    
    // Adress
    UILabel * cAdress=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 40, mask.frame.size.width, 120)];
    [cAdress setFont:[UIFont fontWithName:font size:fontSizeM]];
    [cAdress setTextColor:color];
    [cAdress setTextAlignment:NSTextAlignmentCenter];
    [cAdress setBackgroundColor:[UIColor clearColor]];
    [cAdress setNumberOfLines:3];
    [cAdress setText:@"ODTÜ-Halıcı Yazılımevi \nİnönü Bulvarı 06531 \nODTÜ-Teknokent/ANKARA"];
    
    // Mail
    UILabel * cMail=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 160, mask.frame.size.width, 40.0)];
    [cMail setFont:[UIFont fontWithName:font size:fontSizeM]];
    [cMail setTextColor:color];
    [cMail setTextAlignment:NSTextAlignmentCenter];
    [cMail setBackgroundColor:[UIColor clearColor]];
    [cMail setText:@"iletisim@halici.com.tr"];
    
    
    // Programming
    UILabel * cProgramming=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 240, mask.frame.size.width, 40.0)];
    [cProgramming setFont:[UIFont fontWithName:fontHeader size:fontSizeL]];
    [cProgramming setTextColor:color];
    [cProgramming setTextAlignment:NSTextAlignmentCenter];
    [cProgramming setBackgroundColor:[UIColor clearColor]];
    [cProgramming setText:NSLocalizedString(@"PROGRAMMING",nil)];
    
    
    // Names
    NSArray * names=[[NSArray alloc] initWithObjects:@"Eren HALICI",@"Yunus Eren GÜZEL", @"Abdullah KARACABEY",@"Alperen KAVUN", nil];
    for(int i=0; i<names.count;i++){
        UILabel * cName=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 300+i*40, mask.frame.size.width, 40.0)];
        [cName setFont:[UIFont fontWithName:font size:fontSizeM]];
        [cName setTextColor:color];
        [cName setTextAlignment:NSTextAlignmentCenter];
        [cName setBackgroundColor:[UIColor clearColor]];
        [cName setNumberOfLines:2];
        [cName setText:names[i]];
        [credits addSubview:cName];
    }
    
    
    // Art
    UILabel * cArt=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 500, mask.frame.size.width, 40.0)];
    [cArt setFont:[UIFont fontWithName:fontHeader size:fontSizeL]];
    [cArt setTextColor:color];
    [cArt setTextAlignment:NSTextAlignmentCenter];
    [cArt setBackgroundColor:[UIColor clearColor]];
    [cArt setText:NSLocalizedString(@"ART", nil)];
    
    UILabel * cArtName=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 540, mask.frame.size.width, 40.0)];
    [cArtName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:fontSizeM]];
    [cArtName setTextColor:color];
    [cArtName setTextAlignment:NSTextAlignmentCenter];
    [cArtName setBackgroundColor:[UIColor clearColor]];
    [cArtName setNumberOfLines:2];
    [cArtName setText:@"Ebuzer Egemen DURSUN"];
    
    
    // Copyright
    UILabel * cCRight=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 620, mask.frame.size.width, 40.0)];
    [cCRight setFont:[UIFont fontWithName:font size:fontSizeL]];
    [cCRight setTextColor:color];
    [cCRight setTextAlignment:NSTextAlignmentCenter];
    [cCRight setBackgroundColor:[UIColor clearColor]];
    [cCRight setText:@"Copyright © 2013"];
    
    
    
    [credits addSubview:cName];
    [credits addSubview:cAdress];
    [credits addSubview:cMail];
    [credits addSubview:cProgramming];
    [credits addSubview:cArt];
    [credits addSubview:cArtName];
    [credits addSubview:cCRight];
    [mask addSubview:credits];
    [aboutScreen addSubview:headerLabel];
    [aboutScreen addSubview:headerDoubleLine];
    [aboutScreen addSubview:closeButton];
    [aboutScreen addSubview:mask];
    
    [self.view addSubview:aboutScreen];
    
    /*
    [credits setContentOffset:CGPointMake(0, 0)];
    [UIScrollView animateWithDuration:10.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [credits setUserInteractionEnabled:YES];
        [credits setContentOffset:CGPointMake(0, 700-credits.frame.size.height) animated:NO];
        [UIScrollView setAnimationDidStopSelector:@selector(scrollViewTap)];
    } completion:^(BOOL finished) {
                    NSLog(@"scrollView animate Completion");
        
    }];
    */

    
    /*
    [UIScrollView beginAnimations:@"scrollAnimation" context:nil];
    [UIScrollView setAnimationDuration:10.0];
    [credits setContentOffset:CGPointMake(0, 700-credits.frame.size.height)];
    [UIScrollView commitAnimations];
    */
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap)];
//    [credits addGestureRecognizer:singleTap];
    
    stopWatch = [[StopWatch alloc] init];
    [stopWatch startTimerWithRepeatBlock:^{
        
    }];
    [credits setUserInteractionEnabled:YES];
    [UIScrollView beginAnimations:nil context:NULL];
    [UIScrollView setAnimationDuration:30.0f];
    [UIScrollView setAnimationCurve:UIViewAnimationCurveLinear];
    [credits setDelegate:self];
   [credits setContentOffset:CGPointMake(0, 700-credits.frame.size.height)];
    [UIScrollView commitAnimations];
    didScrolled=0;
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"DEBUG: scrollViewDidScroll" );
    didScrolled++;
    
    if(didScrolled==2)
        [self scrollViewTap];
}

-(void) scrollViewTap
{
    [credits.layer removeAllAnimations];
    [stopWatch pauseTimer];
    float timer=[stopWatch getElapsedMiliseconds]/1000.0;
//    NSLog(@"Touch detected - scrollViewTap: %f",timer);
    [credits.layer removeAllAnimations];
    [credits setContentOffset:CGPointMake(0, (700.0-credits.frame.size.height)*timer/30.0)];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
