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

@implementation EQGameViewController{
    int boxSize;
    int boxSpace;
    int leftAndRightViewSpace;
    
    UIView * questionViewLeftSide;
    UIView * questionViewRightSide;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"game screen");
    [self configureViews];
}
*/
-(void) viewWillAppear:(BOOL)animated{
    [self configureViews];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setCurrentQuestion:(EQQuestion *)currentQuestion{
    _currentQuestion=currentQuestion;
    [_currentQuestion createQuestionArray];
//    [self configureViews];
}

-(void) configureViews{
    boxSize=48;
    boxSpace=10;
    leftAndRightViewSpace=50;
    
    questionViewLeftSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, boxSize)];
    questionViewLeftSide.backgroundColor=[UIColor greenColor];
    
    questionViewRightSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, boxSize)];
    questionViewRightSide.backgroundColor=[UIColor yellowColor];

    [_QuestionView addSubview:questionViewLeftSide];
    [_QuestionView addSubview:questionViewRightSide];

    [self placingBoxes];
//    NSLog(@"Question %i", [_currentQuestion questionId]);
}

-(void)placingBoxes{
       NSLog(@"Placing %@",_currentQuestion.wholeQuestion);
    [EQBox cleanInstances];
    int leftSideCount=0;
    BOOL isRightSide=NO;


    for (int i=0; i<_currentQuestion.questionArray.count; i++) {
        
        
        if([[_currentQuestion.questionArray objectAtIndex:i] isEqual:@"="]){
            isRightSide=YES;
            leftSideCount=i;
            NSLog(@"View: %f, subview %i",_QuestionView.frame.size.width,(boxSize+boxSpace)*i);
            questionViewLeftSide.frame=CGRectMake(((self.view.frame.size.width-(boxSize+boxSpace)*i)+boxSpace)/2, 0, (boxSize+boxSpace)*i-boxSpace, boxSize);
            
            continue;
        }
        if (!isRightSide) {
            EQBox * box=[EQBox BoxWithFrame:CGRectMake((boxSize+boxSpace)*i, 0, boxSize, boxSize) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
            box.caller=self;
            [questionViewLeftSide addSubview:box.boxButton];
        }
        else if(isRightSide){
            NSLog(@"LeftSideCount:  %i",leftSideCount);
            EQBox * box=[EQBox BoxWithFrame:CGRectMake((boxSize+boxSpace)*(i-leftSideCount-1), 0, boxSize, boxSize) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
            box.caller=self;
            [questionViewRightSide addSubview:box.boxButton];
            
            if(_currentQuestion.questionArray.count-1==i){
                questionViewRightSide.frame=CGRectMake(((self.view.frame.size.width-(boxSize+boxSpace)*(i-leftSideCount)+boxSpace))/2, questionViewLeftSide.frame.size.height+leftAndRightViewSpace, (boxSize+boxSpace)*(i-leftSideCount)-boxSpace, boxSize);
            }
        }
        
    }
}

-(void)animateBox:(UIButton *)button {
    NSLog(@"entered deletebox");
    EQBox* box = [EQBox boxByOrder:button.tag];
    NSLog(@"%@",box);
    
    if(!box.isDeleted){
        [box deleteBox];    
    }
    else
        [box resetBox];
    
}

- (void)viewDidUnload {
    [self setStopWatchLabel:nil];
    [self setBtnControl:nil];
    [self setQuestionView:nil];
    [super viewDidUnload];
}
@end
