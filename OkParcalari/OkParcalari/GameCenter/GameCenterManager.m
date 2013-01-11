//
//  GameCenterManager.m
//  OkParcalari
//
//  Created by Alperen Kavun on 27.12.2012.
//
//

#import "GameCenterManager.h"

@implementation GameCenterManager

static GameCenterManager *sharedManager = nil;
+(GameCenterManager *)sharedInstance{
    if(!sharedManager){
        sharedManager = [[GameCenterManager alloc] init];
    }
    return sharedManager;
}

-(void)authenticateLocalUser{
    NSLog(@"entered authenticateLocalUser");
    if(!_isGameCenterAvailable){
        return;
    }
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
        NSLog(@"*********Authenticated***********");
    } else {
        NSLog(@"Already authenticated!");
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
        NSLog(@"Authentication changed: player authenticated.");
        _isUserAuthenticated = TRUE;
        
            [[GameCenterManager sharedInstance] getScores];
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && _isUserAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        _isUserAuthenticated = FALSE;
    }
}

- (void) saveScore:(int)score category:(NSString*)category
{
    NSLog(@"entered saveScore");
    NSLog(@"score: %d, category: %@",score,category);
    GKScore* gkScore =
    [[GKScore alloc]
     initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:
     ^(NSError* error) {
         NSLog(@"score is reported");
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
                    // handle the error.
                    NSLog(@"Error retrieving score.", nil);
                }
                
                if (scores != nil) {
                    for (GKScore *score in scores) {
                        NSLog(@"My Score: %lld", score.value);
                    }
                }
            }];
        }
        else{
            NSLog(@"board is nil");
        }
    }
    else{
        NSLog(@"user is not authenticated");
    }
}

@end
