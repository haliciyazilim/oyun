//
//  RotateMeIAPHelper.m
//  RotateMe
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RotateMeIAPHelper.h"
#import "RotateMeIAPSpecificValues.h"
#import "Gallery.h"
#import <QuartzCore/QuartzCore.h>


@implementation RotateMeIAPHelper
{
    NSString *currentProductIdentifier;
    UIView *currentStore;
    UILabel *descriptionLabel;
    UILabel *priceLabel;
    UIActivityIndicatorView *activity;
}

+ (RotateMeIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RotateMeIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSDictionary *products = @{iYourGalleryKey : iYourGallerySecret,
                                   iSportsGalleryKey : iSportsGallerySecret};
        sharedInstance = [[self alloc] initWithProductsDictionary:products];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(productPurchaseCompleted:) name:IAPHelperProductPurchasedNotification object:nil];
    });
    return sharedInstance;
}

- (void)productPurchaseCompleted:(NSNotification *)notif {
//    [self closeStore];
//    if(!isAlertShown){
//        UIAlertView *productPurchased = [[UIAlertView alloc] initWithTitle:@""
//                                                                   message:NSLocalizedString(@"PRODUCT_PURCHASED", nil)
//                                                                  delegate:self
//                                                         cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                                                         otherButtonTitles:nil,nil];
//        [productPurchased show];
//        isAlertShown = YES;
//        
//        int count = 0;
//        for (Map *map in [[DatabaseManager sharedInstance] getAllMaps]) {
//            
//            if ([map isFinished]) {
//                count++;
//            }
//        }
//        
//        [[AchievementManager sharedAchievementManager] submitAchievement:kAchievementBeAPro percentComplete:100.00];
//        
//        [Flurry logEvent:kFlurryEventUnlockFullGame
//          withParameters:@{@"Solved Map Count" : [NSNumber numberWithInt:count]}];
//    }
}
- (void) showProduct:(Gallery*)gallery onViewController:(UIViewController*) viewController
{
    CGFloat currentScreenWidth = [[UIScreen mainScreen] bounds].size.height;
    CGFloat currentScreenHeight = [[UIScreen mainScreen] bounds].size.width;
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [activity setColor:[UIColor blackColor]];
    [activity setHidesWhenStopped:YES];
    [activity startAnimating];
    activity.frame = CGRectMake(241.0, 115.0, 60.0, 60.0);
    
    CGRect frame = viewController.view.frame;
    currentProductIdentifier = [NSString stringWithString:gallery.name];
    
    currentStore = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x,frame.origin.y,frame.size.height,frame.size.width)];
    if(currentScreenWidth == 568){
        [currentStore setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inapp_bg-568h.png"]]];
    }
    else{
        [currentStore setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inapp_bg.png"]]];
    }
    
    UIView *storeContainer = [[UIView alloc] initWithFrame:CGRectMake((currentScreenWidth-438.0)*0.5, (currentScreenHeight-278.0)*0.5, 438.0, 278.0)];
    [storeContainer setBackgroundColor:[UIColor clearColor]];
    
    // alloc, init and customize description label here
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(219.0, 65.0, 219.0, 106.0)];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionLabel setNumberOfLines:7];
    [descriptionLabel setFont:[UIFont fontWithName:@"TRMcLean" size:18.0]];
    [descriptionLabel setTextColor:[UIColor whiteColor]];
    [descriptionLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
    [descriptionLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    // alloc, init and customize price label here
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    
    // alloc, init, customize and add target to buy button here
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setFrame:CGRectMake(219.0, 215.0, 97.0, 34.0)];
    [buyButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    buyButton.layer.cornerRadius = 7.0;
    
    [buyButton addTarget:self action:@selector(buyCurrentProduct) forControlEvents:UIControlEventTouchUpInside];
    
    // alloc, init, customize and add target to close button here
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(415.0, 0.0, 21.0, 21.0)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"delete_photo_btn.png"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"delete_photo_btn.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeStore) forControlEvents:UIControlEventTouchUpInside];
    
    [storeContainer addSubview:activity];
    [storeContainer addSubview:descriptionLabel];
    [storeContainer addSubview:priceLabel];
    [storeContainer addSubview:buyButton];
    [storeContainer addSubview:closeButton];
    
    [currentStore addSubview:storeContainer];
    
    [viewController.view addSubview:currentStore];
    
    if (!self.products) {
        [self requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            NSLog(@"%d products found",[products count]);
            self.products = products;
            [self productBlock];
        }];
    } else {
        [self productBlock];
    }
}
- (void) productBlock {
    [activity stopAnimating];
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    SKProduct *myProduct = [self getProductWithProductIdentifier:currentProductIdentifier];
    
    NSLog(@"%@",self.products);
    
    [priceFormatter setLocale:myProduct.priceLocale];
    
    NSString *priceStr = [priceFormatter stringFromNumber:[myProduct price]];
    NSString *descriptionStr = [myProduct localizedDescription];
    
    [descriptionLabel setText:descriptionStr];
    [priceLabel setText:priceStr];
}
- (SKProduct *) getProductWithProductIdentifier:(NSString *)productIdentifier {
    for (SKProduct* product in self.products) {
        NSLog(@"%@, and %@",productIdentifier, product.productIdentifier);
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            return product;
        }
    }
    return nil;
}
- (void)closeStore {
    activity = nil;
    priceLabel = nil;
    descriptionLabel = nil;
    [currentStore removeFromSuperview];
    currentStore = nil;

    currentProductIdentifier = nil;
}
- (void) buyCurrentProduct {
    if([[RotateMeIAPHelper sharedInstance] canMakePurchases]){
        [[RotateMeIAPHelper sharedInstance] buyProduct:[[RotateMeIAPHelper sharedInstance] getProductWithProductIdentifier:currentProductIdentifier]];
    }
    else{
        UIAlertView *couldNotMakePurchasesAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"IN_APP_PURCHASES", nil)
                 message:NSLocalizedString(@"COULD_NOT_MAKE_PURCHASES", nil)
                delegate:self
       cancelButtonTitle:NSLocalizedString(@"OK", nil)
       otherButtonTitles:nil,nil];
        [couldNotMakePurchasesAlert show];
    }
}

- (void)restorePurchases {
    [[RotateMeIAPHelper sharedInstance] restoreCompletedTransactions];
}

- (BOOL) isProductPurchased:(NSString *)productKey {
    return [self productPurchased:productKey];
}

@end
