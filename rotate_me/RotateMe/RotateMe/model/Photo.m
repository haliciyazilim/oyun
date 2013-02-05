//
//  Photo.m
//  RotateMe
//
//  Created by Yunus Eren Guzel on 2/4/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "Photo.h"
#import "RMDatabaseManager.h"
#import "RMImage.h"

@implementation Photo
{
    RMImage* image;
}
@dynamic filename;
@dynamic gallery;
@dynamic score;

+ (Photo*)createPhotoWithFileName:(NSString*)fileName andGallery:(Gallery*)gallery
{
    Photo* photo = (Photo*)[[RMDatabaseManager sharedInstance] createEntity:@"Photo"];
    photo.filename = fileName;
    photo.gallery = gallery;
    [[RMDatabaseManager sharedInstance] saveContext];
    return photo;
}
- (void) setScore:(int)elapsedTime forDifficulty:(DIFFICULTY)difficulty
{
    Score* score = [self getScoreForDifficulty:difficulty];
    if(score == nil){
        score = (Score*)[[RMDatabaseManager sharedInstance] createEntity:@"Score"];
        score.photo = self;
        score.difficulty = difficulty;
        score.elapsedSeconds = elapsedTime;
    }
    else if(score.elapsedSeconds > elapsedTime){
        score.elapsedSeconds = elapsedTime;
    }

    [[RMDatabaseManager sharedInstance] saveContext];

}
- (Score*) getScoreForDifficulty:(DIFFICULTY)difficulty
{
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"photo == %@ && difficulty == %d", self, difficulty];
    [request setPredicate:predicate];
    return (Score*)[[RMDatabaseManager sharedInstance] entityWithRequest:request forName:@"Score"];
}

- (RMImage*) getImage
{
    if(image == nil){
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:self.gallery.name];
        NSString* imagePath = [folderPath stringByAppendingPathComponent:self.filename];
        
        image = [[RMImage alloc] initWithContentsOfFile:imagePath];
        image.owner = self;
    }
    return image;
}

@end
