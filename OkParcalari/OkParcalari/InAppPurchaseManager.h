//
//  InAppPurchaseManager.h
//  OkParcalari
//
//  Created by Alperen Kavun on 20.12.2012.
//
//

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

+ (InAppPurchaseManager *) sharedInstance;

- (void)requestProUpgradeProductData;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;

@end
