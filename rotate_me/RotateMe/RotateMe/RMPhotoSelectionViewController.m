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
    NSArray* photos;
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
    [self setGallery:[[Gallery allGalleries] objectAtIndex:0]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selection_bg.png"]]];
    
    DIFFICULTY difficulty = getCurrentDifficulty();
    switch (difficulty) {
        case EASY:
            [self.difficultySegmentedButtons setSelectedSegmentIndex:0];
            break;
        case NORMAL:
            [self.difficultySegmentedButtons setSelectedSegmentIndex:1];
            break;
        case HARD:
            [self.difficultySegmentedButtons setSelectedSegmentIndex:2];
            break;
            
        default:
            break;
    }
    
    
    [self.galleryNameLabel setText:currentGallery.name];
    [self.galleryNameLabel setFont:[UIFont fontWithName:@"TRMcLeanBold" size:20.0] ];
    
    
}

- (void) setGallery:(Gallery*)gallery
{
    if(currentGallery != gallery){
        currentGallery = gallery;
        photos = nil;
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
    CGSize size = CGSizeMake(146, 112);
    CGSize photoSize = CGSizeMake(136, 102);
    CGSize scoreLabelSize = CGSizeMake(50, 25);
    CGSize imageScaleSize;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        imageScaleSize = CGSizeMake(photoSize.width*2, photoSize.height*2.0);
        
    } else {
        imageScaleSize = photoSize;
    }
    
    
    if(photos == nil){
        photos = [currentGallery.photos allObjects];
    }
    [self.scrollView setContentSize:CGSizeMake(leftMargin + ceil(photos.count / 2.0) * size.width,
                                               topMargin  + size.height*2.0)];
    
    [self.scrollView setContentOffset:CGPointMake([RMPhotoSelectionViewController getLastScroll], 0.0)];
    for(int i=0; i < [photos count]; i++){
        Photo* photo = (Photo*)[photos objectAtIndex:i];
        RMImage* originalImage = [photo getImage];
        if([photo getThumbnailImage] == nil){
            [photo setThumbnailImage:[originalImage imageByScalingAndCroppingForSize:imageScaleSize]];
            
        }
        Score* score = [originalImage.owner getScoreForDifficulty:getCurrentDifficulty()];
        
        RMCustomImageView* photoView = [[RMCustomImageView alloc] initWithImage:[photo getThumbnailImage]];
        
        if(score == nil){
//            photo.thumbnailImage = [[[photo getThumbnailImage] imageWithGaussianBlur9] imageWithGaussianBlur9];
        }
        else
        {
            UIImageView* gradient = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_gradient.png"]];
            gradient.frame = CGRectMake(0, photoSize.height - gradient.image.size.height, photoSize.width, gradient.image.size.height);
            [photoView addSubview:gradient];
            
            UILabel* scoreLabel = [[UILabel alloc] init];
            scoreLabel.frame = CGRectMake(10, photoSize.height - scoreLabelSize.height*1.0, scoreLabelSize.width, scoreLabelSize.height);
            scoreLabel.text = [score toText];
            scoreLabel.backgroundColor = [UIColor clearColor];
            [scoreLabel setTextColor:[UIColor whiteColor]];
            [scoreLabel setShadowColor:[UIColor blackColor]];
            [scoreLabel setShadowOffset:CGSizeMake(0,1)];
            [scoreLabel setFont:[UIFont fontWithName:@"TR McLean" size:14.0]];
            
            [scoreLabel setTextAlignment:NSTextAlignmentLeft];
            [photoView addSubview:scoreLabel];
        }
        
        photoView.tag = PHOTO_SELECTION_IMAGEVIEW_TAG;
        photoView.frame = CGRectMake(leftMargin+(i/2)*size.width, topMargin + (i%2) * size.height, photoSize.width, photoSize.height);
        [photoView setContentMode:UIViewContentModeScaleAspectFill];
        [photoView setClipsToBounds:YES];
        [photoView setUserInteractionEnabled:YES];
        photoView.layer.borderColor = [UIColor whiteColor].CGColor;
        photoView.layer.borderWidth = 2.0f;
        [photoView.layer setShadowColor:[UIColor blackColor].CGColor];
        [photoView.layer setShadowOffset:CGSizeMake(0.0, 5.0)];
        [self.scrollView addSubview:photoView];
        __block RMCustomImageView* blockPhotoView = photoView;
        [photoView setTouchesBegan:^{
            if(touchedPhoto == nil){
                touchedPhoto = blockPhotoView;
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
    [inGameView setImage:[[(RMImage*)touchedPhoto.image owner] getImage]];
    touchedPhoto = nil;
    
}


- (IBAction)difficultyChanged:(id)sender {
    
//    [[NSUserDefaults standardUserDefaults] setObject:[self sha1:productDeviceStr] forKey:productIdentifier];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
//[[NSUserDefaults standardUserDefaults] stringForKey:productIdentifier]    
    
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


- (void)viewDidUnload {
    [self setDifficultySegmentedButtons:nil];
    [self setGalleryNameLabel:nil];
    [super viewDidUnload];
}
@end


