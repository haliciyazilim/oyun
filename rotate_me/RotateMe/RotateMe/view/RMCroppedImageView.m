//
//  RMCroppedImageView.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMCroppedImageView.h"
#import "RMInGameViewController.h"

@implementation RMCroppedImageView
{
    BOOL isAnimating;
    float currentAngle;
}


-(id)initWithImage:(UIImage *)image
{
    if(self = [super initWithImage:image]){
        [self setUserInteractionEnabled:YES];
        currentAngle = 0;
    }
    return self;
}

-(void) rotateToAngle:(float)angle
{
    self.transform = CGAffineTransformMakeRotation(angle);
    currentAngle = angle;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isAnimating)
        return;
    isAnimating = YES;
    if([self.parent isGameFinished])
        return;
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGAffineTransform t1 = CGAffineTransformMakeScale(1.3, 1.3);
        currentAngle -= M_PI * 0.25;
        CGAffineTransform t2 = CGAffineTransformMakeRotation(currentAngle);
        self.transform = CGAffineTransformConcat(t1, t2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGAffineTransform t1 = CGAffineTransformMakeScale(1.0, 1.0);
            currentAngle -= M_PI * 0.25;
            CGAffineTransform t2 = CGAffineTransformMakeRotation(currentAngle);
            self.transform = CGAffineTransformConcat(t1, t2);
        } completion:^(BOOL finished){
            isAnimating = NO;
            [self.superview insertSubview:self belowSubview:[[RMInGameViewController lastInstance] grids]];
            if([self.parent canGameFinish]){
                NSLog(@"Game is finished");
                [self.parent endGame];
            }
        }];
    }];
}

-(void)setRotationStateTo:(int)state
{
    if(state < 0 || state > 3)
        return;
    currentAngle = M_PI * ((float)state / 2.0) ;
    [self rotateToAngle:currentAngle];
}

-(int)getCurrentRotationState
{
    if(isAnimating)
        return -2;
    
    float angle = currentAngle;
    
    while (angle < 0) {
        angle += M_PI * 2;
    }
    while(angle > M_PI * 2){
        angle -= M_PI * 2;
    }
    
    float error = 0.0001;
    int state = -1;
    
    if(angle >= 0 - error && angle <= 0 + error )
        state = 0;
    else if(angle >= M_PI * 0.5 - error && angle <= M_PI * 0.5 + error)
        state = 1;
    else if(angle >= M_PI * 1.0 - error && angle <= M_PI * 1.0 + error)
        state = 2;
    else if(angle >= M_PI * 1.5 - error && angle <= M_PI * 1.5 + error)
        state = 3;
    else if(angle >= M_PI * 2.0 - error && angle <= M_PI * 2.0 + error)
        state = 0;
    
    return state;
}


@end
