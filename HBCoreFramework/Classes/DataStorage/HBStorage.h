//
//  HBStorage.h
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HBStorageItem;
@interface HBStorage : NSObject
- (void)setValue:(HBStorageItem *)value forKey:(id<NSCopying>)key;

- (HBStorageItem *)objectForKey:(id<NSCopying>)key;
@end
