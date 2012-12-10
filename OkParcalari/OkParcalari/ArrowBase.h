//
//  ArrowBase.h
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import <Foundation/Foundation.h>

#import "MapEntity.h"

@interface ArrowBase : MapEntity

@property int size;

@property int upArrowSize;
@property int downArrowSize;
@property int leftArrowSize;
@property int rightArrowSize;

+ (id) ArrowBaseWithLocation:(Location)location andSize:(int)size;

- (id) initWithLocation:(Location)location andSize:(int)size;

- (BOOL) isCorrect;

@end
