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
    GameMap* gameMap = [self sharedInstance];

    NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"gamemap"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
	
    NSDictionary* map = [parser objectWithString:content];
    
    
    
    
    if( [(NSNumber*)[map valueForKey:@"version"] intValue] == 1){
        NSDictionary* size = [map valueForKey:@"mapsize"];
        gameMap.rows = [(NSNumber*)[size valueForKey:@"rows"] intValue];
        gameMap.cols = [(NSNumber*)[size valueForKey:@"cols"] intValue];
        
        for(NSDictionary* entitiy in [map objectForKey:@"entities"]){
            if([(NSString*)[entitiy valueForKey:@"class"] compare:@"ArrowBase"] == 0){
                ArrowBase * base = [ArrowBase arrowBaseFromDictionary:entitiy];
                [gameMap addChild:base];
            }
        }
    }
    
    return gameMap;
}




@end
