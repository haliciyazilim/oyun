//
//  DTBBox.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 04.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "DTBBox.h"

static int classOrder = 0;

@implementation DTBBox
{
    // hold a private variable which points to line
    // for adding and removing line easily
    
}

+ (id) BoxWithFrame:(CGRect)frame andTitle:(NSString *)title {
    return [[DTBBox alloc] initWithFrame:frame andTitle:title];
}

- (id) initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.isDeleted = NO;
        self.order = classOrder;
        self.boxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.boxButton.frame = frame;
        classOrder++;
    }
    return self;
}
- (void) deleteBox {
    self.isDeleted = YES;
    [self animateBoxToOutside];
}
- (void) resetBox {
    self.isDeleted = NO;
    [self animateBoxToInside];
}
- (void) animateBoxToOutside {
    [self drawLineToOriginalPosition];
}
- (void) animateBoxToInside {
    [self removeLine];
}
- (void) drawLineToOriginalPosition {
    
}
- (void) removeLine {
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
