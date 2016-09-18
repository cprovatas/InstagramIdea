//
//  LeftFlowLayout.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 8/17/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#define SLIDE_WIDTH 140
#define SLIDE_HEIGHT 140
#define X_PADDING        10.0
#define Y_PADDING        10.0

#import "LeftFlowLayout.h"
#import "ConnectionJSONSerialization.h"
#import "PhotoObject.h"
#import "CustomCollectionView.h"

@implementation LeftFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(NSRect)newBounds {
    return YES; // Our custom SlideLayouts show all items within the CollectionView's visible rect, and must recompute their layouts for a good fit when that rect changes.
}

#pragma - end base class methods

- (NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoObject *photoObjectAtRowForIndexPath = [((CustomCollectionView *)[self collectionView]).feedOfPhotoObjects objectAtIndex: 3 * indexPath.section + indexPath.item];
    
    NSRect itemFrame;
    if(indexPath.section == 0) {
        
        itemFrame = NSMakeRect(indexPath.item * 192 , 0, 192, (192 / photoObjectAtRowForIndexPath.imageWidth) * photoObjectAtRowForIndexPath.imageHeight);
    }else {
        
        NSIndexPath *tempIndex = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section - 1];
        NSRect frame = [self layoutAttributesForItemAtIndexPath:tempIndex].frame;
        
        itemFrame = NSMakeRect(indexPath.item * 192 + (indexPath.item == 0 ? 0 : 1), (frame.origin.y + frame.size.height) + 1, 192, (192 / photoObjectAtRowForIndexPath.imageWidth) * photoObjectAtRowForIndexPath.imageHeight);
    }
   
    
    NSCollectionViewLayoutAttributes *attributes = (NSCollectionViewLayoutAttributes *)[[[self class] layoutAttributesClass] layoutAttributesForItemWithIndexPath:indexPath];
    [attributes setFrame:NSRectToCGRect(itemFrame)];
    
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(NSRect)rect {
    
  //  Connector_JSONSerialization *instance = [Connector_JSONSerialization sharedManager];
    //NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    
    NSInteger itemCount = ((CustomCollectionView *)[self collectionView]).feedOfPhotoObjects.count;
    NSMutableArray *layoutAttributesArray = [NSMutableArray arrayWithCapacity:itemCount];
    
//    for (NSInteger index = 0; index < itemCount; index++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//        NSCollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
//        if (layoutAttributes) {
//            [layoutAttributesArray addObject:layoutAttributes];
//        }
//    }
    
    for(int i = 0; i < ceil(itemCount / 3); i++) {
        for(int j = 0; j < 3 && (i * 3) + j < itemCount; j++){
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            NSCollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (layoutAttributes) {
                [layoutAttributesArray addObject:layoutAttributes];
            }
        }
    }
        
    return layoutAttributesArray;
}

@end
