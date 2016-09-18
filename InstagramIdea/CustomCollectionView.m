//
//  CustomCollectionView.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 8/6/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomCollectionView.h"
#import "ConnectionJSONSerialization.h"
#import "LeftFlowLayout.h"

@implementation CustomCollectionView

- (void)awakeFromNib {
    
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(scrollViewDidScroll:) name:NSViewBoundsDidChangeNotification object: [self enclosingScrollView].contentView];
}

- (void)fireConnection {
    
    if (CGRectGetMaxY([self.enclosingScrollView.contentView visibleRect]) > 700) {
        
        Connector_JSONSerialization *instance = [Connector_JSONSerialization sharedManager];
        
        if(!instance.isCurrentlyFetchingJson) {
            [instance fetchInstagramFeed: true];
            
        }else {
            [self performSelector:@selector(fireConnection) withObject:nil afterDelay:0.3];
        }
    }
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        
    return (section * 3) - _feedOfPhotoObjects.count > -3 ? ((section * 3) - _feedOfPhotoObjects.count) : 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    
    return ceil([_feedOfPhotoObjects count] / 3);
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView makeItemWithIdentifier:@"CustomCollectionViewItem" forIndexPath:indexPath];
    
    CustomCollectionViewItem *itemView = (CustomCollectionViewItem *)[collectionView makeItemWithIdentifier:@"CustomCollectionViewItem" forIndexPath:indexPath];
    
    PhotoObject *photoObjectAtRowForIndexPath = [_feedOfPhotoObjects objectAtIndex: 3 * indexPath.section + indexPath.item];    
    itemView.theImageView.image = nil;
    
        if(!photoObjectAtRowForIndexPath.image){
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:photoObjectAtRowForIndexPath.imageSource completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    photoObjectAtRowForIndexPath.image = [[NSImage alloc] initWithData: data];
                    if (photoObjectAtRowForIndexPath.image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (itemView)
                                itemView.theImageView.image = photoObjectAtRowForIndexPath.image;
                        });
                    }
                }
            }];
            [task resume];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{ itemView.theImageView.image = photoObjectAtRowForIndexPath.image; });
        }
   
    return itemView;
}

- (void)scrollViewDidScroll:(NSNotification *)notification {
    
    CGFloat relativePositionInFrame = CGRectGetMaxY([(NSScrollView *)[notification object] visibleRect]) / [self bounds].size.height;
    
    if (relativePositionInFrame > .99) {
                
        Connector_JSONSerialization *instance = [Connector_JSONSerialization sharedManager];
        
        if(!instance.isCurrentlyFetchingJson)[instance fetchInstagramFeed: true];
    }
}

- (void)collectionView:(NSCollectionView *)collectionView willDisplayItem:(NSCollectionViewItem *)item forRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath { }

- (void)collectionView:(NSCollectionView *)collectionView didEndDisplayingItem:(NSCollectionViewItem *)item forRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath { }

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}
@end