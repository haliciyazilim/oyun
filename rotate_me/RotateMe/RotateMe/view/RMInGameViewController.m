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
    lastInstance = self;
    isGameFinished = NO;
    self.stopWatch = [[RMStopWatch alloc] init];
    
    if([RMPhotoSelectionViewController isEasy]){
        rows = 3;
        cols = 4;
        tileSize = 90;
    }
    else{
        rows = 6;
        cols = 8;
        tileSize = 45;
    }
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.jpg"]]];
    
    hiddenImage = [[UIImageView alloc] initWithImage:currentImage];
    hiddenImage.frame = CGRectMake(7, 5, 374-5-9, 284-7-7);
    [self.photoHolder addSubview:hiddenImage];
    [hiddenImage setClipsToBounds:YES];
    [hiddenImage setContentMode:UIViewContentModeScaleAspectFill];
    
    UIImageView* grids;
    if([RMPhotoSelectionViewController isEasy]){
        grids = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_double_grid.png"]];
    }else{
        grids = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_grid.png"]];
    }
    grids.frame = CGRectMake(7, 5, grids.image.size.width, grids.image.size.height);
    grids.alpha = 0.5;
    [self.photoHolder addSubview:grids];
    self.grids = grids;
    
    [self configureView];
    [self.stopWatchLabel setText:@"00:00.0"];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.stopWatch startTimerWithRepeatBlock:^{
        [self.stopWatchLabel setText:[self.stopWatch toString]];
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
    CGSize canvasSize;
    
    NSMutableArray* croppedImages = [[NSMutableArray alloc] init];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        canvasSize = CGSizeMake(720, 540);
        
    } else {
        canvasSize = CGSizeMake(360, 270);
    }
    UIImage* resizedImage = [self imageByScalingAndCropping:currentImage forSize:canvasSize];
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
            imgView.frame = CGRectMake(7+x*tileSize, 5+y*tileSize, tileSize, tileSize);
            
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

- (UIImage*)imageByScalingAndCropping:(UIImage*)sourceImage forSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else {
            if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
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

- (IBAction)displayHelp:(id)sender {
}
@end


