//
//  GreenTheGardenIAPHelper.h
//  GreenTheGarden
//
//  Created by Alperen Kavun on 10.01.2013.
//
//

#import "IAPHelper.h"

@interface GreenTheGardenIAPHelper : IAPHelper

@property CCLayer *callerLayer;

+ (GreenTheGardenIAPHelper *) sharedInstance;

- (UIView *) createStore;

@end
