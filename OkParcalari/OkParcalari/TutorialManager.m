
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
    UIImageView* balloonImageView;
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
        firstStep.description = @"Go on and water 9 tiles by dragging upwards from this pump.";
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
    NSString* tutorialStartMessage = @"Welcome to Green The Garden. Your objective is to green the garden! You will use water pumps and pipes in your quest.";
    [self showDialogMessage:tutorialStartMessage andCallback:^{
        [self showInstruction:@"This is a water pump. Water pumps have varying water pressures" forTile:LocationMake(0, 0) withCompletionBlock:^{
           [self showInstruction:@"This pump can water 9 tiles" forTile:LocationMake(0,0) withCompletionBlock:^{
               [self showInstruction:@"You can only have straight pipes emanating from the water pumps." forTile:LocationMake(0, 0) withCompletionBlock:^{
                   [self nextStep];
               }];
           }];
        }];
        
    }];
}

-(void)finishTutorial
{
    isTutorialActive = NO;
    
    [balloonImageView removeFromSuperview];
    balloonImageView = nil;
    
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
            //ABDULLAH KARACABEY
        }];
        return;
    }
    TutorialStep* step = [tutorialSteps objectAtIndex:currentStepIndex];
    [self showHelperSignsFrom:step.startTile to:step.targetTile onCompletion:^{
        
    }];
    
    [self showInstruction:step.description forTile:step.startTile];
    
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
    float duration = 0.2 * difference;
    [UIView animateWithDuration:duration delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
    [UIView animateWithDuration:0.5 animations:^{
        balloonImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [balloonImageView removeFromSuperview];
        balloonImageView = nil;
    }];
    
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
//        [self performSelector:@selector(nextStep) withObject:self afterDelay:0.1];
        [self showDialogMessage:@"Congratulations!" andCallback:^{
            [self nextStep];
        }];
        __block UIImageView* previousTutorialArrow = currentTutorialArrow;
        currentTutorialArrow = nil;
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            previousTutorialArrow.alpha = 0;
        } completion:^(BOOL finished) {
            [previousTutorialArrow removeFromSuperview];
            previousTutorialArrow = nil;
        }];
    }
    else{
        [self shortenCurrentArrowForArrow:arrow];
    }
}

-(void)showDialogMessage:(NSString*)message andCallback:(IteratorBlock)block
{
    UIView* dialog = [[UIView alloc] init];
    [dialog setFrame:CGRectMake(512, 384, 0, 0)];
    [dialog setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inapp_back.png"]]];
    [dialog setUserInteractionEnabled:NO];
    [dialog setClipsToBounds:YES];
    dialog.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [dialog setFrame:CGRectMake(512-189, 384 - 152, 379, 305)];
    }];
    [UIView animateWithDuration:0.5 animations:^{
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

-(void)showInstruction:(NSString*)message forTile:(Location)location withCompletionBlock:(IteratorBlock)block
{
    UISetTouchBeganView* background = [[UISetTouchBeganView alloc] init];
    background.frame = CGRectMake(0, 0, 1024, 768);
    [[[CCDirector sharedDirector] view] addSubview:background];
    
    __weak UISetTouchBeganView* weakBackground = background;
    [self showInstruction:message forTile:location];
    [background setTouchesBegan:^{
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint point = [self pointFromLocation:location];
            [balloonImageView setFrame:CGRectMake(point.x-29, point.y+10, balloonImageView.image.size.width, 0)];
        } completion:^(BOOL finished) {
            [weakBackground removeFromSuperview];
            [balloonImageView removeFromSuperview];
            balloonImageView = nil;
            block();
        }];
    }];
}

-(void)showInstruction:(NSString*)message forTile:(Location)location
{
    CGPoint point = [self pointFromLocation:location];
    UIImage* balloonImage = [UIImage imageNamed:@"tut_dialog.png"];
    balloonImage = [self imageWithImage:balloonImage convertToSize:CGSizeMake(300.0, 100.0)];
//    balloonImage
    
    balloonImageView = [[UIImageView alloc] initWithImage:balloonImage];
    [balloonImageView setFrame:CGRectMake(point.x-29, point.y+10, balloonImageView.image.size.width, 0)];
    [balloonImageView setClipsToBounds:YES];
    [UIView animateWithDuration:0.1 animations:^{
        [balloonImageView setFrame:CGRectMake(point.x-29, point.y-balloonImageView.image.size.height+10, balloonImageView.image.size.width, balloonImageView.image.size.height)];
    }];
    
//    UILabel* instructionLabel = [[UILabel alloc] init];
//    instructionLabel.frame = CGRectMake(20, 10, 220, 50);
//    [instructionLabel setText:message];
//    [instructionLabel setBackgroundColor:[UIColor clearColor]];
//    [instructionLabel setNumberOfLines:2];
//    [instructionLabel setContentMode:UIViewContentModeTop];
//    [balloonImageView addSubview:instructionLabel];

    UITextView* instructionTextView = [[UITextView alloc] init];
    instructionTextView.frame = CGRectMake(5, 0, balloonImage.size.width-40, 50);
    [instructionTextView setText:message];
    [instructionTextView setTextColor:[UIColor whiteColor]];
    [instructionTextView setBackgroundColor:[UIColor clearColor]];
    [instructionTextView setContentMode:UIViewContentModeTop];
    [instructionTextView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
    
    [balloonImageView addSubview:instructionTextView];
    
    
    [[[CCDirector sharedDirector] view] addSubview:balloonImageView];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
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