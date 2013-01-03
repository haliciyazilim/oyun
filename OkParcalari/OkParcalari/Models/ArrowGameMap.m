//
//  ArrowGameMap.m
//  OkParcalari
//
//  Created by Yunus Eren Guzel on 12/19/12.
//
//

#import "ArrowGameMap.h"

@implementation ArrowGameMap

+ (NSArray*) loadMapsFromFile:(NSString*)fileName{
    
    NSMutableArray* maps = [[NSMutableArray alloc] init];
    
    NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"packageinfo"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
	
    NSDictionary* file = [parser objectWithString:content];
    
    if( [(NSNumber*)[file valueForKey:@"version"] intValue] == 1){
               
        for(NSString* mapName in [file objectForKey:@"maps"]){
            [maps addObject:mapName];
        }
    }

    return (NSArray*)maps;
    
}

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