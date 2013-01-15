//
//  SoundManager.m
//  GreenTheGarden
//
//  Created by Abdullah Karacabey on 14.01.2013.
//
//

#import "SoundManager.h"
#import "SimpleAudioEngine.h"

@implementation SoundManager

static SoundManager *sharedSoundManager = nil;

+ (SoundManager *) sharedSoundManager {
    if(!sharedSoundManager){
        sharedSoundManager = [[SoundManager alloc] init];
    }
    return sharedSoundManager;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)playBackgroundMusic{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:_backgroundMusic loop:YES];
}

-(void)resumeBackgroundMusic{
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

-(void)stopBackgroundMusic{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void)playEffect:(NSString *)itemKey{
    [[SimpleAudioEngine sharedEngine] playEffect:[self.effects objectForKey:itemKey]];
}



@end
