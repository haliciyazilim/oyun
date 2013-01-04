//
//  ArrowGameLayer.m
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#import "ArrowGameLayer.h"
#import "InGameMenuLayer.h"
#import "GameMap.h"
#import "MapEntity.h"
#import "CCBReader.h"
#import "Squirt.h"
#import "CCBAnimationManager.h"
#import "MapSelectionCollectionViewController.h"

@implementation ArrowGameLayer
{
    CCSprite *buttonView;
    NSString *_fileName;
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
-(void)onEnter{
    [super onEnter];
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
        
        CCSprite *timerView = [CCSprite spriteWithFile:@"timing_bg.png"];
        timerView.position = ccp(size.width * 0.85, size.height * 0.54);
                
        buttonView = [CCSprite spriteWithFile:LocalizedImageName(@"btn_newgame", @"png")];
        buttonView.position = ccp(size.width * 0.86, size.height * 0.38);
        
        [self addChild:background];
        [self addChild:timerView];

        
        [self addChild:buttonView];
        [self addChild:frameView];
        [self reorderChild:frameView z:999];
        [self addChild:topView];
        [self reorderChild:topView z:998];
        
		self.isTouchEnabled = YES;
        
        
	}
	return self;
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
    NSLog(@"touchesBegan");
    if(CGRectContainsPoint([buttonView boundingBox], [self pointFromTouches:touches])){
        [self.arrowGame pauseGame];
        [self showInGameMenu];
    }
    else{
        [self.arrowGame touchBegan:[self locationFromTouches:touches]];
    }
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
    InGameMenuLayer *menuLayer = [[InGameMenuLayer alloc] init];
    menuLayer.callerLayer = self;
    [self addChild:menuLayer];
    [self reorderChild:menuLayer z:1111];
    self.isTouchEnabled = NO;
}
- (void) inGameMenuWillClose {
    [self.arrowGame resumeGame];
    self.isTouchEnabled = YES;
}
- (void) returnToMainMenu {
    [self.arrowGame cleanMap];
    [self.arrowGame removeFromParentAndCleanup:YES];
//    [[CCDirector sharedDirector] popScene];
//    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    [[[CCDirector sharedDirector] navigationController] pushViewController:[[MapSelectionCollectionViewController alloc] init] animated:YES];
}
-(void) gameEnded
{
    
}
@end
