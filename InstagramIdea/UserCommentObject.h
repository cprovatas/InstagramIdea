//
//  UserCommentObject.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 7/4/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCommentObject : NSObject

@property NSString *username;

@property NSURL *profilePicUrl;

@property NSString *commentText;

@property NSString *timeCreated;

@end
