//
//  WebView+JSONSerialization.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/26/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "ConnectionJSONSerialization.h"
#import "PhotoObject.h"
#import "UserCommentObject.h"
#import "Scripts.h"

@implementation Connector_JSONSerialization {
    
    PhotoObject *photoObject;    
    NSString *maxId;
    
}

+ (id)sharedManager {
    static Connector_JSONSerialization *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchInstagramFeed: (bool)isAppending{
    
    _isCurrentlyFetchingJson = true;
    NSString *urlString = isAppending ? [NSString stringWithFormat: FetchInitialFeed, maxId] : FetchInitialFeed;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSMutableURLRequest *theRequest= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                         timeoutInterval:60.0];
    
    [theRequest setHTTPMethod:@"GET"];
    
    //set the content type to JSON
    [theRequest setValue:@"i.instagram.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue: @"Instagram 8.2.0 Android (23/6.0; 515dpi; 1440x2416; huawei/google; Nexus 6P; angler; angler; en_US)" forHTTPHeaderField:@"User-Agent"];
    
    [theRequest addValue: @"sessionid=IGSC6958ba2dab13cb266a28a09e58cc4843d7f81c24a45f453774ec89441247eeaf%3AYVbHmDBBFP9wHRgsCnbpBsygE5uvEbpm%3A%7B%22_token_ver%22%3A2%2C%22_auth_user_id%22%3A1372632715%2C%22_token%22%3A%221372632715%3AUEoGJbCcxbXylpVVuyBwl2rbhvbyBS6T%3A9dc5494f2f142ea514fa33eb34a000fa1931c3d63a1e750547cebb787100d88c%22%2C%22asns%22%3A%7B%22173.94.28.114%22%3A11426%2C%22time%22%3A1469409554%7D%2C%22_auth_user_backend%22%3A%22accounts.backends.CaseInsensitiveModelBackend%22%2C%22last_refreshed%22%3A1469409555.000256%2C%22_platform%22%3A1%2C%22_auth_user_hash%22%3A%22%22%7D;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  " forHTTPHeaderField:@"Cookie"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [self serializeInstagramJson:data];
        
    }];
    
    [postDataTask resume];
}

- (void)serializeInstagramJson: (NSData *) data{
    
    NSError *error = nil;
    NSDictionary *theDictionary = [[NSDictionary alloc] init];
    
    if (data != nil) theDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if(!_tempPhotoObjectArray) _tempPhotoObjectArray = [[NSMutableArray alloc] init];
    
    if(error)
        NSLog(@"JSON Error: %@", error);
    
    //fetch the images
    NSMutableArray *arrayWhereImageJsonStarts = [[NSMutableArray alloc] init];
    arrayWhereImageJsonStarts = [theDictionary valueForKey:@"items"];
    maxId = [theDictionary valueForKey:@"next_max_id"];
    
    if(arrayWhereImageJsonStarts.count > 0) {
                
        for(int i = 0; i < [arrayWhereImageJsonStarts count]; i++){ //insert property into array of photo objects
            
            photoObject = [[PhotoObject alloc] init];
            NSLog(@"about to fetch image source");
            if ([[arrayWhereImageJsonStarts valueForKey: @"image_versions2" ] valueForKey:@"candidates"] != [NSNull null] && [[[[arrayWhereImageJsonStarts valueForKey: @"image_versions2" ] valueForKey:@"candidates"] objectAtIndex: i] objectAtIndex: 0] != [NSNull null] && [NSURL URLWithString: [[[[[arrayWhereImageJsonStarts valueForKey: @"image_versions2" ] valueForKey:@"candidates"] objectAtIndex: i] objectAtIndex: 0] valueForKey: @"url"]] != [NSNull null]) {
                photoObject.imageSource = [NSURL URLWithString: [[[[[arrayWhereImageJsonStarts valueForKey: @"image_versions2" ] valueForKey:@"candidates"] objectAtIndex: i] objectAtIndex: 0] valueForKey: @"url"]];
            }
            NSLog(@"fetching image source at index: %d", i);
            photoObject.theCaption = [[[arrayWhereImageJsonStarts valueForKey:@"caption"] valueForKey: @"text" ]objectAtIndex: i] == [NSNull null] ? @"" : [[[arrayWhereImageJsonStarts valueForKey:@"caption"] valueForKey: @"text" ]objectAtIndex: i];
            NSLog(@"fetching caption at index: %d", i);
            photoObject.fullName = [[[arrayWhereImageJsonStarts valueForKey:@"user"] valueForKey: @"full_name"] objectAtIndex: i];
            NSLog(@"fetching full name: %d", i);
            photoObject.userName = [[[arrayWhereImageJsonStarts valueForKey:@"user"] valueForKey: @"username"] objectAtIndex: i];
            NSLog(@"fetching username: %d", i);
            photoObject.profilePictureSource = [NSURL URLWithString:[[[arrayWhereImageJsonStarts valueForKey:@"user"] valueForKey: @"profile_pic_url"] objectAtIndex: i]];
            NSLog(@"fetching profile pic source: %d", i);
            photoObject.numberOfLikes = [[[arrayWhereImageJsonStarts valueForKey:@"like_count"] objectAtIndex: i] intValue];
            NSLog(@"fetching number of likes: %d", i);
            photoObject.arrayOfCommentUsers = [[NSMutableArray alloc] init];
            photoObject.imageHeight = [[[[[[arrayWhereImageJsonStarts valueForKey: @"image_versions2" ] valueForKey:@"candidates"] objectAtIndex: i] objectAtIndex: 0] valueForKey: @"height"] floatValue];
            NSLog(@"fetching height: %d", i);
            photoObject.imageWidth = [[[[[[arrayWhereImageJsonStarts valueForKey: @"image_versions2" ] valueForKey:@"candidates"] objectAtIndex: i] objectAtIndex: 0] valueForKey: @"width"] floatValue];
            NSLog(@"fetching width: %d", i);
            
            
            if([[arrayWhereImageJsonStarts valueForKey: @"comments"] objectAtIndex: i ] != [NSNull null]) {
                for(int j = 0; j < [[[arrayWhereImageJsonStarts valueForKey: @"comments"] objectAtIndex: i ] count]; j++){
                    
                    
                    UserCommentObject *commentObject = [[UserCommentObject alloc] init];
                    [photoObject.arrayOfCommentUsers addObject: commentObject];
                    [photoObject.arrayOfCommentUsers objectAtIndex: j].commentText = [[[[arrayWhereImageJsonStarts valueForKey: @"comments"] valueForKey:@"text"] objectAtIndex: i] objectAtIndex: j];
                    
                    [photoObject.arrayOfCommentUsers objectAtIndex: j].username = [[[[[arrayWhereImageJsonStarts valueForKey: @"comments"] valueForKey: @"user"] valueForKey: @"username"] objectAtIndex: i] objectAtIndex: j];
                    
                }
            }
            NSLog(@"fetching comments");
            if([[arrayWhereImageJsonStarts valueForKey:@"video_versions"] objectAtIndex: i] != [NSNull null])
                photoObject.videoSource = [NSURL URLWithString: [[[[arrayWhereImageJsonStarts valueForKey: @"video_versions"] objectAtIndex: i] objectAtIndex: 0] valueForKey: @"url"]];
            
            NSLog(@"fetching videos");
            [_tempPhotoObjectArray addObject: photoObject];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"readInstagramJson" object:_tempPhotoObjectArray];
        
        
        
    } else { NSLog(@"something went wrong"); }
    
    _isCurrentlyFetchingJson = false;
}

@end
