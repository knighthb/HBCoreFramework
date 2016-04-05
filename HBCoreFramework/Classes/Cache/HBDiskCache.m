//
//  HBDiskCache.m
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBDiskCache.h"
#import "HBStorage.h"
#import "HBStorageItem.h"
#import "HBArchiveStorage.h"
#define kCurrentTime [[NSDate date] timeIntervalSince1970]
@interface HBDiskCache ()
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSString *path;
@property (nonatomic , strong) HBStorage *storage;
@end

@implementation HBDiskCache
- (instancetype)init {
    return [self initWithName:@"defaultCache"];
}

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
    self.storage = [[HBArchiveStorage alloc] initWithPath:path];
    return self;
}

- (instancetype)initWithStorage:(HBStorage *)storage {
    self = [super init];
    if (self) {
        self.path = storage.path;
        self.storage = storage;
    }
    return self;
}

- (BOOL)containsObjectForKey:(id)key {
    if ([self.storage containsObjectForKey:key]) {
        HBStorageItem * storageItem = [self.storage objectForKey:key];
        if ([self isExpired:storageItem.modifyTime] ) {
            [self.storage removeObjectForKey:key];
            return NO;
        }else {
            return YES;
        }
    }else {
        return NO;
    }
}

- (void)removeObjectForKey:(NSString *)key {
    [self.storage removeObjectForKey:key];
}

- (void)removeAllObjects {
    [self.storage removeAllObjects];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    HBStorageItem * storageItem = nil;
    if ([self.storage containsObjectForKey:key]) {
        storageItem  = [self.storage objectForKey:key];
    }else {
        storageItem = [[HBStorageItem alloc] init];
        storageItem.key = key;
        storageItem.value = object;
        storageItem.path = self.path;
    }
    storageItem.modifyTime = kCurrentTime;
    [self.storage setValue:storageItem forKey:key];
}

- (id)objectForKey:(NSString *)key {
    if (![self.storage containsObjectForKey:key]) {
        return nil;
    }
   HBStorageItem * storageItem = [self.storage objectForKey:key];
    if ([self isExpired:storageItem.modifyTime]) {
        [self.storage removeObjectForKey:key];
        return nil;
    }else {
        storageItem.accessTime = kCurrentTime;
        [self.storage setValue:storageItem forKey:key];
    }
    return storageItem.value;
}

#pragma mark - private methods
- (BOOL)isExpired:(NSTimeInterval)timeInterval {
    return kCurrentTime-timeInterval>=0?YES:NO;
}
@end
