//
//  RMBundleInitializer.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "RMBundleInitializer.h"

@implementation RMBundleInitializer

+ (void)initializeBundle
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex: 0];
    
//    NSString *docFile = [[docDir stringByAppendingPathComponent: @"test"] stringByAppendingPathExtension:@"xxx"];
//    [jsonString writeToFile:docFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
    NSArray* imageNames = [NSArray arrayWithObjects:
                      @"test1.png",
                      @"test2.png",
                      @"test3.png",
                      @"test4.png",
                      @"test6.png",
                      @"test7.png",
                      @"test8.png",
                      @"test10.png",
                      @"test11.png",
                      @"test12.png",
                      @"test13.png",
                      @"test14.png",
                       nil] ;
    for(NSString* imageName in imageNames){
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *sourcePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DEFAULT_GALLERY_NAME] stringByAppendingPathComponent:imageName];
        NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:imageName];
        NSLog(@"Source Path: %@\n Documents Path: %@ \n Folder Path: %@", sourcePath, documentsDirectory, folderPath);
        
        NSError *error;
        
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                                toPath:folderPath
                                                 error:&error];
        
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
    }

}

@end
