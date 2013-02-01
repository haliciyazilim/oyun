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

@interface RMPhotoSelectionViewController ()

@end

@implementation RMPhotoSelectionViewController
{
    RMCustomImageView* touchedPhoto;
}

-(id) init
{
    if(self = [super init]){
        
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    touchedPhoto = nil;
    /*<[[TEST*/
        self.photos = [[NSMutableArray alloc] init];
        [self.photos addObject:[UIImage imageNamed:@"test1.jpg"]];
        [self.photos addObject:[UIImage imageNamed:@"test2.jpg"]];
        [self.photos addObject:[UIImage imageNamed:@"test3.jpg"]];
        [self.photos addObject:[UIImage imageNamed:@"test4.jpg"]];
    /*TEST]]>*/
    
    [self printPhotos];
        
    
}

- (void) printPhotos
{
    int leftMargin = 20;
    int topMargin = 10;
    CGSize size = CGSizeMake(180, 120);
    CGSize photoSize = CGSizeMake(160, 120);
    
    [self.scrollView setContentSize:CGSizeMake(leftMargin*2 + self.photos.count * size.width,
                                               topMargin*2  + size.height)];
    
    for(int i=0; i < [self.photos count]; i++){
        RMCustomImageView* photo = [[RMCustomImageView alloc] initWithImage:[self.photos objectAtIndex:i]];
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

static BOOL isEasy = YES;
+ (BOOL) isEasy
{
    return  isEasy;
}
- (IBAction)difficultyChanged:(id)sender {
    UISegmentedControl* control = (UISegmentedControl*)sender;
    if([control selectedSegmentIndex] == 0){
        isEasy = YES;
    }
    else{
        isEasy = NO;
    }
}


@end


