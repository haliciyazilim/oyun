//
//  ArrowGameMap.m
//  OkParcalari
//
//  Created by Yunus Eren Guzel on 12/19/12.
//
//

#import "ArrowGameMap.h"

@implementation ArrowGameMap


+ (GameMap*) loadFromFile:(NSString*)fileName{
    GameMap* map = [self sharedInstance];

    NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"gamemap"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];

    
    SBJsonParser *parser = [[SBJsonParser alloc] init];

    NSArray *statuses = [parser objectWithString:content error:nil];
    for (NSDictionary *status in statuses) {
        
        
    }
    return map;
}

@end
