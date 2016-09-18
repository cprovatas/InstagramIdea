//
//  LeftFlowLayout.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 8/17/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LeftFlowLayout : NSCollectionViewFlowLayout
{
    NSRect box;
    NSSize itemSize;
    NSPoint circleCenter;
    CGFloat circleRadius;
}
@end
