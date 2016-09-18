//
//  Header.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 8/6/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "CustomCollectionViewItem.h"
#import "PhotoObject.h"

@interface CustomCollectionView : NSCollectionView <NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout>

@property NSMutableArray *feedOfPhotoObjects;

- (void) fireConnection;

@end