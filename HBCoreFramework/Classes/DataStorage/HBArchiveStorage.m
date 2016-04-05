//
//  HBArchiveStorage.m
//  HBCoreFramework
//
//  Created by knight on 16/3/29.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBArchiveStorage.h"
#import "HBStorageItem.h"

@interface HBArchiveStorage ()
//@property (nonatomic , copy) NSString *path;
@property (nonatomic , strong) NSMutableDictionary *kvs;
@end

typedef void(^complete_t)(NSMutableDictionary *) ;
static dispatch_queue_t storage_creation_queue (){
    static dispatch_queue_t hb_storage_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hb_storage_creation_queue = dispatch_queue_create("com.bj.58.hbcoreframework.storage.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    return hb_storage_creation_queue;
}

@implementation HBArchiveStorage
- (instancetype)initWithPath:(NSString *)path {
    NSAssert(path && path.length > 0, @"please make sure path isn't nil or empty!");
    self= [super init];
    if (self) {
        self.path = [path copy];
        self.name = [self.path componentsSeparatedByString:@"/"].lastObject;
        WeakSelf(weakSelf)
        [self kvsFromPath:path completion:^(NSMutableDictionary * dic){
            StrongSelf(weakSelf)
            self.kvs = dic.mutableCopy;
        }];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    NSAssert(name && name.length > 0, @"please make sure your storage has a name!");
    self.name = name;
    NSString * storageFolder = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    if (storageFolder) {
        NSString * path = [storageFolder stringByAppendingPathComponent:name];
        self.path = path;
        return [self initWithPath:path];
    }
    return self;
    
}

- (BOOL)containsObjectForKey:(id<NSCopying>)key {
    __block BOOL hasContain = NO;
    WeakSelf(weakSlef)
    dispatch_sync(storage_creation_queue(), ^{
        StrongSelf(weakSlef)
        if (self.kvs[key]) {//kvs 会与disk的数据保持一致
            hasContain = YES;
        }
    });
    return hasContain;
}

- (void)setValue:(HBStorageItem *)value forKey:(id<NSCopying>)key {
    WeakSelf(weakSelf)
    dispatch_barrier_async(storage_creation_queue(), ^{
        StrongSelf(weakSelf)
        if (self.kvs) {
           id data = self.kvs[key];
            if (data != value) {
                self.kvs[key] = value;
                NSString * filePath = [self.path stringByAppendingPathComponent:[self hb_keyToString:key]];
                [NSKeyedArchiver archiveRootObject:value toFile:filePath];
            }
        }
    });
}

- (HBStorageItem *)objectForKey:(id<NSCopying>)key {
    __block HBStorageItem * data = nil;
    WeakSelf(weakself)
    dispatch_sync(storage_creation_queue(), ^{
        StrongSelf(weakself)
        data = self.kvs[key];
    });
    return data;
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    WeakSelf(weakself)
    dispatch_barrier_async(storage_creation_queue(), ^{
        StrongSelf(weakself)
        NSString * filePath = [self.path stringByAppendingPathComponent:[self hb_keyToString:key]];
        if ([self hb_removeItemAtPath:filePath]) {
            [self.kvs removeObjectForKey:key];
        }
    });
}

- (void)removeAllObjects {
    WeakSelf(weakself)
    dispatch_barrier_async(storage_creation_queue(), ^{
        StrongSelf(weakself)
        NSString * filePath = self.path;
        if ([self hb_removeItemAtPath:filePath]) {
            [self.kvs removeAllObjects];
        }
    });
}

#pragma mark - private methods
- (void)kvsFromPath:(NSString *)path completion:(complete_t)complete {
    dispatch_sync(storage_creation_queue(), ^{
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            NSError * error = nil;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(!error, @"create disk cache path failed!");
        }
        NSError * error;
        NSArray * contentsDir = [fileManager contentsOfDirectoryAtPath:path error:&error];
        if (error) {
            NSException * fileSystemException = [NSException exceptionWithName:@"file system exception" reason:@"file read failed!" userInfo:@{@"error":error}];
            [fileSystemException raise];
        }
        NSMutableDictionary * dic = @{}.mutableCopy;
        if (contentsDir) {
            for (NSString * name in contentsDir) {
                NSString * filePath = [path stringByAppendingPathComponent:name];
                NSData * data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
                if (data) {
                    dic[name] = data;
                }
            }
        }
        complete(dic);
    });
}

- (NSString *)hb_keyToString:(id<NSCopying>)key {
    if (!key) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@",key];
}

- (BOOL)hb_fileExistsAtPath:(NSString *)path {
      NSFileManager * fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

- (BOOL)hb_removeItemAtPath:(NSString *)path{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([self hb_fileExistsAtPath:path]) {
        NSError * error = nil;
       BOOL isRemoved = [fileManager removeItemAtPath:path error:&error];
        if (isRemoved && !error) {
            return YES;
        }else {
            return NO;
        }
    }
    return NO;
}
@end
