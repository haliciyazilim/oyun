//
//  EQViewController.m
//  Equify
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQViewController.h"
#import "EQFirstView.h"
#import "EQSecondView.h"
#import "EQThirdView.h"
#import "EQFourthView.h"
#import "EQAppSpecificViewSizes.h"

@interface EQViewController ()

@end

@implementation EQViewController
{
    // mainView sizes
//    CGFloat mainViewWidth;
//    CGFloat mainViewHeight;
//
//    // singleView sizes
//    CGFloat singleViewWidth;
//    CGFloat singleViewHeight;
    
    // neccessary UIViews
    UIView *mainView;
    
    UIView *firstView;
    UIView *secondView;
    UIView *thirdView;
    UIView *fourthView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, MAIN_VIEW_WIDTH, MAIN_VIEW_HEIGHT)];
    [mainView setBackgroundColor:[UIColor clearColor]];
    
    firstView = [EQFirstView CreateView];
    [firstView setBackgroundColor:[UIColor whiteColor]];
    
    [mainView addSubview:firstView];
    
    [self.view addSubview:mainView];
    
    [self openSecondView];
//    [self animateMainView];
    
}
- (void) animateMainView {
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainView setFrame:CGRectMake(0.0, -SINGLE_VIEW_HEIGHT, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Different views opening methods

- (void) openFirstView {
    // perform neccessary calculation, or get elements from database
    // set frame of the main view for firstView
    // delete any other views, clean properly
    // alloc and init firstView, then add to main view as a subview
    
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainView setFrame:CGRectMake(0.0, 0.0, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        
    }];
    
    
}
- (void) openSecondView {
    // set frame of the main view for SecondView
    // delete any other views, clean properly
    // alloc and init firstView, then add to main view as a subview
    
    secondView = [EQSecondView CreateView];
    [secondView setBackgroundColor:[UIColor redColor]];
    
    [mainView addSubview:secondView];
    
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainView setFrame:CGRectMake(0.0, -SINGLE_VIEW_HEIGHT, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        [self openThirdView];
    }];
    
}
- (void) openThirdView {
    // set frame of the main view for thirdView
    // delete any other views, clean properly
    // alloc and init firstView, then add to main view as a subview
    thirdView = [EQThirdView CreateView];
    [thirdView setBackgroundColor:[UIColor blueColor]];

    [mainView addSubview:thirdView];
    
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainView setFrame:CGRectMake(-SINGLE_VIEW_WIDTH, -SINGLE_VIEW_HEIGHT, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        [self openFourthView];
    }];
    
}
- (void) openFourthView {
    // set frame of the main view for fourthView
    // delete any other views, clean properly
    // alloc and init firstView, then add to main view as a subview
    
    fourthView = [EQFourthView CreateView];
    [fourthView setBackgroundColor:[UIColor yellowColor]];
    
    [mainView addSubview:fourthView];
    
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainView setFrame:CGRectMake(-SINGLE_VIEW_WIDTH, 0.0, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        [self openFirstView];
    }];
}
@end
