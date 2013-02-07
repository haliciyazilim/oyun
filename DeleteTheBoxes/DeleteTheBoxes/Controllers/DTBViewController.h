//
//  DTBViewController.h
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 04.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StopWatch.h"

@class DTBQuestion;

@interface DTBViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *stopWatchLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnControl;

@property StopWatch * stopWatch;

@property (nonatomic) DTBQuestion *currentQuestion;

-(void)placingBoxes: (DTBQuestion *) question;
@end
