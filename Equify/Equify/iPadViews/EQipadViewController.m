//
//  EQipadViewController.m
//  Equify
//
//  Created by Abdullah Karacabey on 14.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQipadViewController.h"

@interface EQipadViewController ()

@end

@implementation EQipadViewController

-(float) btnSize{
    return [UIImage imageNamed:@"main_btn.png"].size.width;
}

-(float) btnGCSize{
    return [UIImage imageNamed:@"game_center_btn.png"].size.width;
}

-(float) btnShadowSize{
    return 110.0;
}

-(float) buttonsViewHeight{
    return 204.0;
}

-(float) buttonsViewWidth{
    return 404.0;
}

-(float) screenWidth{
    return [[UIScreen mainScreen] bounds].size.height;
}


-(void) setBackgrounds{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
}

-(UIImageView *) setLogo{
    UIImage * logo=[UIImage imageNamed:@"equify_logo.png"];
    UIImageView * logoView=[[UIImageView alloc] initWithImage:logo];
    logoView.frame=CGRectMake(80, 80, logo.size.width, logo.size.height);
    return logoView;
    
}


@end
