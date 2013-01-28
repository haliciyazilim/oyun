//
//  ArrowGameLayer.m
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#define MENU_TAG 994

#import "ArrowGameLayer.h"
#import "InGameMenuLayer.h"
#import "GameMap.h"
#import "MapEntity.h"
#import "CCBReader.h"
#import "Squirt.h"
#import "CCBAnimationManager.h"
#import "MapSelectionLayer.h"
#import "GreenTheGardenSoundManager.h"

#import "AchievementManager.h"
#import "GreenTheGardenGCSpecificValues.h"

@implementation ArrowGameLayer
{
    NSString *_fileName;
    UIView *inGameButtonsView;
    UIView *gameWinView;
}

+(CCScene *) sceneWithFile:(NSString *)fileName
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ArrowGameLayer *layer = [ArrowGameLayer node];
	[layer initializeGameWithFile:fileName];
	// add layer as a child to scene
//    InGameMenuLayer *menuLayer = [InGameMenuLayer node];
	[scene addChild: layer];
//    [scene addChild:menuLayer];
    
    
	
	// return the scene
	return scene;
}

static ArrowGameLayer* __lastInstance;

+(ArrowGameLayer*)lastInstance
{
    return __lastInstance;
}

+(void)cleanLastInstance
{
    __lastInstance = nil;
}

-(void)onExit{
    [inGameButtonsView removeFromSuperview];
}
-(void)onEnter{
    [super onEnter];
    inGameButtonsView = [[UIView alloc] initWithFrame:CGRectMake(900.0, 20.0, 105.0, 35.0)];
//    [inGameButtonsView setBackgroundColor:[UIColor redColor]];
    
    UIButton* fxButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 2.0, 30.0, 30.0)];
    if([[GreenTheGardenSoundManager sharedSoundManager] isEffectsMuted]){
        [fxButton setBackgroundImage:[UIImage imageNamed:@"game_btnfx_off.png"] forState:UIControlStateNormal];
        [fxButton setBackgroundImage:[UIImage imageNamed:@"game_btnfx_off.png"] forState:UIControlStateHighlighted];
    }
    else{
        [fxButton setBackgroundImage:[UIImage imageNamed:@"game_btnfx_on.png"] forState:UIControlStateNormal];
        [fxButton setBackgroundImage:[UIImage imageNamed:@"game_btnfx_on.png"] forState:UIControlStateHighlighted];
    }
    [fxButton addTarget:self action:@selector(fxClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* musicButton = [[UIButton alloc] initWithFrame:CGRectMake(38.0, 2.0, 30.0, 30.0)];
    if([[GreenTheGardenSoundManager sharedSoundManager] isBackgroundMusicMuted]){
        [musicButton setBackgroundImage:[UIImage imageNamed:@"game_btnsound_off.png"] forState:UIControlStateNormal];
        [musicButton setBackgroundImage:[UIImage imageNamed:@"game_btnsound_off.png"] forState:UIControlStateHighlighted];
    }
    else{
        [musicButton setBackgroundImage:[UIImage imageNamed:@"game_btnsound_on.png"] forState:UIControlStateNormal];
        [musicButton setBackgroundImage:[UIImage imageNamed:@"game_btnsound_on.png"] forState:UIControlStateHighlighted];
    }
    [musicButton addTarget:self action:@selector(musicClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* menuButton = [[UIButton alloc] initWithFrame:CGRectMake(75.0, 2.0, 30.0, 30.0)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"game_btnmenu.png"] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"game_btnmenu_selected.png"] forState:UIControlStateHighlighted];
    [menuButton addTarget:self action:@selector(showInGameMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [inGameButtonsView addSubview:fxButton];
    [inGameButtonsView addSubview:musicButton];
    [inGameButtonsView addSubview:menuButton];
    
    [[[CCDirector sharedDirector] view] addSubview:inGameButtonsView];
}
// on "init" you need to initialize your instance
-(id) init
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"mainbg.png"];
        background.position = ccp(size.width * 0.5, size.height * 0.5);
        
        CCSprite *frameView = [CCSprite spriteWithFile:@"main_frame.png"];
        frameView.position = ccp(size.width * 0.5, size.height * 0.5);

        CCSprite *topView = [CCSprite spriteWithFile:@"gameboard.png"];
        topView.position = ccp(384,384);
        
        CCSprite *logoView = [CCSprite spriteWithFile:@"game_logo.png"];
        logoView.position = ccp(782,549);
        
        [self addChild:background];
        [self addChild:topView z:998];
        [self addChild:frameView z:999];
        [self addChild:logoView z:1000];
        
		self.isTouchEnabled = YES;
	}
    __lastInstance = self;
	return self;
}

