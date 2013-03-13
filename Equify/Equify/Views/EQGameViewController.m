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

- (void)viewDidLoad
{
    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.png"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    }
    
    
    [self.stopWatchLabel setText:@"00:00"];
    [self.stopWatchLabel setTextColor:[UIColor colorWithRed:0.403 green:0.403 blue:0.403 alpha:1.0]];
    
    [self.stopWatchLabelMS setText:@".0"];
    [self.stopWatchLabelMS setTextColor:[UIColor colorWithRed:0.403 green:0.403 blue:0.403 alpha:1.0]];
    
    self.stopWatch = [[StopWatch alloc] init];
    
    [self.btnControl addTarget:self action:@selector(control) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSkip addTarget:self action:@selector(skipQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view setClipsToBounds:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [self configureViews];
    [self.stopWatch startTimerWithRepeatBlock:^{
        [self.stopWatchLabel setText:[self.stopWatch toStringWithoutMiliseconds]];
        [self.stopWatchLabelMS setText:[self.stopWatch toStringMiliseconds]];
    }];
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
    if(questionViewLeftSide==nil){
        questionViewLeftSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, boxSize)];
        questionViewLeftSide.backgroundColor=[UIColor greenColor];
    
        questionViewRightSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, boxSize)];
        questionViewRightSide.backgroundColor=[UIColor yellowColor];

        [_QuestionView addSubview:questionViewLeftSide];
        [_QuestionView addSubview:questionViewRightSide];
    }
    else{
        [questionViewLeftSide removeFromSuperview];
        [questionViewRightSide removeFromSuperview];
        questionViewLeftSide=nil;
        questionViewRightSide=nil;
        
        questionViewLeftSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, boxSize)];
//        questionViewLeftSide.backgroundColor=[UIColor greenColor];
        
        questionViewRightSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, boxSize)];
//        questionViewRightSide.backgroundColor=[UIColor yellowColor];
        
        [_QuestionView addSubview:questionViewLeftSide];
        [_QuestionView addSubview:questionViewRightSide];
    }
    [self placingBoxes];
//    NSLog(@"Question %i", [_currentQuestion questionId]);
}

-(void)placingBoxes{
    NSLog(@"*******CUrrent Question id: %i",_currentQuestion.questionId);

    [EQBox cleanInstances];
    int leftSideCount=0;
    BOOL isRightSide=NO;


    for (int i=0; i<_currentQuestion.questionArray.count; i++) {
        
        
        if([[_currentQuestion.questionArray objectAtIndex:i] isEqual:@"="]){
            isRightSide=YES;
            leftSideCount=i;
//            NSLog(@"View: %f, subview %i",_QuestionView.frame.size.width,(boxSize+boxSpace)*i);
            questionViewLeftSide.frame=CGRectMake(((self.view.frame.size.width-(boxSize+boxSpace)*i)+boxSpace)/2, 0, (boxSize+boxSpace)*i-boxSpace, boxSize);
            
            continue;
        }
        if (!isRightSide) {
            EQBox * box=[EQBox BoxWithFrame:CGRectMake((boxSize+boxSpace)*i, 0, boxSize, boxSize) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
            box.caller=self;
            [questionViewLeftSide addSubview:box.boxButton];
        }
        else if(isRightSide){
            //NSLog(@"LeftSideCount:  %i",leftSideCount);
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

-(void)control{
    NSLog(@"entered control");
    NSMutableString * answer=[[NSMutableString alloc] initWithString:@""];
    NSMutableString * answerLeftSide=[[NSMutableString alloc] initWithString:@""];
    NSMutableString * answerRightSide=[[NSMutableString alloc] initWithString:@""];
    BOOL isLeftSide=YES;
    for (int i=0; i<self.currentQuestion.questionArray.count-1; i++) {
        if ([[_currentQuestion.questionArray objectAtIndex:i] isEqual:@"="]) {
            isLeftSide=NO;
        }
        
        EQBox * box=[EQBox boxByOrder:i];

        if (isLeftSide) {
            if(!box.isDeleted)
                [answerLeftSide appendString:box.title];
        }
        else if(!isLeftSide) {
            if(!box.isDeleted)
                [answerRightSide appendString:box.title];
        }
    }
    
    [answer appendString:answerLeftSide];
    [answer appendString:@"="];
    [answer appendString:answerRightSide];
    
    if([self.currentQuestion isCorrect:answer]){
        [self onCorrectAnswer];
        
    }
    else{
        NSLog(@"Answer is false");
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            self.view.transform = CGAffineTransformTranslate(self.view.transform, -25, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                self.view.transform = CGAffineTransformTranslate(self.view.transform, 50, 0);   
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

-(void)onCorrectAnswer{
    NSLog(@"Answer is correct");
    [_stopWatch stopTimer];
    [EQScore addScore:[_stopWatch getElapsedMiliseconds]];
    NSLog(@"Answer is correct %i",[_stopWatch getElapsedMiliseconds]);
    [EQStatistic updateStatisticsWithTime:[_stopWatch getElapsedMiliseconds]];
    NSLog(@"Answer is correct");
    
}

-(void)skipQuestion{
    [EQStatistic updateStatisticsWithSkippedGame];
    [self setCurrentQuestion:[EQQuestion getNextQuestion]];
    [self.stopWatch resetTimer];
    [self configureViews];
}

- (void)viewDidUnload {
    [self setStopWatchLabel:nil];
    [self setBtnControl:nil];
    [self setQuestionView:nil];
    [self setStopWatchLabelMS:nil];
    [self setBtnSkip:nil];
    [super viewDidUnload];
}
@end
