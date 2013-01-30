
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
    int currentStepIndex;
    BOOL canInteract;
    UIImageView* currentTutorialArrow;
    Location lastMovedArrowEndLocation;
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
        lastMovedArrowEndLocation = LocationMake(-1, -1);
        tutorialSteps = [[NSMutableArray alloc] init];
        TutorialStep* firstStep = [[TutorialStep alloc] init];
        firstStep.startTile = LocationMake(0, 0);
        firstStep.targetTile = LocationMake(0, 9);
        firstStep.description = @"Deneme description";
        [tutorialSteps addObject:firstStep];
        
        TutorialStep* secondStep = [[TutorialStep alloc] init];
        secondStep.startTile = LocationMake(2,4);
        secondStep.targetTile = LocationMake(2, 1);
        secondStep.description = @"Deneme description";
        [tutorialSteps addObject:secondStep];
        
        TutorialStep* thirdStep = [[TutorialStep alloc] init];
        thirdStep.startTile = LocationMake(8,8);
        thirdStep.targetTile = LocationMake(1, 8);
        thirdStep.description = @"Deneme falan";
        [tutorialSteps addObject:thirdStep];
        
        TutorialStep* forthStep = [[TutorialStep alloc] init];
        forthStep.startTile = LocationMake(1, 0);
        forthStep.targetTile = LocationMake(9, 0);
        forthStep.description = @"Deneme falan";
        [tutorialSteps addObject:forthStep];
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
    currentStepIndex =-1;
    NSString* tutorialStartMessage = @"asdasd asd asd asd as dasdasdasdasd asd asd asd asd asd ads asd asd asd ddsa das das dasd  asdf asrqwr asdf asdf asfasrf qewr af asfd qwr asde asrq e";
    [self showDialogMessage:tutorialStartMessage andCallback:^{
        [self nextStep];
    }];
}

-(void)finishTutorial
{
    isTutorialActive = NO;
    [currentTutorialArrow removeFromSuperview];
    currentTutorialArrow = nil;
}

-(void) nextStep
{
    NSLog(@"next step");
    currentStepIndex++;
    if(currentStepIndex >= [tutorialSteps count]){
        [self showDialogMessage:@"End of Tutorial" andCallback:^{
            [self finishTutorial];
        }];
        return;
    }
    TutorialStep* step = [tutorialSteps objectAtIndex:currentStepIndex];
    [self showHelperSignsFrom:step.startTile to:step.targetTile onCompletion:^{
        
    }];
    [self showInstructionForTile:step.startTile];
    
}

-(CGPoint) pointFromLocation:(Location)location
{
    return [[GameMap sharedInstance] pointFromGridLocation:LocationMake(location.x,[[GameMap sharedInstance] rows] - location.y - 1)];
}

-(void)shortenCurrentArrowForArrow:(Arrow*)arrow
{
    int arrowSize = [arrow getSize];
    if(arrow.endLocation.x == lastMovedArrowEndLocation.x && arrow.endLocation.y == lastMovedArrowEndLocation.y)
        return;
    else
        lastMovedArrowEndLocation = arrow.endLocation;
    
    
    Location startingLocation;
    if(arrowSize > 0)
        startingLocation = [arrow locationAtOrder:arrowSize];
    else
        startingLocation = arrow.base.location;
    switch (arrow.direction) {
        case DOWN:
            startingLocation.y -= 1;
            break;
        case RIGHT:
            startingLocation.x += 1;
            break;
            
        default:
            break;
    }
    CGPoint startingPoint = [self pointFromLocation:startingLocation];
//    
//    TutorialStep* currentStep = (TutorialStep*)[tutorialSteps objectAtIndex:currentStepIndex];
//    Location from = currentStep.startTile;
//    Location to = currentStep.targetTile;
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        switch(arrow.direction){
            case UP:
                [currentTutorialArrow setFrame:CGRectMake(currentTutorialArrow.frame.origin.x, currentTutorialArrow.frame.origin.y, currentTutorialArrow.frame.size.width,abs(currentTutorialArrow.frame.origin.y - startingPoint.y))];
                break;
            case DOWN:
                [currentTutorialArrow setFrame:CGRectMake(startingPoint.x, startingPoint.y, currentTutorialArrow.frame.size.width,abs(currentTutorialArrow.frame.origin.y + currentTutorialArrow.frame.size.height - startingPoint.y))];
                break;
            case LEFT:
                [currentTutorialArrow setFrame:CGRectMake(currentTutorialArrow.frame.origin.x, currentTutorialArrow.frame.origin.y, abs(currentTutorialArrow.frame.origin.x - startingPoint.x),currentTutorialArrow.frame.size.height)];
                break;
            case RIGHT:
                [currentTutorialArrow setFrame:CGRectMake(startingPoint.x, startingPoint.y, abs(currentTutorialArrow.frame.origin.x + currentTutorialArrow.frame.size.width - startingPoint.x),currentTutorialArrow.frame.size.height)];
                break;
            case NONE:
                break;
        }
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showHelperSignsFrom:(Location)from to:(Location)to onCompletion:(IteratorBlock)block
{
    Direction direction = DirectionFromTwoLocations(from, to);
    CGPoint toPoint = [self pointFromLocation:to];
    Arrow* arrow = [(ArrowBase*)[[GameMap sharedInstance] entityAtLocation:from] arrowAtDirection:DirectionFromTwoLocations(from, to)];
    CGPoint startingPoint = [self pointFromLocation:[arrow locationAtOrder:1]];
    int difference = differenceBetweenTwoLocations(from, to);
    UIImageView* tutorialArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tut_arrow.png"]];
    tutorialArrow = [self rotatedImageView:tutorialArrow forDirection:direction];
    [tutorialArrow setFrame:CGRectMake(startingPoint.x, startingPoint.y, [GameMap sharedInstance].tileSize.width * 1, tutorialArrow.image.size.height)];
    [[[CCDirector sharedDirector] view] addSubview:tutorialArrow];
    [tutorialArrow setClipsToBounds:YES];
    [tutorialArrow setContentMode:UIViewContentModeRight];
    tutorialArrow.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        tutorialArrow.alpha = 1.0;
    }];
    float duration = 0.30 * difference;
    [UIView animateWithDuration:duration delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        switch (direction) {
            case UP:
                [tutorialArrow setFrame:CGRectMake(toPoint.x, toPoint.y, [GameMap sharedInstance].tileSize.width * 1, [GameMap sharedInstance].tileSize.width * difference)];
                break;
            case DOWN:
                [tutorialArrow setFrame:CGRectMake(startingPoint.x, startingPoint.y, [GameMap sharedInstance].tileSize.width * 1, [GameMap sharedInstance].tileSize.width * difference)];
                break;
            case LEFT:
                [tutorialArrow setFrame:CGRectMake(toPoint.x, toPoint.y, [GameMap sharedInstance].tileSize.width * difference, [GameMap sharedInstance].tileSize.width * 1)];
                break;
            case RIGHT:
                [tutorialArrow setFrame:CGRectMake(startingPoint.x, startingPoint.y, [GameMap sharedInstance].tileSize.width * difference, [GameMap sharedInstance].tileSize.width * 1)];
                break;
            case NONE:
                break;
        }
    } completion:^(BOOL finished) {
            
    }];
    currentTutorialArrow = tutorialArrow;
}

