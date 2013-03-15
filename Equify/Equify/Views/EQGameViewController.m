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
    
    UIView * questionViewLeftSide;
    UIView * questionViewRightSide;
    
    NSMutableArray *counterImages;
    int moveCount;
    int deleteCount;
}
-(int)boxSize{
    return 48;
}
-(int)boxSpace{
    return 10;
}
-(int) leftAndRightViewSpace{
    return 50;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) setBackground{
    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.png"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    }
}

-(float) buttonSize{
    return 69.0;
}

- (void)viewDidLoad
{
    
    [self setBackground];
    
    [self.stopWatchLabel setText:@"00:00"];
    [self.stopWatchLabel setTextColor:[UIColor colorWithRed:0.403 green:0.403 blue:0.403 alpha:1.0]];
    
    [self.stopWatchLabelMS setText:@".0"];
    [self.stopWatchLabelMS setTextColor:[UIColor colorWithRed:0.403 green:0.403 blue:0.403 alpha:1.0]];
    
    self.stopWatch = [[StopWatch alloc] init];
    
    
    
    CGFloat winWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat winHeight = [[UIScreen mainScreen] bounds].size.height;
    
    UIButton *btnControl=[self makeButton:CGRectMake((winHeight-[self buttonSize])/2, winWidth-[self buttonSize]-24.0, [self buttonSize], [self buttonSize]) title:@"bitir"];
    [btnControl addTarget:self action:@selector(control) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnSkip=[self makeButton:CGRectMake(winHeight-[self buttonSize]-24, winWidth-[self buttonSize]-24, [self buttonSize], [self buttonSize]) title:@"geç"];
    [btnSkip addTarget:self action:@selector(skipQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnControl];
    [self.view addSubview:btnSkip];
    
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
    
    if(questionViewLeftSide==nil){
        questionViewLeftSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [self boxSize])];
//        questionViewLeftSide.backgroundColor=[UIColor greenColor];
    
        questionViewRightSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [self boxSize])];
//        questionViewRightSide.backgroundColor=[UIColor yellowColor];

        [_QuestionView addSubview:questionViewLeftSide];
        [_QuestionView addSubview:questionViewRightSide];
    }
    else{
        [questionViewLeftSide removeFromSuperview];
        [questionViewRightSide removeFromSuperview];
        questionViewLeftSide=nil;
        questionViewRightSide=nil;
        
        questionViewLeftSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [self boxSize])];
//        questionViewLeftSide.backgroundColor=[UIColor greenColor];
        
        questionViewRightSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [self boxSize])];
//        questionViewRightSide.backgroundColor=[UIColor yellowColor];
        
        [_QuestionView addSubview:questionViewLeftSide];
        [_QuestionView addSubview:questionViewRightSide];
    }
    [self placingBoxes];
//    NSLog(@"Question %i", [_currentQuestion questionId]);
    
    deleteCount = 0;
    moveCount = [[self.currentQuestion wholeQuestion] length] - [[self.currentQuestion answer] length];
    NSLog(@"MoveCount: %i", moveCount);
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



-(UIButton *) makeButton:(CGRect)frame title:(NSString *) title{
    
    
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.layer.cornerRadius = [self buttonSize]/2;
    btn.layer.borderWidth = 1.0;
    btn.layer.shadowRadius = 2.0;
    btn.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    btn.layer.shadowOpacity = 0.3;
    [btn.layer setShadowPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 2, [self buttonSize], [self buttonSize])] CGPath]];
    btn.layer.borderColor = [[UIColor colorWithRed:0.596 green:0.596 blue:0.596 alpha:1.0] CGColor];
    [btn setBackgroundColor:[UIColor colorWithRed:0.827 green:0.827 blue:0.827 alpha:1.0]];
    
    UIImageView *controlInnerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"control_bg.png"]];
    
    btn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    btn.titleLabel.numberOfLines=2;
    
    [btn setTitleColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.shadowColor=[UIColor colorWithWhite:1.0 alpha:0.3];
    btn.titleLabel.shadowOffset=CGSizeMake(0.0, 1.0);
    btn.titleLabel.backgroundColor=[UIColor clearColor];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;

    //    [controlButton addTarget:self action:@selector(makeHighlighted:) forControlEvents:UIControlEventTouchDown];
    //    [controlButton addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpOutside];
    
    [btn addSubview:controlInnerShadow];
   
    
    return btn;
    
    
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
            questionViewLeftSide.frame=CGRectMake(((self.view.frame.size.width-([self boxSize]+[self boxSpace])*i)+[self boxSpace])/2, 0, ([self boxSize]+[self boxSpace])*i-[self boxSpace], [self boxSize]);
            
            continue;
        }
        if (!isRightSide) {
            EQBox * box=[EQBox BoxWithFrame:CGRectMake(([self boxSize]+[self boxSpace])*i, 0, [self boxSize], [self boxSize]) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
            box.caller=self;
            [questionViewLeftSide addSubview:box.boxButton];
        }
        else if(isRightSide){
            //NSLog(@"LeftSideCount:  %i",leftSideCount);
            EQBox * box=[EQBox BoxWithFrame:CGRectMake(([self boxSize]+[self boxSpace])*(i-leftSideCount-1), 0, [self boxSize], [self boxSize]) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
            box.caller=self;
            [questionViewRightSide addSubview:box.boxButton];
            
            if(_currentQuestion.questionArray.count-1==i){
                questionViewRightSide.frame=CGRectMake(((self.view.frame.size.width-([self boxSize]+[self boxSpace])*(i-leftSideCount)+[self boxSpace]))/2, questionViewLeftSide.frame.size.height+[self leftAndRightViewSpace], ([self boxSize]+[self boxSpace])*(i-leftSideCount)-[self boxSpace], [self boxSize]);
            }
        }
        
    }
}

-(void)animateBox:(UIButton *)button {
    NSLog(@"entered deletebox");
    EQBox* box = [EQBox boxByOrder:button.tag];
    NSLog(@"%@",box);
    
    if(!box.isDeleted){
        if (deleteCount != moveCount) {
            [box deleteBox];
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
    
    [_stopWatch stopTimer];
    [EQScore addScore:[_stopWatch getElapsedMiliseconds]];
    [EQStatistic updateStatisticsWithTime:[_stopWatch getElapsedMiliseconds]];
    
    [[GameCenterManager sharedInstance] submitScore:[_stopWatch getElapsedMiliseconds] category:kLeaderboardBestTime];
    [[GameCenterManager sharedInstance] submitScore:[[EQStatistic getStatistics] totalSolvedQuestion] category:kLeaderboardTotalSolvedQuestion];

    [self.navigationController popViewControllerAnimated:YES];

    
}

-(void)skipQuestion{
    [EQStatistic updateStatisticsWithSkippedGame];
    [self setCurrentQuestion:[EQQuestion getNextQuestion]];
    [self.stopWatch resetTimer];
    [self configureViews];
}



- (void)viewDidUnload {
    [self setStopWatchLabel:nil];
    [self setQuestionView:nil];
    [self setStopWatchLabelMS:nil];
    [super viewDidUnload];
}
@end
