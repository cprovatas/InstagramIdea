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
    
    //self.font = [NSFont systemFontOfSize:13 weight:NSFontWeightThin];
    self.enclosingScrollView.hasHorizontalScroller = NO;   
    self.layoutOrientation = NSTextLayoutOrientationVertical;
    self.layoutOrientation = NSTextLayoutOrientationHorizontal;
    
}

- (void)scrollWheel:(NSEvent *)theEvent{
    
    if(self.textStorage.characters.count > 500)
            [super scrollWheel: theEvent];
        
        
    else
        [self.enclosingScrollView.enclosingScrollView scrollWheel: theEvent];
        
    
}

@end
