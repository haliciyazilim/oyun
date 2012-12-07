//
//  ArrowGame.m
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#import "ArrowGame.h"

@implementation ArrowGame

- (id)init
{
    self = [super init];
    if (self) {
        self.gameTable = [NSMutableDictionary dictionaryWithCapacity:100];
    }

    return self;
}

@end
