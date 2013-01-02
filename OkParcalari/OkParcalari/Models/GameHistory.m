//
//  GameHistory.m
//  OkParcalari
//
//  Created by Yunus Eren Guzel on 1/2/13.
//
//

#import "GameHistory.h"

@implementation Score

+(Score*)score:(int)s map:(NSString*)mapName
{
    Score* score = [[Score alloc] init];
    score.score = s;
    score.mapName = mapName;
    return score;
}

@end

@implementation GameHistory


+(NSMutableArray*)_scores
{
    static NSMutableArray* scores;
    if(scores == nil){
        scores = [[NSMutableArray alloc] init];
    }
    return scores;
}

+(void)saveScore:(int)score forMap:(NSString*)map
{
    
}

+(NSArray*)scores
{
    return [GameHistory _scores];
}

+(Score*)scoreForMap:(NSString*)mapName
{
    return nil;
}


@end
