//
//  IAPHelper.h
//  GreenTheGarden
//
//  Created by Alperen Kavun on 10.01.2013.
//
//

#import <StoreKit/StoreKit.h>

#define IAPHelperProductPurchasedNotification @"IAPHelperProductPurchasedNotification"

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

- (void)restoreCompletedTransactions;

@end