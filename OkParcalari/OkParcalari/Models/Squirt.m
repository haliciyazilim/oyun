//
//  Squirt.m
//  OkParcalari
//
//  Created by Alperen Kavun on 31.12.2012.
//
//

#import "Squirt.h"
#import "CCBAnimationManager.h"

@implementation Squirt

- (void) runAnimation{
    CCBAnimationManager* animationManager = self.userObject;
    NSLog(@"*************animationManager: %@***************", animationManager);
    [animationManager runAnimationsForSequenceNamed:@"SquirtLoop"];
}

@end
