//
//  RMPhotoSelectionImageView.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/7/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMPhotoSelectionImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#import "RMImage.h"

@implementation RMPhotoSelectionImageView
{
    CGSize imageScaleSize;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (RMPhotoSelectionImageView *)viewWithPhoto:(Photo *)photo andFrame:(CGRect)frame andScaleSize:(CGSize)imageScaleSize
{
    RMPhotoSelectionImageView* photoView = [[RMPhotoSelectionImageView alloc] initWithPhoto:photo andFrame:frame andScaleSize:imageScaleSize];
    return photoView;
}
- (id) initWithPhoto:(Photo *)photo andFrame:(CGRect)frame andScaleSize:(CGSize)_imageScaleSize
{
    imageScaleSize = _imageScaleSize;
    if(self = [super init]){
        self.tag = PHOTO_SELECTION_IMAGEVIEW_TAG;
        self.frame = frame;
        [self setContentMode:UIViewContentModeScaleAspectFill];
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2.0f;
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOffset:CGSizeMake(0.0, 5.0)];
        
        UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] init];
        activityIndicator.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [activityIndicator startAnimating];
        [self addSubview:activityIndicator];
        
        self.layer.masksToBounds = NO;
//        self.layer.cornerRadius = 8; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowRadius = 6;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.5;
        
        [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:CGRectMake(5, 5, frame.size.width, frame.size.height)] CGPath]];
        
        

        Score* score = [photo getScoreForDifficulty:getCurrentDifficulty()];
        if(score != nil){
            UIImageView* gradient = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_gradient.png"]];
            gradient.frame = CGRectMake(0, frame.size.height - gradient.image.size.height, frame.size.width, gradient.image.size.height);
            [self addSubview:gradient];
            CGSize scoreLabelSize = CGSizeMake(50, 25);
            
            UILabel* scoreLabel = [[UILabel alloc] init];
            scoreLabel.frame = CGRectMake(10, frame.size.height - scoreLabelSize.height*1.0, scoreLabelSize.width, scoreLabelSize.height);
            scoreLabel.text = [score toText];
            scoreLabel.backgroundColor = [UIColor clearColor];
            [scoreLabel setTextColor:[UIColor whiteColor]];
            [scoreLabel setShadowColor:[UIColor blackColor]];
            [scoreLabel setShadowOffset:CGSizeMake(0,1)];
            [scoreLabel setFont:[UIFont fontWithName:@"TR McLean" size:14.0]];
            
            [scoreLabel setTextAlignment:NSTextAlignmentLeft];
            [self addSubview:scoreLabel];
        }
        
        [[[NSThread alloc] initWithTarget:self selector:@selector(loadImageForView:) object:[NSArray arrayWithObjects:photo,activityIndicator, nil]] start];
    }
    return self;
}

- (void) loadImageForView:(NSArray*)params
{
    Photo* photo = [params objectAtIndex:0];
    UIActivityIndicatorView* activityIndicator = [params objectAtIndex:1];
    
    RMImage* originalImage = [photo getImage];
    if([photo getThumbnailImage] == nil){
        [photo setThumbnailImage:[originalImage imageByScalingAndCroppingForSize:imageScaleSize]];
    }
    self.image = [photo getThumbnailImage];
    
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
}


@end
