//
//  HBDiskCache.h
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HBStorage;

@interface HBDiskCache : NSObject
@property (nonatomic , assign) NSTimeInterval expireTimeDuration;

- (instancetype)initWithName:(NSString *)name;

- (instancetype)initWithPath:(NSString *)path;

- (instancetype)initWithStorage:(HBStorage *)storage;

- (BOOL)containsObjectForKey:(id<NSCopying>)key;

- (void)setObject:(id<NSCoding>)object forKey:(id<NSCopying>)key;

- (void)removeObjectForKey:(id<NSCopying>)key;

- (void)removeAllObjects;

- (id)objectForKey:(id<NSCopying>)key;
@end
