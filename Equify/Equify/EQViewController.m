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
#import "EQSettingsViewController.h"
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
    
    
    UIButton * btnLevel1;
    UIButton * btnLevel2;
    UIButton * btnLevel3;
    int difficulty;

}

-(float) btnSize{
    return [UIImage imageNamed:@"main_btn.png"].size.width;
}

-(float) btnGCSize{
    return [UIImage imageNamed:@"game_center_btn.png"].size.width;
}

-(float) btnShadowSize{
    return 110.0;
}

-(float) buttonsViewHeight{
    return 204.0;
}

-(float) buttonsViewWidth{
    return 404.0;
}

-(float) screenWidth{
    return [[UIScreen mainScreen] bounds].size.height;
}


-(void) setBackgrounds{
    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.png"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    }
}

-(UIImageView *) setLogo{
    UIImage * logo=[UIImage imageNamed:@"equify_logo.png"];
    UIImageView * logoView=[[UIImageView alloc] initWithImage:logo];
    logoView.frame=CGRectMake(20, 20, logo.size.width, logo.size.height);
    return logoView;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"first screen");  
    
    [self setBackgrounds];
            
    [self.view addSubview:[self setLogo]];
    
    
    
    UIView *difficultyButtonsView=[self makeDifficultyButtons];
    [difficultyButtonsView setFrame:CGRectMake([self screenWidth]-difficultyButtonsView.frame.size.width-25, 25, difficultyButtonsView.frame.size.width, difficultyButtonsView.frame.size.height)];
    [self.view addSubview:difficultyButtonsView];
    
    
    buttonsView=[[UIView alloc] initWithFrame:CGRectMake(([self screenWidth]-[self buttonsViewWidth])/2, 100, [self buttonsViewWidth], [self buttonsViewHeight])];
