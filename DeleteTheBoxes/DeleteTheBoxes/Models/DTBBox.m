//
//  DTBBox.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 04.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "DTBBox.h"
#import "DTBViewController.h"


@implementation DTBBox
{
    // hold a private variable which points to line
    // for adding and removing line easily
    
}

static int classOrder = 0;
static NSMutableArray* boxes = nil;
static NSMutableArray* paths=nil;

+ (void) addToArrayBoxes:(DTBBox*)box
{
    if(boxes == nil){
        boxes = [[NSMutableArray alloc] init];
    }
    [boxes addObject:box];
}

+ (void) addToArrayPaths:(NSDictionary*)dict
{
    if(paths == nil){
        paths = [[NSMutableArray alloc] init];
    }
    [paths addObject:dict];
}

+(void) cleanInstances
{
    classOrder = 0;
    boxes = nil;
    paths=nil;
}

+(DTBBox*)boxByOrder:(int)order
{
//    NSLog(@"%d",order);
    for (int i=0; i<[boxes count];i++) {
//        NSLog(@"%d",box.order);
        DTBBox* box = [boxes objectAtIndex:i];
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
        self.boxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.boxButton.frame = frame;
        self.boxButton.tag = classOrder;
//        [self.boxButton setTitle:title forState:UIControlStateNormal];
        
        [self.boxButton addTarget:self.caller action:@selector(animateBox:) forControlEvents:UIControlEventTouchUpInside];

        self.boxButton.layer.cornerRadius = 6.0;
        self.boxButton.layer.borderWidth = 1.0;
        self.boxButton.layer.shadowRadius = 2.0;
        self.boxButton.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.boxButton.layer.shadowOpacity = 0.3;
        [self.boxButton.layer setShadowPath:[[UIBezierPath bezierPathWithRect:CGRectMake(0, 1, 48.0, 48.0)] CGPath]];
        
        self.boxButton.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.boxButton.layer.borderColor = [[UIColor colorWithRed:0.596 green:0.596 blue:0.596 alpha:1.0] CGColor];
        [self.boxButton setBackgroundColor:[UIColor colorWithRed:0.701 green:0.701 blue:0.701 alpha:1.0]];
        
        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(4, 4, 40, 40)];
        [title setTextColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.0]];
        [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:33.0 ]];
        [title setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [title setShadowOffset:CGSizeMake(0.0, 1.0)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:self.title];
        [title setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *innerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"box_bg.png"]];
        
        [self.boxButton addSubview:innerShadow];
        [self.boxButton addSubview:title];
        
        
        [DTBBox addToArrayBoxes:self];
        classOrder++;
        
        
    }
    return self;
}
- (void) deleteBox: (UIView *) view{
    self.isDeleted = YES;
    [boxes replaceObjectAtIndex:self.order withObject:self];
    [self.boxButton setAlpha:0.3];
//    [self animateBoxToOutside:view];
}
- (void) resetBox {
    self.isDeleted = NO;
    
    [self.boxButton setAlpha:1];
    
//    [self animateBoxToInside];
}
- (void) animateBoxToOutside: (UIView *) view {
//    [self drawLineToOriginalPosition: view];
//    NSLog(@"Yukarı ÇIk");    
//    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        
//        self.boxButton.frame=CGRectMake(self.boxButton.frame.origin.x+self.boxButton.frame.size.width/4, self.boxButton.frame.origin.y-60, self.boxButton.frame.size.width/2,self.boxButton.frame.size.height/2);
//        NSLog(@"self.order: %d, classOrder: %d, pathsCount: %d",self.order,classOrder,paths.count);
//        for(int i=self.order+1;i<classOrder;i++){
//            DTBBox * box=[boxes objectAtIndex:i];
//            box.boxButton.frame=CGRectMake(box.boxButton.frame.origin.x-30, box.boxButton.frame.origin.y, box.boxButton.frame.size.width,box.boxButton.frame.size.height);
//
//        }
//        
//        for(int i=0;i<self.order;i++){
//            DTBBox * box=[boxes objectAtIndex:i];
//            box.boxButton.frame=CGRectMake(box.boxButton.frame.origin.x+30, box.boxButton.frame.origin.y, box.boxButton.frame.size.width,box.boxButton.frame.size.height);
//            
//        }
//
//        NSLog(@"PathsCount: %d",paths.count);
//        for(int i=0; i<paths.count;i++){
//            UIBezierPath *path=[paths[i] valueForKey:@"path"];
////            UIBezierPath *pathLayer=[paths[i] valueForKey:@"pathLayer"];
//            
//            CGRect line=CGPathGetBoundingBox(path.CGPath);
//            CGAffineTransform transFORM=CGAffineTransformMakeScale(20, 100);
//            CGPathRef pathref=CGPathCreateCopyByTransformingPath(path.CGPath, &transFORM);
//            path.CGPath=pathref;
//            
//            // BUraya bak
//            //http://stackoverflow.com/questions/8143750/ios-core-animation-incorrect-anchor-point-for-rotation
//            
//           // [path applyTransform:CGAffineTransformMakeTranslation(20, 20)];
//            //            if(self.order<order){
//            //                path
//            //            }
//        }
//
//        
//        
//    } completion:^(BOOL finished) {
//        ;
//    }];
////    CGRect screenBounds = [[UIScreen mainScreen] bounds];
////    [self drawLineToOriginalPosition:screenBounds];
}
- (void) animateBoxToInside {
//    
//    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        
//        self.boxButton.frame=CGRectMake(self.boxButton.frame.origin.x-self.boxButton.frame.size.width*2/4, self.boxButton.frame.origin.y+60, self.boxButton.frame.size.width*2,self.boxButton.frame.size.height*2);
//        
//        NSLog(@"self.order: %d, classOrder: %d, pathsCount: %d",self.order,classOrder,paths.count);
//        for(int i=self.order+1;i<classOrder;i++){
//            DTBBox * box=[boxes objectAtIndex:i];
//            box.boxButton.frame=CGRectMake(box.boxButton.frame.origin.x+30, box.boxButton.frame.origin.y, box.boxButton.frame.size.width,box.boxButton.frame.size.height);
//            
//        }
//        
//        for(int i=0;i<self.order;i++){
//            DTBBox * box=[boxes objectAtIndex:i];
//            box.boxButton.frame=CGRectMake(box.boxButton.frame.origin.x-30, box.boxButton.frame.origin.y, box.boxButton.frame.size.width,box.boxButton.frame.size.height);
//            
//        }
//        NSLog(@"PathsCount: %d",paths.count);
//        for(int i=0; paths.count;i++){
//            UIBezierPath *path=[paths[i] valueForKey:@"path"];
//            UIBezierPath *pathLayer=[paths[i] valueForKey:@"pathLayer"];
//            
//            [pathLayer applyTransform:CGAffineTransformMakeTranslation(20, 20)];
////            if(self.order<order){
////                path
////            }
//        }
//         
//        
//    } completion:^(BOOL finished) {
//        ;
//    }];
//
//    
//    [self removeLine];
//    
    
}
- (void) drawLineToOriginalPosition: (UIView *) view {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.boxButton.frame.origin.x+24,self.boxButton.frame.origin.y+24)];
    [path addLineToPoint:CGPointMake(self.boxButton.frame.origin.x+24, self.boxButton.frame.origin.y*3/4)];
    
    
    
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = view.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor redColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCGLineJoinMiter;
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys: path,@"path",pathLayer,@"pathLayer", nil];
    [DTBBox addToArrayPaths:dict];

    [view.layer addSublayer:pathLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    
    
    
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
