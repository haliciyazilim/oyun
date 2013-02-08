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
@property int scrollViewWitdh;
@property DTBQuestion *question;

@end

@implementation DTBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setUserInteractionEnabled:NO];
//    [self.scrollView setUserInteractionEnabled:NO];
    
    [self.stopWatchLabel setText:@"00:00"];
    self.stopWatch = [[StopWatch alloc] init];
    
    [self.stopWatchLabelMS setText:@".0"];
    
    
    [self.btnControl addTarget:self action:@selector(control) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnControl setEnabled:NO];
    [self.view setClipsToBounds:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self configureViews];
}
- (void) setCurrentQuestion:(DTBQuestion *)currentQuestion {
    _currentQuestion = currentQuestion;
    [_currentQuestion createQuestionArray];
    
    [self configureViews];
}
- (void) configureViews {
        
    NSLog(@" Soru %@",[self.currentQuestion questionArray]);
    _scrollViewWitdh=self.currentQuestion.questionArray.count*65+30;
    NSLog(@"ScrolWitdh: %d",_scrollViewWitdh);
    [self.scrollView setContentSize:CGSizeMake(_scrollViewWitdh, 48)];
    
    [self placingBoxes];

}
-(void) viewDidAppear:(BOOL)animated{
    // ScrollView animated
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.scrollView setContentOffset:CGPointMake(_scrollViewWitdh/2.5, 0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            NSLog(@"scrollView animate Completion");
            [self.view setUserInteractionEnabled:YES];
            [self.btnControl setEnabled:YES];
            
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
    [self setBtnControl:nil];
    [self setBtnWarning:nil];
    [self setStopWatchLabelMS:nil];
    [super viewDidUnload];
}

//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
////    [self dismissModalViewControllerAnimated:YES];
//}

-(void)placingBoxes{
//    NSLog(@"Placing %d",_currentQuestion.questionArray.count);
    [DTBBox cleanInstances];
    for (int i=0; i<_currentQuestion.questionArray.count; i++) {
        

        DTBBox * box=[DTBBox BoxWithFrame:CGRectMake(58*i+30, _scrollView.frame.size.height/2, 48, 48) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
        box.caller=self;
        
        NSLog(@"PLacing %@",box);
        [_scrollView addSubview:box.boxButton];
    }
}
-(void)animateBox:(UIButton *)button {
    NSLog(@"entered deletebox");
    DTBBox* box = [DTBBox boxByOrder:button.tag];
    NSLog(@"%@",box);
    
    if(!box.isDeleted){
        [box deleteBox:self.scrollView];
                
//        [box drawLineToOriginalPosition:self.view];

    }
    else
        [box resetBox];

}



-(void)control{
    NSMutableString * answer=[[NSMutableString alloc] initWithString:@""];
    for (int i=0; i<self.currentQuestion.questionArray.count; i++) {
        DTBBox * box=[DTBBox boxByOrder:i];
        
        if(!box.isDeleted)
            [answer appendString:box.title];
    }
    
    if([self.currentQuestion isCorrect:answer]){
        [_btnWarning setText:@"Doğru"];
        [self.stopWatch stopTimer];
        [self.currentQuestion updateScore:[self.stopWatch getElapsedMiliseconds]];
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
                
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
