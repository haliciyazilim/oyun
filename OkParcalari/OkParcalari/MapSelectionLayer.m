//
//  MapSelectionLayer.m
//  OkParcalari
//
//  Created by Alperen Kavun on 24.12.2012.
//
//

#import "MapSelectionLayer.h"

@implementation MapSelectionLayer
{
    MapSelectionCollectionViewController* collectionViewController;
}
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MapSelectionLayer *layer = [MapSelectionLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)onEnter{
    [super onEnter];
}

-(id) init
{
    if(self = [super init]){
        
        collectionViewController = [[MapSelectionCollectionViewController alloc] init];
        [[[CCDirector sharedDirector] view] addSubview:[collectionViewController view]];
        self.isTouchEnabled = YES;
    }
    return self;
}

@end
