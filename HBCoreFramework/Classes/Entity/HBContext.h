//
//  HBContext.h
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBContext : NSObject

- (void)setObject:(_Nonnull id)object forKey:(nonnull id<NSCopying>)aKey;

- (_Nonnull id)objectForKey:(_Nonnull id<NSCopying>)key;
@end