-(UIImageView*)rotatedImageView:(UIImageView*)imageView forDirection:(Direction)direction
{
    float angle;
    UIViewContentMode contentMode;
    switch (direction) {
        case UP:
            angle = - M_PI * 0.5;
            contentMode = UIViewContentModeRight;
            break;
        case DOWN:
            angle = + M_PI * 0.5;
            contentMode = UIViewContentModeLeft;
            break;
        case LEFT:
            angle = - M_PI * 1;
            contentMode = UIViewContentModeTop;
            break;
        case RIGHT:
            angle = 0;
            contentMode = UIViewContentModeBottom;
            break;
        case NONE:
            return imageView;
    }
    imageView.transform = CGAffineTransformRotate(imageView.transform, angle);
    return imageView;
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

-(void)pauseTutorial
{
    [currentTutorialArrow setAlpha:0.0];
}

-(void)resumeTutorial
{
    [currentTutorialArrow setAlpha:1.0];
}

-(BOOL)isCorrectEntitity:(ArrowBase*)entity
{
    Location startLocation = ((TutorialStep*)[tutorialSteps objectAtIndex:currentStepIndex]).startTile;
    return entity.location.x == startLocation.x && entity.location.y == startLocation.y;
}

-(void)updateForMovedBase:(ArrowBase*)arrowBase
{
    if(![self isCorrectEntitity:arrowBase])
        return;
    TutorialStep* currentStep = (TutorialStep*)[tutorialSteps objectAtIndex:currentStepIndex];
    Location from = currentStep.startTile;
    Location to = currentStep.targetTile;
    Arrow* arrow = [arrowBase arrowAtDirection:DirectionFromTwoLocations(from, to)];
    [self shortenCurrentArrowForArrow:arrow];
}

-(void)checkEntity:(ArrowBase*)entity
{
    if(![self isCorrectEntitity:entity])
        return;
    TutorialStep* currentStep = (TutorialStep*)[tutorialSteps objectAtIndex:currentStepIndex];
    Location from = currentStep.startTile;
    Location to = currentStep.targetTile;
    
    Arrow* arrow = [entity arrowAtDirection:DirectionFromTwoLocations(from, to)];
    BOOL result = NO;
    if(arrow.endLocation.x == to.x && arrow.endLocation.y == to.y)
        result = YES;
    if(result == YES){
        [self showDialogMessage:@"Congratulations!" andCallback:^{
            [self nextStep];
        }];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            currentTutorialArrow.alpha = 0;
        } completion:^(BOOL finished) {
            [currentTutorialArrow removeFromSuperview];
            currentTutorialArrow = nil;
        }];
    }
    else{
        [self shortenCurrentArrowForArrow:arrow];
        
    }
    
    
}

-(void)showDialogMessage:(NSString*)message andCallback:(IteratorBlock)block
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
    
    [[ArrowGame lastInstance] pauseTimer];
    [background setTouchesBegan:^{
        [dialog removeFromSuperview];
        [weakBackground removeFromSuperview];
        [[ArrowGame lastInstance] resumeTimer];
        block();
    }];
    
    [[[CCDirector sharedDirector] view] addSubview:background];
    [[[CCDirector sharedDirector] view] addSubview:dialog];
}

-(void)closeDialog
{
    
}

-(void)showInstructionForTile:(Location)location
{
    CGPoint point = [self pointFromLocation:location];
    UIImageView* balloonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tut_dialog.png"]];
    [balloonImageView setFrame:CGRectMake(point.x-29, point.y-balloonImageView.image.size.height, balloonImageView.image.size.width, balloonImageView.image.size.height)];
    [[[CCDirector sharedDirector] view] addSubview:balloonImageView];
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