//    buttonsView.backgroundColor=[UIColor yellowColor];
    
    [self.view addSubview:buttonsView];
    
    UIButton * btnGameSettings=[EQViewController makeButton:CGRectMake(0, 50, [self btnSize], [self btnSize]) title:NSLocalizedString(@"GAMESETTINGS", nil)];
    [btnGameSettings addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnStartGame=[EQViewController makeButton:CGRectMake(([self buttonsViewWidth]-[self btnSize])/2, 0, [self btnSize], [self btnSize]) title:NSLocalizedString(@"GAMESTART", nil) ];
    [btnStartGame addTarget:self action:@selector(startNewGame:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnUserStats=[EQViewController makeButton:CGRectMake([self buttonsViewWidth]-[self btnSize], 50, [self btnSize], [self btnSize]) title:NSLocalizedString(@"USERSTATS", nil)];
    [btnUserStats addTarget:self action:@selector(openStats) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnGameCenter=[self makeGameCenterButton:CGRectMake(([self buttonsViewWidth]-[self btnGCSize])/2, [self buttonsViewHeight]-[self btnGCSize], [self btnGCSize], [self btnGCSize])];
    [btnGameCenter addTarget:self action:@selector(showGameCenter) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonsView addSubview:btnStartGame];
    [buttonsView addSubview:btnGameSettings];
    [buttonsView addSubview:btnUserStats];
    [buttonsView addSubview:btnGameCenter];




    
}

+(UIButton *) makeButton:(CGRect)frame title:(NSString *) title{
    
    NSArray * tile=[title componentsSeparatedByString:@"\n"];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:@"main_btn.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"main_btn_pressed.png"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(makeHighlighted:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpOutside];
    [btn addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpInside];

    if(tile.count>1){
        UILabel * lblA=[[UILabel alloc]initWithFrame:CGRectMake(0, (btn.frame.size.height-30)/2-11, btn.frame.size.width, 30)];
        UIFont * font=[UIFont fontWithName:@"HelveticaNeue-Light" size:27.0];
        [lblA setText:tile[0]];
        [lblA setFont:font];
        [lblA setBackgroundColor:[UIColor clearColor]];
        [lblA setTextColor:[UIColor colorWithRed:0.462 green:0.364 blue:0.227 alpha:1.0]];
        [lblA setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [lblA setShadowOffset:CGSizeMake(0.0, 1.0)];
        [lblA setTextAlignment:NSTextAlignmentCenter];
    
    
        UILabel * lblB=[[UILabel alloc]initWithFrame:CGRectMake(0, (btn.frame.size.height-30)/2+11, btn.frame.size.width, 30)];
        [lblB setText:tile[1]];
        [lblB setFont:font];
        [lblB setBackgroundColor:[UIColor clearColor]];
        [lblB setTextColor:[UIColor colorWithRed:0.462 green:0.364 blue:0.227 alpha:1.0]];
        [lblB setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [lblB setShadowOffset:CGSizeMake(0.0, 1.0)];
        [lblB setTextAlignment:NSTextAlignmentCenter];
    
        [btn addSubview:lblA];
        [btn addSubview:lblB];
    }
    else if(tile.count==1){
        NSLog(@"tile==1: %i",tile.count);
        UILabel * lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
        UIFont * font=[UIFont fontWithName:@"HelveticaNeue-Light" size:27.0];
        [lbl setText:tile[0]];
        [lbl setFont:font];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextColor:[UIColor colorWithRed:0.462 green:0.364 blue:0.227 alpha:1.0]];
        [lbl setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [lbl setShadowOffset:CGSizeMake(0.0, 1.0)];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTag:1];
        
        [btn addSubview:lbl];
        
    }

    return btn;

}

-(UIButton *) makeGameCenterButton:(CGRect)frame{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:@"game_center_btn.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"game_center_btn_pressed.png"] forState:UIControlStateHighlighted];
    
    return btn;
    
}

+ (void) makeUnhighlighted:(UIButton *)button {
    [EQViewController unhighlight:button];
}
+ (void) makeHighlighted:(UIButton *)button {
    [EQViewController highlight:button];
}
+(void)highlight:(UIButton *)button {
    button.titleLabel.textColor=[UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0];
    
}
+(void)unhighlight:(UIButton *)button {
    button.titleLabel.textColor=[UIColor colorWithRed:0.462 green:0.364 blue:0.227 alpha:1.0];
}


-(UIView *) makeDifficultyButtons{
    
    float btnWidth=[UIImage imageNamed:@"level_01.png"].size.width;
    float btnHeight=[UIImage imageNamed:@"level_01.png"].size.height;
    
    btnLevel1=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLevel1 setBackgroundImage:[UIImage imageNamed:@"level_01.png"] forState:UIControlStateNormal];
    [btnLevel1 setBackgroundImage:[UIImage imageNamed:@"level_01_selected.png"] forState:UIControlStateHighlighted];
    [btnLevel1 setBackgroundImage:[UIImage imageNamed:@"level_01_selected.png"] forState:UIControlStateSelected];
    [btnLevel1 setBackgroundImage:[UIImage imageNamed:@"level_01_selected.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [btnLevel1 addTarget:self action:@selector(selectDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    [btnLevel1 setFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    [btnLevel1 setTag:1];
    
    btnLevel2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLevel2 setBackgroundImage:[UIImage imageNamed:@"level_02.png"] forState:UIControlStateNormal];
    [btnLevel2 setBackgroundImage:[UIImage imageNamed:@"level_02_selected.png"] forState:UIControlStateHighlighted];
    [btnLevel2 setBackgroundImage:[UIImage imageNamed:@"level_02_selected.png"] forState:UIControlStateSelected];
    [btnLevel2 setBackgroundImage:[UIImage imageNamed:@"level_02_selected.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [btnLevel2 addTarget:self action:@selector(selectDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    [btnLevel2 setFrame:CGRectMake(btnWidth, 0, btnWidth, btnHeight)];
    [btnLevel2 setTag:2];
    
    btnLevel3=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLevel3 setBackgroundImage:[UIImage imageNamed:@"level_03.png"] forState:UIControlStateNormal];
    [btnLevel3 setBackgroundImage:[UIImage imageNamed:@"level_03_selected.png"] forState:UIControlStateHighlighted];
    [btnLevel3 setBackgroundImage:[UIImage imageNamed:@"level_03_selected.png"] forState:UIControlStateSelected];
    [btnLevel3 setBackgroundImage:[UIImage imageNamed:@"level_03_selected.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [btnLevel3 addTarget:self action:@selector(selectDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    [btnLevel3 setFrame:CGRectMake(btnWidth*2, 0, btnWidth, btnHeight)];
    [btnLevel3 setTag:3];
    
    [self selectDifficulty:btnLevel1];
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth*3, btnHeight)];
    [view addSubview:btnLevel1];
    [view addSubview:btnLevel2];
    [view addSubview:btnLevel3];
    
    return view;
    
}

-(void) selectDifficulty:(UIButton *)button{
    switch (button.tag) {
        case 1:
            btnLevel1.selected=YES;
            btnLevel2.selected=NO;
            btnLevel3.selected=NO;
            difficulty=1;

            break;
        case 2:
            btnLevel1.selected=NO;
            btnLevel2.selected=YES;
            btnLevel3.selected=NO;
            difficulty=2;
            break;
        case 3:
            btnLevel1.selected=NO;
            btnLevel2.selected=NO;
            btnLevel3.selected=YES;
            difficulty=3;
            break;
            
            
        default:
            break;
    }
    
    NSLog(@"DİFF: %d",difficulty);
}
- (IBAction)startNewGame:(id)sender {
    [self performSegueWithIdentifier:@"GameStartSegue" sender:self];
}

-(void)openStats{
    [self performSegueWithIdentifier:@"StatsSegue" sender:self];
}

-(void)openSettings{
    [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
}

- (void) showGameCenter
{
    if(!self.reachability)
        self.reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [self.reachability currentReachabilityStatus];
    
    if(netStatus == NotReachable){
        UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:@""
                                                                message:NSLocalizedString(@"CONNECTION_ERROR", nil)
                                                                delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                otherButtonTitles:nil,nil];
        [noConnection show];
    }
    else{
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil){
            gameCenterController.gameCenterDelegate = self;
            [self presentViewController:gameCenterController animated:YES completion:nil];
        }
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameStartSegue"]) {
        //
        EQGameViewController *eqGameViewController = [segue destinationViewController];
        [eqGameViewController setCurrentQuestion:[EQQuestion getNextQuestionWithDifficulty:difficulty]];
        [eqGameViewController setDifficulty:difficulty];
    }
    else if ([segue.identifier isEqualToString:@"StatsSegue"]) {
        EQStatsViewController *eqStatsViewController = [segue destinationViewController];
        [eqStatsViewController setDifficulty:difficulty];
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
