//
//  ViewController.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/12/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "TableViewController.h"
#import "PhotoObject.h"
#import "CustomCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@import Foundation;

@implementation TableViewController{
    
    NSMutableArray *feedOfPhotoObjects;
    PhotoObject *photoObject;
    NSString *webDataString;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    feedOfPhotoObjects = [[NSMutableArray alloc] init];
    _theWebView.frameLoadDelegate = self;
    [[self.theWebView mainFrame] loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:@"https://www.instagram.com/"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 10.0]]; //caches web view so it can show feed on launch after 1st login
    self.centersDocumentView = YES;
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    
    if(!webDataString){ //this method gets called frequently (doesn't behave like connectionDidFinishLoading)
        
        webDataString = [[NSString alloc] initWithData: [[[self.theWebView mainFrame] dataSource] data] encoding:NSUTF8StringEncoding]; //fetch web source
        webDataString = [webDataString substringFromIndex:[webDataString rangeOfString:@"{\"country_code\": "].location]; //remove source code before json starts
        webDataString = [webDataString substringToIndex:[webDataString rangeOfString:@";</script>"].location]; //remove source code after json ends
        //[self.theWebView removeFromSuperview]; //remove view (very expensive otherwise)
        //_theWebView.frameLoadDelegate = nil; //so we can ignore this method after
        [self serializeInstagramJson];
    }
    
}

- (void)serializeInstagramJson{
    
    NSError *error = nil;
    NSDictionary *theDictionary = [[NSDictionary alloc] init];
    theDictionary = [NSJSONSerialization JSONObjectWithData: [webDataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
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
        photoObject.image = [[NSImage alloc] initWithContentsOfURL: photoObject.imageSource]; //load images beforehand

        if([videoURLArray objectAtIndex: i] != [NSNull null])
            photoObject.videoSource = [NSURL URLWithString:[videoURLArray objectAtIndex: i]];
        
        [feedOfPhotoObjects addObject: photoObject];
    }
    
    webDataString = @""; //no longer needed (very long string)
    [_TableView setDelegate: self];
    [_TableView setDataSource: self];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{    
    return [feedOfPhotoObjects count];
}

- (NSView *)tableView: (NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    
    CustomCell *result = [tableView makeViewWithIdentifier:@"imageView" owner:self];
    
    PhotoObject *photoObjectAtRowForIndexPath = [feedOfPhotoObjects objectAtIndex: row];
    
    result.textField.stringValue = photoObjectAtRowForIndexPath.theCaption; //caption
    
    if(photoObjectAtRowForIndexPath.videoSource){ //display image or video...
            result.imageView.hidden = YES;
            result.videoPlayer.player = [AVPlayer playerWithURL:photoObjectAtRowForIndexPath.videoSource];        
            result.videoPlayer.hidden = NO;
            result.videoPlayer.player.muted = NO;
        }else{
            result.videoPlayer.hidden = YES;
            result.imageView.image = photoObjectAtRowForIndexPath.image;
            result.imageView.hidden = NO;
            result.videoPlayer.player.muted = YES;
    }
        
    [result.videoPlayer.player addBoundaryTimeObserverForTimes:@[[NSValue valueWithCMTime:CMTimeMake(1, 1000)]] queue:NULL usingBlock:^{ [result.videoPlayer.player pause];}]; //gets when the player starts playing and then pause the player (otherwise player will autoplay)

    result.User.stringValue = photoObjectAtRowForIndexPath.user; //username
    return result;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 500;
}

@end
