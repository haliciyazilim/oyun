//
//  RMPhotoSelectionViewController.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/1/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMPhotoSelectionViewController.h"
#import "RMCustomImageView.h"
#import "RMInGameViewController.h"
#import "RMImage.h"
#import "Photo.h"
#import "UIView+Util.h"

@interface RMPhotoSelectionViewController ()

@end

@implementation RMPhotoSelectionViewController
{
    RMCustomImageView* touchedPhoto;
    Gallery* currentGallery;
}

-(id) init
{
    if(self = [super init]){
        
    }
    return self;
}

static RMPhotoSelectionViewController* lastInstance = nil;
+ (RMPhotoSelectionViewController*) lastInstance
{
    return lastInstance;
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    touchedPhoto = nil;
    /*<[[TEST*/
//        self.photos = [[NSMutableArray alloc] init];
    
//        [self.photos addObject:[UIImage imageNamed:@"test1.jpg"]];
//        [self.photos addObject:[UIImage imageNamed:@"test2.jpg"]];
//        [self.photos addObject:[UIImage imageNamed:@"test3.jpg"]];
//        [self.photos addObject:[UIImage imageNamed:@"test4.jpg"]];
//    
//        [self.photos addObject:[UIImage imageNamed:@"test6.jpg"]];
//        [self.photos addObject:[UIImage imageNamed:@"test7.jpg"]];
//        [self.photos addObject:[UIImage imageNamed:@"test8.jpg"]];
//    
//        [self.photos addObject:[UIImage imageNamed:@"test10.jpg"]];
//        [self.photos addObject:[UIImage imageNamed:@"test11.jpg"]];
//        [self.photos addObject:[UIImage imageNamed:@"test12.jpg"]];
//        [self.photos addObject:[UIImage imageNamed:@"test13.jpg"]];
//        [self.photos addObject:[UIImage imageNamed:@"test14.jpg"]];
    /*TEST]]>*/
    [self setGallery:[[Gallery allGalleries] objectAtIndex:0]];

    
}

- (void) setGallery:(Gallery*)gallery
{
    if(currentGallery != gallery){
        currentGallery = gallery;
        [self printPhotos];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshPhotos];
}

- (void) refreshPhotos
{
    [RMPhotoSelectionViewController setLastScroll:self.scrollView.contentOffset.x];
    NSArray* imageViews = [self.scrollView viewsByTag:PHOTO_SELECTION_IMAGEVIEW_TAG];
    for(UIImageView* imageView in imageViews ){
        [imageView removeFromSuperview];
    }
    [self printPhotos];
}

- (void) printPhotos
{
    int leftMargin = 20;
    int topMargin = 10;
    CGSize size = CGSizeMake(180, 120);
    CGSize photoSize = CGSizeMake(160, 120);
    CGSize scoreLabelSize = CGSizeMake(50, 25);
    CGSize imageScaleSize;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        imageScaleSize = CGSizeMake(photoSize.width*2, photoSize.height*2.0);
        
    } else {
        imageScaleSize = photoSize;
    }
    
    NSArray* photos = [currentGallery.photos allObjects];
    
    [self.scrollView setContentSize:CGSizeMake(leftMargin + photos.count * size.width,
                                               topMargin*2  + size.height)];
    
    [self.scrollView setContentOffset:CGPointMake([RMPhotoSelectionViewController getLastScroll], 0.0)];
    for(int i=0; i < [photos count]; i++){
        
        RMImage* originalImage = [(Photo*)[photos objectAtIndex:i] getImage];
        RMImage* tempImageForThumbnail;
        
        tempImageForThumbnail = [originalImage imageByScalingAndCroppingForSize:imageScaleSize];
        RMThumbnailImage* thumbnailImage;
        
        Score* score = [originalImage.owner getScoreForDifficulty:getCurrentDifficulty()];
        
        RMCustomImageView* photo;
        if(score == nil){
            thumbnailImage = [RMThumbnailImage thumbnailWithUIImage:[[tempImageForThumbnail imageWithGaussianBlur9] imageWithGaussianBlur9]];
            photo = [[RMCustomImageView alloc] initWithImage:thumbnailImage];
        }
        else{
            thumbnailImage = [RMThumbnailImage thumbnailWithUIImage:tempImageForThumbnail];
            photo = [[RMCustomImageView alloc] initWithImage:thumbnailImage];
            
            UILabel* scoreLabel = [[UILabel alloc] init];
            scoreLabel.frame = CGRectMake(photoSize.width - scoreLabelSize.width, photoSize.height - scoreLabelSize.height*1.5, scoreLabelSize.width, scoreLabelSize.height);
            scoreLabel.text = [score toText];
            scoreLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            [scoreLabel setTextColor:[UIColor whiteColor]];
            [scoreLabel setShadowColor:[UIColor blackColor]];
            [scoreLabel setShadowOffset:CGSizeMake(0,1)];
            [scoreLabel setTextAlignment:NSTextAlignmentCenter];
            [scoreLabel.layer setCornerRadius:5.0];
            [photo addSubview:scoreLabel];
        }
        
        thumbnailImage.originalImage = originalImage;
        
        photo.tag = PHOTO_SELECTION_IMAGEVIEW_TAG;
        photo.frame = CGRectMake(leftMargin+i*size.width, topMargin, photoSize.width, photoSize.height);
        [photo setContentMode:UIViewContentModeScaleAspectFill];
        [photo setClipsToBounds:YES];
        [photo setUserInteractionEnabled:YES];
//        photo.layer.borderColor = [UIColor colorWithPatternImage:photo.image].CGColor;
        photo.layer.borderColor = [UIColor grayColor].CGColor;
        photo.layer.borderWidth = 3.0f;
        [self.scrollView addSubview:photo];
        __block RMCustomImageView* blockPhoto = photo;
        [photo setTouchesBegan:^{
            if(touchedPhoto == nil){
                touchedPhoto = blockPhoto;
                [self performSegueWithIdentifier:@"StartGame" sender:self];
            }
        }];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RMInGameViewController* inGameView = [segue destinationViewController];
    [inGameView setImage:[(RMThumbnailImage*)touchedPhoto.image originalImage]];
    touchedPhoto = nil;
    
}


- (IBAction)difficultyChanged:(id)sender {
    UISegmentedControl* control = (UISegmentedControl*)sender;
    if([control selectedSegmentIndex] == 0){
        setCurrentDifficulty(EASY);
    }
    else if ([control selectedSegmentIndex] == 1){
        setCurrentDifficulty(NORMAL);
    }
    else if([control selectedSegmentIndex] == 2){
        setCurrentDifficulty(HARD);
    }
    
    [self refreshPhotos];

}

static int __lastScroll = 0;

+(int)getLastScroll
{
    return __lastScroll;
}

+(void)setLastScroll:(int)scroll{
    __lastScroll = scroll;
}


@end


