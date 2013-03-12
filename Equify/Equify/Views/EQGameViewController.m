//
//  EQGameViewController.m
//  Equify
//
//  Created by Alperen Kavun on 12.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQGameViewController.h"

@interface EQGameViewController ()

@end

@implementation EQGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"game screen");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setCurrentQuestion:(EQQuestion *)currentQuestion{
    _currentQuestion=currentQuestion;
    [self configureViews];
}

-(void) configureViews{
    
}

-(void)placingBoxes{
    //    NSLog(@"Placing %d",_currentQuestion.questionArray.count);
    [EQBox cleanInstances];
    for (int i=0; i<_currentQuestion.questionArray.count; i++) {
        
        
        EQBox * box=[EQBox BoxWithFrame:CGRectMake(58*i+30, self.view.frame.size.height/2, 48, 48) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
        box.caller=self;
        
        NSLog(@"PLacing %@",box);
        [self.view addSubview:box.boxButton];
    }
}

- (void)viewDidUnload {
    [self setStopWatchLabel:nil];
    [self setBtnControl:nil];
    [self setQuestionView:nil];
    [self setQuestionViewLeftSide:nil];
    [self setQuestionViewRightSide:nil];
    [super viewDidUnload];
}
@end
