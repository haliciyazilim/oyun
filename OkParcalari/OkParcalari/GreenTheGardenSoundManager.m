//
//  GreenTheGardenSoundManager.m
//  GreenTheGarden
//
//  Created by Alperen Kavun on 15.01.2013.
//
//

#import "GreenTheGardenSoundManager.h"

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
    }
    return self;
}

@end
