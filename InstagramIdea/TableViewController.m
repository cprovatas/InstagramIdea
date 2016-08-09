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
#import "CustomTableView.h"
#import "ConnectionJSONSerialization.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomTableView.h"
#import <objc/runtime.h>

@import Foundation;

@implementation TableViewController{
    
    NSMutableArray *feedOfPhotoObjects;
    NSInteger previousRow;
}

- (void)viewDidAppear{
    
    Connector_JSONSerialization *instance = [Connector_JSONSerialization sharedManager];
    [instance fetchInstagramFeed: false];
    
    //[_TableView window].titlebarAppearsTransparent = true;
  //  [_TableView window].titleVisibility = NSWindowTitleHidden;
    
    dispatch_async(dispatch_get_main_queue(), ^{ [self performSegueWithIdentifier:@"webSegue" sender:self]; });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readInstagramJson:) name:@"readInstagramJson" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHeaderOnMouseOver:) name:@"displayCellView" object:nil];
    
     
}

- (void)showHeaderOnMouseOver: (NSNotification *) notification {
    
    /* cell one display still has issues */
    NSInteger row = ((CustomTableView *)[notification object]).mouseOverRow;
    
    if(row == -1){
        
        ((CustomCell *)[self.TableView viewAtColumn:0 row:previousRow makeIfNecessary:true]).blackView.hidden = true;
        
    }else {
        
        ((CustomCell *)[self.TableView viewAtColumn:0 row:previousRow makeIfNecessary:true]).blackView.hidden = true;
        ((CustomCell *)[self.TableView viewAtColumn:0 row:row makeIfNecessary:true]).blackView.hidden = false;
        previousRow = row;
    }
}

- (void)readInstagramJson: (NSNotification *)name {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        feedOfPhotoObjects = [name object];    
        [self.TableView setDelegate: self];
        [self.TableView setDataSource: self];        
        _collectionView.feedOfPhotoObjects = feedOfPhotoObjects;
        [self.collectionView setDataSource: self.collectionView];
        [self.collectionView setDelegate: self.collectionView];
       // NSIndexPath *index = [NSIndexPath indexPathWithIndex:0];
       // [self.collectionView collectionView:self.collectionView itemForRepresentedObjectAtIndexPath:index];
        [_collectionView reloadData];
        [self.TableView reloadData];
    });    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{    
    return [feedOfPhotoObjects count];
}

- (NSView *)tableView: (NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    
    CustomCell *result = [tableView makeViewWithIdentifier:@"imageView" owner:nil];
    
    PhotoObject *photoObjectAtRowForIndexPath = [feedOfPhotoObjects objectAtIndex: row];
        
    result.imageView.image = nil;
    if(photoObjectAtRowForIndexPath.videoSource){ //display image or video...
        
            result.imageView.hidden = YES;
            result.videoPlayer.player = [AVPlayer playerWithURL:photoObjectAtRowForIndexPath.videoSource];        
            result.videoPlayer.hidden = NO;
            result.videoPlayer.player.muted = YES;
        }else{
            
            result.videoPlayer.hidden = YES;            
            if(!photoObjectAtRowForIndexPath.image){
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:photoObjectAtRowForIndexPath.imageSource completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        photoObjectAtRowForIndexPath.image = [[NSImage alloc] initWithData: data];
                        if (photoObjectAtRowForIndexPath.image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (result)
                                    result.imageView.image = photoObjectAtRowForIndexPath.image;
                            });
                        }
                    }
                }];
                [task resume];
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{ result.imageView.image = photoObjectAtRowForIndexPath.image; });
        }
            result.imageView.hidden = NO;
            result.videoPlayer.player.muted = YES;
    }
    
    
    [result.blackView setWantsLayer: true];
    result.blackView.layer.backgroundColor = [NSColor blackColor].CGColor;
    result.blackView.hidden = true;
    [result.blackView.layer setBackgroundColor: [[[NSColor blackColor] colorWithAlphaComponent:0.7] CGColor]];    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [result.profilePictureImage setWantsLayer: YES];
        result.profilePictureImage.layer.masksToBounds = YES;
        result.profilePictureImage.layer.cornerRadius = result.profilePictureImage.frame.size.width / 2;
        [result.profilePictureImage setImageScaling: NSScaleProportionally];
    });
    
    NSURLSessionTask *task2 = [[NSURLSession sharedSession] dataTaskWithURL:photoObjectAtRowForIndexPath.profilePictureSource completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            photoObjectAtRowForIndexPath.profilePictureImage = [[NSImage alloc] initWithData: data];
            if (photoObjectAtRowForIndexPath.profilePictureImage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (result)
                        result.profilePictureImage.image = photoObjectAtRowForIndexPath.profilePictureImage;
                });
            }
        }
    }];
    [task2 resume];
    
    [result.videoPlayer.player addBoundaryTimeObserverForTimes:@[[NSValue valueWithCMTime:CMTimeMake(1, 1000)]] queue:NULL usingBlock:^{ [result.videoPlayer.player pause]; result.videoPlayer.player.muted = NO;}]; //gets when the player starts playing and then pause the player (otherwise player will autoplay)
    
    
    result.User.stringValue = ![photoObjectAtRowForIndexPath.fullName isEqualToString:@""] ? photoObjectAtRowForIndexPath.fullName : photoObjectAtRowForIndexPath.userName  ; //username;
    
    result.numberOfLikesView.stringValue = [self generateNumberOfLikesString: photoObjectAtRowForIndexPath.numberOfLikes];
        
    return result;  
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{

    PhotoObject *photoObject = [feedOfPhotoObjects objectAtIndex: row];
    
    return ((569 / photoObject.imageWidth) * photoObject.imageHeight);
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
    
    return @"❤  No  likes ";
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
