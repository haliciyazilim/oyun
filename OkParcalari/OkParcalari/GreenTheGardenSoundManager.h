//
//  GreenTheGardenSoundManager.h
//  GreenTheGarden
//
//  Created by Alperen Kavun on 15.01.2013.
//
//

#import "SoundManager.h"

@interface GreenTheGardenSoundManager : SoundManager

+ (GreenTheGardenSoundManager *) sharedSoundManager;

@property (nonatomic) BOOL isBackgroundMusicMuted;
@property (nonatomic) BOOL isEffectsMuted;
@property (nonatomic) BOOL isStarted;

@end
