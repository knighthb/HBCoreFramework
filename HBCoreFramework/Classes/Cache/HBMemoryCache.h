//
//  HBMemoryCache.h
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSCache.h>
@interface HBMemoryCache : NSCache
+ (instancetype)sharedInstance;
@end
