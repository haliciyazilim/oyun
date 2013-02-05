//
//  Gallery.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "Gallery.h"

@implementation Gallery
@dynamic name;
@dynamic photos;

+ (Gallery*) createGalleryWithName:(NSString*)name
{
    Gallery* gallery = (Gallery*)[[RMDatabaseManager sharedInstance] createEntity:@"Gallery"];
    gallery.name = name;
    [[RMDatabaseManager sharedInstance] saveContext];
    return gallery;
}
+ (NSMutableArray*) allGalleries
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    return [[RMDatabaseManager sharedInstance] entitiesWithRequest:request forName:@"Gallery"];
}

@end
