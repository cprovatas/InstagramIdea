//
//  CustomAVPlayerView.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 7/2/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "CustomAVPlayerView.h"

@implementation CustomAVPlayerView

- (void)scrollWheel: (NSEvent *)theEvent{
    
    [self.enclosingScrollView scrollWheel:theEvent];
}

@end
