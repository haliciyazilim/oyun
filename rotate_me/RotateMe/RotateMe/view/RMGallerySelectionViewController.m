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
#import "RotateMeIAPHelper.h"
#import "Photo.h"
#import "RMSettingsView.h"
#import "RotateMeIAPHelper.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(configureViews)
                                                 name:kPhotoNotificationPhotoCreated
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(configureViews)
                                                 name:kPhotoNotificationPhotoDeleted
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(configureViews)
                                                 name:IAPHelperProductPurchasedNotification
                                               object:nil];
    
    [self configureViews];
    [self setBackground];
    isFirstLoad = YES;
    touchedGallery = nil;
    // Do any additional setup after loading the view.
    [self.view setUserInteractionEnabled:YES];
    [self.scrollView setUserInteractionEnabled:YES];
}

-(void) setBackground
{
    if([[UIScreen mainScreen] bounds].size.height == 568){
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selection_bg-568h.png"]]];
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selection_bg.png"]]];
        
    }
	
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

- (void) configureViews {
    NSArray* allGaleries = [Gallery allGalleries];
    int index = 0;
    int topMargin = 30;
    
    
    for(UIView* view in [self.scrollView subviews]){
        if(view.tag == GALLERY_SELECTION_GALLERY_ITEM_TAG){
            [view removeFromSuperview];
        }
    }
    
    for(Gallery* gallery in allGaleries){
        RMGallerySelectionItemView* galleryItem = [self generateGallerySelectionItemViewWithGallery:gallery animate:YES];
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
            if(gallery.isPurchased){
                touchedGallery = gallery;
                [self performSegueWithIdentifier:@"OpenPhotoSelection" sender:self];
            }else{
                [[RotateMeIAPHelper sharedInstance] showProduct:gallery onViewController:self];    
            }
         
        }];
        index++;
        if(gallery.isPurchased == NO){
            [galleryItem setLocked];
        }
    }
    
    touchedGallery = nil;

}


- (RMGallerySelectionItemView*) generateGallerySelectionItemViewWithGallery:(Gallery*)gallery animate:(BOOL)animate
{
    return [[RMGallerySelectionItemView alloc] initWithGallery:gallery animate:YES];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    isFirstLoad = NO;
}

- (IBAction)openSettings:(id)sender {
    RMSettingsView* settings = [[RMSettingsView alloc] init];
    [self.view addSubview:settings];
}
@end
