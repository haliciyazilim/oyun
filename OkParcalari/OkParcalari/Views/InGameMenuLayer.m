//
//  InGameMenuLayer.m
//  OkParcalari
//
//  Created by Alperen Kavun on 03.01.2013.
//
//

#import "InGameMenuLayer.h"
#import "ArrowGameLayer.h"
#import "Util.h"

@implementation InGameMenuLayer
{
    UIButton *menuItem1;
    UIButton *menuItem2;
    UIButton *menuItem3;
//    UIButton *menuItem4;
}

- (id) init {
    if (self = [super init]) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGFloat top = size.height*0.5;
        CGFloat left = 412.0;
        
        CCSprite *background = [CCSprite spriteWithFile:@"ingame_menu_frame.png"];
        background.position = ccp(size.width * 0.5, size.height * 0.5);
        
        CCSprite *menuFrame = [CCSprite spriteWithFile:@"ingame_menu_btnbg.png"];
        menuFrame.position = ccp(size.width * 0.5+4.0, size.height * 0.5-4.0);
        
        menuItem1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem1 setFrame:CGRectMake(left, top-103.0, 206, 66.0)];
        [menuItem1 setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"ingamebtn_resume", @"png")] forState:UIControlStateNormal];
        [menuItem1 setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"ingamebtn_resume_hover", @"png")] forState:UIControlStateHighlighted];
        
        [menuItem1 addTarget:self
                     action:@selector(resumeGame)
           forControlEvents:UIControlEventTouchUpInside];
        
        menuItem2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem2 setFrame:CGRectMake(left, top-33.0, 206, 66.0)];
        [menuItem2 setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"ingamebtn_restart", @"png")] forState:UIControlStateNormal];
        [menuItem2 setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"ingamebtn_restart_hover", @"png")] forState:UIControlStateHighlighted];
        
        [menuItem2 addTarget:self
                      action:@selector(restartGame)
            forControlEvents:UIControlEventTouchUpInside];
        
        menuItem3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem3 setFrame:CGRectMake(left, top+37.0, 206.0, 66.0)];
        [menuItem3 setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"ingamebtn_mainmenu", @"png")] forState:UIControlStateNormal];
        [menuItem3 setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"ingamebtn_mainmenu_hover", @"png")] forState:UIControlStateHighlighted];
        
        [menuItem3 addTarget:self
                      action:@selector(returnToMainMenu)
            forControlEvents:UIControlEventTouchUpInside];
        
//        menuItem4 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [menuItem4 setFrame:CGRectMake(412.0, 450.0, 206.0, 66.0)];
//        [menuItem4 setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"ingamebtn_settings", @"png")] forState:UIControlStateNormal];
//        [menuItem4 setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"ingamebtn_settings_hover", @"png")] forState:UIControlStateHighlighted];
        
        [self addChild:background];
        [self addChild:menuFrame];
        
        [[[CCDirector sharedDirector] view] addSubview:menuItem1];
        [[[CCDirector sharedDirector] view] addSubview:menuItem2];
        [[[CCDirector sharedDirector] view] addSubview:menuItem3];
//        [[[CCDirector sharedDirector] view] addSubview:menuItem4];
        
        self.isTouchEnabled = YES;
    }
    return self;
}
- (void) onEnter {
    [super onEnter];
}

- (void) removeAllButtons {
    [menuItem1 removeFromSuperview];
    [menuItem2 removeFromSuperview];
    [menuItem3 removeFromSuperview];
//    [menuItem4 removeFromSuperview];
    menuItem1 = nil;
    menuItem2 = nil;
    menuItem3 = nil;
//    menuItem4 = nil;
}
- (void) resumeGame {
    [self removeAllButtons];
    [(ArrowGameLayer *)self.callerLayer inGameMenuWillClose];
    [self removeFromParentAndCleanup:YES];
}
- (void) restartGame {
    [self removeAllButtons];
    [(ArrowGameLayer *)self.callerLayer restartGame];
    [self removeFromParentAndCleanup:YES];
}
- (void) returnToMainMenu {
    [self removeAllButtons];
    [(ArrowGameLayer *)self.callerLayer returnToMainMenu];
    [self removeFromParentAndCleanup:YES];
}

@end
