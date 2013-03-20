//
//  EQBox.m
//  Equify
//
//  Created by Alperen Kavun on 11.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQBox.h"
#import <QuartzCore/QuartzCore.h>
//#import "DTBViewController.h"


@implementation EQBox
{
    // hold a private variable which points to line
    // for adding and removing line easily
    
}

static int classOrder = 0;
static NSMutableArray* boxes = nil;

+ (void) addToArrayBoxes:(EQBox*)box
{
    if(boxes == nil){
        boxes = [[NSMutableArray alloc] init];
    }
    [boxes addObject:box];
}

+(void) cleanInstances
{
    classOrder = 0;
    boxes = nil;
}

+(EQBox*)boxByOrder:(int)order
{
    for (int i=0; i<[boxes count];i++) {
        EQBox* box = [boxes objectAtIndex:i];
        if(box.order == order){
            return box;
        }
    }
    return nil;
}

+ (id) BoxWithFrame:(CGRect)frame andTitle:(NSString *)title {
    return [[EQBox alloc] initWithFrame:frame andTitle:title];
}

- (id) initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.isDeleted = NO;
        self.order = classOrder;
        self.boxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.boxButton.frame = frame;
        self.boxButton.tag = classOrder;
        
        [self.boxButton addTarget:self.caller action:@selector(animateBox:) forControlEvents:UIControlEventTouchUpInside];
        
        self.boxButton.layer.cornerRadius = 6.0;
        self.boxButton.layer.borderWidth = 0.0;
        self.boxButton.layer.shadowRadius = 2.0;
        self.boxButton.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.boxButton.layer.shadowOpacity = 0.3;
        [self.boxButton.layer setShadowPath:[[UIBezierPath bezierPathWithRect:CGRectMake(0, 1, 48.0, 48.0)] CGPath]];
        
        self.boxButton.layer.shadowColor = [[UIColor blackColor] CGColor];
//        self.boxButton.layer.borderColor = [[UIColor colorWithRed:0.596 green:0.596 blue:0.596 alpha:1.0] CGColor];
        [self.boxButton setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        
        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(4, 4, 40, 40)];
        [title setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0]];
        [title setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:33.0 ]];
        [title setShadowColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        [title setShadowOffset:CGSizeMake(0.0, 1.0)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:self.title];
        [title setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *innerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"box_bg.png"]];
        
        [self.boxButton addSubview:innerShadow];
        [self.boxButton addSubview:title];
        
        [EQBox addToArrayBoxes:self];
        classOrder++;
    }
    return self;
}
- (void) deleteBox{
    self.isDeleted = YES;
    [boxes replaceObjectAtIndex:self.order withObject:self];
    [self.boxButton setAlpha:0.3];
}
- (void) resetBox {
    self.isDeleted = NO;
    [self.boxButton setAlpha:1];
}
@end
