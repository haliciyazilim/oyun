//
//  AchievementManager.m
//  GreenTheGarden
//
//  Created by Alperen Kavun on 22.01.2013.
//
//

#import "AchievementManager.h"
#import "GameCenterManager.h"
#import "GKAchievementHandler.h"
//#import "GreenTheGardenAppSpecificValues.h"


@implementation AchievementManager

static AchievementManager * sharedAchievementManager=nil;

+(AchievementManager *) sharedAchievementManager{
    if(!sharedAchievementManager){
        sharedAchievementManager=[[AchievementManager alloc]init];
    }
    return sharedAchievementManager;
}



- (id)init
{
    self = [super init];
    if (self) {
        [self getAchievements];
        
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
            NSLog(@"Acievement Descripticon: %@", achievementDescription.achievedDescription);
        
        }
    }];
    _achievementDescriptions=achievementDescriptions;
    
}

- (void) loadAchievements
{
    
    NSMutableDictionary *achievementsDictionary = [[NSMutableDictionary alloc] init];

    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
     {
         
         NSLog(@"Load Acievements Count: %i", [achievements count]);
         if (error == nil)
         {
             for (GKAchievement* achievement in achievements){
                 if(achievement.percentComplete==100.0){
                     [achievementsDictionary setObject: achievement forKey: achievement.identifier];
                     NSLog(@"Load Acievements: %@, percent: %f", achievement.identifier,achievement.percentComplete);
                 }
                 
             }
         }
         else{
             NSLog(@"Error in loading achievements: %@", error);

         }
         _achievementsDictionary=achievementsDictionary;
     }];
}

- (void) submitAchievement: (NSString*) identifier percentComplete: (float) percent;
{
    
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    
    NSLog(@"submitted Achievement: %@, Lid: %@, Lpercent: %f", achievement,achievement.identifier,achievement.percentComplete);

    
    BOOL isExist=NO;
    GKAchievement * loadedAchievement=[[GKAchievement alloc] initWithIdentifier:[_achievementsDictionary objectForKey:achievement.identifier]];
    
    
    
    if(loadedAchievement!=NULL){
        isExist=YES;
        //loadedAchievement=[[GKAchievement alloc] initWithIdentifier:strAchievement];
        NSLog(@"Loaded Achievement: %@, Lid: %@, Lpercent: %f", loadedAchievement,loadedAchievement.identifier,loadedAchievement.percentComplete);
    }
    
    NSLog(@"Gelen Başarı: %@, percet: %f",achievement.identifier, achievement.percentComplete);
    
    NSLog(@"IsExist: %d",isExist);
    
    if (achievement || isExist==NO)
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (achievement.percentComplete==100.0) {
                 GKAchievementDescription *achievementDescription=[[GKAchievementDescription alloc] init];
                 achievementDescription=[_achievementDescriptions objectForKey:achievement.identifier];
                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:achievementDescription.title andMessage:achievementDescription.achievedDescription];
             }
             
             
             if (error != nil)
             {
                 NSLog(@"Error in reporting achievements: %@", error);
             }
         }];
    }
}

- (void) resetAchievements
{
    // Clear all locally saved achievement objects.
    _achievementsDictionary = [[NSMutableDictionary alloc] init];
    // Clear all progress saved on Game Center.
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error){
         if (error != nil){
             // handle the error.
         }
    }];
}

@end
