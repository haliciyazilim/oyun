//
//  EQStatsViewController.m
//  Equify
//
//  Created by Alperen Kavun on 14.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQStatsViewController.h"
#import "StopWatch.h"

@interface EQStatsViewController ()

@end

@implementation EQStatsViewController{
    UILabel *bestTime;
    UILabel *worstTime;
    UILabel *totalSolved;
    UILabel *totalSkipped;
    UILabel *average;
    UILabel *allTimeAverage;
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
	// Do any additional setup after loading the view.
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.png"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    }
    CGSize mainViewSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width-50.0, [[UIScreen mainScreen] bounds].size.height-50.0);
    UIView *statsMainView = [[UIView alloc] initWithFrame:CGRectMake(25.0, 25.0, mainViewSize.height, mainViewSize.width)];
    [statsMainView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, mainViewSize.height-10.0, 45.0)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-Th" size:34.0]];
    [headerLabel setTextColor:[UIColor colorWithRed:0.463 green:0.365 blue:0.227 alpha:1.0]];
    [headerLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [headerLabel setShadowColor:[UIColor whiteColor]];
    [headerLabel setText:NSLocalizedString(@"STATS", nil)];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn_pressed.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeStats) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(mainViewSize.height-40.0, 0.0, 35.0, 35.0);
    
    UILabel *bestTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 40.0, 300.0, 40.0)];
    [bestTimeLabel setBackgroundColor:[UIColor clearColor]];
    [bestTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [bestTimeLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [bestTimeLabel setText:NSLocalizedString(@"BEST_TIME", nil)];
    
    UIView *seperator1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 80.0, mainViewSize.height, 2.0)];
    [seperator1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    
    UILabel *worstTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0, 300.0, 40.0)];
    [worstTimeLabel setBackgroundColor:[UIColor clearColor]];
    [worstTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [worstTimeLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [worstTimeLabel setText:NSLocalizedString(@"WORST_TIME", nil)];
    
    UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 120.0, mainViewSize.height, 2.0)];
    [seperator2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    UILabel *totalSolvedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 120.0, 300.0, 40.0)];
    [totalSolvedLabel setBackgroundColor:[UIColor clearColor]];
    [totalSolvedLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [totalSolvedLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [totalSolvedLabel setText:NSLocalizedString(@"TOTAL_SOLVED_COUNT", nil)];
    
    UIView *seperator3 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 160.0, mainViewSize.height, 2.0)];
    [seperator3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    
    UILabel *totalSkippedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 160.0, 300.0, 40.0)];
    [totalSkippedLabel setBackgroundColor:[UIColor clearColor]];
    [totalSkippedLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [totalSkippedLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [totalSkippedLabel setText:NSLocalizedString(@"TOTAL_SKIP_COUNT", nil)];
    
    UIView *seperator4 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 200.0, mainViewSize.height, 2.0)];
    [seperator4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    
    UILabel *averageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 200.0, 300.0, 40.0)];
    [averageLabel setBackgroundColor:[UIColor clearColor]];
    [averageLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [averageLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [averageLabel setText:NSLocalizedString(@"AVERAGE", nil)];
    
    UIView *seperator5 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 240.0, mainViewSize.height, 2.0)];
    [seperator5 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    
    UILabel *allTimeAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 240.0, 300.0, 40.0)];
    [allTimeAverageLabel setBackgroundColor:[UIColor clearColor]];
    [allTimeAverageLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [allTimeAverageLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [allTimeAverageLabel setText:NSLocalizedString(@"ALLTIME_AVERAGE", nil)];
    
    bestTime = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, 40.0, 140.0, 40.0)];
    [bestTime setBackgroundColor:[UIColor clearColor]];
    [bestTime setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [bestTime setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [bestTime setTextAlignment:NSTextAlignmentRight];
    
    worstTime = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, 80.0, 140.0, 40.0)];
    [worstTime setBackgroundColor:[UIColor clearColor]];
    [worstTime setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [worstTime setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [worstTime setTextAlignment:NSTextAlignmentRight];
    
    totalSolved = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, 120.0, 140.0, 40.0)];
    [totalSolved setBackgroundColor:[UIColor clearColor]];
    [totalSolved setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [totalSolved setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [totalSolved setTextAlignment:NSTextAlignmentRight];
    
    totalSkipped = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, 160.0, 140.0, 40.0)];
    [totalSkipped setBackgroundColor:[UIColor clearColor]];
    [totalSkipped setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [totalSkipped setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [totalSkipped setTextAlignment:NSTextAlignmentRight];
    
    average = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, 200.0, 140.0, 40.0)];
    [average setBackgroundColor:[UIColor clearColor]];
    [average setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [average setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [average setTextAlignment:NSTextAlignmentRight];
    
    allTimeAverage = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, 240.0, 140.0, 40.0)];
    [allTimeAverage setBackgroundColor:[UIColor clearColor]];
    [allTimeAverage setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-MD" size:30.0]];
    [allTimeAverage setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [allTimeAverage setTextAlignment:NSTextAlignmentRight];
    
    [statsMainView addSubview:headerLabel];
    [statsMainView addSubview:closeButton];
    [statsMainView addSubview:bestTimeLabel];
    [statsMainView addSubview:seperator1];
    [statsMainView addSubview:worstTimeLabel];
    [statsMainView addSubview:seperator2];
    [statsMainView addSubview:totalSolvedLabel];
    [statsMainView addSubview:seperator3];
    [statsMainView addSubview:totalSkippedLabel];
    [statsMainView addSubview:seperator4];
    [statsMainView addSubview:averageLabel];
    [statsMainView addSubview:seperator5];
    [statsMainView addSubview:allTimeAverageLabel];
    [statsMainView addSubview:bestTime];
    [statsMainView addSubview:worstTime];
    [statsMainView addSubview:totalSolved];
    [statsMainView addSubview:totalSkipped];
    [statsMainView addSubview:average];
    [statsMainView addSubview:allTimeAverage];
    
    [self.view addSubview:statsMainView];
    
    [self configureViews];
}
- (void) closeStats {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCurrentStatistics:(EQStatistic *)currentStatistics {
    _currentStatistics = currentStatistics;
    [self configureViews];
}

- (void) configureViews {
    if (self.currentStatistics.minTime == INT32_MAX) {
        [bestTime setText:@"-"];
    } else {
        [bestTime setText:[StopWatch textWithMiliseconds:self.currentStatistics.minTime]];
    }
    if (self.currentStatistics.maxTime == INT32_MIN) {
        [worstTime setText:@"-"];
    } else {
        [worstTime setText:[StopWatch textWithMiliseconds:self.currentStatistics.maxTime]];
    }
    [totalSolved setText:[NSString stringWithFormat:@"%d",self.currentStatistics.totalSolvedQuestion]];
    [totalSkipped setText:[NSString stringWithFormat:@"%d",self.currentStatistics.totalSkippedQuestion]];
    if (self.currentStatistics.allTimeAverage == 0) {
        [average setText:@"-"];
        [allTimeAverage setText:@"-"];
    } else {
        [average setText:[StopWatch textWithMiliseconds:self.currentStatistics.allTimeAverage]];
        [allTimeAverage setText:[StopWatch textWithMiliseconds:self.currentStatistics.allTimeAverage]];
    }

}
@end
