//
//  PhotoObject.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/12/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCommentObject.h"

@interface PhotoObject : NSObject

@property NSURL *imageSource;

@property NSURL *videoSource;

@property NSString *theCaption;

@property NSURL *profilePictureSource;

@property NSString *fullName;

@property NSString *userName;

@property NSImage *image; //actual image is stored into object from imageSource

@property NSImage *profilePictureImage;

@property int numberOfLikes;

@property NSMutableArray<UserCommentObject *> *arrayOfCommentUsers;

@property CGFloat imageHeight;

@property CGFloat imageWidth;

@end
