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
    UIImageView *myImage;
}
- (id) initWithTransitionBlock:(TransitionBlock)transitionBlock {
    if (self = [super init]) {
        transition = transitionBlock;
    }
    return self;
}

- (void) closeTransitionLayers {
    NSLog(@"making closing");
    myImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    [myImage setImage:[UIImage imageNamed:@"game_bg.png"]];
    myImage.layer.zPosition = 999.0;
    [[[CCDirector sharedDirector] view] addSubview:myImage];
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        myImage.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    } completion:^(BOOL finished) {
        [self performRealTransition];
    }];
}
- (void) openTransitionLayers {
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        myImage.frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    } completion:^(BOOL finished) {
        [myImage removeFromSuperview];
        myImage = nil;
    }];
}

- (void) startTransition {
    [self closeTransitionLayers];
}
- (void) performRealTransition{
    transition();
//    [[[CCDirector sharedDirector] view] bringSubviewToFront:myImage];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self openTransitionLayers];
    });
}
@end
