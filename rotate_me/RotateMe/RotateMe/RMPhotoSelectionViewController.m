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
#import "Photo.h"

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


- (void) printPhotos
{
    int leftMargin = 20;
    int topMargin = 10;
    CGSize size = CGSizeMake(180, 120);
    CGSize photoSize = CGSizeMake(160, 120);
    
    
    NSArray* photos = [currentGallery.photos allObjects];
    
    [self.scrollView setContentSize:CGSizeMake(leftMargin*2 + photos.count * size.width,
                                               topMargin*2  + size.height)];
    
    for(int i=0; i < [photos count]; i++){
        RMCustomImageView* photo = [[RMCustomImageView alloc] initWithImage:[(Photo*)[photos objectAtIndex:i] getImage]];
        photo.frame = CGRectMake(leftMargin+i*size.width, topMargin, photoSize.width, photoSize.height);
        [photo setContentMode:UIViewContentModeScaleAspectFill];
        [photo setClipsToBounds:YES];
        [photo setUserInteractionEnabled:YES];
        photo.layer.borderColor = [UIColor colorWithPatternImage:photo.image].CGColor;
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
//    NSLog(@"segue started");
//    RMCustomImageView* photo = (RMCustomImageView*)segue;
    RMInGameViewController* inGameView = [segue destinationViewController];
    [inGameView setImage:touchedPhoto.image];
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

}


@end


