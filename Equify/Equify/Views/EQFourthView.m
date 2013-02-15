//
//  EQFourthView.m
//  Equify
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQFourthView.h"
#import "EQAppSpecificViewSizes.h"

@implementation EQFourthView

// game screen

+ (id) CreateView {
    return [[EQFourthView alloc] initWithFrame:CGRectMake(SINGLE_VIEW_WIDTH, 0.0, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
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
