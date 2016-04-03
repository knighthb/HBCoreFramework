//
//  HBDiskCache.h
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBDiskCache : NSObject

- (instancetype)initWithName:(NSString *)name;

- (instancetype)initWithPath:(NSString *)path;

- (BOOL)containsObjectForKey:(id<NSCopying>)key;

- (void)setObject:(id<NSCoding>)object forKey:(id<NSCopying>)key;

- (BOOL)removeObjectForKey:(id<NSCopying>)key;

- (BOOL)removeAllObjects;

- (id)objectForKey:(id<NSCopying>)key;
@end
