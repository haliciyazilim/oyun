//
//  TutorialManager.m
//  GreenTheGarden
//
//  Created by Yunus Eren Guzel on 1/25/13.
//
//

#import "TutorialManager.h"

@interface UISetTouchBeganView : UIView

-(void)setTouchesBegan:(SEL)selector target:(id)target;
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
        firstStep.description = @"";
        
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
    [self showDialogMessage];
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

-(void)showDialogMessage
{
    UIView* dialog = [[UIView alloc] init];
    [dialog setFrame:CGRectMake(512-189, 384 - 152, 379, 305)];
    [dialog setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inapp_back.png"]]];
    UISetTouchBeganView* background = [[UISetTouchBeganView alloc] init];
    [background setUserInteractionEnabled:YES];
    [background setFrame:CGRectMake(0, 0, 1024, 768)];
    [background setTouchesBegan:@selector(closeDialog) target:self];
    
    [[[CCDirector sharedDirector] view] addSubview:background];
    [[[CCDirector sharedDirector] view] addSubview:dialog];
}

-(void)closeDialog
{
    NSLog(@"close dialog");
}

-(void)showInstructionForTile:(Location)location
{
    
}
@end



@implementation UISetTouchBeganView
{
    SEL touchesBeganSelector;
    id targetInstance;
}


-(void)setTouchesBegan:(SEL)selector target:(id)target
{
    touchesBeganSelector = selector;
    targetInstance = target;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [targetInstance performSelector:touchesBeganSelector withObject:targetInstance];
    [targetInstance performSelector:touchesBeganSelector];
}

@end