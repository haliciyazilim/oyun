//
//  DTBViewController.m
//  DeleteTheBoxes
//
//  Created by Alperen Kavun on 04.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "DTBViewController.h"
#import "DTBQuestion.h"

@interface DTBViewController ()

@end

@implementation DTBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    DTBQuestion *deneme = [DTBQuestion QuestionWithQuestion:@"3x5=3+0:2" andAnswer:@"3x5=30"];
    NSLog(@"%@",[deneme questionArray]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
