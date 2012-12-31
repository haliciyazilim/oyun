//
//  ArrowGameLayer.m
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#import "ArrowGameLayer.h"
#import "GameMap.h"
#import "MapEntity.h"
#import "CCBReader.h"
#import "Squirt.h"

@implementation ArrowGameLayer

+(CCScene *) sceneWithFile:(NSString *)fileName
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ArrowGameLayer *layer = [ArrowGameLayer node];
	[layer initializeGameWithFile:fileName];
	// add layer as a child to scene
	[scene addChild: layer];
	
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
                
//        CCSprite *buttonView = [CCSprite spriteWithFile:LocalizedImageName(@"btn_newgame", @"png")];
//        buttonView.position = ccp(size.width * 0.86, size.height * 0.38);
        
        
        
        [self addChild:background];
        [self addChild:timerView];

        
//        [self addChild:buttonView];
        [self addChild:frameView];
        [self reorderChild:frameView z:999];
        [self addChild:topView];
        [self reorderChild:topView z:998];
        
        CCNode *mySquirt = [CCBReader nodeGraphFromFile:@"Spray.ccbi"];
        mySquirt.position = ccp(size.width * 0.5+32, size.height * 0.5+32);
        
        [self addChild:mySquirt];
        
		self.isTouchEnabled = YES;
        
        
	}
	return self;
}

- (void) initializeGameWithFile:(NSString*)fileName
{
    self.arrowGame = [[ArrowGame alloc] initWithFile:fileName];
    [self addChild:self.arrowGame];
    
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

-(void) gameEnded
{
    
}
@end
