//
//  EQThirdView.m
//  Equify
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQThirdView.h"
#import "EQAppSpecificViewSizes.h"

@implementation EQThirdView

// matchs or last 10 single game screen

+ (id) CreateView {
    return [[EQThirdView alloc] initWithFrame:CGRectMake(SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
