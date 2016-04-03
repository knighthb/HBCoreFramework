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
- (void)setValue:(HBStorageItem *)value forKey:(id<NSCopying>)key {
    [self doesNotRecognizeSelector:_cmd];
}

- (HBStorageItem *)objectForKey:(id<NSCopying>)key {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}
@end
