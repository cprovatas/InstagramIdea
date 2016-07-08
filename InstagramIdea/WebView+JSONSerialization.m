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

@implementation WebView_JSONSerialization {
    
    PhotoObject *photoObject;
    NSString *webDataString;
    NSMutableArray *tempPhotoObjectArray;
}

- (void)viewDidLoad{
        
    _webView.frameLoadDelegate = self;
    [[_webView mainFrame] loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:@"https://www.instagram.com/"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 10.0]]; //caches web view so it can show feed on launch after 1st login
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    
    if(!webDataString || webDataString.length < 1055){ //this method gets called frequently (doesn't behave like connectionDidFinishLoading)
        
        _messageText.stringValue = @"Click login below to login";
        webDataString = [[NSString alloc] initWithData: [[[_webView mainFrame] dataSource] data] encoding:NSUTF8StringEncoding]; //fetch web source
        webDataString = [webDataString substringFromIndex:[webDataString rangeOfString:@"{\"country_code\": "].location]; //remove source code before json starts
        webDataString = [webDataString substringToIndex:[webDataString rangeOfString:@";</script>"].location]; //remove source code after json ends
        
         [NSTimer scheduledTimerWithTimeInterval: 1.5 target:[^{ [_webView scrollToEndOfDocument: self];} copy] selector:@selector(invoke) userInfo:nil repeats:NO];
        
        if(webDataString.length > 1054){ //determine wheter the feed is loaded now or not
            
            _messageText.stringValue = @"Loading Your Instagram Feed :)";
            
            NSProgressIndicator *activityIndicator = [[NSProgressIndicator alloc] initWithFrame:_webView.frame];
                activityIndicator.style = NSProgressIndicatorSpinningStyle;
                [self.view addSubview: activityIndicator];
                [activityIndicator startAnimation: self];
            
            [_webView removeFromSuperview]; //remove view (very expensive otherwise)
            _webView.frameLoadDelegate = nil; //so we can ignore this method after
            
            [self serializeInstagramJson];
        }
    }
}

- (void)serializeInstagramJson{
    
    NSError *error = nil;
    NSDictionary *theDictionary = [[NSDictionary alloc] init];
    theDictionary = [NSJSONSerialization JSONObjectWithData: [webDataString  dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    tempPhotoObjectArray = [[NSMutableArray alloc] init];
    
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
        
        [tempPhotoObjectArray addObject: photoObject];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{ [self dismissViewController: self]; });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"readInstagramJson" object:tempPhotoObjectArray];

}

@end
