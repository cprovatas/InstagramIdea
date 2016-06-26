//
//  ViewController.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/12/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface TableViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, WebFrameLoadDelegate>

@property (weak) IBOutlet NSTableView *TableView;

@property (assign) IBOutlet WebView *theWebView;

@property (strong) id playerObserver;

@property BOOL centersDocumentView;


@end