- (void)fxClicked:(UIButton *)button {
    if([[GreenTheGardenSoundManager sharedSoundManager] isEffectsMuted]){
        [button setBackgroundImage:[UIImage imageNamed:@"game_btnfx_on.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"game_btnfx_on.png"] forState:UIControlStateHighlighted];
        [[GreenTheGardenSoundManager sharedSoundManager] setIsEffectsMuted:NO];
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"game_btnfx_off.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"game_btnfx_off.png"] forState:UIControlStateHighlighted];
        [[GreenTheGardenSoundManager sharedSoundManager] setIsEffectsMuted:YES];
    }
}
- (void)musicClicked:(UIButton *)button {
    if([[GreenTheGardenSoundManager sharedSoundManager] isBackgroundMusicMuted]){
        [button setBackgroundImage:[UIImage imageNamed:@"game_btnsound_on.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"game_btnsound_on.png"] forState:UIControlStateHighlighted];
        [[GreenTheGardenSoundManager sharedSoundManager] setIsBackgroundMusicMuted:NO];
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"game_btnsound_off.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"game_btnsound_off.png"] forState:UIControlStateHighlighted];
        [[GreenTheGardenSoundManager sharedSoundManager] setIsBackgroundMusicMuted:YES];
    }
}

- (void) initializeGameWithFile:(NSString*)fileName
{
    _fileName = fileName;
    self.arrowGame = [[ArrowGame alloc] initWithFile:fileName];
    [self addChild:self.arrowGame];
}

- (void) restartGame {
    [self.arrowGame cleanMap];
    [self.arrowGame removeFromParentAndCleanup:YES];
    self.isTouchEnabled = YES;
    [self initializeGameWithFile:_fileName];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.arrowGame touchBegan:[self locationFromTouches:touches]];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.arrowGame touchMoved:[self locationFromTouches:touches]];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.arrowGame touchEnded:[self locationFromTouches:touches]];
}

-(CGPoint)pointFromTouches:(NSSet*) touches
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector] convertToGL:point];
    return point;
}

-(Location)locationFromTouches:(NSSet*) touches
{
    CGPoint point = [self pointFromTouches:touches];
    Location location = [[GameMap sharedInstance] convertAbsolutePointToGridPoint:point];
    return location;
}

