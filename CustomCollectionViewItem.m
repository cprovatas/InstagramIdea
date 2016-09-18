//
//  CustomCollectionViewItem.m
//  InstagramIdeaRFOverlayScrollView
//
//  Created by Charlton Provatas on 8/7/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "CustomCollectionViewItem.h"

@interface CustomCollectionViewItem ()

@end

@implementation CustomCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.wantsLayer = true;
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
}

@end
