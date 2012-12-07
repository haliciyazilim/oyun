//
//  ArrowBase.h
//  OkParcalari
//
//  Created by Eren Halici on 07.12.2012.
//
//

#import <Foundation/Foundation.h>

typedef struct {
    int x;
    int y;
} Location;

Location LocationMake(int x, int y);

@interface ArrowBase : NSObject

@property Location location;
@property int size;

@property int upArrowSize;
@property int downArrowSize;
@property int leftArrowSize;
@property int rightArrowSize;

+ (id) ArrowBaseWithLocation:(Location)location andSize:(int)size;

- (id) initWithLocation:(Location)location andSize:(int)size;

- (BOOL) isCorrect;

@end
