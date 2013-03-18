//
//  EQSettingsViewController.m
//  Equify
//
//  Created by Abdullah Karacabey on 15.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQSettingsViewController.h"

@interface EQSettingsViewController ()

@end

@implementation EQSettingsViewController

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

    UIView *seperator1 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2-55, 175, 3.0)];
    [seperator1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"double_line.png"]]];

    UIButton * btnReset=[self makeButton:CGRectMake((winWidth-175)/2, (winHeight-40)/2-50, 175, 40) title:@"reset stats"];
    
    UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2-5, 175, 3.0)];
    [seperator2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"double_line.png"]]];

    UIButton * btnAbout=[self makeButton:CGRectMake((winWidth-175)/2, (winHeight-40)/2, 175, 40) title:@"about us"];

    UIView *seperator3 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2+45, 175, 3.0)];
    [seperator3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"double_line.png"]]];

    UIButton * btnMoreGames=[self makeButton:CGRectMake((winWidth-175)/2, (winHeight-40)/2+50, 175, 40) title:@"more games"];
    
    UIView *seperator4 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2+95, 175, 3.0)];
    [seperator4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"double_line.png"]]];

    
    [self.view addSubview:seperator1];
    [self.view addSubview:btnReset];
    [self.view addSubview:seperator2];
    [self.view addSubview:btnAbout];
    [self.view addSubview:seperator3];
    [self.view addSubview:btnMoreGames];
    [self.view addSubview:seperator4];
    
    
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
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;

    btn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Light" size:25.0];
    btn.titleLabel.numberOfLines=2;
    
    [btn setTitleColor:[UIColor colorWithRed:0.462 green:0.364 blue:0.227 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateNormal];

    btn.titleLabel.backgroundColor=[UIColor clearColor];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    return btn;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
