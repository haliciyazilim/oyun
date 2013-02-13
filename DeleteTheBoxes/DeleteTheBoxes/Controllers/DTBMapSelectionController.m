//
//  DTBMapSelectionController.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 05.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DTBMapSelectionController.h"
#import "DTBQuestion.h"
#import "DTBAppSpecificValues.h"
#import "DTBViewController.h"
#import "StopWatch.h"
#import "DTBGameCenterAppSpecificValues.h"
#import "DTBSegue.h"

@implementation DTBMapSelectionController
{
    UIButton *selectedButton;
    NSArray *wholeQuestionsArray;
    NSArray *myMatches;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidLoad
{
    NSLog(@"entered didLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.png"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    }
//    wholeQuestionsArray = [DTBQuestion getAllQuestions];
    
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error) {
        myMatches = [[NSArray alloc] initWithArray:matches];
        [self leaveMatches];
    }];
    
    
}
- (void) leaveMatches {
    for (int i = 0; i < [myMatches count]; i++) {
        [[myMatches objectAtIndex:i]  participantQuitOutOfTurnWithOutcome:GKTurnBasedMatchOutcomeQuit withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"quit is not successfull");
            } else {
                NSLog(@"quited match");
                [[myMatches objectAtIndex:i] removeWithCompletionHandler:^(NSError *error) {
                    NSLog(@"REMOVED");
                }];
            }
        }];
//        [(GKTurnBasedMatch *)[myMatches objectAtIndex:i] endMatchInTurnWithMatchData:nil completionHandler:^(NSError *error) {
//            if (error) {
//                NSLog(@"error occured : %@",error.localizedDescription);
//            }
//            else{
//                NSLog(@"end operation is successfull");
//            }
//        }];
    }
}
- (void) deleteMatches {
    NSLog(@"entered deleteMatches");
    NSLog(@"%d",[myMatches count]);
    for (int i = 0; i < [myMatches count]; i++) {
        [(GKTurnBasedMatch *)[myMatches objectAtIndex:i] removeWithCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@",error.localizedDescription);
            } else {
                NSLog(@"remove operation is completed succesfully");
            }
        }];
    }

}
- (void) viewDidAppear:(BOOL)animated {

}
- (void)viewWillAppear:(BOOL)animated {
    if (selectedButton) {
        [self unhighlight:selectedButton];
        selectedButton = nil;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localPlayerAuthenticationChanged:) name:kAuthenticationChangedNotification object:nil];
    [self updateScrollView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAuthenticationChangedNotification object:nil];
}
-(void)localPlayerAuthenticationChanged:(NSNotification *)notif {
    [self installTurnBasedEventHandler];
}
- (void) cleanScrollView {
    for (UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
}
- (void) updateScrollView {
    [self cleanScrollView];
    
    wholeQuestionsArray = [DTBQuestion getAllQuestions];
    
    int questionCount = [wholeQuestionsArray count];
    
    [self.scrollView setContentSize:CGSizeMake((questionCount*0.5+1)*(93), 160.0)];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    CGFloat xOffset, yOffset;
    for (int i = 0; i < questionCount; i++) {
        DTBQuestion *currentProccessingQuestion = [wholeQuestionsArray objectAtIndex:i];
        UIButton *question = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i % 2 == 0){
            xOffset = 25.0 + i/2*93;
            yOffset = 5.0;
        }
        else{
            xOffset = 72.0 + i/2*93;
            yOffset = 85.0;
        }
        question.frame = CGRectMake(xOffset, yOffset, 70.0, 70.0);
        question.layer.cornerRadius = 35.0;
        question.layer.borderWidth = 1.0;
        question.layer.shadowRadius = 0.0;
        question.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        question.layer.shadowOpacity = 1.0;
        [question.layer setShadowPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-5, -5, 80.0, 80.0)] CGPath]];
        
        
        UILabel *buttonLabel;
        UILabel *timerLabel;
        
