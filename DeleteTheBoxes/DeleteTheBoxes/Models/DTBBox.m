//
//  DTBBox.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 04.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "DTBBox.h"

static int classOrder = 0;
static NSMutableArray* boxes = nil;

@implementation DTBBox
{
    // hold a private variable which points to line
    // for adding and removing line easily
    
}

+ (void) addToArray:(DTBBox*)box
{
    if(boxes == nil){
        boxes = [[NSMutableArray alloc] init];
    }
    [boxes addObject:box];
}

+(void) cleanInstances
{
    boxes = nil;
}

+(DTBBox*)boxByOrder:(int)order
{
    NSLog(@"%d",order);
    for (DTBBox* box in boxes) {
        NSLog(@"%d",box.order);
        if(box.order == order){
            return box;
        }
    }
    return nil;
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
        self.boxButton.tag = classOrder;

        [self.boxButton addTarget:self.caller action:@selector(animateBox:) forControlEvents:UIControlEventTouchUpInside];


        [DTBBox addToArray:self];
        classOrder++;
    }
    return self;
}
- (void) deleteBox{
    NSLog(@"Delete BOX");

    self.isDeleted = YES;
    [self animateBoxToOutside];
}
- (void) resetBox {
    NSLog(@"Reset BOX");
    self.isDeleted = NO;
    [self animateBoxToInside];
}
- (void) animateBoxToOutside {

    NSLog(@"Yukarı ÇIk");    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.boxButton.frame=CGRectMake(self.boxButton.frame.origin.x+self.boxButton.frame.size.width/4, self.boxButton.frame.origin.y-60, self.boxButton.frame.size.width/2,self.boxButton.frame.size.height/2);
        NSLog(@"self.order: %d, classOrder: %d",self.order,classOrder);
        for(int i=self.order+1;i<classOrder;i++){
            DTBBox * box=[boxes objectAtIndex:i];
            box.boxButton.frame=CGRectMake(box.boxButton.frame.origin.x-30, box.boxButton.frame.origin.y, box.boxButton.frame.size.width,box.boxButton.frame.size.height);

        }
        
        for(int i=0;i<self.order;i++){
            DTBBox * box=[boxes objectAtIndex:i];
            box.boxButton.frame=CGRectMake(box.boxButton.frame.origin.x+30, box.boxButton.frame.origin.y, box.boxButton.frame.size.width,box.boxButton.frame.size.height);
            
        }

        
        
    } completion:^(BOOL finished) {
        ;
    }];
    
    [self drawLineToOriginalPosition];
}
- (void) animateBoxToInside {
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.boxButton.frame=CGRectMake(self.boxButton.frame.origin.x-self.boxButton.frame.size.width*2/4, self.boxButton.frame.origin.y+60, self.boxButton.frame.size.width*2,self.boxButton.frame.size.height*2);
        
        NSLog(@"self.order: %d, classOrder: %d",self.order,classOrder);
        for(int i=self.order+1;i<classOrder;i++){
            DTBBox * box=[boxes objectAtIndex:i];
            box.boxButton.frame=CGRectMake(box.boxButton.frame.origin.x+30, box.boxButton.frame.origin.y, box.boxButton.frame.size.width,box.boxButton.frame.size.height);
            
        }
        
        for(int i=0;i<self.order;i++){
            DTBBox * box=[boxes objectAtIndex:i];
            box.boxButton.frame=CGRectMake(box.boxButton.frame.origin.x-30, box.boxButton.frame.origin.y, box.boxButton.frame.size.width,box.boxButton.frame.size.height);
            
        }
        
    } completion:^(BOOL finished) {
        ;
    }];

    
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
