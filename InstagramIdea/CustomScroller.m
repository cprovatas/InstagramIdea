//
//  CustomScroller.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 7/3/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "CustomScroller.h"

@implementation CustomScroller

+ (BOOL)isCompatibleWithOverlayScrollers{
    
    // Let this scroller sit on top of the content view, rather than next to it.
    return YES;
}

- (void)setHidden:(BOOL)flag{
    
    // Ugly hack: make sure we are always hidden.
    [super setHidden:YES];
}

@end
