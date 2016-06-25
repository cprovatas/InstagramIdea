//
//  CustomCell.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/13/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVKit/AVKit.h>

@interface CustomCell : NSTableCellView

@property (weak) IBOutlet NSTextField *User;

@property (weak) IBOutlet AVPlayerView *videoPlayer;

@end
