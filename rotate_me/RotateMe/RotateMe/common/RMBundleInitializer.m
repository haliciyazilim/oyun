//
//  RMBundleInitializer.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMBundleInitializer.h"
#import "Photo.h"

@implementation RMBundleInitializer

+ (void)initializeBundle
{
    NSArray* imageNames = [NSArray arrayWithObjects:@"test1.jpg",@"test2.jpg",@"test3.jpg",@"test4.jpg",@"test6.jpg",@"test7.jpg",@"test8.jpg",@"test10.jpg",@"test11.jpg",@"test12.jpg",@"test13.jpg",@"test14.jpg",nil] ;
    
    [RMBundleInitializer copyImages:imageNames];
    Gallery* gallery = [Gallery createGalleryWithName:DEFAULT_GALLERY_NAME];
    [RMBundleInitializer insertImages:imageNames forGallery:gallery];

}

+ (void) copyImages:(NSArray*)imageNames
{
    for(NSString* imageName in imageNames){
        NSError *error;
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName];

        NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:DEFAULT_GALLERY_NAME];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
        
        folderPath = [folderPath stringByAppendingPathComponent:imageName];
        
        
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                                toPath:folderPath
                                                 error:&error];
        
    }
}

+ (void) insertImages:(NSArray*)imageNames forGallery:(Gallery*)gallery
{
    for(NSString* imageName in imageNames){
        [Photo createPhotoWithFileName:imageName andGallery:gallery];
    }
}

@end
