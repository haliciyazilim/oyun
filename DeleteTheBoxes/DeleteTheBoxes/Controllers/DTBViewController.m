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
	
    
    NSArray *wholeQuestions = [DTBQuestion getAllQuestions];
    self.question = [wholeQuestions objectAtIndex:0];
    [self.question createQuestionArray];
    
    NSLog(@"%@",[self.question questionArray]);
    _scrollViewWitdh=self.question.questionArray.count*65+30;
    [self.scrollView setContentSize:CGSizeMake(_scrollViewWitdh, 48)];
    self.scrollView.backgroundColor=[UIColor clearColor];
    
    [self placingBoxes:self.question];
    
    
    [self.view setUserInteractionEnabled:NO];
//    [self.scrollView setUserInteractionEnabled:NO];
    
    [self.stopWatchLabel setText:@"00:00.0"];
    self.stopWatch = [[StopWatch alloc] init];
    
    [self.btnControl addTarget:self action:@selector(control:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnControl setEnabled:NO];
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
            [self.btnControl setEnabled:NO];
            
            [self.stopWatch startTimerWithRepeatBlock:^{
                [self.stopWatchLabel setText:[self.stopWatch toString]];
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
    [super viewDidUnload];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self dismissModalViewControllerAnimated:YES];
}

-(void)placingBoxes: (DTBQuestion *) question{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSLog(@"SV h: %f",screenBounds.size.width);
    
    for (int i=0; i<[question questionArray].count; i++) {
        
        DTBBox * box=[DTBBox BoxWithFrame:CGRectMake(58*i+30, _scrollView.frame.size.height /2-24, 48, 48) andTitle:[question questionArray][i]];
        box.caller=self;
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
//    for (int i=0; i>; <#increment#>) {
//        <#statements#>
//    }
//    DTBBox *box=[DTBBox boxByOrder:<#(int)#>]
//    [self.question isCorrect:<#(NSString *)#>]
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
