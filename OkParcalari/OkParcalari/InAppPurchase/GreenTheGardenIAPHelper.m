//
//  GreenTheGardenIAPHelper.m
//  GreenTheGarden
//
//  Created by Alperen Kavun on 10.01.2013.
//
//

#import "GreenTheGardenIAPHelper.h"

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

@end