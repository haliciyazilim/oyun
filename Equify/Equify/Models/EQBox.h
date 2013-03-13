//
//  EQBox.h
//  Equify
//
//  Created by Alperen Kavun on 11.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EQBox : NSObject

@property UIButton *boxButton;
@property NSString *title;
@property BOOL isDeleted;
@property int order;
@property UIViewController * caller;

// class methods
+ (id) BoxWithFrame:(CGRect)frame andTitle:(NSString *)title;

// instance method
- (id) initWithFrame:(CGRect)frame andTitle:(NSString *)title;

- (void) deleteBox;
- (void) resetBox;

+(EQBox*)boxByOrder:(int)order;

+(void) cleanInstances;


@end
