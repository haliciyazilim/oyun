//
//  EQViewController.m
//  Equify
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "EQViewController.h"
#import "EQGameViewController.h"
#import "EQQuestion.h"
#import "EQAppSpecificViewSizes.h"
#import "EQStatsViewController.h"

@interface EQViewController ()

@end

@implementation EQViewController
{
    // neccessary UIViews
    UIView *mainView;
    UIView * buttonsView;
    
    float btnSize;
    float btnGCSize;
    float btnShadowSize;
    float buttonsViewHeight;
    float buttonsViewWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"first screen");
    
    
    btnSize=[UIImage imageNamed:@"main_btn.png"].size.width;
    btnGCSize=[UIImage imageNamed:@"game_center_btn.png"].size.width;

    btnShadowSize=110.0;
    buttonsViewHeight=204;
    buttonsViewWidth=404;
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.png"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    }
    
    float screenWidth=[[UIScreen mainScreen] bounds].size.height;
    UIImage * logo=[UIImage imageNamed:@"equify_logo.png"];
    UIImageView * logoView=[[UIImageView alloc] initWithImage:logo];
    logoView.frame=CGRectMake(20, 20, logo.size.width, logo.size.height);
    
    [self.view addSubview:logoView];
    
    buttonsView=[[UIView alloc] initWithFrame:CGRectMake((screenWidth-buttonsViewWidth)/2, 100, buttonsViewWidth, buttonsViewHeight)];
//    buttonsView.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:buttonsView];
    
     UIButton * btnGameSettings=[self makeButton:CGRectMake(0, 50, btnSize, btnSize) title:@"game\nsettings"];
    
    UIButton * btnStartGame=[self makeButton:CGRectMake((buttonsViewWidth-btnSize)/2, 0, btnSize, btnSize) title:@"start\ngame"];
    [btnStartGame addTarget:self action:@selector(startNewGame:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnUserStats=[self makeButton:CGRectMake(buttonsViewWidth-btnSize, 50, btnSize, btnSize) title:@"user\nstaats"];
    [btnUserStats addTarget:self action:@selector(openStats) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnGameCenter=[self makeGameCenterButton:CGRectMake((buttonsViewWidth-btnGCSize)/2, buttonsViewHeight-btnGCSize, btnGCSize, btnGCSize)];
    
    [buttonsView addSubview:btnStartGame];
    [buttonsView addSubview:btnGameSettings];
    [buttonsView addSubview:btnUserStats];
    [buttonsView addSubview:btnGameCenter];




    
}

-(UIButton *) makeButton:(CGRect)frame title:(NSString *) title{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:@"main_btn.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"main_btn_pressed.png"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(makeHighlighted:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpOutside];
    [btn addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpInside];
    
//    btn.titleLabel.textColor=[UIColor colorWithRed:0.462 green:0.364 blue:0.227 alpha:1.0];
    btn.titleLabel.font=[UIFont fontWithName:@"Helvetica Thin" size:60.0];
    btn.titleLabel.numberOfLines=2;
    
    [btn setTitleColor:[UIColor colorWithRed:0.462 green:0.364 blue:0.227 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.shadowColor=[UIColor colorWithWhite:1.0 alpha:0.7];
    btn.titleLabel.shadowOffset=CGSizeMake(0.0, 1.0);
    btn.titleLabel.backgroundColor=[UIColor clearColor];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    return btn;

}

-(UIButton *) makeGameCenterButton:(CGRect)frame{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:@"game_center_btn.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"game_center_btn_pressed.png"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(makeHighlighted:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpOutside];
    [btn addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpInside];
    
//    btn.titleLabel.textColor=[UIColor colorWithRed:0.46 green:0.36 blue:0.22 alpha:1.0];
//    btn.titleLabel.font=[UIFont fontWithName:@"Helvetica Thin" size:24.0];
    //    btnGameStart.titleLabel.shadowColor=[UIColor colorWithWhite:1.0 alpha:0.7];
    //    btnGameStart.titleLabel.shadowOffset=CGSizeMake(0.0, 2.0);
    btn.titleLabel.backgroundColor=[UIColor clearColor];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    return btn;
    
}

- (void) makeUnhighlighted:(UIButton *)button {
    [self unhighlight:button];
}
- (void) makeHighlighted:(UIButton *)button {
    [self highlight:button];
}
-(void)highlight:(UIButton *)button {
    button.titleLabel.textColor=[UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0];
    
}
-(void)unhighlight:(UIButton *)button {
    button.titleLabel.textColor=[UIColor colorWithRed:0.462 green:0.364 blue:0.227 alpha:1.0];
}

- (IBAction)startNewGame:(id)sender {
    [self performSegueWithIdentifier:@"GameStartSegue" sender:self];
}

-(void)openStats{
    [self performSegueWithIdentifier:@"StatsSegue" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameStartSegue"]) {
        //
        EQGameViewController *eqGameViewController = [segue destinationViewController];
        [eqGameViewController setCurrentQuestion:[EQQuestion getNextQuestion]];
    }
    else if ([segue.identifier isEqualToString:@"StatsSegue"]) {
        EQStatsViewController *eqStatsViewController = [segue destinationViewController];
        [eqStatsViewController setCurrentStatistics:[EQStatistic getStatistics]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
