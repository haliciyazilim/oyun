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
    
    firstView = [[EQFirstView alloc] initWithFrame:CGRectMake(0.0, 0.0, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    [firstView setBackgroundColor:[UIColor whiteColor]];
    
    secondView = [[EQSecondView alloc] initWithFrame:CGRectMake(0.0, SINGLE_VIEW_HEIGHT, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    [secondView setBackgroundColor:[UIColor redColor]];
    
    thirdView = [[EQThirdView alloc] initWithFrame:CGRectMake(SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    [thirdView setBackgroundColor:[UIColor blueColor]];
    
    fourthView = [[EQFourthView alloc] initWithFrame:CGRectMake(SINGLE_VIEW_WIDTH, 0.0, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    [fourthView setBackgroundColor:[UIColor yellowColor]];
    
    [mainView addSubview:firstView];
    [mainView addSubview:secondView];
    [mainView addSubview:thirdView];
    [mainView addSubview:fourthView];
    [self.view addSubview:mainView];
    
    [self animateMainView];
    
}
- (void) animateMainView {
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainView setFrame:CGRectMake(0.0, -SINGLE_VIEW_HEIGHT, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [mainView setFrame:CGRectMake(-SINGLE_VIEW_WIDTH, -SINGLE_VIEW_HEIGHT, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [mainView setFrame:CGRectMake(-SINGLE_VIEW_WIDTH, 0.0, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [mainView setFrame:CGRectMake(0.0, 0.0, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
                } completion:^(BOOL finished) {
                    [self animateMainView];
                }];
            }];
        }];
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
}
- (void) openSecondView {
    // set frame of the main view for SecondView
    // delete any other views, clean properly
    // alloc and init firstView, then add to main view as a subview
}
- (void) openThirdView {
    // set frame of the main view for thirdView
    // delete any other views, clean properly
    // alloc and init firstView, then add to main view as a subview
}
- (void) openFourthView {
    // set frame of the main view for fourthView
    // delete any other views, clean properly
    // alloc and init firstView, then add to main view as a subview
}
@end
