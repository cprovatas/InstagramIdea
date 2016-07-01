//
//  WebView+JSONSerialization.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/26/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "WebView+JSONSerialization.h"
#import "PhotoObject.h"

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
                
        webDataString = [[NSString alloc] initWithData: [[[_webView mainFrame] dataSource] data] encoding:NSUTF8StringEncoding]; //fetch web source
        webDataString = [webDataString substringFromIndex:[webDataString rangeOfString:@"{\"country_code\": "].location]; //remove source code before json starts
        webDataString = [webDataString substringToIndex:[webDataString rangeOfString:@";</script>"].location]; //remove source code after json ends
        
         [NSTimer scheduledTimerWithTimeInterval: 1.5 target:[^{ [_webView scrollToEndOfDocument: self];} copy] selector:@selector(invoke) userInfo:nil repeats:NO];
        
        if(webDataString.length > 1054){
            
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
    theDictionary = [NSJSONSerialization JSONObjectWithData: [webDataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    tempPhotoObjectArray = [[NSMutableArray alloc] init];
    
    if(error)
        NSLog(@"JSON Error: %@", error);
    
    //fetch the images
    NSMutableArray *arrayWhereImageJsonStarts = [[NSMutableArray alloc] init];
    arrayWhereImageJsonStarts = [[[[[[theDictionary valueForKey:@"entry_data"] valueForKey:@"FeedPage"] valueForKey:@"feed"] valueForKey:@"media"] valueForKey:@"nodes"] objectAtIndex: 0];
    
    NSMutableArray *tempImageArray = [[NSMutableArray alloc] init];
    tempImageArray = [arrayWhereImageJsonStarts valueForKey:@"display_src"];
    
    NSMutableArray *tempCaptionArray = [[NSMutableArray alloc] init];
    tempCaptionArray =  [arrayWhereImageJsonStarts valueForKey:@"caption"];
    
    NSMutableArray *tempUsernameArray = [[NSMutableArray alloc] init];
    tempUsernameArray = [[arrayWhereImageJsonStarts valueForKey:@"owner"] valueForKey:@"username"];
    
    NSMutableArray *videoURLArray = [[NSMutableArray alloc] init];
    videoURLArray = [arrayWhereImageJsonStarts valueForKey:@"video_url"];
    
    for(int i = 0; i < [tempImageArray count]; i++){ //insert property into array of photo objects
        
        photoObject = [[PhotoObject alloc] init];
        photoObject.imageSource = [NSURL URLWithString: [tempImageArray objectAtIndex: i]];
        photoObject.theCaption = [tempCaptionArray objectAtIndex: i];
        photoObject.user = [tempUsernameArray objectAtIndex: i];
        
        if([videoURLArray objectAtIndex: i] != [NSNull null])
            photoObject.videoSource = [NSURL URLWithString:[videoURLArray objectAtIndex: i]];
        
        [tempPhotoObjectArray addObject: photoObject];
    }
    
    [self getImage];
}

- (void)getImage{
    
    NSURL *tempUrl = [[NSURL alloc] init];
    for(int i = 0; i < [tempPhotoObjectArray count]; i++){ //find location of empty image and send url
        PhotoObject *temp = [tempPhotoObjectArray objectAtIndex: i];
        if(!temp.image){
            tempUrl = temp.imageSource;
            break;
        }        
    }
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:tempUrl] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        int i = 0;
        PhotoObject *temp = [[PhotoObject alloc] init];
        do{
            temp = [tempPhotoObjectArray objectAtIndex: i];

            if(!temp.image){
                [self assignImage: i image: [[NSImage alloc] initWithData: data]];
                break;
                
            }else if(i + 1 < [tempPhotoObjectArray count]){
                i++;
            
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"readInstagramJson" object:tempPhotoObjectArray];
                [self dismissViewController: self];
                break;
            }
            
        }while(temp.image);
        
    }];

    
}

- (void)assignImage: (int) i image: (NSImage *) image{
    
    PhotoObject *temp = [tempPhotoObjectArray objectAtIndex: i];
    temp.image = image;
    [self getImage];
}


@end
