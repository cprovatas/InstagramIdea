//
//  CustomCaptionView.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 7/2/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "CustomCaptionView.h"

@implementation CustomCaptionView

- (void)viewWillMoveToWindow:(NSWindow *)newWindow{
    
    self.enclosingScrollView.hasHorizontalScroller = NO;   
    self.layoutOrientation = NSTextLayoutOrientationVertical;
    self.layoutOrientation = NSTextLayoutOrientationHorizontal;
}

- (void)scrollWheel:(NSEvent *)theEvent{
    
    NSTextContainer* textContainer = [self textContainer];
    NSLayoutManager* layoutManager = [self layoutManager];
    [layoutManager ensureLayoutForTextContainer: textContainer];
    
    if([layoutManager usedRectForTextContainer: textContainer].size.height >= (self.frame.size.height - 1))
        [super scrollWheel: theEvent];
    
    else
        [self.enclosingScrollView.enclosingScrollView scrollWheel: theEvent];    
}

@end
