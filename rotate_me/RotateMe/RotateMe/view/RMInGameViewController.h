//
//  RMInGameViewController.h
//  RotateMe
//
//  Created by Yunus Eren Guzel on 1/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMInGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoHolder;
@property UIImageView* grids;
+(RMInGameViewController*)lastInstance;
@end
