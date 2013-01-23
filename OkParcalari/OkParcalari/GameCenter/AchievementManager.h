//
//  AchievementManager.h
//  GreenTheGarden
//
//  Created by Alperen Kavun on 22.01.2013.
//
//

#import <Foundation/Foundation.h>

@interface AchievementManager : NSObject


@property NSMutableDictionary * achievementDescriptions;


-(void) getAchievements;
-(void) submitAchievement: (NSString*) identifier percentComplete: (float) percent;
@end
