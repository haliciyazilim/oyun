//
//  TransitionManager.m
//  GreenTheGarden
//
//  Created by Alperen Kavun on 28.01.2013.
//
//

#import "TransitionManager.h"
#import "MapSelectionLayer.h"

@implementation TransitionManager
{
    TransitionBlock transition;
    UIImageView *transitionImage;
    UIImageView *transitionImage2;
    UIImageView *transitionImage3;
}
- (id) initWithTransitionBlock:(TransitionBlock)transitionBlock {
    if (self = [super init]) {
        transition = transitionBlock;
    }
    return self;
}

- (void) closeTransitionLayers {
    NSLog(@"making closing");
    [[[CCDirector sharedDirector] view] setUserInteractionEnabled:NO];
    
    transitionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 768.0, 1024.0, 768.0)];
    [transitionImage setImage:[UIImage imageNamed:@"transition_leafs.png"]];
    transitionImage.layer.zPosition = 999.0;
    
    transitionImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, -768.0, 1024, 768.0)];
    [transitionImage2 setImage:[UIImage imageNamed:@"transition_leafs.png"]];
    [transitionImage2 setTransform:CGAffineTransformMakeRotation(M_PI)];
    transitionImage2.layer.zPosition = 998.0;
    
    transitionImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0)];
    [transitionImage3 setImage:[UIImage imageNamed:@"transition_grass.png"]];
    transitionImage3.alpha = 0.0;
    transitionImage3.layer.zPosition = 997.0;
    
    [[[CCDirector sharedDirector] view] addSubview:transitionImage];
    [[[CCDirector sharedDirector] view] addSubview:transitionImage2];
    [[[CCDirector sharedDirector] view] addSubview:transitionImage3];
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        transitionImage.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
        transitionImage2.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
        transitionImage3.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self performRealTransition];
    }];
}
- (void) openTransitionLayers {
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        transitionImage.frame = CGRectMake(0.0, 768.0, 1024.0, 768.0);
        transitionImage2.frame = CGRectMake(0.0, -768.0, 1024.0, 768.0);
        transitionImage3.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionImage removeFromSuperview];
        [transitionImage2 removeFromSuperview];
        [transitionImage3 removeFromSuperview];
        transitionImage = nil;
        transitionImage2 = nil;
        transitionImage3 = nil;
        [[[CCDirector sharedDirector] view] setUserInteractionEnabled:YES];
    }];
}

- (void) startTransition {
    [self closeTransitionLayers];
}
- (void) performRealTransition{
    transition();
//    [[[CCDirector sharedDirector] view] bringSubviewToFront:myImage];
//    double delayInSeconds = 1.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self openTransitionLayers];
//    });
}
@end
