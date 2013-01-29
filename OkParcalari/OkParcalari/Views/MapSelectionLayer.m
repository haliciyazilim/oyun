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
#import "AchievementManager.h"
#import "GreenTheGardenGCSpecificValues.h"
#import "TransitionManager.h"


@implementation MapSelectionLayer
{
    UIScrollView* scrollView;
    UIView *barView;
    UIImageView *leafView;
    UIImageView *maskView;
    UIImageView *logoView;
    CGSize unitSize;
    CGSize buttonSize;
    NSString* packageFileName;
    CGFloat topMargin;
    CGFloat contentPadding;
    UIImage* passiveStar;
    UIImage* activeStar;
    UIButton *unlockButton;
//    NSArray *_products;
    int rowCount;
    
    UIViewController * tempVC;
    BOOL shouldCancel;
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

-(id) init
{
    if(self = [super init]){
        packageFileName = @"standart";
        //        CGSize size = [[CCDirector sharedDirector] winSize];
        buttonSize = CGSizeMake(111.0, 128.0);
        unitSize = CGSizeMake(120.0, 135.0);
        topMargin = 26.0;
        contentPadding = 400.0;
        rowCount = 3;
        passiveStar = [UIImage imageNamed:@"level_star_passive.png"];
        activeStar  = [UIImage imageNamed:@"level_star_active.png"];
        
        maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_selection_masklayer.png"]];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 300.0, 1024.0, 400.0)];
        [scrollView setBackgroundColor:[UIColor colorWithWhite:255.0 alpha:0.5]];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        
        leafView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_selection_leaflayer.png"]];
        
        logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GreenTheGarden_Logo.png"]];
        [logoView setFrame:CGRectMake(521, 69, logoView.image.size.width, logoView.image.size.height)];
        
        barView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 708.0, 1024.0, 60)];
        
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
        
        UIButton *gameCenterButton = [[UIButton alloc] initWithFrame:CGRectMake(142.0, 17.0, 26.0, 28.0)];
        [gameCenterButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_gc.png"] forState:UIControlStateNormal];
        [gameCenterButton setBackgroundImage:[UIImage imageNamed:@"map_barbtn_gc_hover.png"] forState:UIControlStateHighlighted];
        [gameCenterButton addTarget:self action:@selector(showGameCenter) forControlEvents:UIControlEventTouchUpInside];

        
        [barView addSubview:infoButton];
        [barView addSubview:fxButton];
        [barView addSubview:musicButton];
        [barView addSubview:gameCenterButton];
        
        if(![[GreenTheGardenIAPHelper sharedInstance] isPro]){
            unlockButton = [[UIButton alloc] initWithFrame:CGRectMake(783.0, 17.0, 150.0, 28.0)];
            [unlockButton setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"map_barbtn_unlock", @"png")] forState:UIControlStateNormal];
            [unlockButton setBackgroundImage:[UIImage imageNamed:LocalizedImageName(@"map_barbtn_unlock_hover", @"png")] forState:UIControlStateHighlighted];
            [unlockButton addTarget:self action:@selector(addStore) forControlEvents:UIControlEventTouchUpInside];
            [barView addSubview:unlockButton];
        }

        
        [[[CCDirector sharedDirector] view] addSubview:maskView];
        [[[CCDirector sharedDirector] view] addSubview:logoView];
        [[[CCDirector sharedDirector] view] addSubview:scrollView];
        [[[CCDirector sharedDirector] view] addSubview:leafView];
        [[[CCDirector sharedDirector] view] addSubview:barView];
        
    }
    return self;
}


