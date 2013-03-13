//
//  GameCenterManager.m
//  Equify
//
//  Created by Alperen Kavun on 13.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "GameCenterManager.h"
#import "EQGameCenterSpecificValues.h"

@implementation GameCenterManager

static GameCenterManager *sharedManager = nil;
+(GameCenterManager *)sharedInstance{
    if(!sharedManager){
        sharedManager = [[GameCenterManager alloc] init];
    }
    return sharedManager;
}

-(void)authenticateLocalUser{
    if(!_isGameCenterAvailable){
        return;
    }
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        ;
    }
}

- (id)init {
    if ((self = [super init])) {
        _isGameCenterAvailable = [self isGameCenterAvailable];
        if (_isGameCenterAvailable) {
            NSNotificationCenter *notif = [NSNotificationCenter defaultCenter];
            [notif addObserver:self
                      selector:@selector(authenticationChanged)
                          name:GKPlayerAuthenticationDidChangeNotificationName
                        object:nil];
        }
    }
    return self;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !_isUserAuthenticated) {
        _isUserAuthenticated = TRUE;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationChangedNotification object:nil userInfo:nil];
        
        [[GameCenterManager sharedInstance] getScores];
        [[GameCenterManager sharedInstance] loadCategoriesAndTitles];
        
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && _isUserAuthenticated) {
        _isUserAuthenticated = FALSE;
    }
}

- (void) loadCategoriesAndTitles
{
    [GKLeaderboard loadCategoriesWithCompletionHandler:^(NSArray *categories, NSArray *titles, NSError *error) {
        _leaderboardCategories = categories;
        _leaderboardTitles = titles;
        
    }];
}

- (void) submitScore:(int)score category:(NSString*)category
{
    GKScore* gkScore = [[GKScore alloc] initWithCategory:category];
    
    gkScore.value = score;
    
    [gkScore reportScoreWithCompletionHandler: ^(NSError* error) {
         ;
     }];
}

-(void) getScores
{
    
    if([GKLocalPlayer localPlayer].isAuthenticated) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[GKLocalPlayer localPlayer].playerID, nil];
        GKLeaderboard *board = [[GKLeaderboard alloc] initWithPlayerIDs:arr];
        if(board != nil) {
            board.timeScope = GKLeaderboardTimeScopeAllTime;
            board.range = NSMakeRange(1, 1);
            board.category = @"high_score";
            [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                if (error != nil) {
                    ;
                }
                
                //                if (scores != nil) {
                //                    for (GKScore *score in scores) {
                //                        NSLog(@"My Score: %lld", score.value);
                //                    }
                //                }
            }];
        }
        else{
            ;
        }
    }
    else{
        ;
    }
}

@end