//        if (![currentProccessingQuestion isPurchased]) {
//            question.layer.shadowColor = [[UIColor colorWithWhite:0.0 alpha:0.10] CGColor];
//            question.layer.borderColor = [[UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1.0] CGColor];
//            [question setBackgroundColor:[UIColor colorWithRed:0.773 green:0.773 blue:0.773 alpha:1.0]];
//            buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
//            [buttonLabel setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]];
//            [question addTarget:self action:@selector(buyPro) forControlEvents:UIControlEventTouchUpInside];
//
//        }
//        else{
            question.layer.shadowColor = [[UIColor colorWithWhite:1.0 alpha:0.35] CGColor];
            question.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.741 blue:0.659 alpha:1.0] CGColor];
            [question setBackgroundColor:[UIColor colorWithRed:0.894 green:0.855 blue:0.8 alpha:1.0]];
            
            if ([currentProccessingQuestion score] < INT32_MAX) {
                // bitirildi, score var
                buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 46.0)];
                timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(1.0, 40.0, 68.0, 30.0)];
                [timerLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"played_btn_bg.png"]]];
                [timerLabel setText:[StopWatch textWithMiliseconds:[currentProccessingQuestion score]]];
                [timerLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
                [timerLabel setTextColor:[UIColor colorWithRed:0.463 green:0.365 blue:0.227 alpha:1.0]];
                [timerLabel setTextAlignment:NSTextAlignmentCenter];
            }
            else{
                // bitirilmedi, score yok
                buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
            }
            [buttonLabel setTextColor:[UIColor colorWithRed:0.463 green:0.365 blue:0.227 alpha:1.0]];
            [question addTarget:self action:@selector(makeHighlighted:) forControlEvents:UIControlEventTouchDown];
            [question addTarget:self action:@selector(makeUnhighlighted:) forControlEvents:UIControlEventTouchUpOutside];
            [question addTarget:self action:@selector(openQuestion:) forControlEvents:UIControlEventTouchUpInside];
//        }
        
        [buttonLabel setFont:[UIFont fontWithName:@"Helvetica" size:24.0]];
        [buttonLabel setText:[NSString stringWithFormat:@"%d",[currentProccessingQuestion questionOrder]]];
        [buttonLabel setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
        [buttonLabel setShadowOffset:CGSizeMake(0.0, 2.0)];
        [buttonLabel setBackgroundColor:[UIColor clearColor]];
        [buttonLabel setTextAlignment:NSTextAlignmentCenter];
        
        question.tag = i;
        
        [question addSubview:buttonLabel];
        [question addSubview:timerLabel];

        [self.scrollView addSubview:question];
    }
}
- (void) buyPro {
    NSLog(@"********buyPro here ************");
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
- (void) openQuestion:(UIButton *)button {
    selectedButton = button;
    [self highlight:selectedButton];
    [self performSegueWithIdentifier:@"openQuestion" sender:self];

//    [UIView animateWithDuration:0.5 animations:^{
//        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-320, self.view.frame.size.width, self.view.frame.size.height)];
//    } completion:^(BOOL finished) {
//    }];
}
- (void) prepareForSegue:(DTBSegue *)segue sender:(id)sender {
    NSLog(@"entered prepareForSegue and identifier is: %@",segue.identifier);
    NSLog(@"source: %@, and destination: %@",segue.sourceViewController,segue.destinationViewController);
    if ([segue.identifier isEqualToString:@"openQuestion"]) {
        DTBViewController *destination = [segue destinationViewController];
        [destination setCurrentQuestion:[wholeQuestionsArray objectAtIndex:3]];
        [destination setWholeQuestionCount:15];
        [destination setCurrentMatch:(GKTurnBasedMatch *)sender];
//        NSLog(@"%@",[destination currentQuestion]);
//        [destination setCurrentQuestion:[wholeQuestionsArray objectAtIndex:[selectedButton tag]]];
//        NSLog(@"%d from map selection",[wholeQuestionsArray count]);
//        [destination setWholeQuestionCount:[wholeQuestionsArray count]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
- (void) installTurnBasedEventHandler
{
    [GKTurnBasedEventHandler sharedTurnBasedEventHandler].delegate = self;
}
- (IBAction)createMatch:(id)sender {
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.turnBasedMatchmakerDelegate = self;
    
    [self presentViewController:mmvc animated:YES completion:nil];
}
#pragma mark GKTurnBasedMatchmakerViewControllerDelegate Protocol methods
- (void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match
{
    NSLog(@"entered didFindMatch");
    [self dismissViewControllerAnimated:YES completion:^{
//        [self performSegueWithIdentifier:@"openQuestion" sender:match];
    }];

}
-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    [match removeWithCompletionHandler:^(NSError *error) {
//        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
#pragma mark GKTurnBasedEventHandlerDelegate Protocol methods
- (void)handleInviteFromGameCenter:(NSArray *)playersToInvite {
    
}
@end
