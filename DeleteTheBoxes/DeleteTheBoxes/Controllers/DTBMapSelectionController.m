//
//  DTBMapSelectionController.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 05.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "DTBMapSelectionController.h"
#import <QuartzCore/QuartzCore.h>

@interface DTBMapSelectionController ()

@end

@implementation DTBMapSelectionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
    
    [self.scrollView setContentSize:CGSizeMake(1300.0, 160.0)];
//    [self.scrollView setBackgroundColor:[UIColor yellowColor]];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    CGFloat xOffset, yOffset;
    for (int i = 0; i < 20; i++) {
        UIButton *question = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i % 2 == 0){
            xOffset = 5.0 + i/2*93;
            yOffset = 5.0;
        }
        else{
            xOffset = 52.0 + i/2*93;
            yOffset = 85.0;
        }
        question.frame = CGRectMake(xOffset, yOffset, 70.0, 70.0);
        question.layer.cornerRadius = 35.0;
        question.layer.borderWidth = 1.0;
        question.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.741 blue:0.659 alpha:1.0] CGColor];
        question.layer.shadowColor = [[UIColor colorWithWhite:1.0 alpha:0.35] CGColor];
        question.layer.shadowRadius = 0.0;
//        question.layer.shadowColor = [[UIColor blackColor] CGColor];
        question.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        question.layer.shadowOpacity = 1.0;
//        [question.layer setMasksToBounds:NO];
//        [question.layer setShadowPath:[[UIBezierPath bezierPathWithRect:question.bounds] CGPath]];
//        [question.layer setShadowPath:[[UIBezierPath bezierPathWithOvalInRect:question.bounds] CGPath]];
//        [question.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(xOffset-5, yOffset-5, 80, 80) cornerRadius:35.0] CGPath]];
        [question.layer setShadowPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-5, -5, 80.0, 80.0)] CGPath]];
//        [question.layer setShouldRasterize:YES];
        [question setBackgroundColor:[UIColor colorWithRed:0.894 green:0.855 blue:0.8 alpha:1.0]];
        [question setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [question addTarget:self action:@selector(openQuestion) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:question];
    }
}
- (void) openQuestion {
    [self performSegueWithIdentifier:@"openQuestion" sender:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
