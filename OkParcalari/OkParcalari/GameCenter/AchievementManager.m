//
//  AchievementManager.m
//  GreenTheGarden
//
//  Created by Alperen Kavun on 22.01.2013.
//
//

#import "AchievementManager.h"
#import "GameCenterManager.h"
#import "DatabaseManager.h"
#import "GreenTheGardenGCSpecificValues.h"


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
//            NSLog(@"Acievement Descripticon: %@", achievementDescription.achievedDescription);
        
        }
    }];
    _achievementDescriptions=achievementDescriptions;
    
}

- (void) loadAchievements
{
    
    NSMutableDictionary *achievementsDictionary = [[NSMutableDictionary alloc] init];

    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
     {
         
//         NSLog(@"Load Acievements Count: %i", [achievements count]);
         if (error == nil)
         {
             for (GKAchievement* achievement in achievements){
                 if(achievement.percentComplete==100.0){
                     [achievementsDictionary setObject: achievement forKey: achievement.identifier];
//                     NSLog(@"Load Acievements: %@, percent: %f", achievement.identifier,achievement.percentComplete);
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
//        NSLog(@"Loaded Achievement: %@, Lid: %@, Lpercent: %f", loadedAchievement,loadedAchievement.identifier,loadedAchievement.percentComplete);
    }
    
//    NSLog(@"Gelen Başarı: %@, percet: %f",achievement.identifier, achievement.percentComplete);
    
//    NSLog(@"IsExist: %d",isExist);
    
    //if (achievement || isExist==NO) // esas sorgu bu.
    if (achievement) // Test için duruyor bu.
    {

        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES; 
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             
             if (achievement.percentComplete==100.0) {
                 GKAchievementDescription *achievementDescription=[[GKAchievementDescription alloc] init];
                 achievementDescription=[_achievementDescriptions objectForKey:achievement.identifier];
                
             }
             
             dispatch_async(dispatch_get_main_queue(), ^(void)
                            {
                                if (error == NULL) {
                                    NSLog(@"Successfully sent archievement!");
                                    [[AchievementManager sharedAchievementManager]loadAchievements];
                                } else {
                                    NSLog(@"Achievement failed to send... will try again \
                                          later.  Reason: %@", error.localizedDescription);
                                }
                            });
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

-(void)checkAchievementFastMindQuickHands: (Map*) playedMap{
//    NSLog(@"MAp.score: %@", playedMap.score);
    if(playedMap.score.intValue<60)
    [self submitAchievement:kAchievementFastMindQuickHands percentComplete:100];
}

-(void) checkAchievementMapsStars:(Map*) playedMap{
    // Check maps for difficulty
    NSArray * maps=[[DatabaseManager sharedInstance] getMapsForDifficulty:playedMap.difficulty];
    int mapsCount=maps.count;
    int solvedMapsCount=0;
    int star3Count=0;
    
    for(Map * map in maps){
        if (map.isFinished) {
            solvedMapsCount++;
        }
        if (map.getStarCount==3) {
            star3Count++;
        }
    }
    NSLog(@"Çözülen Haritananın zorluğu: %i, Aynı zorlutaki tüm harita sayısı: %i, çözülmüş harita sayısı: %i",playedMap.difficulty,mapsCount,solvedMapsCount);
    
    

        NSString * achievementCompletionist=[[NSString alloc] init];
        NSString * achievementPerfectionist=[[NSString alloc] init];
        switch (playedMap.difficulty) {
            case 1:
                achievementCompletionist=kAchievementEasyMapsCompletionist;
                achievementPerfectionist =kAchievementEasyMapsPerfectionist;
                break;
            case 2:
                achievementCompletionist=kAchievementNormalMapsCompletionist;
                achievementPerfectionist=kAchievementNormalMapsPerfectionist;
                break;
            case 3:
                achievementCompletionist=kAchievementHardMapsCompletionist;
                achievementPerfectionist=kAchievementHardMapsPerfectionist;
                break;
            case 4:
                achievementCompletionist=kAchievementInsaneMapsCompletionist;
                achievementPerfectionist=kAchievementInsaneMapsPerfectionist;
                break;
            default:
                break;
        }
    double solvedMapPercentComplete=solvedMapsCount*100/mapsCount;
    double star3PercentComplete=star3Count*100/mapsCount;
    

    [self submitAchievement:achievementCompletionist percentComplete:solvedMapPercentComplete];
    [self submitAchievement:achievementPerfectionist percentComplete:star3PercentComplete];
    
    
}

@end
