//
//  DTBViewController.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 04.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "DTBViewController.h"
#import "DTBQuestion.h"
#import "DTBBox.h"

@interface DTBViewController ()

@end

@implementation DTBViewController
{
    int scrollViewWidth;
    UIButton *controlButton;
    NSMutableArray *counterImages;
    int moveCount;
    int deleteCount;
}
- (id)init{
    if (self= [super init]) {
        self.wholeQuestionCount = 0;
    }
    return self;
}
- (void)viewDidLoad
{
    NSLog(@"didLoad");
    [super viewDidLoad];
    
    CGFloat winWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat winHeight = [[UIScreen mainScreen] bounds].size.height;
    NSLog(@"%f,%f",winWidth,winHeight);

    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.png"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    }
    
    [self.view setUserInteractionEnabled:NO];
//    [self.scrollView setUserInteractionEnabled:NO];
    
    [self.stopWatchLabel setText:@"00:00"];
    [self.stopWatchLabel setTextColor:[UIColor colorWithRed:0.403 green:0.403 blue:0.403 alpha:1.0]];
    
    [self.stopWatchLabelMS setText:@".0"];
    [self.stopWatchLabelMS setTextColor:[UIColor colorWithRed:0.403 green:0.403 blue:0.403 alpha:1.0]];
    
    self.stopWatch = [[StopWatch alloc] init];
    
    controlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    controlButton.frame = CGRectMake(winHeight*0.5-34.0, winWidth-69.0-24.0, 69.0, 69.0);
    controlButton.layer.cornerRadius = 35.0;
    controlButton.layer.borderWidth = 1.0;
    controlButton.layer.shadowRadius = 2.0;
    controlButton.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    controlButton.layer.shadowOpacity = 0.3;
    [controlButton.layer setShadowPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 2, 69.0, 69.0)] CGPath]];
    controlButton.layer.borderColor = [[UIColor colorWithRed:0.596 green:0.596 blue:0.596 alpha:1.0] CGColor];
    [controlButton setBackgroundColor:[UIColor colorWithRed:0.827 green:0.827 blue:0.827 alpha:1.0]];
    
    UIImageView *controlInnerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"control_bg.png"]];
    
    UILabel *controlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 69.0, 69.0)];
    [controlLabel setText:@"bitir"];
    [controlLabel setTextAlignment:NSTextAlignmentCenter];
    [controlLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    [controlLabel setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
    [controlLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [controlLabel setTextColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0]];
    [controlLabel setBackgroundColor:[UIColor clearColor]];
    
    [controlButton addTarget:self action:@selector(control) forControlEvents:UIControlEventTouchUpInside];
//    [controlButton addTarget:self action:@selector(makeHighlighted:) forControlEvents:UIControlEventTouchDown];
//    [controlButton addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpOutside];
    
    [controlButton addSubview:controlInnerShadow];
    [controlButton addSubview:controlLabel];
    [self.view addSubview:controlButton];
    
    [controlButton setEnabled:NO];
    
    [self.orderLabel setText:[NSString stringWithFormat:@"%d/%d",self.currentQuestion.questionOrder,self.wholeQuestionCount]];
    
    [self.view setClipsToBounds:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self configureViews];
    
    [self.orderLabel setText:[NSString stringWithFormat:@"%d/%d",self.currentQuestion.questionOrder,self.wholeQuestionCount]];
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
- (void) setCurrentQuestion:(DTBQuestion *)currentQuestion {
    _currentQuestion = currentQuestion;
    [_currentQuestion createQuestionArray];
    NSLog(@"question set");
    [self configureViews];
}
- (void) configureViews {
    scrollViewWidth=self.currentQuestion.questionArray.count*65+30;
    [self.scrollView setContentSize:CGSizeMake(scrollViewWidth, 48)];
//    [self.orderLabel setText:[NSString stringWithFormat:@"%d/%d",self.currentQuestion.questionOrder,self.wholeQuestionCount]];
    NSLog(@"%d",self.wholeQuestionCount);
    [self placingBoxes];
    
    deleteCount = 0;
    moveCount = [[self.currentQuestion wholeQuestion] length] - [[self.currentQuestion answer] length];
    
    if (!counterImages) {
        counterImages = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < moveCount; i++) {
            UIImageView *count = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete_counter.png"]];
            count.frame = CGRectMake(25.0+6.0*i, 280.0, 6.0, 18.0);
            [counterImages addObject:count];
            [self.view addSubview:count];
        }
    }

}
-(void) viewDidAppear:(BOOL)animated{
    // ScrollView animated
    [self.orderLabel setText:[NSString stringWithFormat:@"%d/%d",self.currentQuestion.questionOrder,self.wholeQuestionCount]];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.scrollView setContentOffset:CGPointMake(scrollViewWidth/2.5, 0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            NSLog(@"scrollView animate Completion");
            [self.view setUserInteractionEnabled:YES];
            [controlButton setEnabled:YES];
            
            [self.stopWatch startTimerWithRepeatBlock:^{
                [self.stopWatchLabel setText:[self.stopWatch toStringWithoutMiliseconds]];
                [self.stopWatchLabelMS setText:[self.stopWatch toStringMiliseconds]];
            }];
        }];
    }];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setStopWatchLabel:nil];
    controlButton = nil;
    [self setStopWatchLabelMS:nil];
    [self setOrderLabel:nil];
    [super viewDidUnload];
}

