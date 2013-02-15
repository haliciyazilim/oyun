//
//  EQFirstView.m
//  Equify
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQFirstView.h"
#import "EQAppSpecificViewSizes.h"

@implementation EQFirstView

// game mode selection screen

+ (id) CreateView {
    return [[EQFirstView alloc] initWithFrame:CGRectMake(0.0, 0.0, SINGLE_VIEW_WIDTH, SINGLE_VIEW_HEIGHT)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *denemeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 100.0, 500.0, 100.0)];
        [denemeLabel setBackgroundColor:[UIColor clearColor]];
        
        [denemeLabel setText:@"This is the first View"];
        
        [self addSubview:denemeLabel];
    }
    return self;
}

@end
