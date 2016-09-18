//
//  WebView+JSONSerialization.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/26/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/Webkit.h>

@interface Connector_JSONSerialization : NSViewController <NSURLSessionDelegate>

@property NSMutableArray *tempPhotoObjectArray;

- (void)fetchInstagramFeed: (bool)isAppending;

+ (id)sharedManager;

@property bool isCurrentlyFetchingJson;

@end
