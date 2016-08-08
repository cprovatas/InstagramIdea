//
//  CustomCollectionView.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 8/6/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomCollectionView.h"

@implementation CustomCollectionView

- (void)awakeFromNib {
    
    
    
    //self.storyboard?.instantiateControllerWithIdentifier("collectionViewItem") as? CustomCollectionViewItem else { return }

}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    
    return [_feedOfPhotoObjects count] / 4;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionViewItem *itemView = (CustomCollectionViewItem *)[collectionView makeItemWithIdentifier:@"CustomCollectionViewItem" forIndexPath:indexPath];
    
    PhotoObject *photoObjectAtRowForIndexPath = [_feedOfPhotoObjects objectAtIndex: 3 * indexPath.section + indexPath.item];
    
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

   // itemView.theImageView.image = [NSImage  imageNamed:@"pug"];
    return itemView;
}


- (void)collectionView:(NSCollectionView *)collectionView willDisplayItem:(NSCollectionViewItem *)item forRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath { }

- (void)collectionView:(NSCollectionView *)collectionView didEndDisplayingItem:(NSCollectionViewItem *)item forRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath { }

@end