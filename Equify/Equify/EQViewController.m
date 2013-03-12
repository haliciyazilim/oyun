//
//  EQViewController.m
//  Equify
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQViewController.h"
#import "EQAppSpecificViewSizes.h"

@interface EQViewController ()

@end

@implementation EQViewController
{
    // neccessary UIViews
    UIView *mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"first screen");
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)startNewGame:(id)sender {
    [self performSegueWithIdentifier:@"GameStartSegue" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameStartSegue"]) {
        //
    }
}
@end
