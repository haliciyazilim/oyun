//
//  DTBBox.h
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 04.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTBBox : NSObject

@property UIButton *boxButton;
@property NSString *title;
@property BOOL isDeleted;
@property int order;
@property UIViewController * caller;

// class methods
+ (id) BoxWithFrame:(CGRect)frame andTitle:(NSString *)title;

// instance method
- (id) initWithFrame:(CGRect)frame andTitle:(NSString *)title;

- (void) deleteBox: (UIView *) view;
- (void) resetBox;

+(DTBBox*)boxByOrder:(int)order;

+(void) cleanInstances;


@end
