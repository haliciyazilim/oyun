//
//  RMGallerySelectionItemView.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/11/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMGallerySelectionItemView.h"
#import "Photo.h"
#import "RMImage.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"

@implementation RMGallerySelectionItemView
{
    Gallery* gallery;
    NSMutableArray* galleryPhotos;
    NSMutableArray* imageViews;
    int scaleFactor;
    NSString* galleryName;
    BOOL shouldAnimate;
}


- (id) initWithGallery:(Gallery*) _gallery animate:(BOOL)animate
{
    if(self = [super init]){
        gallery = _gallery;
        shouldAnimate = animate;
        galleryName = gallery.name;
        galleryPhotos = [[NSMutableArray alloc] init];
        NSArray* photos = [gallery allPhotos];
        int length = [photos count] < 3 ? [photos count] : 3;
        for(int i=0;i<length;i++){
            [galleryPhotos addObject:[photos objectAtIndex:i]];
        }
        self.frame = [self getGallleryItemFrame];
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            scaleFactor = 2;
            
        } else {
            scaleFactor = 1;
        }
        [[[NSThread alloc] initWithTarget:self selector:@selector(loadImages) object:nil] start];
    }
    return self;
}

- (void) loadImages
{
    imageViews = [[NSMutableArray alloc] init];
    UIImage* maskImage = [UIImage imageNamed:@"gallery_selection_mask.png"];
    for(Photo* photo in galleryPhotos){
        UIImageView* borderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gallery_selection_bg.png"]];
        borderImageView.frame = [self getBorderImageViewFrame];
        if(shouldAnimate)
            borderImageView.alpha = 0.0;
        
        [imageViews addObject:borderImageView];
        UIImage* image = [[photo getImage] imageByScalingAndCroppingForSize:CGSizeMake([self getPhotoImageSize].width * 2, [self getPhotoImageSize].height * 2)];
        UIImageView* photoImageView = [[UIImageView alloc] initWithImage:image];
        
        photoImageView.frame = [self getPhotoImageFrame];
        [photoImageView setClipsToBounds:YES];
        [photoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [borderImageView addSubview:photoImageView];
        [self addSubview:borderImageView];
    }
    
    if([imageViews count] == 0){
        UIImageView* borderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gallery_selection_bg.png"]];
        borderImageView.frame = [self getBorderImageViewFrame];
        if(shouldAnimate)
            borderImageView.alpha = 0.0;
        [imageViews addObject:borderImageView];
        [self addSubview:borderImageView];
     }
    
    
    UILabel* galleryNameLabel = [[UILabel alloc] initWithFrame:[self getGalleryNameLabelFrame]];
    [galleryNameLabel setText:galleryName];
    [galleryNameLabel setBackgroundColor:[UIColor clearColor]];
    [galleryNameLabel setTextAlignment:NSTextAlignmentCenter];
    [galleryNameLabel setFont:[UIFont fontWithName:@"TRMcLeanBold" size:13.0]];
    [galleryNameLabel setTextColor:BROWN_TEXT_COLOR];
    [galleryNameLabel setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.20]];
    [galleryNameLabel setShadowOffset:CGSizeMake(0, 1)];
    
    for(int i=0;i<[imageViews count];i++){
        UIImageView* view = [imageViews objectAtIndex:i];
        int rand = arc4random();
        CGFloat angle = ((abs(rand) % 128)/128.0) * (M_PI/36) + M_PI/36;
        
        UIImageView* maskImageView = [[UIImageView alloc] initWithImage:maskImage];
        [view addSubview:maskImageView];
        
        if(i == 0){
            [view addSubview:galleryNameLabel];
            view.transform = CGAffineTransformTranslate(view.transform, 15, 0);
            [maskImageView setAlpha:0.0];
        }
        if(i == 1){
            [view.superview insertSubview:view belowSubview:[imageViews objectAtIndex:0]];
            view.transform = CGAffineTransformTranslate(view.transform, 0, 0);
            view.transform = CGAffineTransformRotate(view.transform, -angle);
            [maskImageView setAlpha:0.13];
        }
        if(i == 2){
            [view.superview insertSubview:view belowSubview:[imageViews objectAtIndex:1]];
            view.transform = CGAffineTransformTranslate(view.transform, 30, 10);
            view.transform = CGAffineTransformRotate(view.transform, angle);
            [maskImageView setAlpha:0.20];
            
        }
        [view.layer setShouldRasterize:YES];
    }
    if(shouldAnimate)
        [self performSelectorOnMainThread:@selector(showViews) withObject:nil waitUntilDone:NO];
}

-(void)showViews
{
    for(int i=0;i<[imageViews count];i++){
        UIImageView* view = [imageViews objectAtIndex:i];
        [UIView animateWithDuration:0.3 delay:0.9 - 0.3*i options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [view setAlpha:1.0];
        } completion:^(BOOL finished) {}];
    }
}

-(CGRect) getBorderImageViewFrame
{
    return CGRectMake(30,20,292/2,270/2);
}

-(CGSize) getPhotoImageSize
{
    return CGSizeMake(272/2, 208/2);
}

-(CGRect) getPhotoImageFrame
{
    return CGRectMake(5, 5, [self getPhotoImageSize].width, [self getPhotoImageSize].height);
}

-(CGRect) getGallleryItemFrame
{
    return CGRectMake(0, 0, 300, 200);
}

-(CGRect) getGalleryNameLabelFrame
{
    return CGRectMake(0, [self getBorderImageViewFrame].size.height - 28, [self getBorderImageViewFrame].size.width, 27);
}


@end
