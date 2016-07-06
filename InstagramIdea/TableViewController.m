//
//  ViewController.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/12/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "TableViewController.h"
#import "PhotoObject.h"
#import "CustomCell.h"
#import "WebView+JSONSerialization.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@import Foundation;

@implementation TableViewController{
    
    NSMutableArray *feedOfPhotoObjects;
}

- (void)viewDidAppear{
    
    [self performSegueWithIdentifier:@"webSegue" sender:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readInstagramJson:) name:@"readInstagramJson" object:nil];
}

- (void)readInstagramJson: (NSNotification *)name {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        feedOfPhotoObjects = [name object];    
        [self.TableView setDelegate: self];
        [self.TableView setDataSource: self];
        
    });
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"readInstagramJson" object:nil];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{    
    return [feedOfPhotoObjects count];
}

- (NSView *)tableView: (NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    
    CustomCell *result = [tableView makeViewWithIdentifier:@"imageView" owner:self];
    
    PhotoObject *photoObjectAtRowForIndexPath = [feedOfPhotoObjects objectAtIndex: row];
    
    result = [self generateCaptionString: photoObjectAtRowForIndexPath currentCell: result];
    
    if(photoObjectAtRowForIndexPath.videoSource){ //display image or video...
            result.imageView.hidden = YES;
            result.videoPlayer.player = [AVPlayer playerWithURL:photoObjectAtRowForIndexPath.videoSource];        
            result.videoPlayer.hidden = NO;
            result.videoPlayer.player.muted = NO;
        }else{
            result.videoPlayer.hidden = YES;
            result.imageView.image = photoObjectAtRowForIndexPath.image;
            result.imageView.hidden = NO;
            result.videoPlayer.player.muted = YES;
    }
        
    [result.profilePictureImage setWantsLayer: YES];
    result.profilePictureImage.layer.masksToBounds = YES;
    result.profilePictureImage.layer.cornerRadius = result.profilePictureImage.frame.size.width / 2;
    [result.profilePictureImage setImageScaling: NSScaleProportionally];
    
    result.profilePictureImage.image = photoObjectAtRowForIndexPath.profilePictureImage;
        
    [result.videoPlayer.player addBoundaryTimeObserverForTimes:@[[NSValue valueWithCMTime:CMTimeMake(1, 1000)]] queue:NULL usingBlock:^{ [result.videoPlayer.player pause];}]; //gets when the player starts playing and then pause the player (otherwise player will autoplay)

    result.User.stringValue = photoObjectAtRowForIndexPath.fullName != [NSNull null] ? photoObjectAtRowForIndexPath.fullName : photoObjectAtRowForIndexPath.userName  ; //username;
    
    result.numberOfLikesView.stringValue = [self generateNumberOfLikesString: photoObjectAtRowForIndexPath.numberOfLikes];
        
    return result;  
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 500;
}

- (IBAction)refreshButtonClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"webSegue" sender:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readInstagramJson:) name:@"readInstagramJson" object:nil];
}

- (NSString *)generateNumberOfLikesString: (int)numberOfLikes{
    
    /* Add users here */
    if(numberOfLikes > 1)
        return [NSString stringWithFormat:@"❤  %i  likes", numberOfLikes];
    
    else if(numberOfLikes == 1)
        return @"❤  1  like";
    
    return @"❤  No  likes :(";
}

- (CustomCell *)generateCaptionString: (PhotoObject *) photoObject currentCell: (CustomCell *) currentCell{
    
    currentCell.theCaptionView.font = [NSFont systemFontOfSize:13 weight:NSFontWeightThin];
    
    [currentCell.theCaptionView setString: [NSString stringWithFormat:@"%@  %@", photoObject.userName, photoObject.theCaption]]; //initial caption
    
    NSMutableAttributedString *text = [currentCell.theCaptionView textStorage];
    
    for(int i = 0; i < [photoObject.arrayOfCommentUsers count]; i++){
        
        NSUInteger currentStringIndex = [currentCell.theCaptionView textStorage].length;
        
        NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@   %@", [photoObject.arrayOfCommentUsers objectAtIndex: i].username, [photoObject.arrayOfCommentUsers objectAtIndex: i].commentText]];
        
        [attrstr setAttributes:@{ NSFontAttributeName : [NSFont systemFontOfSize: 13 weight: NSFontWeightThin]} range:NSMakeRange(0, attrstr.length)];
        [text appendAttributedString: attrstr];
        [text applyFontTraits: NSBoldFontMask range: NSMakeRange(currentStringIndex,  [photoObject.arrayOfCommentUsers objectAtIndex: i].username.length + 1)];
        
    }
    
    [text applyFontTraits: NSBoldFontMask range: NSMakeRange(0, [photoObject.userName length])];
    
    return currentCell;
}

@end
