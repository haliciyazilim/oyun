//
//  DTBViewController.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 04.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "DTBViewController.h"
#import "DTBQuestion.h"
#import "DTBBox.h"

@interface DTBViewController ()

@end

@implementation DTBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.scrollView setContentSize:CGSizeMake(672, 48)];

    DTBQuestion *deneme = [DTBQuestion QuestionWithQuestion:@"3x5=3+0:2" andAnswer:@"3x5=30"];
    NSLog(@"%@",[deneme questionArray]);
    
    [self placingBoxes:deneme];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}


-(void)placingBoxes: (DTBQuestion *) question{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSLog(@"SV h: %f",screenBounds.size.width);
    
    for (int i=0; i<[question questionArray].count; i++) {
        
        DTBBox * box=[DTBBox BoxWithFrame:CGRectMake(60*i+10, screenBounds.size.width/2-24, 48, 48) andTitle:[question questionArray][i]];
        
                
        [_scrollView addSubview:box.boxButton];
        
        
        
//        UIButton * box1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        box1.frame=CGRectMake(60*i+10, screenBounds.size.width/2-24, 48, 48);
//        [box1 setTitle:@"1" forState:UIControlStateNormal];
//        
//        [_scrollView addSubview:box1];
    }
}

@end
