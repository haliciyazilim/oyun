//
//  RMGallerySelectionViewController.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/6/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMGallerySelectionViewController.h"
#import "Gallery.h"
#import "RMGallerySelectionItemView.h"
#import "RMPhotoSelectionViewController.h"
#import "Config.h"

@interface RMGallerySelectionViewController ()

@end

@implementation RMGallerySelectionViewController
{
    Gallery* touchedGallery;
    BOOL isFirstLoad;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirstLoad = YES;
    touchedGallery = nil;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selection_bg.png"]]];
	// Do any additional setup after loading the view.
    [self.view setUserInteractionEnabled:YES];
    [self.scrollView setUserInteractionEnabled:YES];
    
    
}

- (CGSize) scrollViewItemSize{
    return CGSizeMake(250,150);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RMPhotoSelectionViewController* photoSelectionViewController = [segue destinationViewController];
    [photoSelectionViewController setGallery:touchedGallery];
    touchedGallery = nil;
}


-(void)viewWillAppear:(BOOL)animated
{
    NSArray* allGaleries = [Gallery allGalleries];
    int index = 0;
    int topMargin = 30;
    
    
    for(UIView* view in [self.scrollView subviews]){
        if(view.tag == GALLERY_SELECTION_GALLERY_ITEM_TAG){
            [view removeFromSuperview];
        }
    }
    
    for(Gallery* gallery in allGaleries){
        RMGallerySelectionItemView* galleryItem = [[RMGallerySelectionItemView alloc] initWithGallery:gallery animate:isFirstLoad];
        [self.scrollView addSubview:galleryItem];
        galleryItem.tag = GALLERY_SELECTION_GALLERY_ITEM_TAG;
        galleryItem.frame = CGRectMake(
                                       [self scrollViewItemSize].width * index,
                                       topMargin,
                                       galleryItem.frame.size.width,
                                       galleryItem.frame.size.height);
        [galleryItem setUserInteractionEnabled:YES];
        
        [galleryItem setTouchesBegan:^{
            if(touchedGallery != nil)
                return;
            touchedGallery = gallery;
            [self performSegueWithIdentifier:@"OpenPhotoSelection" sender:self];
            
        }];
        index++;
    }

    touchedGallery = nil;
    isFirstLoad = NO;
    
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