- (void) showInGameMenu {
    InGameMenuLayer *child = (InGameMenuLayer*)[self getChildByTag:MENU_TAG];
    if(child){
        [child resumeGame];
    }
    else{
        [self.arrowGame pauseGame];
        InGameMenuLayer *menuLayer = [[InGameMenuLayer alloc] init];
        menuLayer.callerLayer = self;
        menuLayer.tag = MENU_TAG;
        [self addChild:menuLayer];
        [self reorderChild:menuLayer z:1111];
        self.isTouchEnabled = NO;
    }
//    [self gameEnded];
}
- (void) inGameMenuWillClose {
    [self.arrowGame resumeGame];
    self.isTouchEnabled = YES;
}
- (void) returnToMainMenu {
    if(gameWinView){
        [gameWinView removeFromSuperview];
    }
    [self.arrowGame cleanMap];
    [self.arrowGame removeFromParentAndCleanup:YES];
    [self removeFromParentAndCleanup:YES];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[MapSelectionLayer scene] withColor:ccWHITE]];
}
- (void) nextGame {
//    Map *oldMap = [[DatabaseManager sharedInstance] getMapWithID:_fileName];
//    int oldMapOrder = oldMap.order;
//    NSString *oldMapPackage = oldMap.packageId;
//    Map *newMap = [[DatabaseManager sharedInstance] getMapWithOrder:[NSNumber numberWithInt:oldMapOrder+1] forPackage:oldMapPackage];
    
}
-(void) gameEnded
{
    self.isTouchEnabled = NO;
    
    Map* map = [[DatabaseManager sharedInstance] getMapWithID:_fileName];
    NSString *levelNumStr = [NSString stringWithFormat:@"%d",map.order];
    
    gameWinView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0)];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inapp_menu_frame.png"]];
    
    UIView *holderFrame = [[UIView alloc] initWithFrame:CGRectMake(350.0, 200.0, 327.0, 395.0)];
    
    UIImageView *star1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_star_passive.png"]];
    star1.frame = CGRectMake(39.0, 26.0, 80.0, 77.0);
    UIImageView *star2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_star_passive.png"]];
    star2.frame = CGRectMake(126.0, 0.0, 80.0, 77.0);
    UIImageView *star3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_star_passive.png"]];
    star3.frame = CGRectMake(212.0, 26.0, 80.0, 77.0);
    
    UIImageView *levelNumHolder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_mapnum.png"]];
    levelNumHolder.frame = CGRectMake(122.0, 80.0, 80.0, 75.0);
    
    UILabel *levelNum = [[UILabel alloc] initWithFrame:CGRectMake(140.0, 100.0, 45.0, 30.0)];
    [levelNum setBackgroundColor:[UIColor clearColor]];
    [levelNum setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
    [levelNum setTextAlignment:NSTextAlignmentCenter];
    [levelNum setTextColor:[UIColor colorWithRed:0.309 green:0.176 blue:0.0 alpha:1.0]];
    [levelNum setShadowColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4]];
    [levelNum setShadowOffset:CGSizeMake(0, 1)];
    [levelNum setText:levelNumStr];
    
    UIImageView *rope1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_ayrac.png"]];
    rope1.frame = CGRectMake(0.0, 111.0, 327.0, 13.0);
    
    UIView *timerHolder = [[UIView alloc] initWithFrame:CGRectMake(45.0, 160.0, 240.0, 75.0)];
    UIImageView *num1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_num_0.png"]];
    num1.frame = CGRectMake(0.0, 0.0, 55.0, 75.0);
    
    UIImageView *num2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_num_0.png"]];
    num2.frame = CGRectMake(55.0, 0.0, 55.0, 75.0);
    
    UIImageView *dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_num_nokta.png"]];
    dot.frame = CGRectMake(110.0, 0.0, 21.0, 75.0);
    
    UIImageView *num3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_num_0.png"]];
    num3.frame = CGRectMake(130.0, 0.0, 55.0, 75.0);
    
    UIImageView *num4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_num_0.png"]];
    num4.frame = CGRectMake(185.0, 0.0, 55.0, 75.0);
    
    UIImageView *rope2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_ayrac.png"]];
    rope2.frame = CGRectMake(0.0, 250.0, 327.0, 13.0);
    
    UIButton *mainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [mainMenu setFrame:CGRectMake(19.0, 263.0, 139.0, 55.0)];
    [mainMenu setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"youwin_mainmenu", @"png")] forState:UIControlStateNormal];
    [mainMenu setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"youwin_mainmenu_hover", @"png")] forState:UIControlStateHighlighted];
    [mainMenu addTarget:self action:@selector(returnToMainMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *buttonsDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_nokta.png"]];
    buttonsDot.frame = CGRectMake(153.0, 263.0, 20.0, 55.0);
    
    UIButton *nextGame = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextGame setFrame:CGRectMake(173.0, 263.0, 139.0, 55.0)];
    [nextGame setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"youwin_next", @"png")] forState:UIControlStateNormal];
    [nextGame setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"youwin_next_hover", @"png")] forState:UIControlStateHighlighted];
    [nextGame addTarget:self action:@selector(nextMap) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *rope3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_ayrac.png"]];
    rope3.frame = CGRectMake(0.0, 318.0, 327.0, 13.0);
    
    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setFrame:CGRectMake(100.0, 345.0, 50.0, 50.0)];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"youwin_social_face.png"] forState:UIControlStateNormal];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"youwin_social_face_hover.png"] forState:UIControlStateHighlighted];
    [faceButton addTarget:self action:@selector(shareOnFacebook) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tweetButton setFrame:CGRectMake(179.0, 345.0, 50.0, 50.0)];
    [tweetButton setBackgroundImage:[UIImage imageNamed:@"youwin_social_tweet.png"] forState:UIControlStateNormal];
    [tweetButton setBackgroundImage:[UIImage imageNamed:@"youwin_social_tweet_hover.png"] forState:UIControlStateHighlighted];
    [tweetButton addTarget:self action:@selector(shareOnTwitter) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *activeStar1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_star_active.png"]];
//    activeStar1.frame = CGRectMake(star1.center.x, star1.center.y, 0.0, 0.0);
    activeStar1.frame = CGRectMake(39.0, 26.0, 80.0, 77.0);
    activeStar1.transform = CGAffineTransformMakeScale(0.0, 0.0);
    activeStar1.alpha = 0.0;
    UIImageView *activeStar2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_star_active.png"]];
//    activeStar2.frame = CGRectMake(star2.center.x, star2.center.y, 0.0, 0.0);
    activeStar2.frame = CGRectMake(126.0, 0.0, 80.0, 77.0);
    activeStar2.transform = CGAffineTransformMakeScale(0.0, 0.0);
    activeStar2.alpha = 0.0;
    UIImageView *activeStar3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_star_active.png"]];
//    activeStar3.frame = CGRectMake(star3.center.x, star3.center.y, 0.0, 0.0);
    activeStar3.frame = CGRectMake(212.0, 26.0, 80.0, 77.0);
    activeStar3.transform = CGAffineTransformMakeScale(0.0, 0.0);
    activeStar3.alpha = 0.0;
    
    [gameWinView addSubview:background];
    [holderFrame addSubview:star1];
    [holderFrame addSubview:star2];
    [holderFrame addSubview:star3];
    [holderFrame addSubview:activeStar1];
    [holderFrame addSubview:activeStar2];
    [holderFrame addSubview:activeStar3];
    [holderFrame addSubview:rope1];
    [holderFrame addSubview:levelNumHolder];
    [holderFrame addSubview:levelNum];
    [timerHolder addSubview:num1];
    [timerHolder addSubview:num2];
    [timerHolder addSubview:dot];
    [timerHolder addSubview:num3];
    [timerHolder addSubview:num4];
    [holderFrame addSubview:timerHolder];
    [holderFrame addSubview:rope2];
    [holderFrame addSubview:mainMenu];
    [holderFrame addSubview:buttonsDot];
    [holderFrame addSubview:nextGame];
    [holderFrame addSubview:rope3];
    [holderFrame addSubview:faceButton];
    [holderFrame addSubview:tweetButton];
    [gameWinView addSubview:holderFrame];
    
    [[[CCDirector sharedDirector] view] addSubview:gameWinView];

    // opacities
    [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        activeStar1.alpha = 1.0;
    } completion:^(BOOL finished) {
        ;
    }];
    [UIView animateWithDuration:0.7 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        activeStar2.alpha = 1.0;
    } completion:^(BOOL finished) {
        ;
    }];
    [UIView animateWithDuration:0.7 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        activeStar3.alpha = 1.0;
    } completion:^(BOOL finished) {
        ;
    }];
    /////////
    // frames
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        activeStar1.frame = CGRectMake(24.0, 11.0, 110.0, 107.0);
        activeStar1.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [star1 removeFromSuperview];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            activeStar1.frame = CGRectMake(39.0, 26.0, 80.0, 77.0);
            activeStar1.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            ;
        }];
    }];
    [UIView animateWithDuration:1.0 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        activeStar2.frame = CGRectMake(111.0, -15.0, 110.0, 107.0);
        activeStar2.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [star2 removeFromSuperview];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            activeStar2.frame = CGRectMake(126.0, 0.0, 80.0, 77.0);
            activeStar2.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            ;
        }];
    }];
    [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        activeStar3.frame = CGRectMake(197.0, 11.0, 110.0, 107.0);
        activeStar3.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [star3 removeFromSuperview];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            activeStar3.frame = CGRectMake(212.0, 26.0, 80.0, 77.0);
            activeStar3.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            ;
        }];
    }];
    ///////
    
    
