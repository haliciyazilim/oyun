//
//  ArrowGameLayer.m
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#define MENU_TAG 994

#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>

#import "ArrowGameLayer.h"
#import "InGameMenuLayer.h"
#import "GameMap.h"
#import "MapEntity.h"
#import "CCBReader.h"
#import "Squirt.h"
#import "CCBAnimationManager.h"
#import "MapSelectionLayer.h"
#import "GreenTheGardenSoundManager.h"
#import "Stopwatch.h"

#import "AchievementManager.h"
#import "GreenTheGardenGCSpecificValues.h"
#import "TransitionManager.h"

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachedToRestaurantNotification object:nil];
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
    [menuButton addTarget:self action:@selector(goToMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachedToRestaurant:) name:kReachedToRestaurantNotification object:nil];
    
    [inGameButtonsView addSubview:fxButton];
    [inGameButtonsView addSubview:musicButton];
    [inGameButtonsView addSubview:menuButton];
    
    [[[CCDirector sharedDirector] view] addSubview:inGameButtonsView];
}
-(void)goToMenu{
    if(!_isRestaurantOpened){
        [self showInGameMenu:NO];
    }
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
        
        _isRestaurantOpened = NO;
        
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
    __lastInstance = self;
    self.arrowGame = [[ArrowGame alloc] initWithFile:fileName];
    [self addChild:self.arrowGame];
}

- (void) restartGame {
    self.isTouchEnabled = NO;
    
    [[TransitionManager sharedInstance] makeTransitionWithBlock:^{
        [self.arrowGame cleanMap];
        [self.arrowGame removeFromParentAndCleanup:YES];
        [ArrowGame cleanLastInstance];
        [ArrowGameLayer cleanLastInstance];
        self.isTouchEnabled = YES;
        _isRestaurantOpened = NO;
        [self initializeGameWithFile:_fileName];
    }];
    
//    TransitionManager *myManager = [[TransitionManager alloc] initWithTransitionBlock:^{
//        [self.arrowGame cleanMap];
//        [self.arrowGame removeFromParentAndCleanup:YES];
//        [ArrowGame cleanLastInstance];
//        [ArrowGameLayer cleanLastInstance];
//        self.isTouchEnabled = YES;
//        [self initializeGameWithFile:_fileName];
//    }];
//    [myManager startTransition];
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
- (void) reachedToRestaurant:(NSNotification *)notif {
    [[AchievementManager sharedAchievementManager] submitAchievement:kAchievementTheRestaurant percentComplete:100.0];
    _isRestaurantOpened = YES;
    [self showInGameMenu:YES];
    
}
- (void) showInGameMenu:(BOOL)isRestaurant {
    InGameMenuLayer *child = (InGameMenuLayer*)[self getChildByTag:MENU_TAG];
    if(child){
        [child resumeGame];
    }
    else{
        if([self.arrowGame isGameRunning]){
            [self.arrowGame pauseGame];
        }
        InGameMenuLayer *menuLayer = [[InGameMenuLayer alloc] initWithRestaurant:isRestaurant];
        menuLayer.callerLayer = self;
        menuLayer.tag = MENU_TAG;
        [self addChild:menuLayer];
        [self reorderChild:menuLayer z:1111];
        self.isTouchEnabled = NO;
    }
}
- (void) inGameMenuWillClose {
    [self.arrowGame resumeGame];
    self.isTouchEnabled = YES;
}
- (void) returnToMainMenu {
    self.isTouchEnabled = NO;
    [[TransitionManager sharedInstance] makeTransitionWithBlock:^{
        if(gameWinView){
            [gameWinView removeFromSuperview];
            gameWinView = nil;
        }
        _isRestaurantOpened = NO;
        [self.arrowGame cleanMap];
        [self.arrowGame removeFromParentAndCleanup:YES];
        [self removeFromParentAndCleanup:YES];
        [ArrowGameLayer cleanLastInstance];
        [ArrowGame cleanLastInstance];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[MapSelectionLayer scene] withColor:ccWHITE]];
    }];
    
