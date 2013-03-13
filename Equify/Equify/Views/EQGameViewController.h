//
//  EQGameViewController.h
//  Equify
//
//  Created by Alperen Kavun on 12.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EQQuestion.h"
#import "EQBox.h"

@interface EQGameViewController : UIViewController

@property (nonatomic) EQQuestion * currentQuestion;
@property (weak, nonatomic) IBOutlet UILabel *stopWatchLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnControl;

@property (weak, nonatomic) IBOutlet UIView *QuestionView;

@end
