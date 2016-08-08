//
//  ViewController.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/12/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomCollectionView.h"

@interface TableViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *TableView;

@property (strong) id playerObserver;

@property (weak) IBOutlet CustomCollectionView *collectionView;

@end