//    TransitionManager *myManager = [[TransitionManager alloc] initWithTransitionBlock:^{
//        if(gameWinView){
//            [gameWinView removeFromSuperview];
//            gameWinView = nil;
//        }
//        [self.arrowGame cleanMap];
//        [self.arrowGame removeFromParentAndCleanup:YES];
//        [self removeFromParentAndCleanup:YES];
//        [ArrowGameLayer cleanLastInstance];
//        [ArrowGame cleanLastInstance];
//        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[MapSelectionLayer scene] withColor:ccWHITE]];
//    }];
//    [myManager startTransition];
}
- (void) nextGame {
    Map *oldMap = [[DatabaseManager sharedInstance] getMapWithID:_fileName];
    int oldMapOrder = oldMap.order;
    NSString *oldMapPackage = oldMap.packageId;
    Map *newMap = [[DatabaseManager sharedInstance] getMapWithOrder:[NSNumber numberWithInt:oldMapOrder+1] forPackage:oldMapPackage];
    if (!newMap.isPurchased) {
        UIAlertView *noPurchased = [[UIAlertView alloc] initWithTitle:@""
                                                                   message:NSLocalizedString(@"NO_PURCHASED", nil)
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                         otherButtonTitles:nil,nil];
        [noPurchased show];
    }
    else{
        self.isTouchEnabled = NO;
        [[TransitionManager sharedInstance] makeTransitionWithBlock:^{
            if(gameWinView){
                [gameWinView removeFromSuperview];
                gameWinView = nil;
            }
            [self.arrowGame cleanMap];
            [self.arrowGame removeFromParentAndCleanup:YES];
            self.isTouchEnabled = YES;
            [ArrowGame cleanLastInstance];
            [ArrowGameLayer cleanLastInstance];
            [self initializeGameWithFile:newMap.mapId];
        }];
    }
    
}
-(void) gameEnded:(int)starCount andElapsedSeconds:(int)elapsedSeconds
{
    self.isTouchEnabled = NO;
    
    Map* map = [[DatabaseManager sharedInstance] getMapWithID:_fileName];
    NSString *levelNumStr = [NSString stringWithFormat:@"%d",map.order];
    
    int mapOrder = map.order;
    NSString *oldMapPackage = map.packageId;
    Map *newMap = [[DatabaseManager sharedInstance] getMapWithOrder:[NSNumber numberWithInt:mapOrder+1] forPackage:oldMapPackage];
    
    int minutes = elapsedSeconds / 60;
    int seconds = elapsedSeconds % 60;
    
    NSString *fileName1, *fileName2, *fileName3, *fileName4;
    
    if (minutes < 10) {
        fileName1 = @"youwin_num_0.png";
        fileName2 = [NSString stringWithFormat:@"youwin_num_%d.png",minutes];
    }
    else {
        fileName1 = [NSString stringWithFormat:@"youwin_num_%d.png",minutes/10];
        fileName2 = [NSString stringWithFormat:@"youwin_num_%d.png",minutes%10];
    }
    
    if (seconds < 10) {
        fileName3 = @"youwin_num_0.png";
        fileName4 = [NSString stringWithFormat:@"youwin_num_%d.png",seconds];
    }
    else {
        fileName3 = [NSString stringWithFormat:@"youwin_num_%d.png",seconds/10];
        fileName4 = [NSString stringWithFormat:@"youwin_num_%d.png",seconds%10];
    }
    
    gameWinView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0)];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inapp_menu_frame.png"]];
    
    UIView *holderFrame = [[UIView alloc] initWithFrame:CGRectMake(350.0, 200.0, 327.0, 395.0)];
    
    UIImageView *star1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_star_passive.png"]];
    star1.frame = CGRectMake(40.0, 26.0, 80.0, 77.0);
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
    
    UIView *timerHolder = [[UIView alloc] initWithFrame:CGRectMake(39.0, 160.0, 252.0, 75.0)];
    UIImageView *num1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName1]];
    num1.frame = CGRectMake(0.0, 0.0, 57.0, 75.0);
    num1.transform = CGAffineTransformMakeScale(4.0, 4.0);
    num1.alpha = 0.0;
    
    UIImageView *num2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName2]];
    num2.frame = CGRectMake(57.0, 0.0, 57.0, 75.0);
    num2.transform = CGAffineTransformMakeScale(4.0, 4.0);
    num2.alpha = 0.0;
    
    UIImageView *dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_num_nokta.png"]];
    dot.frame = CGRectMake(114.0, 0.0, 25.0, 75.0);
    
    UIImageView *num3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName3]];
    num3.frame = CGRectMake(138.0, 0.0, 57.0, 75.0);
    num3.transform = CGAffineTransformMakeScale(4.0, 4.0);
    num3.alpha = 0.0;
    
    UIImageView *num4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName4]];
    num4.frame = CGRectMake(195.0, 0.0, 57.0, 75.0);
    num4.transform = CGAffineTransformMakeScale(4.0, 4.0);
    num4.alpha = 0.0;
    
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
    if(newMap){
        [nextGame addTarget:self action:@selector(nextGame) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [nextGame setEnabled:NO];
    }
    
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
    
    NSMutableArray *activeStars = [[NSMutableArray alloc] initWithCapacity:starCount];
    
    for ( int i = 0; i < starCount; i++) {
        CGFloat yOffset;
        if( i % 2 == 0) {
            yOffset = 0.0;
        }
        else{
            yOffset = -26.0;
        }
        UIImageView *activeStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youwin_star_active.png"]];
        activeStar.frame = CGRectMake(40.0+i*86, 26.0+yOffset, 80.0, 77.0);
        activeStar.transform = CGAffineTransformMakeScale(0.0, 0.0);
        activeStar.alpha = 0.0;
        [activeStars addObject:activeStar];
    }
    
    [gameWinView addSubview:background];
    [holderFrame addSubview:star1];
    [holderFrame addSubview:star2];
    [holderFrame addSubview:star3];
    for ( int i = 0; i < starCount; i++){
        [holderFrame addSubview:[activeStars objectAtIndex:i]];
    }
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
    for ( int i = 0; i < starCount; i++){
        [UIView animateWithDuration:0.7 delay:1.2+i*0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [[activeStars objectAtIndex:i] setAlpha:1.0];
        } completion:^(BOOL finished) {
            ;
        }];
    }
    for ( int i = 0; i < starCount; i++){
        [UIView animateWithDuration:1.0 delay:1.2+i*0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGAffineTransform myTransform = CGAffineTransformConcat(CGAffineTransformMakeRotation(1.0), CGAffineTransformMakeScale(1.5, 1.5));
            ((UIView *)[activeStars objectAtIndex:i]).transform = myTransform;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGAffineTransform myTransform = CGAffineTransformConcat(CGAffineTransformMakeRotation(0.0), CGAffineTransformMakeScale(1.0, 1.0));
            ((UIView *)[activeStars objectAtIndex:i]).transform = myTransform;
            } completion:^(BOOL finished) {
                ;
            }];
        }];
    }
    [UIView animateWithDuration:0.8 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        num1.alpha = 1.0;
        num2.alpha = 1.0;
        num3.alpha = 1.0;
        num4.alpha = 1.0;
        num1.transform = CGAffineTransformMakeScale(1.0, 1.0);
        num2.transform = CGAffineTransformMakeScale(1.0, 1.0);
        num3.transform = CGAffineTransformMakeScale(1.0, 1.0);
        num4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        ;
    }];

}

