//
//  HBCache.m
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBCache.h"
#import "HBDiskCache.h"
#import "HBMemoryCache.h"
@interface HBCache ()
@property (nonatomic,strong) HBDiskCache * diskCache;
@property (nonatomic ,strong) HBMemoryCache * memChace;
@property (nonatomic , readwrite) NSString * name;
@property (nonatomic , readwrite) NSString * path;
@end

@implementation HBCache
- (instancetype)initWithName:(NSString *)name {
    NSAssert(name && name.length > 0, @"please specify a name!");
    NSString * cacheFolder = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    if (cacheFolder) {
        NSString * cachePath = [cacheFolder stringByAppendingPathComponent:name];
        _name = name;
       return [self initWithPath:cachePath];
    }
    return nil;
}

- (instancetype)initWithPath:(NSString *)path {
    NSAssert(path && path.length > 0, @"please specify a path");
    self = [super init];
    if (self) {
        _path = path;
        _diskCache = [[HBDiskCache alloc] initWithPath:path];
        _memChace = [HBMemoryCache sharedInstance];
        _memChace.totalCostLimit = 5*1024*1024;
        _memChace.countLimit = 1000;
        
    }
    return self;
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    [_memChace removeObjectForKey:key];
    [_diskCache removeObjectForKey:key];
}

- (void)removeAllObject {
    [_memChace removeAllObjects];
    [_diskCache removeAllObjects];
}

- (id)objectForKey:(id<NSCopying>)key {
    id object = nil;
    object = [_memChace objectForKey:key];
    if (!object) {
        object = [_diskCache objectForKey:key];
        if (object) {
            [_memChace setObject:object forKey:key];
        }
    }
    return object;
}

- (BOOL)containsObjectForKey:(id<NSCopying>)key {
    if ([_memChace objectForKey:key] || [_diskCache containsObjectForKey:key]) {
        return YES;
    }
    return NO;
}

- (void)setObject:(id<NSCoding>)object forKey:(id<NSCopying>)aKey {
    [_memChace setObject:object forKey:aKey];
    [_diskCache setObject:object forKey:aKey];
}
@end
