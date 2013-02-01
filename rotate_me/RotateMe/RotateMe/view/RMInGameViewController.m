//
//  RMInGameViewController.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 1/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMInGameViewController.h"


typedef void (^ IteratorBlock)();



@interface CroppedImageView : UIImageView
-(void) rotateToAngle:(float)angle;
@end



@interface RMInGameViewController ()

@end

@implementation RMInGameViewController
{
    int rows;
    int cols;
    int tileSize;
    NSArray* croppedImages;
    UIImage* currentImage;
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
    
    rows = 6;
    cols = 8;
    
    tileSize = 45;
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.jpg"]]];
    
        
    UIImageView* grids = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_grid.png"]];
    
    grids.frame = CGRectMake(7, 5, grids.image.size.width, grids.image.size.height);
    grids.alpha = 0.5;
    [self.photoHolder addSubview:grids];
    self.grids = grids;
    
    [self configureView];
	// Do any additional setup after loading the view.
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



- (void) configureView
{
    
    CGSize canvasSize;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        canvasSize = CGSizeMake(720, 540);
        
    } else {
        canvasSize = CGSizeMake(360, 270);
    }
//    NSLog(@"canvasSize w:%f h:%f",canvasSize.width,canvasSize.height);
    UIImage* resizedImage = [self imageByScalingAndCropping:currentImage forSize:canvasSize];
//    UIImage* resizedImage = currentImage;
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
            if((x+y)%2 == 0)
                [imgView rotateToAngle:M_PI*0.5];
            [self.photoHolder addSubview:imgView];
            [self.photoHolder insertSubview:imgView belowSubview:self.grids];
                        
        }
    }
    
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isAnimating)
        return;
    isAnimating = YES;
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
        }];
    }];
}

@end