- (void) shareOnFacebook {
    // If a user has *never* logged into your app, request one of
    // "email", "user_location", or "user_birthday". If you do not
    // pass in any permissions, "email" permissions will be automatically
    // requested for you. Other read permissions can also be included here.
//    NSArray *permissions =
//    [NSArray arrayWithObjects:@"email", nil];
//
//    [FBSession openActiveSessionWithReadPermissions:permissions
//                                       allowLoginUI:YES
//                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                                      /* handle success + failure in block */
//
//                                      // can include any of the "publish" or "manage" permissions
//                                      NSArray *permissions =
//                                      [NSArray arrayWithObjects:@"publish_actions", nil];
//                                      
//                                      [[FBSession activeSession] reauthorizeWithPublishPermissions:permissions
//                                                                                   defaultAudience:FBSessionDefaultAudienceFriends
//                                                                                 completionHandler:^(FBSession *session, NSError *error) {
//                                                                                     /* handle success + failure in block */
//                                                                                 }];
//                                  }];
    
    [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                       defaultAudience:FBSessionDefaultAudienceEveryone
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                         NSLog(@"Success!");
                                     
                                         if (status != FBSessionStateOpen) {
                                             // Show alert
                                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FACEBOOK_SESSION_NOT_OPEN_TITLE", nil)
                                                                                                message:NSLocalizedString(@"FACEBOOK_SESSION_NOT_OPEN", nil)
                                                                                               delegate:nil
                                                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                      otherButtonTitles:nil];
                                             
                                             [alertView show];
                                         } else {
                                             //
                                             //                                         BOOL displayedNativeDialog =
                                             //                                         [FBNativeDialogs
                                             //                                          presentShareDialogModallyFrom:[CCDirector sharedDirector]
                                             //                                          initialText:@"(Deneme) 1:15'de üç yıldızı çaktım"
                                             //                                          image:[UIImage imageNamed:@"Icon-72@2x.png"]
                                             //                                          url:[NSURL URLWithString:@"http://www.halici.com.tr"]
                                             //                                          handler:^(FBNativeDialogResult result, NSError *error) {
                                             //                                              if (error) {
                                             //                                                  /* handle failure */
                                             //                                              } else {
                                             //                                                  if (result == FBNativeDialogResultSucceeded) {
                                             //                                                      /* handle success */
                                             //                                                  } else {
                                             //                                                      /* handle user cancel */
                                             //                                                  }
                                             //                                              }
                                             //                                          }];
                                             //                                         if (!displayedNativeDialog) {
                                             //                                             /*
                                             //                                              Fallback to web-based Feed Dialog:
                                             //                                              https://developers.facebook.com/docs/howtos/feed-dialog-using-ios-sdk/
                                             //                                              */
                                             //                                         }
                                             
                                             
                                             // This function will invoke the Feed Dialog to post to a user's Timeline and News Feed
                                             // It will first attempt to do this natively through iOS 6
                                             // If that's not supported we'll fall back to the web based dialog.
                                             
                                             UIImage *image = [UIImage imageNamed:@"Icon-72@2x.png"];
                                             
                                             NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/chp-mobil/id588335596"]];
                                             
                                             bool bDisplayedDialog = [FBNativeDialogs presentShareDialogModallyFrom:[CCDirector sharedDirector]
                                                                                                        initialText:@"Deneme! 5 yildizi caktim ha!"
                                                                                                              image:nil
                                                                                                                url:url
                                                                                                            handler:^(FBNativeDialogResult result, NSError *error) {}];
                                             
                                             if (!bDisplayedDialog)
                                             {
                                                 
                                                 // Put together the dialog parameters
                                                 NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                                @"Green the Garden", @"name",
                                                                                @"1:13'te 3 yildizi caktim!", @"caption",
                                                                                [NSString stringWithFormat:@"I just smashed 1r12 friends! Can you beat my score?"], @"description",
                                                                                @"http://www.friendsmash.com/images/logo_large.jpg", @"picture",
                                                                                
                                                                                // Add the link param for Deep Linking
                                                                                [NSString stringWithFormat:@"http://www.halici.com.tr"], @"link",
                                                                                nil];
                                                 
                                                 // Invoke the dialog
                                                 //                                             [appDelegate.facebook dialog:@"feed" andParams:params andDelegate:nil];
                                                 
                                                 [FBRequestConnection
                                                  startWithGraphPath:@"me/feed"
                                                  parameters:params
                                                  HTTPMethod:@"POST"
                                                  completionHandler:^(FBRequestConnection *connection,
                                                                      id result,
                                                                      NSError *error) {
                                                      NSString *alertText;
                                                      if (error) {
                                                          alertText = [NSString stringWithFormat:
                                                                       @"error: domain = %@, code = %d",
                                                                       error.domain, error.code];
                                                      } else {
                                                          alertText = [NSString stringWithFormat:
                                                                       @"Posted action, id: %@",
                                                                       [result objectForKey:@"id"]];
                                                      }
                                                      // Show the result in an alert
                                                      [[[UIAlertView alloc] initWithTitle:@"Result"
                                                                                  message:alertText
                                                                                 delegate:self
                                                                        cancelButtonTitle:@"OK!"
                                                                        otherButtonTitles:nil]
                                                       show];
                                                  }];
                                             }
                                        }
                                         
                                     }];
}

- (void) shareOnTwitter {
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:@"Deneme #GreenTheGarden"];
    
    [tweetViewController addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/chp-mobil/id588335596"]];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        UIAlertView *alertView;
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                NSLog(@"Tweet cancelled.");
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TWEET_SENT", nil)
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                             otherButtonTitles:nil];
                
                [alertView show];
        
                break;
            default:
                break;
        }
        
        // Dismiss the tweet composition view controller.
        [[CCDirector sharedDirector] dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [[CCDirector sharedDirector] presentModalViewController:tweetViewController animated:YES];
    
}
@end
