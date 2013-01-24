//
//  GreenTheGardenIAPHelper.m
//  GreenTheGarden
//
//  Created by Alperen Kavun on 10.01.2013.
//
//

#import "GreenTheGardenIAPHelper.h"
#import "MapSelectionLayer.h"

@implementation GreenTheGardenIAPHelper

+ (GreenTheGardenIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static GreenTheGardenIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.halici.GreenTheGarden.gameUnlock",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}
- (UIView *) createStore {
    UIView *storeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0)];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ingame_menu_frame.png"]];
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inapp_back.png"]];
    [backView setFrame:CGRectMake(322.0, 231.0, 380.0, 306.0)];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(667.0, 220.0, 45.0, 45.0)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"inapp_btn_close.png"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"inapp_btn_close_hover.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeStore) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setFrame:CGRectMake(520.0, 443.0, 148.0, 69.0)];
    [buyButton setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"inapp_btn_buynow", @"png")] forState:UIControlStateNormal];
    [buyButton setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"inapp_btn_buynow_hover", @"png")] forState:UIControlStateHighlighted];
    [buyButton addTarget:self.callerLayer action:@selector(buyPro) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *restoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [restoreButton setFrame:CGRectMake(357.0, 443.0, 148.0, 69.0)];
    [restoreButton setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"inapp_btn_purchase", @"png")] forState:UIControlStateNormal];
    [restoreButton setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"inapp_btn_purchase_hover", @"png")] forState:UIControlStateHighlighted];
    [restoreButton addTarget:self.callerLayer action:@selector(restorePurchases) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *unlockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inapp_image.png"]];
    [unlockImage setFrame:CGRectMake(355.0, 260.0, 153.0, 178.0)];
    
    NSString *header = [[self.callerLayer.products objectAtIndex:0] localizedTitle];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(522.0, 260.0, 160.0, 40.0)];
    [headerLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [headerLabel setText:header];
    
    NSString *description = [[self.callerLayer.products objectAtIndex:0] localizedDescription];
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(522.0, 300.0, 160.0, 100.0)];
    [descriptionLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionLabel setTextAlignment:NSTextAlignmentLeft];
    [descriptionLabel setNumberOfLines:3];
    [descriptionLabel setText:description];
    
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    SKProduct *myProduct = [self.callerLayer.products objectAtIndex:0];
    
    [priceFormatter setLocale:myProduct.priceLocale];
    
    NSString *priceStr = [priceFormatter stringFromNumber:[[self.callerLayer.products objectAtIndex:0] price]];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(522.0, 400.0, 160.0, 40.0)];
    [priceLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [priceLabel setTextAlignment:NSTextAlignmentLeft];
    [priceLabel setText:priceStr];
    
    [storeView addSubview:backgroundView];
    [storeView addSubview:backView];
    [storeView addSubview:closeButton];
    [storeView addSubview:buyButton];
    [storeView addSubview:restoreButton];
    [storeView addSubview:unlockImage];
    [storeView addSubview:headerLabel];
    [storeView addSubview:descriptionLabel];
    [storeView addSubview:priceLabel];
    
    return storeView;
}
- (void)closeStore {
    [self.callerLayer closeStore];
}

@end