//
//  HBMemoryCache.m
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBMemoryCache.h"

@implementation HBMemoryCache
+ (instancetype)sharedInstance {
    static HBMemoryCache * _memCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_memCache) {
            _memCache = [[HBMemoryCache alloc] init];
        }
    });
    return _memCache;
}
@end
