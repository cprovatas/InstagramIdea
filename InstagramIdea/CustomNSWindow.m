//
//  CustomNSWindow.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 8/9/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "CustomNSWindow.h"
#import "TableViewController.h"
#import "ConnectionJSONSerialization.h"
#import "CustomCollectionView.h"
#import "RFOverlayScrollView.h"

@interface CustomNSWindow ()

@end

@implementation CustomNSWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.contentViewController.view.subviews[0].hidden = false;
    self.contentViewController.view.subviews[1].hidden = true;

}

- (IBAction)segmentedClicked:(id)sender {
    
    
    if(_gridSelection.selectedSegment) {
        
        self.contentViewController.view.subviews[0].hidden = true;
        self.contentViewController.view.subviews[1].hidden = false;
        
        static dispatch_once_t once;
        dispatch_once(&once, ^ {
            [((CustomCollectionView *)((NSClipView *)((RFOverlayScrollView *)self.contentViewController.view.subviews[1]).subviews[0]).subviews[3]) fireConnection];
        });        
            
    }else {
        
        self.contentViewController.view.subviews[0].hidden = false;
        self.contentViewController.view.subviews[1].hidden = true;
        
        [self.contentViewController.view.subviews[0] becomeFirstResponder];
    }
}

@end
