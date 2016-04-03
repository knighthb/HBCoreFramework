//
//  HBContext.m
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBContext.h"
@interface HBContext ()
@property (nonatomic , strong) NSMutableDictionary * context;
@end

@implementation HBContext

- (instancetype)init {
    self = [super init];
    if (self) {
        self.context = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setObject:(id)object forKey:(nonnull id<NSCopying>)aKey {
    if (!object) {
        object = [[NSObject alloc] init];
    }
    if (!self.context) {
        self.context = [[NSMutableDictionary alloc] init];
    }
    self.context[aKey] = object;
}


- (id)objectForKey:(_Nonnull id<NSCopying>)key {
    return self.context[key];
}
@end
