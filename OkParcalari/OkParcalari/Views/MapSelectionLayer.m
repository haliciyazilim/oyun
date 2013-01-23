//
//  MainGameLayer.m
//  OkParcalari
//
//  Created by Alperen Kavun on 24.12.2012.
//
//

#define GAME_LAYER_TAG 582

#import "MapSelectionLayer.h"
#import "GreenTheGardenSoundManager.h"
#import "GreenTheGardenIAPHelper.h"

@implementation MapSelectionLayer
{
    UIView *store;
    UIScrollView* scrollView;
    UIView *barView;
    UIImageView *leafView;
    UIImageView *maskView;
    CGSize unitSize;
    CGSize buttonSize;
    NSString* packageFileName;
//    NSArray *_products;
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

- (void) loadMapIcons
{
    CGFloat topMargin = 31.0;
    CGFloat contentLeftPadding = 400.0;
    
    NSArray* maps = [ArrowGameMap loadMapsFromFile:@"standart"];
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
        [button setBackgroundImage:[UIImage imageNamed:@"level_bg.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"level_bg_selected.png"] forState:UIControlStateHighlighted];
        [scrollView addSubview:button];
        
        index++;
        
        if(map.order < 10){
            UIImageView* view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"level_num_%d.png",map.order]]];
            //            CGRect rect = CGRectMake(40.0, 20.0, view.image.size.width, view.image.size.height);
            view.frame = CGRectMake((float)(buttonSize.width - view.image.size.width) * 0.5+5.0, topMargin, view.image.size.width, view.image.size.height);
            //            NSLog(@"buttonSize.width: %f, view.image.size.width",buttonSize.width);
            [button addSubview:view];
        }
        else{
            UIImageView* firstDigit  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"level_num_%d.png",map.order/10]]];
            UIImageView* secondDigit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"level_num_%d.png",map.order%10]]];
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
            UIImageView* lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level_locked.png"]];
            lock.frame = CGRectMake(buttonSize.width*0.5 - lock.image.size.width*0.5 + 5.0, buttonSize.height * 0.5 , lock.image.size.width , lock.image.size.height);
            [button addSubview:lock];
            
        }
        else {
            
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            //            [button addTarget:self action:@selector(onDown:) forControlEvents:UIControlEventTouchDown] ;
            if(map.isFinished){
                int score = [map.score intValue];
                map.starCount = score < 60 ? 3 : (score < 120 ? 2 : ( score < 300 ? 1 : 0));
                NSLog(@"score: %d",score);
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
        
        /*<[[TEST*/
        //delete after testing
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        /*TEST]]>*/
        
    }

}

- (void)onEnter{
    [self loadMapIcons];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
}

- (void)onExit {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
}

-(void)onDown:(UIButton*)button
{
    [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"level_bg_selected.png"]]];
}

-(void)onClick:(UIButton*)button
{
//    NSLog(@"button tag: %d",button.tag);
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[ArrowGameLayer sceneWithFile:[NSString stringWithFormat:@"haydn_%d",button.tag]] withColor:ccWHITE]];
    [scrollView removeFromSuperview];
    [maskView removeFromSuperview];
    [leafView removeFromSuperview];
    [barView removeFromSuperview];
    [self removeFromParentAndCleanup:YES];
}

- (void) setPackage:(NSString*)package
{
    packageFileName = package;
}

