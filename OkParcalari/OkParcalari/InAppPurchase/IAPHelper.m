//
//  IAPHelper.m
//  GreenTheGarden
//
//  Created by Alperen Kavun on 10.01.2013.
//
//

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const IAPHelperProductPurchaseDidFailedNotification = @"IAPHelperProductPurchaseDidFailedNotification";

#import "IAPHelper.h"
#import <CommonCrypto/CommonDigest.h>

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper
{
    SKProductsRequest * _productsRequest;
    
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSArray * _productKeys;
    NSMutableSet * _purchasedProductIdentifiers;
    NSString *_deviceName;
}
- (id) initWithProductsDictionary:(NSDictionary *)products {
    if ( self = [super init] ) {
        _iProducts = [NSDictionary dictionaryWithDictionary:products];
        _productIdentifiers = [NSSet setWithArray:[_iProducts allKeys]];
        _purchasedProductIdentifiers = [NSMutableSet set];
        _deviceName = [[UIDevice currentDevice] name];
        
        for ( NSString * productIdentifier in [_iProducts allKeys]) {
            BOOL productPurchased;
            NSString *productDeviceStr = [NSString stringWithFormat:@"%@%@",[_iProducts objectForKey:productIdentifier],_deviceName];
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:productIdentifier] isEqualToString:[self sha1:productDeviceStr]]) {
                productPurchased = YES;
            }
            else{
                productPurchased = NO;
            }
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
            }
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    _completionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}
- (BOOL)canMakePurchases {
    return [SKPaymentQueue canMakePayments];
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSString *errorStr = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"PRODUCT_PURCHASE_FAILED", nil),transaction.error.localizedDescription];
        UIAlertView *productPurchased = [[UIAlertView alloc] initWithTitle:@""
                                                                   message:errorStr
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                         otherButtonTitles:nil,nil];
        [productPurchased show];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    [_purchasedProductIdentifiers addObject:productIdentifier];
    
    NSString *productDeviceStr = [NSString stringWithFormat:@"%@%@",[_iProducts objectForKey:productIdentifier],_deviceName];
    
    [[NSUserDefaults standardUserDefaults] setObject:[self sha1:productDeviceStr] forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
}
- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}
- (void)buyProduct:(SKProduct *)product {
    
    if([self canMakePurchases]){
        SKPayment * payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
    }
    
}
-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
@end
