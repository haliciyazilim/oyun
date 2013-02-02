//
//  RMInGameViewController.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 1/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMInGameViewController.h"
#import "RMPhotoSelectionViewController.h"

typedef void (^ IteratorBlock)();

@interface CroppedImageView : UIImageView
@property RMInGameViewController* parent;
- (void) rotateToAngle:(float)angle;
- (void) setRotationStateTo:(int)state;
- (int) getCurrentRotationState;
@end

@interface RMInGameViewController ()

@end

@implementation RMInGameViewController
{
    int rows;
    int cols;
    int tileSize;
    UIImage* currentImage;
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
        lastInstance = self;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    lastInstance = self;
    isGameFinished = NO;
    
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
}

- (void) setImage:(UIImage*)image
{
    if(currentImage != image){
        currentImage = image;
        [self configureView];
    }
}

- (IBAction)returnToPhotoSelection:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL) isGameFinished
{
    return isGameFinished;
}

- (BOOL) canGameFinish
{
    BOOL isFinished = YES;
    for(CroppedImageView* croppedImage in self.croppedImages){
        NSLog(@"state: %d",[croppedImage getCurrentRotationState]);
        if([croppedImage getCurrentRotationState] != 0)
            isFinished = NO;
    }
    return isFinished;
}

- (void) endGame
{
    isGameFinished = YES;
    for(CroppedImageView* croppedImage in self.croppedImages){
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
            CroppedImageView* imgView = [[CroppedImageView alloc] initWithImage:img];
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
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
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

@end


@implementation CroppedImageView
{
    BOOL isAnimating;
    float currentAngle;
}


-(id)initWithImage:(UIImage *)image
{
    if(self = [super initWithImage:image]){
        [self setUserInteractionEnabled:YES];
        currentAngle = 0;
    }
    return self;
}

-(void) rotateToAngle:(float)angle
{
    self.transform = CGAffineTransformMakeRotation(angle);
    currentAngle = angle;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isAnimating)
        return;
    isAnimating = YES;
    if([self.parent isGameFinished])
        return;
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGAffineTransform t1 = CGAffineTransformMakeScale(1.3, 1.3);
        currentAngle -= M_PI * 0.25;
        CGAffineTransform t2 = CGAffineTransformMakeRotation(currentAngle);
        self.transform = CGAffineTransformConcat(t1, t2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGAffineTransform t1 = CGAffineTransformMakeScale(1.0, 1.0);
            currentAngle -= M_PI * 0.25;
            CGAffineTransform t2 = CGAffineTransformMakeRotation(currentAngle);
            self.transform = CGAffineTransformConcat(t1, t2);
        } completion:^(BOOL finished){
            isAnimating = NO;
            [self.superview insertSubview:self belowSubview:[[RMInGameViewController lastInstance] grids]];
            if([self.parent canGameFinish]){
                NSLog(@"Game is finished");
                [self.parent endGame];
            }
        }];
    }];
}

-(void)setRotationStateTo:(int)state
{
    if(state < 0 || state > 3)
        return;
    currentAngle = M_PI * ((float)state / 2.0) ;
    [self rotateToAngle:currentAngle];
}

-(int)getCurrentRotationState
{
    if(isAnimating)
        return -2;
    
    float angle = currentAngle;
    
    while (angle < 0) {
        angle += M_PI * 2;
    }
    while(angle > M_PI * 2){
        angle -= M_PI * 2;
    }
    
    float error = 0.0001;
    int state = -1;
    
    if(angle >= 0-error && angle <= 0+error )
        state = 0;
    else if(angle >= M_PI*0.5-error && angle <= M_PI*0.5+error)
        state = 1;
    else if(angle >= M_PI*1.0-error && angle <= M_PI*1.0+error)
        state = 2;
    else if(angle >= M_PI*1.5-error && angle <= M_PI*1.5+error)
        state = 3;
    else if(angle >= M_PI*2.0-error && angle <= M_PI*2.0+error)
        state = 0;
    
    return state;
}

@end