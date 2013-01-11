//
//  Map.h
//  GreenTheGarden
//
//  Created by Yunus Eren Guzel on 1/10/13.
//
//

#import <Foundation/Foundation.h>

@interface MapPackage

@property NSString* name;
@property int packageId;
@property NSArray* maps;

@end

@interface Map : NSObject

@property BOOL isFinished;
@property BOOL isPurchased;
@property BOOL isLocked;
@property int  starCount;
@property int  mapId;
@property MapPackage* package;

@end
