//
//  JSONParser.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 7/10/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "JSONParser.h"
#import "PhotoObject.h"
#import "UserCommentObject.h"

@implementation JSONParser{
    
    NSMutableArray *tempPhotoObjectArray;
    PhotoObject *photoObject;
}

+ (instancetype)sharedInstance {
    
    static JSONParser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JSONParser alloc] init];        
    });
    return sharedInstance;
}

- (void)serializeInstagramJson: (NSString *)jsonAsString{
    
    NSError *error = nil;
    NSDictionary *theDictionary = [[NSDictionary alloc] init];
    theDictionary = [NSJSONSerialization JSONObjectWithData: [jsonAsString  dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    tempPhotoObjectArray = tempPhotoObjectArray == nil ? [[NSMutableArray alloc] init] : tempPhotoObjectArray;
    
    if(error)
        NSLog(@"JSON Error: %@", error);
    
    //fetch the images
    NSMutableArray *arrayWhereImageJsonStarts = [[NSMutableArray alloc] init];
    arrayWhereImageJsonStarts = [[[[[[theDictionary valueForKey:@"entry_data"] valueForKey:@"FeedPage"] valueForKey:@"feed"] valueForKey:@"media"] valueForKey:@"nodes"] objectAtIndex: 0];
    
    for(int i = 0; i < [arrayWhereImageJsonStarts count]; i++){ //insert property into array of photo objects
        
        photoObject = [[PhotoObject alloc] init];
        photoObject.imageSource = [NSURL URLWithString: [[arrayWhereImageJsonStarts valueForKey:@"display_src"] objectAtIndex: i]];
        photoObject.theCaption = [[arrayWhereImageJsonStarts valueForKey:@"caption"] objectAtIndex: i] == [NSNull null] ? @"" : [[arrayWhereImageJsonStarts valueForKey:@"caption"] objectAtIndex: i];
        photoObject.fullName = [[[arrayWhereImageJsonStarts valueForKey:@"owner"] valueForKey:@"full_name"] objectAtIndex: i];
        photoObject.userName = [[[arrayWhereImageJsonStarts valueForKey:@"owner"] valueForKey:@"username"] objectAtIndex: i];
        photoObject.profilePictureSource = [NSURL URLWithString:[[[arrayWhereImageJsonStarts valueForKey:@"owner"] valueForKey: @"profile_pic_url"] objectAtIndex: i]];
        photoObject.numberOfLikes = [[[[arrayWhereImageJsonStarts valueForKey:@"likes"] valueForKey:@"count"] objectAtIndex: i] intValue];
        photoObject.arrayOfCommentUsers = [[NSMutableArray alloc] init];
        photoObject.imageHeight = [[[[arrayWhereImageJsonStarts valueForKey:@"dimensions"] valueForKey:@"height"] objectAtIndex: i] floatValue];
        photoObject.imageWidth = [[[[arrayWhereImageJsonStarts valueForKey:@"dimensions"] valueForKey:@"width"] objectAtIndex: i] floatValue];
        
        for(int j = 0; j < [[[[[arrayWhereImageJsonStarts valueForKey: @"comments"] valueForKey:@"nodes"] valueForKey:@"text"] objectAtIndex: i] count]; j++){
            
            
            UserCommentObject *commentObject = [[UserCommentObject alloc] init];
            [photoObject.arrayOfCommentUsers addObject: commentObject];
            [photoObject.arrayOfCommentUsers objectAtIndex: j].commentText = [[[[[arrayWhereImageJsonStarts valueForKey: @"comments"] valueForKey:@"nodes"] valueForKey:@"text"] objectAtIndex: i] objectAtIndex: j];
            
            [photoObject.arrayOfCommentUsers objectAtIndex: j].username = [[[[[[arrayWhereImageJsonStarts valueForKey: @"comments"] valueForKey:@"nodes"] valueForKey: @"user"] valueForKey: @"username"] objectAtIndex: i] objectAtIndex: j];
            
        }
        
        if([[arrayWhereImageJsonStarts valueForKey:@"video_url"] objectAtIndex: i] != [NSNull null])
            photoObject.videoSource = [NSURL URLWithString: [[arrayWhereImageJsonStarts valueForKey:@"video_url"] objectAtIndex: i]];
        
        if(i >= tempPhotoObjectArray.count)
            [tempPhotoObjectArray addObject: photoObject];
    }
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"readInstagramJson" object:tempPhotoObjectArray];
}

@end
