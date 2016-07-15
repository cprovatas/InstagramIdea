//
//  CustomCell.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/13/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [NSGraphicsContext saveGraphicsState];
    
    [[NSColor lightGrayColor] set];
    NSFrameRect(NSRectFromCGRect(CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height - 2, self.frame.size.width, 1)));
    
    [NSGraphicsContext restoreGraphicsState];
}

@end