-(id) init
{
    if(self = [super init]){
        packageFileName = @"standart";
//        CGSize size = [[CCDirector sharedDirector] winSize];
        buttonSize = CGSizeMake(158.0, 182.0);
        unitSize = CGSizeMake(180.0, 190.0);
        rowCount = 2;
        
        maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_selection_masklayer.png"]];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 300.0, 1024.0, 400.0)];
        [scrollView setBackgroundColor:[UIColor colorWithWhite:255.0 alpha:0.5]];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        
        leafView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_selection_leaflayer.png"]];
        
        barView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 708.0, 1024.0, 60)];
        
        UIButton *unlockButton = [[UIButton alloc] initWithFrame:CGRectMake(783.0, 17.0, 150.0, 28.0)];
        [unlockButton setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"map_barbtn_unlock", @"png")] forState:UIControlStateNormal];
        [unlockButton setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"map_barbtn_unlock_hover", @"png")] forState:UIControlStateHighlighted];
        [unlockButton addTarget:self action:@selector(addStore) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton* infoButton = [[UIButton alloc] initWithFrame:CGRectMake(35.0, 17.0, 26.0, 28.0)];
        [infoButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_info.png"] forState:UIControlStateNormal];
        [infoButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_info_hover.png"] forState:UIControlStateHighlighted];
        
        UIButton* fxButton = [[UIButton alloc] initWithFrame:CGRectMake(70.0, 17.0, 26.0, 28.0)];
        if([[GreenTheGardenSoundManager sharedSoundManager] isEffectsMuted]){
            [fxButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_fx_off.png"] forState:UIControlStateNormal];
            [fxButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_fx_off.png"] forState:UIControlStateHighlighted];
        }
        else{
            [fxButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_fx_on.png"] forState:UIControlStateNormal];
            [fxButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_fx_on.png"] forState:UIControlStateHighlighted];
        }
        [fxButton addTarget:self action:@selector(fxClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* musicButton = [[UIButton alloc] initWithFrame:CGRectMake(106.0, 17.0, 26.0, 28.0)];
        if([[GreenTheGardenSoundManager sharedSoundManager] isBackgroundMusicMuted]){
            [musicButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_music_off.png"] forState:UIControlStateNormal];
            [musicButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_music_off.png"] forState:UIControlStateHighlighted];
        }
        else{
            [musicButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_music_on.png"] forState:UIControlStateNormal];
            [musicButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_music_on.png"] forState:UIControlStateHighlighted];
        }
        [musicButton addTarget:self action:@selector(musicClicked:) forControlEvents:UIControlEventTouchUpInside];

        [barView addSubview:infoButton];
        [barView addSubview:fxButton];
        [barView addSubview:musicButton];
        [barView addSubview:unlockButton];
        
        [[[CCDirector sharedDirector] view] addSubview:maskView];
        [[[CCDirector sharedDirector] view] addSubview:scrollView];
        [[[CCDirector sharedDirector] view] addSubview:leafView];
        [[[CCDirector sharedDirector] view] addSubview:barView];
        
    }
    return self;
}
- (void)productPurchased:(NSNotification *)notification {

    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            NSLog(@"successfully purchased %@",productIdentifier);
            *stop = YES;
        }
    }];

}
- (void)buyPro {
    NSLog(@"entered buyPro at callerLayer");
    if([[GreenTheGardenIAPHelper sharedInstance] canMakePurchases]){
        [[GreenTheGardenIAPHelper sharedInstance] buyProduct:[_products objectAtIndex:0]];
    }
    else{
        UIAlertView *couldNotMakePurchasesAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"IN_APP_PURCHASES", nil)
                                                                             message:NSLocalizedString(@"COULD_NOT_MAKE_PURCHASES", nil)
                                                                            delegate:self
                                                                   cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                   otherButtonTitles:nil,nil];
        [couldNotMakePurchasesAlert show];
    }
}
- (void)restorePurchases {
    NSLog(@"entered restore purchases at caller layer");
    [[GreenTheGardenIAPHelper sharedInstance] restoreCompletedTransactions];
}
-(void)addStore {
    if(!self.reachability){
        self.reachability = [Reachability reachabilityForInternetConnection];
    }
    NetworkStatus netStatus = [self.reachability currentReachabilityStatus];
    if(netStatus == NotReachable){
        UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:@""
                                                                      message:NSLocalizedString(@"CONNECTION_ERROR", nil)
                                                                     delegate:self
                                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                            otherButtonTitles:nil,nil];
        [noConnection show];
    }
    else{
        UIView *storeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0)];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ingame_menu_frame.png"]];
        UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inapp_back.png"]];
        [backView setFrame:CGRectMake(322.0, 231.0, 380.0, 306.0)];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity setColor:[UIColor blackColor]];
        [activity setHidesWhenStopped:YES];
        [activity startAnimating];
        activity.frame = CGRectMake(161.0, 115.0, 60.0, 60.0);
        
        [storeView addSubview:backgroundView];
        [backView addSubview:activity];
        [storeView addSubview:backView];
        [[[CCDirector sharedDirector] view] addSubview:storeView];
        [[GreenTheGardenIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if([products count] != 0){
                [storeView removeFromSuperview];
                _products = products;
                [[GreenTheGardenIAPHelper sharedInstance] setCallerLayer:self];
                store = [[GreenTheGardenIAPHelper sharedInstance] createStore];
                [[[CCDirector sharedDirector] view] addSubview:store];
            }
            else{
                UIAlertView *couldNotGetProducts = [[UIAlertView alloc] initWithTitle:@""
                                                                                     message:NSLocalizedString(@"SERVER_ERROR", nil)
                                                                                    delegate:self
                                                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                           otherButtonTitles:nil,nil];
                [couldNotGetProducts show];
            }
        }];
    }
    
}
- (void)closeStore {
    [store removeFromSuperview];
}
- (void)fxClicked:(UIButton *)button {
    if([[GreenTheGardenSoundManager sharedSoundManager] isEffectsMuted]){
        [button setBackgroundImage:[UIImage imageNamed:@"map_barbtn_fx_on.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"map_barbtn_fx_on.png"] forState:UIControlStateHighlighted];
        [[GreenTheGardenSoundManager sharedSoundManager] setIsEffectsMuted:NO];
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"map_barbtn_fx_off.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"map_barbtn_fx_off.png"] forState:UIControlStateHighlighted];
        [[GreenTheGardenSoundManager sharedSoundManager] setIsEffectsMuted:YES];
    }
}
- (void)musicClicked:(UIButton *)button {
    if([[GreenTheGardenSoundManager sharedSoundManager] isBackgroundMusicMuted]){
        [button setBackgroundImage:[UIImage imageNamed:@"map_barbtn_music_on.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"map_barbtn_music_on.png"] forState:UIControlStateHighlighted];
        [[GreenTheGardenSoundManager sharedSoundManager] setIsBackgroundMusicMuted:NO];
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"map_barbtn_music_off.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"map_barbtn_music_off.png"] forState:UIControlStateHighlighted];
        [[GreenTheGardenSoundManager sharedSoundManager] setIsBackgroundMusicMuted:YES];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) makeTransition
{
    NSLog(@"entered makeTransition");
}

static MAP_DIFFICULTY difficulty = EASY;
+(MAP_DIFFICULTY) getDifficulty
{
    return difficulty;
}
+(void) setDifficulty:(MAP_DIFFICULTY)_difficulty
{
    difficulty = _difficulty;
}


@end
