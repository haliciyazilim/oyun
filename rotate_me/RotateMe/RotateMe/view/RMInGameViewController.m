//
//  RMInGameViewController.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 1/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMInGameViewController.h"
#import "RMPhotoSelectionViewController.h"
#import "RMImage.h"



@interface RMInGameViewController ()

@end

@implementation RMInGameViewController
{
    int rows;
    int cols;
    int tileSize;
    RMImage* currentImage;
    BOOL isGameFinished;
    UIImageView* hiddenImage;
    int photoHolderTopPadding;
    int photoHolderLeftPadding;
    int scaleFactor;
}

+(RMInGameViewController *)lastInstance
{
    return lastInstance;
}

static RMInGameViewController* lastInstance = nil;

-(id) init
{
    if(self = [super init]){
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.jpg"]]];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        scaleFactor = 2;
        
    } else {
        scaleFactor = 1;
    }
    lastInstance = self;
    isGameFinished = NO;
    self.stopWatch = [[RMStopWatch alloc] init];
    
    if(getCurrentDifficulty() == EASY){
        rows = 3;
        cols = 4;
        tileSize = 90;
    }
    else if(getCurrentDifficulty() == NORMAL){
        rows = 4;
        cols = 6;
        tileSize = 61;
    }
    else if(getCurrentDifficulty() == HARD){
        rows = 6;
        cols = 8;
        tileSize = 45;
    }
    
    if(getCurrentDifficulty() == NORMAL){
        photoHolderTopPadding = 4;
        photoHolderLeftPadding = 6;
        [self.photoHolder setImage:[UIImage imageNamed:@"photo_holder_normal.png"]];
        self.photoHolder.frame = CGRectMake(self.photoHolder.frame.origin.x-6, self.photoHolder.frame.origin.y+10, self.photoHolder.image.size.width, self.photoHolder.image.size.height);
    }
    else{
        photoHolderTopPadding = 5;
        photoHolderLeftPadding = 7;
    }
    
    hiddenImage = [[UIImageView alloc] initWithImage:currentImage];
    hiddenImage.frame = CGRectMake(photoHolderLeftPadding, photoHolderTopPadding, cols * tileSize, rows * tileSize);
    [self.photoHolder addSubview:hiddenImage];
    [hiddenImage setClipsToBounds:YES];
    [hiddenImage setContentMode:UIViewContentModeScaleAspectFill];
    
    UIImageView* grids;
    if(getCurrentDifficulty() == EASY){
        grids = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_double_grid.png"]];
    }else if(getCurrentDifficulty() == HARD){
        grids = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_grid.png"]];
    } else if(getCurrentDifficulty() == NORMAL){
        grids = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_grid_normal.png"]];
        
    }
    grids.frame = CGRectMake(photoHolderLeftPadding, photoHolderTopPadding, grids.image.size.width, grids.image.size.height);
    grids.alpha = 0.5;
    [self.photoHolder addSubview:grids];
    self.grids = grids;
    
    [self configureView];
    [self.stopWatchLabel setFont:[UIFont fontWithName:@"TRMcLean" size:20]];
    [self.stopWatchLabel setText:@"00:00"];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.stopWatch startTimerWithRepeatBlock:^{
        [self.stopWatchLabel setText:[self.stopWatch toStringWithoutMiliseconds]];
    }];
}

- (void) setImage:(RMImage*)image
{
    if(currentImage != image){
        currentImage = image;
        [self configureView];
    }
}

- (BOOL) isGameFinished
{
    return isGameFinished;
}

- (BOOL) canGameFinish
{
    BOOL isFinished = YES;
    for(RMCroppedImageView* croppedImage in self.croppedImages){
        if([croppedImage getCurrentRotationState] != 0)
            isFinished = NO;
    }
    return isFinished;
}

- (void) endGame
{
    isGameFinished = YES;
    [self.stopWatch stopTimer];
    [currentImage.owner setScore:[self.stopWatch getElapsedSeconds] forDifficulty:getCurrentDifficulty()];
    
    for(RMCroppedImageView* croppedImage in self.croppedImages){
        [croppedImage removeFromSuperview];
    }
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationCurveEaseIn animations:^{
        self.grids.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        CGRect initialFrame = hiddenImage.frame;
        [UIView animateWithDuration:0.5 animations:^{
            hiddenImage.frame = CGRectMake(initialFrame.origin.x - initialFrame.size.width*0.035, initialFrame.origin.y - initialFrame.size.height*0.035, initialFrame.size.width*1.07, initialFrame.size.height*1.07);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                hiddenImage.frame = initialFrame;
            }];
        }];
    }];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) configureView
{
    CGSize canvasSize = CGSizeMake(cols * tileSize * scaleFactor, rows * tileSize * scaleFactor);
    
    NSMutableArray* croppedImages = [[NSMutableArray alloc] init];
    
    UIImage* resizedImage = [currentImage imageByScalingAndCroppingForSize:canvasSize];
    for(int x=0; x<cols; x++){
        for(int y=0; y<rows; y++){
            CGRect rect;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)) {
                rect = CGRectMake(x*tileSize*2, y*tileSize*2, tileSize*2, tileSize*2);
            } else {
                rect = CGRectMake(x*tileSize, y*tileSize, tileSize, tileSize);
            }
            
            CGImageRef imageRef = CGImageCreateWithImageInRect([resizedImage CGImage], rect);
            UIImage *img = [UIImage imageWithCGImage:imageRef];
            RMCroppedImageView* imgView = [[RMCroppedImageView alloc] initWithImage:img];
            imgView.frame = CGRectMake(photoHolderLeftPadding+x*tileSize, photoHolderTopPadding+y*tileSize, tileSize, tileSize);
            
            if(arc4random()%100 < 10)
                [imgView setRotationStateTo: M_PI * 0.0];
            else if(arc4random()%100 < 40)
                [imgView setRotationStateTo: M_PI * 0.5];
            else if(arc4random()%100 < 70)
                [imgView setRotationStateTo: M_PI * 1.0];
            else if(arc4random()%100 < 100)
                [imgView setRotationStateTo: M_PI * 1.5];

            [self.photoHolder addSubview:imgView];
            [self.photoHolder insertSubview:imgView belowSubview:self.grids];
            imgView.parent = self;
            [croppedImages addObject:imgView];
                        
        }
    }
    self.croppedImages = croppedImages;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setStopWatchLabel:nil];
    [super viewDidUnload];
}

- (IBAction)displayMenu:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end


