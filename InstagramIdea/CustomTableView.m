//
//  CustomTableView.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 7/30/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTableView.h"
#import "CustomCell.h"
#import "TableViewController.h"
#import "ConnectionJSONSerialization.h"

@implementation CustomTableView{
    
    NSTrackingRectTag trackingTag;
    BOOL mouseOverView;
    NSInteger mouseOverRow;
    NSInteger lastOverRow;
}

- (void)awakeFromNib {
    
    trackingTag = [self addTrackingRect:[self frame] owner:self userData:nil assumeInside:NO];
    mouseOverView = NO;
    mouseOverRow = -1;
    lastOverRow = -1;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(scrollViewDidScroll:) name:NSViewBoundsDidChangeNotification object: [self enclosingScrollView].contentView];
}

- (void)scrollViewDidScroll:(NSNotification *)notification {
    
    CGFloat relativePositionInFrame = CGRectGetMaxY([(NSScrollView *)[notification object] visibleRect]) / [self bounds].size.height;
    
    if (relativePositionInFrame > .75) {
        
        
        Connector_JSONSerialization *instance = [Connector_JSONSerialization sharedManager];
        
        if(!instance.isCurrentlyFetchingJson)[instance fetchInstagramFeed: true];        
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeTrackingRect:trackingTag];    
}

- (void)mouseEntered:(NSEvent*)theEvent
{
    [self becomeFirstResponder];
    [self acceptsFirstResponder];
    [[self window] setAcceptsMouseMovedEvents:YES];
    [[self window] makeFirstResponder:self];
    
    mouseOverView = YES;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)mouseMoved:(NSEvent*)theEvent {
    
    id myDelegate = [self delegate];
    
    if (!myDelegate)
        return; // No delegate, no need to track the mouse.
    
        mouseOverRow = [self rowAtPoint:[self convertPoint:[theEvent locationInWindow] fromView:nil]];
        
        if (lastOverRow == mouseOverRow){
            
            return;
            
        }else {
            
            [self setNeedsDisplayInRect:[self rectOfRow:lastOverRow]];
            lastOverRow = mouseOverRow;
        }
    
        [self setNeedsDisplayInRect:[self rectOfRow:mouseOverRow]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayCellView" object: self];
}

- (void)mouseExited:(NSEvent *)theEvent {
    
    mouseOverView = NO;
    mouseOverRow = -1;
    lastOverRow = -1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayCellView" object: self];
    [self setNeedsDisplayInRect:[self rectOfRow:mouseOverRow]];    
}

- (NSInteger)mouseOverRow {
    
    return mouseOverRow;
}

- (void)viewDidEndLiveResize {
    
    [super viewDidEndLiveResize];
    
    [self removeTrackingRect:trackingTag];
    trackingTag = [self addTrackingRect:[self frame] owner:self userData:nil assumeInside:NO];
}

- (void)scrollWheel:(NSEvent *)theEvent {
    
    [super scrollWheel: theEvent];
    
    [self mouseMoved: theEvent];
}

@end