- (UIButton*) buttonForMap:(Map*)map atIndex:(int)index
{
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(
                                                           (index/rowCount)*unitSize.width + (unitSize.width*0.5*(index%rowCount))+contentPadding,
                                                           (index%rowCount)*unitSize.height,
                                                           buttonSize.width,
                                                           buttonSize.height)];
    button.tag = [map.mapId intValue];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"map_%@_bg.png",stringOfDifficulty(map.difficulty)]] forState:UIControlStateNormal];
    
    BOOL isPassive = map.isLocked || !map.isPurchased;
    
    [scrollView addSubview:button];
    if(map.order < 10){
        UIImageView* view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"level_num_%d.png",map.order]]];
        view.frame = CGRectMake((float)(buttonSize.width - view.image.size.width) * 0.5+5.0, topMargin, view.image.size.width, view.image.size.height);
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
    
    if(isPassive){
        UIImageView* passiveLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"map_%@_mask.png",stringOfDifficulty(map.difficulty)]]];
        [passiveLayer setAlpha:0.80];
        
        [button addSubview:passiveLayer];
        
        if(!map.isPurchased){
            [passiveLayer setAlpha:1.0];
            [button addTarget:self action:@selector(addStore) forControlEvents:UIControlEventTouchUpInside];
            UIImageView* lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level_locked.png"]];
//            lock.image = [lock.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
            lock.frame = CGRectMake(buttonSize.width*0.5 - lock.image.size.width*0.5 + 5.0, buttonSize.height * 0.5 , lock.image.size.width, lock.image.size.height);
            [button addSubview:lock];
        }
        else if(map.isLocked){
//            UIImageView* lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"level_locked.png"]];
//            lock.frame = CGRectMake(buttonSize.width*0.5 - lock.image.size.width*0.5 + 5.0, buttonSize.height * 0.5 , lock.image.size.width , lock.image.size.height);
//            [button addSubview:lock];
            
        }
        
    }else {
        
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(map.isFinished){
            int score = [map.score intValue];
            NSLog(@"score: %d",score);
            for(int i=0;i<3;i++){
                UIImageView* view;
                if(i < [map getStarCount])
                    view = [[UIImageView alloc] initWithImage:activeStar];
                else
                    view = [[UIImageView alloc] initWithImage:passiveStar];
                view.frame = CGRectMake((buttonSize.width - passiveStar.size.width * 3) * 0.5 + 5.0 + passiveStar.size.width * i, buttonSize.height - passiveStar.size.height - 20.0, passiveStar.size.width, passiveStar.size.height);
                [button addSubview:view];
            }
        }
    }
    

    return button;
}

-(void) refreshScrollView
{
    for (UIView* view in scrollView.subviews) {
        if([view isKindOfClass:[UIButton class]]){
            [view removeFromSuperview];
        }
    }
    
    [self loadMapIcons];

    
}

- (void) loadMapIcons
{
    NSArray* maps = [ArrowGameMap loadMapsFromFile:@"standart"];
    
    
    [scrollView setContentSize:CGSizeMake(unitSize.width*ceil((float)maps.count/(float)rowCount)+unitSize.width*0.5+contentPadding*2.0, unitSize.height*rowCount)];
    [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.contentSize.height)];
    int index = 0;
    for (Map* map in maps) {
        [self buttonForMap:map atIndex:index];
        index++;
    }
//    [scrollView scrollRectToVisible:CGSizeMake([MapSelectionLayer getLastScroll], 0) animated:NO];
    [scrollView setContentOffset:CGPointMake([MapSelectionLayer getLastScroll], 0.0)];
    

}

- (void)onEnter{
    [self refreshScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (!shouldCancel) {
            [[AchievementManager sharedAchievementManager]submitAchievement:kAchievementNothingToDoHere percentComplete:100];
        }
    });
    
    
}

- (void)onExit {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
    shouldCancel=YES;
}

-(void)onDown:(UIButton*)button
{
    [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"level_bg_selected.png"]]];
}

-(void)onClick:(UIButton*)button
{
//    NSLog(@"button tag: %d",button.tag);
    self.isTouchEnabled = NO;
    TransitionManager *myManager = [[TransitionManager alloc] initWithTransitionBlock:^{
        [MapSelectionLayer setLastScroll:scrollView.contentOffset.x];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[ArrowGameLayer sceneWithFile:[NSString stringWithFormat:@"%d",button.tag]] withColor:ccWHITE]];
        [scrollView removeFromSuperview];
        [maskView removeFromSuperview];
        [leafView removeFromSuperview];
        [barView removeFromSuperview];
        [logoView removeFromSuperview];
        [self removeFromParentAndCleanup:YES];
    }];
    [myManager startTransition];
}

- (void) setPackage:(NSString*)package
{
    packageFileName = package;
}

- (void)productPurchased:(NSNotification *)notification {
    [unlockButton removeFromSuperview];
    [self refreshScrollView];
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
        [[GreenTheGardenIAPHelper sharedInstance] setCallerLayer:self];
        [[GreenTheGardenIAPHelper sharedInstance] createStore];
    }
    
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

- (void) showGameCenter
{
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
        NSLog(@"show GameCenter");
        tempVC = [[UIViewController alloc] init];
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil){
            gameCenterController.gameCenterDelegate = self;
            [[[CCDirector sharedDirector] view] addSubview:tempVC.view];
            [tempVC presentModalViewController:gameCenterController animated:YES];
        }
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [tempVC dismissModalViewControllerAnimated:YES];
    [tempVC.view removeFromSuperview];
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

//static MAP_DIFFICULTY difficulty = EASY;
//+(MAP_DIFFICULTY) getDifficulty
//{
//    return difficulty;
//}
//+(void) setDifficulty:(MAP_DIFFICULTY)_difficulty
//{
//    difficulty = _difficulty;
//}

static int __lastScroll = 0;

+(int)getLastScroll
{
    return __lastScroll;
}

+(void)setLastScroll:(int)scroll{
    __lastScroll = scroll;
}

@end
