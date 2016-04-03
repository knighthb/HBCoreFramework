//
//  HBCache.h
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBCache : NSObject
@property (nonatomic , readonly)  NSString *name;
@property (nonatomic , readonly) NSString *path;
@property (nonatomic , assign) NSInteger totalCost;
@property (nonatomic , assign) NSInteger totalCount;

- (instancetype)initWithName:(NSString *)name;

- (instancetype)initWithPath:(NSString *)path;

- (void)removeObjectForKey:(id<NSCopying>)key;

- (void)removeAllObject;

- (BOOL)containsObjectForKey:(id<NSCopying>)key;

- (void)setObject:(id<NSCoding>)object forKey:(id<NSCopying>)aKey;

- (id)objectForKey:(id<NSCopying>)key;
@end
