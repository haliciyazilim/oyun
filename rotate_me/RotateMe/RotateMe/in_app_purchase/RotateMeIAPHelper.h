//
//  RotateMeIAPHelper.h
//  RotateMe
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "IAPHelper.h"

@interface RotateMeIAPHelper : IAPHelper

+ (RotateMeIAPHelper *) sharedInstance;

- (BOOL) isProductPurchased:(NSString *)productKey;
- (void) createStore;
- (void)buySelectedProduct:(int)productIndex;

@end
