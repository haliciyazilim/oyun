//
//  RMInGameIPadViewController.m
//  RotateMe
//
//  Created by Eren Halici on 07.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMInGameIPadViewController.h"
#import "RMPhotoSelectionIPadViewController.h"
#import "RMImage.h"

@interface RMInGameIPadViewController ()

@end

@implementation RMInGameIPadViewController
{
    
}

+(RMInGameIPadViewController *)lastInstance
{
    return lastInstance;
}

static RMInGameIPadViewController* lastInstance = nil;


- (int) tileSize {
    if(getCurrentDifficulty() == EASY){
        return 198;
    }
    else if(getCurrentDifficulty() == NORMAL){
        return 122;
    }
    else {
        return 99;
    }
}

- (int) photoHolderTopPadding {
    if(getCurrentDifficulty() == NORMAL) {
        return 4;
    } else {
        return 11;
    }
}

- (CGFloat) timerFontSize
{
    return 34.0;
}

- (int) photoHolderLeftPadding {
    if(getCurrentDifficulty() == NORMAL) {
        return 6;
    } else {
        return 16;
    }
}

- (UIImageView *) createGridView {
    
    return nil;
    
    if(getCurrentDifficulty() == EASY){
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_double_grid.png"]];
    }else if(getCurrentDifficulty() == HARD){
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_grid.png"]];
    } else {
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_grid_normal.png"]];
    }
}
- (void) setBackground {
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.jpg"]]]; 
}

@end


