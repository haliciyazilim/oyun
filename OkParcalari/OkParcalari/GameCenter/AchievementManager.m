//
//  AchievementManager.m
//  GreenTheGarden
//
//  Created by Alperen Kavun on 22.01.2013.
//
//

#import "AchievementManager.h"
#import "GameCenterManager.h"
//#import "GreenTheGardenAppSpecificValues.h"


@implementation AchievementManager



- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void) getAchievements{
    NSMutableDictionary *achievementDescriptions = [[NSMutableDictionary alloc] init];

    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray *descriptions, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting achievement descriptions: %@", error);
        }
        for (GKAchievementDescription *achievementDescription in descriptions) {
            [achievementDescriptions setObject:achievementDescription forKey:achievementDescription.identifier];
            NSLog(@"Bir şeyler oldu: %@", achievementDescription.identifier);
        
        }
    }];
    _achievementDescriptions=achievementDescriptions;
}

- (void) submitAchievement: (NSString*) identifier percentComplete: (float) percent;
{
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    if (achievement)
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"Error in reporting achievements: %@", error);
             }
         }];
    }
}

@end
