//
//  TutorialManager.m
//  GreenTheGarden
//
//  Created by Yunus Eren Guzel on 1/25/13.
//
//

#import "TutorialManager.h"
typedef void (^ IteratorBlock)();
@interface UISetTouchBeganView : UIView
-(void)setTouchesBegan:(IteratorBlock)block;
@end

@interface TutorialStep : NSObject
@property Location startTile;
@property Location targetTile;
@property NSString* description;
@end
@implementation TutorialStep
@end

@implementation TutorialManager
{
    NSString* mapId;
    NSMutableArray* tutorialSteps;
    BOOL isTutorialActive;
    int currentStep;
    BOOL canInteract;
}

+(TutorialManager *)sharedInstance
{
    static TutorialManager* currentInstance = nil;
    if(currentInstance == nil){
        currentInstance = [[TutorialManager alloc] init];
    }
    return currentInstance;
}

-(id)init
{
    if(self = [super init]){
        canInteract = NO;
        isTutorialActive = NO;
        mapId = @"10000";
        tutorialSteps = [[NSMutableArray alloc] init];
        
        TutorialStep* firstStep = [[TutorialStep alloc] init];
        firstStep.startTile = LocationMake(0, 0);
        firstStep.targetTile = LocationMake(0, 9);
        firstStep.description = @"Deneme description";
        
        
        
        [tutorialSteps addObject:firstStep];
    }
    return self;
}

-(BOOL)isTutorialEnabled
{
    return YES;
}

-(void)setTutorialEnabled
{
    
}

-(void)setTutorialDisabled
{
    
}

-(void)startTutorial
{
    isTutorialActive = YES;
    currentStep = 0;
    [self showDialogMessage:@"asdasd asd asd asd as dasdasdasdasd asd asd asd asd asd ads asd asd asd ddsa das das dasd  asdf asrqwr asdf asdf asfasrf qewr af asfd qwr asde asrq e"];
}

-(void) nextStep
{
    currentStep++;
}

-(void)skipTutorial
{
    
}

-(BOOL)isTutorialActive
{
    return isTutorialActive;
}

-(BOOL)isTutoringMap:(NSString*)mapFileName
{
    return [mapId compare:mapFileName] == 0;
}

-(BOOL)shouldDisableOtherEntities
{
    return YES;
}

-(BOOL)isCorrectEntitity:(MapEntity*)entity
{
    Location startLocation = ((TutorialStep*)[tutorialSteps objectAtIndex:currentStep]).startTile;
    return entity.location.x == startLocation.x && entity.location.y == startLocation.y;
}

-(BOOL)checkEntity:(MapEntity*)entity
{
    return NO;
}

-(void)showDialogMessage:(NSString*)message
{
    UIView* dialog = [[UIView alloc] init];
    [dialog setFrame:CGRectMake(512-189, 384 - 152, 379, 305)];
    [dialog setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inapp_back.png"]]];
    [dialog setUserInteractionEnabled:NO];
    dialog.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        dialog.alpha = 1;
    }];
    
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:18.0];
    
    UILabel* tapToCloseLabel = [[UILabel alloc] init];
    [tapToCloseLabel setText:[NSString stringWithFormat:@" %@ ",NSLocalizedString(@"TAP_TO_CLOSE", nil)]];
    [tapToCloseLabel setFrame:CGRectMake(0.0, dialog.frame.size.height-50, dialog.frame.size.width, 30.0)];
    [tapToCloseLabel setTextAlignment:NSTextAlignmentCenter];
    [tapToCloseLabel setBackgroundColor:[UIColor clearColor]];
    [tapToCloseLabel setTextColor:[UIColor blackColor]];
//    [tapToCloseLabel setShadowColor:[UIColor whiteColor]];
//    [tapToCloseLabel setShadowOffset:CGSizeMake(0, 1)];
    [tapToCloseLabel setFont:font];
    [dialog addSubview:tapToCloseLabel];
    
    UITextView* messageTextView = [[UITextView alloc] init];
    [messageTextView setFrame:CGRectMake(50.0, 50.0, dialog.frame.size.width-100.0, dialog.frame.size.height - 150)];
    [messageTextView setText:message];
    [messageTextView setFont:font];
    [messageTextView setTextAlignment:NSTextAlignmentCenter];
    [messageTextView setTextColor:[UIColor blackColor]];
    [messageTextView setBackgroundColor:[UIColor clearColor]];
    [dialog addSubview:messageTextView];
    
    
    UISetTouchBeganView* background = [[UISetTouchBeganView alloc] init];
    [background setUserInteractionEnabled:YES];
    [background setFrame:CGRectMake(0, 0, 1024, 768)];
    __weak UISetTouchBeganView* weakBackground = background;

    [background setTouchesBegan:^{
        [dialog removeFromSuperview];
        [weakBackground removeFromSuperview];
    }];
    
    [[[CCDirector sharedDirector] view] addSubview:background];
    [[[CCDirector sharedDirector] view] addSubview:dialog];
}

-(void)closeDialog
{
//    NSLog(@"close dialog");
    
}

-(void)showInstructionForTile:(Location)location
{
    
}
@end



@implementation UISetTouchBeganView
{
    IteratorBlock touchBeganBlock;
}


-(void)setTouchesBegan:(IteratorBlock)block
{
    touchBeganBlock = block;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchBeganBlock();
}

@end