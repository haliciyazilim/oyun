//
//  DTBMapSelectionController.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 05.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DTBMapSelectionController.h"
#import "DTBQuestion.h"
#import "DTBAppSpecificValues.h"
#import "DTBViewController.h"
#import "StopWatch.h"

@interface DTBMapSelectionController ()

@end

@implementation DTBMapSelectionController
{
    UIButton *selectedButton;
    NSArray *wholeQuestionsArray;
}

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
}
- (void)viewWillAppear:(BOOL)animated {
    if (selectedButton) {
        [self unhighlight:selectedButton];
        selectedButton = nil;
    }
    [self updateScrollView];
}
- (void) cleanScrollView {
    for (UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
}
- (void) updateScrollView {
    [self cleanScrollView];
    
    wholeQuestionsArray = [DTBQuestion getAllQuestions];
    
    int questionCount = [wholeQuestionsArray count];
    
    [self.scrollView setContentSize:CGSizeMake((questionCount*0.5+1)*(93), 160.0)];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    CGFloat xOffset, yOffset;
    for (int i = 0; i < questionCount; i++) {
        DTBQuestion *currentProccessingQuestion = [wholeQuestionsArray objectAtIndex:i];
        UIButton *question = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i % 2 == 0){
            xOffset = 25.0 + i/2*93;
            yOffset = 5.0;
        }
        else{
            xOffset = 72.0 + i/2*93;
            yOffset = 85.0;
        }
        question.frame = CGRectMake(xOffset, yOffset, 70.0, 70.0);
        question.layer.cornerRadius = 35.0;
        question.layer.borderWidth = 1.0;
        question.layer.shadowRadius = 0.0;
        question.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        question.layer.shadowOpacity = 1.0;
        [question.layer setShadowPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-5, -5, 80.0, 80.0)] CGPath]];
        
        
        UILabel *buttonLabel;
        UILabel *timerLabel;
        
        if (![currentProccessingQuestion isPurchased]) {
            question.layer.shadowColor = [[UIColor colorWithWhite:0.0 alpha:0.10] CGColor];
            question.layer.borderColor = [[UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1.0] CGColor];
            [question setBackgroundColor:[UIColor colorWithRed:0.773 green:0.773 blue:0.773 alpha:1.0]];
            buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
            [buttonLabel setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]];
            [question addTarget:self action:@selector(buyPro) forControlEvents:UIControlEventTouchUpInside];

        }
        else{
            question.layer.shadowColor = [[UIColor colorWithWhite:1.0 alpha:0.35] CGColor];
            question.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.741 blue:0.659 alpha:1.0] CGColor];
            [question setBackgroundColor:[UIColor colorWithRed:0.894 green:0.855 blue:0.8 alpha:1.0]];
            
            if ([currentProccessingQuestion score] < INT32_MAX) {
                // bitirildi, score var
                buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 46.0)];
                timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(1.0, 40.0, 68.0, 30.0)];
                [timerLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"played_btn_bg.png"]]];
                [timerLabel setText:[StopWatch textWithMiliseconds:[currentProccessingQuestion score]]];
                [timerLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                [timerLabel setTextColor:[UIColor colorWithRed:0.463 green:0.365 blue:0.227 alpha:1.0]];
                [timerLabel setTextAlignment:NSTextAlignmentCenter];
            }
            else{
                // bitirilmedi, score yok
                buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
            }
            [buttonLabel setTextColor:[UIColor colorWithRed:0.463 green:0.365 blue:0.227 alpha:1.0]];
            [question addTarget:self action:@selector(makeHighlighted:) forControlEvents:UIControlEventTouchDown];
            [question addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpOutside];
            [question addTarget:self action:@selector(openQuestion:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [buttonLabel setFont:[UIFont fontWithName:@"Helvetica" size:24.0]];
        [buttonLabel setText:[NSString stringWithFormat:@"%d",[currentProccessingQuestion questionOrder]]];
        [buttonLabel setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
        [buttonLabel setShadowOffset:CGSizeMake(0.0, 2.0)];
        [buttonLabel setBackgroundColor:[UIColor clearColor]];
        [buttonLabel setTextAlignment:NSTextAlignmentCenter];
        
        question.tag = i;
        
        [question addSubview:buttonLabel];
        [question addSubview:timerLabel];

        [self.scrollView addSubview:question];
    }
}
- (void) buyPro {
    NSLog(@"********buyPro here ************");
}
- (void) makeUnhighlighted:(UIButton *)button {
    [self unhighlight:button];
}
- (void) makeHighlighted:(UIButton *)button {
    [self highlight:button];
}
-(void)highlight:(UIButton *)button {
    button.layer.shadowColor = [[UIColor colorWithRed:0.463 green:0.365 blue:0.227 alpha:0.4] CGColor];
    [button setBackgroundColor:[UIColor colorWithRed:0.8 green:0.741 blue:0.659 alpha:1.0]];
}
-(void)unhighlight:(UIButton *)button {
    button.layer.shadowColor = [[UIColor colorWithWhite:1.0 alpha:0.35] CGColor];
    [button setBackgroundColor:[UIColor colorWithRed:0.894 green:0.855 blue:0.8 alpha:1.0]];
}
- (void) openQuestion:(UIButton *)button {
    selectedButton = button;
    [self highlight:selectedButton];
    [self performSegueWithIdentifier:@"openQuestion" sender:self];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"openQuestion"]) {
        DTBViewController *destination = [segue destinationViewController];
        [destination setCurrentQuestion:[wholeQuestionsArray objectAtIndex:[selectedButton tag]]];
    }
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
