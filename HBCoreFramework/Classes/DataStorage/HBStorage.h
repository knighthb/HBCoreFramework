//
//  HBStorage.h
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define StrongSelf(v) __strong __typeof(&*v)self = v;

@class HBStorageItem;

@protocol HBStorageProtocol <NSObject>

@required

- (void)setValue:(HBStorageItem *)value forKey:(id<NSCopying>)key;

- (HBStorageItem *)objectForKey:(id<NSCopying>)key;

- (void)removeObjectForKey:(id<NSCopying>)key;

- (void)removeAllObjects;

- (BOOL)containsObjectForKey:(id<NSCopying>)key;

@end
@interface HBStorage : NSObject <HBStorageProtocol>
@property (nonatomic , copy)NSString * name;

@property (nonatomic , copy)NSString * path;

- (instancetype)initWithName:(NSString *)name;

- (instancetype)initWithPath:(NSString *)path;
@end
