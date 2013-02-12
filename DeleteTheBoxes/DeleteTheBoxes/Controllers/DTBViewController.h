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
#import <GameKit/GameKit.h>

@class DTBQuestion;

@interface DTBViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *stopWatchLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopWatchLabelMS;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property GKTurnBasedMatch *currentMatch;

@property StopWatch * stopWatch;

@property (nonatomic) DTBQuestion *currentQuestion;
@property int wholeQuestionCount;

@end
