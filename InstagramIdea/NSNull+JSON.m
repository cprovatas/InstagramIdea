//
//  NSNull+JSON.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 8/15/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (JSON)
@end

@implementation NSNull (JSON)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

- (NSString *)description { return @"0(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }

- (id)valueForKey:(id)key { return nil; }

@end