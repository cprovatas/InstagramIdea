//
//  JSONParser.h
//  InstagramIdea
//
//  Created by Charlton Provatas on 7/10/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+ (instancetype)sharedInstance;

- (void)serializeInstagramJson: (NSString *)jsonAsString;

@end
