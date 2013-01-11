//
//  MainGameLayer.m
//  OkParcalari
//
//  Created by Alperen Kavun on 24.12.2012.
//
//

#import "MapSelectionLayer.h"

@implementation MapSelectionLayer
{
    UIScrollView* scrollView;
    CGSize unitSize;
    CGSize buttonSize;
    int rowCount;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MapSelectionLayer *gameLayer = [MapSelectionLayer node];
	
	// add layer as a child to scene
	[scene addChild:gameLayer];
	
	// return the scene
	return scene;
}

- (void)onEnter{
    [super onEnter];
    
    NSArray* maps = [ArrowGameMap loadMapsFromFile:@"haydn"];
//    NSLog(@"maps.count: %d",maps.count);
//    NSLog(@"content width: %f",unitSize.width*ceil((float)maps.count/(float)rowCount));
    [scrollView setContentSize:CGSizeMake(unitSize.width*ceil((float)maps.count/(float)rowCount), unitSize.height*rowCount)];
    
    int index = 0;
    for (Map* map in maps) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                      (index/rowCount)*unitSize.width,
                                                                      (index%rowCount)*unitSize.height,
                                                                      buttonSize.width,
                                                                      buttonSize.height)];
        [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"level_bg.png"]]];
                
        [scrollView addSubview:button];
        
        index++;
    }
    
}

-(id) init
{
    if(self = [super init]){
        
        buttonSize = CGSizeMake(158.0, 182.0);
        unitSize = CGSizeMake(250.0, 190.0);
        rowCount = 2;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"map_selection_layer.png"];
        background.position = ccp(size.width * 0.5, size.height * 0.5);
        [self addChild:background];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(100.0, 300.0, 924.0, 400.0)];
        [scrollView setBackgroundColor:[UIColor colorWithWhite:255.0 alpha:0.5]];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [[[CCDirector sharedDirector] view] addSubview:scrollView];
        
        
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"entered touchesEnded");
//    CGPoint point = [self pointFromTouches:touches];
//    if(CGRectContainsPoint([newGameButton boundingBox], point)){
//        [self makeTransition];
//    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(CGPoint)pointFromTouches:(NSSet*) touches
{
//    UITouch* touch = [touches anyObject];
//    CGPoint point = [touch locationInView:[touch view]];
//    point = [[CCDirector sharedDirector] convertToGL:point];
//    return point;
}
-(void) makeTransition
{
    NSLog(@"entered makeTransition");
    //	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[MapSelectionLayer scene] withColor:ccWHITE]];
//    [[[CCDirector sharedDirector] navigationController] pushViewController:[[MapSelectionCollectionViewController alloc] init] animated:YES];
}

@end