//    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        activeStar1.alpha = 1.0;
//        activeStar1.frame = CGRectMake(39.0, 26.0, 80.0, 77.0);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            activeStar2.alpha = 1.0;
//            activeStar2.frame = CGRectMake(126.0, 0.0, 80.0, 77.0);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                activeStar3.alpha = 1.0;
//                activeStar3.frame = CGRectMake(212.0, 26.0, 80.0, 77.0);
//            } completion:^(BOOL finished) {
//                ;
//            }];
//        }];
//    }];
    
//    [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        star1.alpha = 0.0;
//        star1.frame = CGRectMake(levelNumHolder.center.x, levelNumHolder.center.y, 0.0, 0.0);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            star2.alpha = 0.0;
//            star2.frame = CGRectMake(levelNumHolder.center.x, levelNumHolder.center.y, 0.0, 0.0);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                star3.alpha = 0.0;
//                star3.frame = CGRectMake(levelNumHolder.center.x, levelNumHolder.center.y, 0.0, 0.0);
//            } completion:^(BOOL finished) {
//                ;
//            }];
//        }];
//    }];
//    
//    [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        activeStar1.alpha = 1.0;
//        activeStar1.frame = CGRectMake(39.0, 26.0, 80.0, 77.0);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            activeStar2.alpha = 1.0;
//            activeStar2.frame = CGRectMake(126.0, 0.0, 80.0, 77.0);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                activeStar3.alpha = 1.0;
//                activeStar3.frame = CGRectMake(212.0, 26.0, 80.0, 77.0);
//            } completion:^(BOOL finished) {
//                ;
//            }];
//        }];
//    }];
}

- (void) shareOnFacebook {
    
}
- (void) shareOnTwitter {
    
}
@end
