//
//  HBStorage.m
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBStorage.h"
#import "HBStorageItem.h"

@implementation HBStorage

- (instancetype)initWithName:(NSString *)name {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithPath:(NSString *)path {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)setValue:(HBStorageItem *)value forKey:(id<NSCopying>)key {
    [self doesNotRecognizeSelector:_cmd];
}

- (HBStorageItem *)objectForKey:(id<NSCopying>)key {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)removeAllObjects {
    [self doesNotRecognizeSelector:_cmd];
}

- (BOOL)containsObjectForKey:(id<NSCopying>)key {
    NSAssert(key, @"key must not be nil!");
    if ([self objectForKey:key]) {
        return YES;
    }else{
        return NO;
    }
}

@end
