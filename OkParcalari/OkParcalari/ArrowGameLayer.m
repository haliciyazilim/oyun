//
//  ArrowGameLayer.m
//  OkParcalari
//
//  Created by Eren Halici on 06.12.2012.
//
//

#import "ArrowGameLayer.h"

@implementation ArrowGameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ArrowGameLayer *layer = [ArrowGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


@end
