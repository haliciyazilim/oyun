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
    
    CGFloat topMargin = 31.0;
    CGFloat contentLeftPadding = 400.0;
    
    NSArray* maps = [ArrowGameMap loadMapsFromFile:@"haydn"];
    [scrollView setContentSize:CGSizeMake(unitSize.width*ceil((float)maps.count/(float)rowCount)+unitSize.width*0.5+contentLeftPadding, unitSize.height*rowCount)];
    
    
    int index = 0;
    int nonPlayedActiveGameCount = 2;
    for (Map* map in maps) {
        if(map.isFinished == NO){
            if(nonPlayedActiveGameCount > 0){
                map.isNotPlayedActiveGame = YES;
                nonPlayedActiveGameCount--;
                map.isLocked = NO;
            }
            else
                map.isLocked = YES;
        }
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                      (index/rowCount)*unitSize.width + (index%rowCount == 1 ? unitSize.width*0.5 : 0)+contentLeftPadding,
                                                                      (index%rowCount)*unitSize.height,
                                                                      buttonSize.width,
                                                                      buttonSize.height)];
        
        button.tag = index;
        [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"level_bg.png"]]];
                
        [scrollView addSubview:button];
        
        index++;
        
        if(index < 10){
            UIImageView* view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"level_num_%d.png",index]]];
//            CGRect rect = CGRectMake(40.0, 20.0, view.image.size.width, view.image.size.height);
            view.frame = CGRectMake((float)(buttonSize.width - view.image.size.width) * 0.5+5.0, topMargin, view.image.size.width, view.image.size.height);
//            NSLog(@"buttonSize.width: %f, view.image.size.width",buttonSize.width);
            [button addSubview:view];
        }
        else{
            UIImageView* firstDigit  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"level_num_%d.png",index/10]]];
            UIImageView* secondDigit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"level_num_%d.png",index%10]]];
            CGFloat width = firstDigit.image.size.width + secondDigit.image.size.width;
            firstDigit.frame  = CGRectMake((buttonSize.width - width) * 0.5 + 5.0, topMargin, firstDigit.image.size.width,firstDigit.image.size.height);
            secondDigit.frame = CGRectMake((buttonSize.width - width) * 0.5 + 5.0 + firstDigit.image.size.width, topMargin, secondDigit.image.size.width,secondDigit.image.size.height);
            [button addSubview:firstDigit];
            [button addSubview:secondDigit];
        }
    
        UIImage* passiveStar = [UIImage imageNamed:@"level_star_passive.png"];
        UIImage* activeStar  = [UIImage imageNamed:@"level_star_active.png"];
//        NSLog(@"buttonSize.width: %f, passiveStar.size.width * 3: %f ",buttonSize.width,passiveStar.size.width*3);
        
        
        if(map.isLocked){
            UIImageView* passiveLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level_bg_pasive.png"]];
            [button addSubview:passiveLayer];
        }
        else {
            
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            if(map.isFinished){
                for(int i=0;i<3;i++){
                    UIImageView* view;
                    if(i < map.starCount)
                        view = [[UIImageView alloc] initWithImage:activeStar];
                    else
                        view = [[UIImageView alloc] initWithImage:passiveStar];
                    view.frame = CGRectMake((buttonSize.width - passiveStar.size.width * 3) * 0.5 + 5.0 + passiveStar.size.width * i, buttonSize.height - passiveStar.size.height - 20.0, passiveStar.size.width, passiveStar.size.height);
                    [button addSubview:view];
                }
            }
        }

    }
    
}

-(void)onClick:(UIButton*)button
{
//    NSLog(@"button tag: %d",button.tag);
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ArrowGameLayer sceneWithFile:[NSString stringWithFormat:@"haydn_%d",button.tag]] withColor:ccWHITE]];
    [scrollView removeFromSuperview];
    [self removeFromParentAndCleanup:YES];
}

-(id) init
{
    if(self = [super init]){
        
        buttonSize = CGSizeMake(158.0, 182.0);
        unitSize = CGSizeMake(180.0, 190.0);
        rowCount = 2;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"map_selection_layer.png"];
        background.position = ccp(size.width * 0.5, size.height * 0.5);
        [self addChild:background];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 300.0, 1024.0, 400.0)];
        [scrollView setBackgroundColor:[UIColor colorWithWhite:255.0 alpha:0.5]];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [[[CCDirector sharedDirector] view] addSubview:scrollView];
        
        
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"entered touchesEnded");
//    CGPoint point = [self pointFromTouches:touches];
//    if(CGRectContainsPoint([newGameButton boundingBox], point)){
//        [self makeTransition];
//    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) makeTransition
{
    NSLog(@"entered makeTransition");
    //	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[MapSelectionLayer scene] withColor:ccWHITE]];
//    [[[CCDirector sharedDirector] navigationController] pushViewController:[[MapSelectionCollectionViewController alloc] init] animated:YES];
}

@end
