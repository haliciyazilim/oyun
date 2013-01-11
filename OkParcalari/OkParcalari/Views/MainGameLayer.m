//
//  MainGameLayer.m
//  OkParcalari
//
//  Created by Alperen Kavun on 24.12.2012.
//
//

#import "MainGameLayer.h"
#import "GameCenterManager.h"
#import "GreenTheGardenIAPHelper.h"
#import "Util.h"
#import "CCBReader.h"

@implementation MainGameLayer{
    CCSprite *newGameButton;
    NSArray *_products;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainGameLayer *gameLayer = [MainGameLayer node];
	
	// add layer as a child to scene
	[scene addChild:gameLayer];
	
	// return the scene
	return scene;
}

- (void)onEnter{
    [super onEnter];
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[GameCenterManager sharedInstance] authenticateLocalUser];
//    [[GreenTheGardenIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
//        _products = products;
//    }];
//    [[GameCenterManager sharedInstance] saveScore:9 category:@"high_score"];
//    [[GameCenterManager sharedInstance] getScores];
    
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
    colorLayer.position = ccp(size.width*0.0,size.height*0.0);
    
    CCLayer *backLayer = (CCLayer *)[CCBReader nodeGraphFromFile:@"mainLayer.ccbi"];
    backLayer.position = ccp(size.width*0.0, size.height*0.0);
    
    [self addChild:colorLayer];
    [self addChild:backLayer];
    
}

//- (void)productPurchased:(NSNotification *)notification {
//    
//    NSString * productIdentifier = notification.object;
//    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
//        if ([product.productIdentifier isEqualToString:productIdentifier]) {
//            NSLog(@"successfully purchased %@",productIdentifier);
//            *stop = YES;
//        }
//    }];
//    
//}

-(id) init
{
    if(self = [super init]){
        CGSize size = [[CCDirector sharedDirector] winSize];
//        CCSprite *background = [CCSprite spriteWithFile:@"game_bg.png"];
//        background.position = ccp(size.width * 0.5, size.height * 0.5);
//        [self addChild:background];
        
        newGameButton = [CCSprite spriteWithFile:LocalizedImageName(@"btn_newgame", @"png")];
        newGameButton.position = ccp(size.width * 0.5, size.height * 0.5);
        
        [self addChild:newGameButton z:997];
        self.isTouchEnabled = YES;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"entered touchesEnded");
    CGPoint point = [self pointFromTouches:touches];
    if(CGRectContainsPoint([newGameButton boundingBox], point)){
        [self makeTransition];
//        [self buyButtonTapped];
    }
//    else{
//        [self restoreTapped];
//    }
}

//- (void) buyButtonTapped {
//    SKProduct *product = [_products objectAtIndex:0];
//    
//    NSLog(@"Buying %@...", product.productIdentifier);
//    [[GreenTheGardenIAPHelper sharedInstance] buyProduct:product];
//}
//
//- (void)restoreTapped {
//    [[GreenTheGardenIAPHelper sharedInstance] restoreCompletedTransactions];
//}

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
