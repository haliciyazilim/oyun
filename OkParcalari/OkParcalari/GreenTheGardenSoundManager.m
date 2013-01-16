//
//  GreenTheGardenSoundManager.m
//  GreenTheGarden
//
//  Created by Alperen Kavun on 15.01.2013.
//
//

#import "GreenTheGardenSoundManager.h"
#import "SimpleAudioEngine.h"

@implementation GreenTheGardenSoundManager

static GreenTheGardenSoundManager *sharedSoundManager = nil;

+ (GreenTheGardenSoundManager *) sharedSoundManager {
    if(!sharedSoundManager){
        sharedSoundManager = [[GreenTheGardenSoundManager alloc] init];
    }
    return sharedSoundManager;
}

- (id) init {
    if(self = [super init]) {
        self.backgroundMusic = @"backgroundMusic.mp3";
        NSArray *objectsArray = [[NSArray alloc] initWithObjects:@"", nil];
        NSArray *keysArray = [[NSArray alloc] initWithObjects:@"", nil];
        self.effects = [[NSMutableDictionary alloc] initWithObjects:objectsArray forKeys:keysArray];
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:self.backgroundMusic];
        for (NSString *effect in self.effects) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:effect];
        }
        
        NSNumber *isMusicMuted = [[NSUserDefaults standardUserDefaults] objectForKey:@"isBackgroundMusicMuted"];
        if(!isMusicMuted){
            _isBackgroundMusicMuted = NO;
        }
        else{
            _isBackgroundMusicMuted = [isMusicMuted boolValue];
        }
        NSNumber *isEffMuted = [[NSUserDefaults standardUserDefaults] objectForKey:@"isEffectsMuted"];
        if(!isEffMuted){
            _isEffectsMuted = NO;
        }
        else{
            _isEffectsMuted = [isEffMuted boolValue];
        }

    }
    return self;
}

- (void) setIsBackgroundMusicMuted:(BOOL)isBackgroundMusicMuted {
    _isBackgroundMusicMuted = isBackgroundMusicMuted;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isBackgroundMusicMuted] forKey:@"isBackgroundMusicMuted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setIsEffectsMuted:(BOOL)isEffectsMuted {
    _isEffectsMuted = isEffectsMuted;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isEffectsMuted] forKey:@"isEffectsMuted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
