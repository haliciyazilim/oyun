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
        self.boxButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.boxButton.frame = frame;
        [self.boxButton setTitle:title forState:UIControlStateNormal];
        // Aşağıdaki satırda sıkıntı var. Animasyon çalışmıyor.
//        [self.boxButton addTarget:self action:@selector(animateBoxToOutside:) forControlEvents:UIControlEventTouchUpInside];
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

//    NSLog(@"Yukarı ÇIk")
//    ;    [self drawLineToOriginalPosition];
//    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        [self.boxButton setCenter:CGPointMake(24, 24)];
//        self.boxButton.frame=CGRectMake(self.boxButton.frame.origin.x, self.boxButton.frame.origin.y-30, self.boxButton.frame.size.width/2,self.boxButton.frame.size.height/2);
//    } completion:^(BOOL finished) {
//        ;
//    }];
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
