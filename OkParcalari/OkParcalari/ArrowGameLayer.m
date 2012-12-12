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

@implementation ArrowGameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ArrowGameLayer *layer = [ArrowGameLayer node];
	
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
        CCSprite *background = [CCSprite spriteWithFile:@"game_bg.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
		self.isTouchEnabled = YES;
        self.arrowGame = [[ArrowGame alloc] init];
        [self addChild:self.arrowGame];
        
	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"asdasdasd");
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
