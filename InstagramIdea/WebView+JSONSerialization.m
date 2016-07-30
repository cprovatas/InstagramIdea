//
//  WebView+JSONSerialization.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/26/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "WebView+JSONSerialization.h"
#import "PhotoObject.h"
#import "UserCommentObject.h"
#import "Scripts.h"

@implementation WebView_JSONSerialization {
    
    PhotoObject *photoObject;
    NSMutableArray *tempPhotoObjectArray;
    NSMutableData *webData;
}

- (void)viewDidLoad{
        
    NSMutableURLRequest *theRequest= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ FetchInitialFeed stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                            cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                        timeoutInterval:60.0];
    [theRequest setHTTPMethod:@"GET"];
    
    //set the content type to JSON
    [theRequest setValue:@"i.instagram.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue: @"Instagram 8.2.0 Android (23/6.0; 515dpi; 1440x2416; huawei/google; Nexus 6P; angler; angler; en_US)" forHTTPHeaderField:@"User-Agent"];
    
    [theRequest addValue: @"sessionid=IGSC6958ba2dab13cb266a28a09e58cc4843d7f81c24a45f453774ec89441247eeaf%3AYVbHmDBBFP9wHRgsCnbpBsygE5uvEbpm%3A%7B%22_token_ver%22%3A2%2C%22_auth_user_id%22%3A1372632715%2C%22_token%22%3A%221372632715%3AUEoGJbCcxbXylpVVuyBwl2rbhvbyBS6T%3A9dc5494f2f142ea514fa33eb34a000fa1931c3d63a1e750547cebb787100d88c%22%2C%22asns%22%3A%7B%22173.94.28.114%22%3A11426%2C%22time%22%3A1469409554%7D%2C%22_auth_user_backend%22%3A%22accounts.backends.CaseInsensitiveModelBackend%22%2C%22last_refreshed%22%3A1469409555.000256%2C%22_platform%22%3A1%2C%22_auth_user_hash%22%3A%22%22%7D;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  " forHTTPHeaderField:@"Cookie"];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if(!webData){
        
        webData = [[NSMutableData alloc] initWithData: data];
        
    }else {
        
        [webData appendData: data];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    NSLog(@"done %@", [[NSString alloc] initWithData: webData encoding: NSUTF8StringEncoding]);
    [self serializeInstagramJson];
}

- (void)serializeInstagramJson{
    
    NSError *error = nil;
    NSDictionary *theDictionary = [[NSDictionary alloc] init];
    theDictionary = [NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingAllowFragments error:&error];
    
    tempPhotoObjectArray = [[NSMutableArray alloc] init];
    
    if(error)
        NSLog(@"JSON Error: %@", error);
    
    //fetch the images
    NSMutableArray *arrayWhereImageJsonStarts = [[NSMutableArray alloc] init];
    arrayWhereImageJsonStarts = [theDictionary valueForKey:@"items"];
    
    for(int i = 0; i < [arrayWhereImageJsonStarts count]; i++){ //insert property into array of photo objects
        
        photoObject = [[PhotoObject alloc] init];
        photoObject.imageSource = [NSURL URLWithString: [[[[[arrayWhereImageJsonStarts valueForKey: @"image_versions2" ] valueForKey:@"candidates"] objectAtIndex: i] objectAtIndex: 0] valueForKey: @"url"]];
        photoObject.theCaption = [[[arrayWhereImageJsonStarts valueForKey:@"caption"] valueForKey: @"text" ]objectAtIndex: i] == [NSNull null] ? @"" : [[[arrayWhereImageJsonStarts valueForKey:@"caption"] valueForKey: @"text" ]objectAtIndex: i];
        photoObject.fullName = [[[arrayWhereImageJsonStarts valueForKey:@"user"] valueForKey: @"full_name"] objectAtIndex: i];
        photoObject.userName = [[[arrayWhereImageJsonStarts valueForKey:@"user"] valueForKey: @"username"] objectAtIndex: i];
        photoObject.profilePictureSource = [NSURL URLWithString:[[[arrayWhereImageJsonStarts valueForKey:@"user"] valueForKey: @"profile_pic_url"] objectAtIndex: i]];
        photoObject.numberOfLikes = [[[arrayWhereImageJsonStarts valueForKey:@"like_count"] objectAtIndex: i] intValue];
        photoObject.arrayOfCommentUsers = [[NSMutableArray alloc] init];
        photoObject.imageHeight = [[[[[[arrayWhereImageJsonStarts valueForKey: @"image_versions2" ] valueForKey:@"candidates"] objectAtIndex: i] objectAtIndex: 0] valueForKey: @"height"] floatValue];
        photoObject.imageWidth = [[[[[[arrayWhereImageJsonStarts valueForKey: @"image_versions2" ] valueForKey:@"candidates"] objectAtIndex: i] objectAtIndex: 0] valueForKey: @"width"] floatValue];
        
        for(int j = 0; j < [[[arrayWhereImageJsonStarts valueForKey: @"comments"] objectAtIndex: i ] count]; j++){
            
            
            UserCommentObject *commentObject = [[UserCommentObject alloc] init];
            [photoObject.arrayOfCommentUsers addObject: commentObject];
            [photoObject.arrayOfCommentUsers objectAtIndex: j].commentText = [[[[arrayWhereImageJsonStarts valueForKey: @"comments"] valueForKey:@"text"] objectAtIndex: i] objectAtIndex: j];
            
            [photoObject.arrayOfCommentUsers objectAtIndex: j].username = [[[[[arrayWhereImageJsonStarts valueForKey: @"comments"] valueForKey: @"user"] valueForKey: @"username"] objectAtIndex: i] objectAtIndex: j];
            
        }
        
//        if([[arrayWhereImageJsonStarts valueForKey:@"video_url"] objectAtIndex: i] != [NSNull null])
//            photoObject.videoSource = [NSURL URLWithString: [[arrayWhereImageJsonStarts valueForKey:@"video_url"] objectAtIndex: i]];
        
        [tempPhotoObjectArray addObject: photoObject];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{ [self dismissViewController: self]; });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"readInstagramJson" object:tempPhotoObjectArray];
}

@end
