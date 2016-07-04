//
//  ViewController.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/12/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TableViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *TableView;

@property (strong) id playerObserver;

- (IBAction)refreshButtonClicked:(id)sender;

@end

