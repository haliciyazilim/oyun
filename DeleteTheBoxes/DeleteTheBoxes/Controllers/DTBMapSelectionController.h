//
//  DTBMapSelectionController.h
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 05.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface DTBMapSelectionController : UIViewController <GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)createMatch:(id)sender;

@end
