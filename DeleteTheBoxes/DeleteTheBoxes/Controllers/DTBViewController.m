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
    
    [self.view setUserInteractionEnabled:YES];
    [self.scrollView setUserInteractionEnabled:NO];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)placingBoxes: (DTBQuestion *) question{
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    NSLog(@"SV h: %f",screenBounds.size.width);
//    
//    for (int i=0; i<[question questionArray].count; i++) {
//        
//        DTBBox * box=[DTBBox BoxWithFrame:CGRectMake(60*i+10, screenBounds.size.width/2-24, 48, 48) andTitle:[question questionArray][i]];
//                
//        [_scrollView addSubview:box];
    
        
//    }
}

@end
