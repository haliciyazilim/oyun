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
#import "RMPhotoSelectionImageView.h"

@interface RMPhotoSelectionViewController ()

@end

@implementation RMPhotoSelectionViewController
{
    RMCustomImageView* touchedPhoto;
    Gallery* currentGallery;
    NSArray* photos;
    CGSize imageScaleSize;
    NSMutableArray* imageThreads;
    
}

-(id) init
{
    if(self = [super init]){
        
    }
    return self;
}

- (IBAction)backButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES ];
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
    imageThreads = [[NSMutableArray alloc] init];
    
    [self.galleryNameLabel setText:currentGallery.name];
    [self.galleryNameLabel setFont:[UIFont fontWithName:@"TRMcLeanBold" size:20.0] ];
    
}

- (void) setGallery:(Gallery*)gallery
{
    if(currentGallery != gallery){
        currentGallery = gallery;
        photos = nil;
        [self printPhotos];
        [self processImageThreads];
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
    [self processImageThreads];
}

- (void) printPhotos
{
    int leftMargin = 20;
    int topMargin = 5;
    CGSize size = CGSizeMake(156, 116);
    CGSize photoSize = CGSizeMake(136, 102);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        imageScaleSize = CGSizeMake(photoSize.width*2, photoSize.height*2.0);
        
    } else {
        imageScaleSize = photoSize;
    }
    
    if(photos == nil){
        photos = [currentGallery allPhotos];
    }
    [self.scrollView setContentSize:CGSizeMake(leftMargin + ceil(photos.count / 2.0) * size.width,
                                               topMargin  + size.height*2.0)];
    
    [self.scrollView setContentOffset:CGPointMake([RMPhotoSelectionViewController getLastScroll], 0.0)];
    for(int i=0; i < [photos count]; i++){
        Photo* photo = (Photo*)[photos objectAtIndex:i];
        
        CGRect photoViewRect = CGRectMake(leftMargin+(i/2)*size.width, topMargin + (i%2) * size.height, photoSize.width, photoSize.height);
        
        RMPhotoSelectionImageView* photoView = [RMPhotoSelectionImageView viewWithPhoto:photo andFrame:photoViewRect andScaleSize:imageScaleSize];
        __block RMCustomImageView* blockPhotoView = photoView;
        [photoView setTouchesBegan:^{
            if(touchedPhoto == nil){
                touchedPhoto = blockPhotoView;
                [self performSegueWithIdentifier:@"StartGame" sender:self];
            }
        }];
        
        [self.scrollView addSubview:photoView];
                
    }
    
}


- (void) processImageThreads
{
    for(NSThread* thread in imageThreads){
        [thread start];
    }
    imageThreads = [[NSMutableArray alloc] init];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self processImageThreads];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RMInGameViewController* inGameView = [segue destinationViewController];
    [inGameView setImage:[[(RMImage*)touchedPhoto.image owner] getImage]];
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


- (void)viewDidUnload {
    [self setDifficultySegmentedButtons:nil];
    [self setGalleryNameLabel:nil];
    [super viewDidUnload];
}
@end


