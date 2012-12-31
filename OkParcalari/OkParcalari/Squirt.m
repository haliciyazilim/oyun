//
//  Squirt.m
//  OkParcalari
//
//  Created by Alperen Kavun on 31.12.2012.
//
//

#import "Squirt.h"

@implementation Squirt

- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explostion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
}

@end
