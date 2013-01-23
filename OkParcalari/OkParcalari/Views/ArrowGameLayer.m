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

@implementation ArrowGameLayer
{
    NSString *_fileName;
    UIView *inGameButtonsView;
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
}
- (void) inGameMenuWillClose {
    [self.arrowGame resumeGame];
    self.isTouchEnabled = YES;
}
- (void) returnToMainMenu {
    [self.arrowGame cleanMap];
    [self.arrowGame removeFromParentAndCleanup:YES];
    [self removeFromParentAndCleanup:YES];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[MapSelectionLayer scene] withColor:ccWHITE]];
}
-(void) gameEnded
{
    NSLog(@"entered gameEnded");
}
@end
