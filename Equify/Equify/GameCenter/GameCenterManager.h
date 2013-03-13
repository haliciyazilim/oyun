//
//  GameCenterManager.h
//  Equify
//
//  Created by Alperen Kavun on 13.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterManager : NSObject

@property (nonatomic) BOOL isGameCenterAvailable;
@property (nonatomic) BOOL isUserAuthenticated;
@property NSArray * leaderboardCategories;
@property NSArray * leaderboardTitles;

+ (GameCenterManager *) sharedInstance;
- (void) authenticateLocalUser;
- (void) submitScore:(int)score category:(NSString*)category;

-(void) getScores;
@end
