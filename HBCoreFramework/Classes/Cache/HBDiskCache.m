//
//  HBDiskCache.m
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBDiskCache.h"
@interface HBDiskCache ()
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSString *path;
@end

@implementation HBDiskCache
- (instancetype)initWithName:(NSString *)name {
    NSAssert(name && name.length > 0, @"please specify a name!");
    _name = name;
    NSString * diskCacheFolder = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    if (diskCacheFolder) {
        NSString * path = [diskCacheFolder stringByAppendingPathComponent:name];
        return [self initWithPath:path];
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    NSAssert(path && path.length > 0, @"please specify a path!");
    self = [super init];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSError * error = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(!error, @"create disk cache path failed!");
        
    }
    return self;
}

- (BOOL)containsObjectForKey:(id)key {
    return NO;
}

- (BOOL)removeObjectForKey:(NSString *)key {
    return NO;
}

- (BOOL)removeAllObjects {
    return NO;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    
}

- (id)objectForKey:(NSString *)key {
    return nil;
}
@end
