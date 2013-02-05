//
//  DTBViewController.h
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 04.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DTBQuestion;

@interface DTBViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(void)placingBoxes: (DTBQuestion *) question;
@end
