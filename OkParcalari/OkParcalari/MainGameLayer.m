//
//  MainGameLayer.m
//  OkParcalari
//
//  Created by Alperen Kavun on 24.12.2012.
//
//

#import "MainGameLayer.h"
#import "GameCenterManager.h"

@implementation MainGameLayer{
    CCSprite *newGameButton;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainGameLayer *layer = [MainGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)onEnter{
    [super onEnter];
        [[GameCenterManager sharedInstance] authenticateLocalUser];
}

-(id) init
{
    if(self = [super init]){
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"game_bg.png"];
        background.position = ccp(size.width * 0.5, size.height * 0.5);
        [self addChild:background];
        
        newGameButton = [CCSprite spriteWithFile:@"btn_newgame.png"];
        newGameButton.position = ccp(size.width * 0.5, size.height * 0.5);
        
        [self addChild:newGameButton];
        self.isTouchEnabled = YES;
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"entered touchesEnded");
    CGPoint point = [self pointFromTouches:touches];
    if(CGRectContainsPoint([newGameButton boundingBox], point)){
        [self makeTransition];
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(CGPoint)pointFromTouches:(NSSet*) touches
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector] convertToGL:point];
    return point;
}
-(void) makeTransition
{
    NSLog(@"entered makeTransition");
//	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[MapSelectionLayer scene] withColor:ccWHITE]];
    [[[CCDirector sharedDirector] navigationController] pushViewController:[[MapSelectionCollectionViewController alloc] init] animated:YES];
}

@end
