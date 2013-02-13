//
//  RotateMeIAPHelper.m
//  RotateMe
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RotateMeIAPHelper.h"
#import "RotateMeIAPSpecificValues.h"

@implementation RotateMeIAPHelper

+ (RotateMeIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RotateMeIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSDictionary *products = @{iYourGalleryKey : iYourGallerySecret};
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

- (void) createStore {
    
}

- (void)buySelectedProduct:(int)productIndex {
    if([[RotateMeIAPHelper sharedInstance] canMakePurchases]){
        [[RotateMeIAPHelper sharedInstance] buyProduct:[self.products objectAtIndex:productIndex]];
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

- (void)closeStore {
//    [super removeActivity];
//    isClosed = YES;
//    [storeView removeFromSuperview];
//    storeView = nil;
}

- (BOOL) isProductPurchased:(NSString *)productKey {
    return [self productPurchased:productKey];
}

@end
