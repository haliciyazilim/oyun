//
//  EQAppDelegate.m
//  Equify
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQAppDelegate.h"
#import "EQBundleInitializer.h"
#import "EQDatabaseManager.h"
#import "GameCenterManager.h"

@implementation EQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [EQBundleInitializer initializeBundle];
    
    [[GameCenterManager sharedInstance] authenticateLocalUser];
    
//    [self generateJson];
    
    
//    [self.window makeKeyAndVisible];
    return YES;
}
-(void)generateJson {
    NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"standard-10000-3" ofType:@"questionpack"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *questionPack = [parser objectWithString:content];
    
    NSMutableArray *questionsArray = [NSMutableArray arrayWithCapacity:100];
    
    for (NSDictionary *question in [questionPack objectForKey:@"questions"]) {
        NSArray *questionParts = [[question valueForKey:@"wholeQuestion"] componentsSeparatedByString:@"="];
        
        if ([[questionParts objectAtIndex:0] length] > 8 || [[questionParts objectAtIndex:1] length] > 8) {
            ;
        } else {
            [questionsArray addObject:question];
        }
    }
    
    NSLog(@"there are %d questions",[questionsArray count]);
    
    NSArray *objectsArray = [NSArray arrayWithObjects:questionsArray,@"standard",[NSNumber numberWithInt:1], nil];
    
    NSArray *keysArray = [NSArray arrayWithObjects:@"questions",@"name",@"version", nil];

    NSDictionary* wholeJson = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
    
    NSString *finalJson = [wholeJson JSONRepresentation];
    
    NSLog(@"%@",finalJson);
    
//    NSString *sourcePath = [[NSBundle mainBundle] resourcePath];
//    //        sourcePath = [sourcePath stringByAppendingPathComponent:@"gallery"];
//    //        sourcePath = [sourcePath stringByAppendingPathComponent:galleryName];
//    sourcePath = [sourcePath stringByAppendingPathComponent:@"standard-reduced.questionpack"];
//    
//    // Open output file in append mode:
//    NSOutputStream *stream = [[NSOutputStream alloc] initToFileAtPath:sourcePath append:YES];
//    [stream open];
//    // Make NSData object from string:
//    NSData *data = [finalJson dataUsingEncoding:NSUTF8StringEncoding];
//    // Write data to output file:
//    [stream write:data.bytes maxLength:data.length];
//    [stream close];


}
-(BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
