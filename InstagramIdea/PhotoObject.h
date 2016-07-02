//
//  PhotoObject.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/12/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoObject : NSObject

@property NSURL *imageSource;

@property NSURL *videoSource;

@property NSString *theCaption;

@property NSURL *profilePictureSource;

@property NSString *user;

@property NSImage *image; //actual image is stored into object from imageSource

@property NSImage *profilePictureImage;

@end