-(void)placingBoxes{
//    NSLog(@"Placing %d",_currentQuestion.questionArray.count);
    [DTBBox cleanInstances];
    for (int i=0; i<_currentQuestion.questionArray.count; i++) {
        

        DTBBox * box=[DTBBox BoxWithFrame:CGRectMake(58*i+30, _scrollView.frame.size.height/2-24, 48, 48) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
        box.caller=self;
        
        [_scrollView addSubview:box.boxButton];
    }
}
-(void)animateBox:(UIButton *)button {
    DTBBox* box = [DTBBox boxByOrder:button.tag];
    
    if(!box.isDeleted){
        if (deleteCount != moveCount) {
            [box deleteBox:self.scrollView];
            [[counterImages objectAtIndex:[counterImages count]-1-deleteCount] setAlpha:0.0];
            deleteCount++;
        }
    }
    else{
        [box resetBox];
        [[counterImages objectAtIndex:[counterImages count]-deleteCount] setAlpha:1.0];
        deleteCount--;
    }

}

-(void)control{
//    [self unhighlight:controlButton];
    NSMutableString * answer=[[NSMutableString alloc] initWithString:@""];
    for (int i=0; i<self.currentQuestion.questionArray.count; i++) {
        DTBBox * box=[DTBBox boxByOrder:i];
        
        if(!box.isDeleted)
            [answer appendString:box.title];
    }
    
    if([self.currentQuestion isCorrect:answer]){
        [self.stopWatch stopTimer];
        [self.currentQuestion updateScore:[self.stopWatch getElapsedMiliseconds]];
        // game win
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        // game lose
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//            CGAffineTransform transform = CGAffineTransformMakeTranslation(-5, -5);
            self.view.transform = CGAffineTransformTranslate(self.view.transform, -25, 0);
//            self.view.transform = transform;
            
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                self.view.transform = CGAffineTransformTranslate(self.view.transform, 50, 0);
//                CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
//                self.view.transform = transform;
                
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                     self.view.transform = CGAffineTransformTranslate(self.view.transform, -50, 0);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                        self.view.transform = CGAffineTransformTranslate(self.view.transform, 25, 0);
                    } completion:^(BOOL finished) {
                        ;
                    }];
                }];
            }];
        }];

    }
}

- (void) drawRect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(120.0,0.0)];
    [path addLineToPoint:CGPointMake(120.0, 200.0)];
    
    
    
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.view.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor redColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCGLineJoinMiter;
    
    [self.view.layer addSublayer:pathLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}


@end
