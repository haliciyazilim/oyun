//
//  EQViewController.h
//  Equify
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "Reachability.h"

@interface EQViewController : UIViewController <GKGameCenterControllerDelegate>

@property (strong, nonatomic) Reachability *reachability;

- (IBAction)startNewGame:(id)sender;


@end
