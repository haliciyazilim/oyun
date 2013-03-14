//
//  EQStatsViewController.m
//  Equify
//
//  Created by Alperen Kavun on 14.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQStatsViewController.h"

@interface EQStatsViewController ()

@end

@implementation EQStatsViewController

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
    
}
@end
