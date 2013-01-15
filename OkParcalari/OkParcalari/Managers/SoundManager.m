//
//  SoundManager.m
//  GreenTheGarden
//
//  Created by Abdullah Karacabey on 14.01.2013.
//
//

#import "SoundManager.h"
#import "SimpleAudioEngine.h"

@interface SoundManager()

@property NSString * background;

@end


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
        _background=@"backgroundMusic.mp3";
    }
    return self;
}


-(void)playBackgroundMusic{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:_background loop:YES];
}

-(void)resumeBackgroundMusic{
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

-(void)stopBackgroundMusic{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void)playEffect:(NSString *)item{
    [[SimpleAudioEngine sharedEngine] playEffect:item];
}



@end
