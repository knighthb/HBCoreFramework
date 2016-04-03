//
//  HBStorageItem.m
//  HBCoreFramework
//
//  Created by knight on 16/3/29.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBStorageItem.h"

@implementation HBStorageItem

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.key = [aDecoder decodeObjectForKey:@"key"];
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
        self.accessTime = [aDecoder decodeDoubleForKey:@"accessTime"];
        self.modifyTime = [aDecoder decodeDoubleForKey:@"modifyTime"];
        self.extendData = [aDecoder decodeObjectForKey:@"extendData"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeDouble:self.accessTime forKey:@"accessTime"];
    [aCoder encodeDouble:self.modifyTime forKey:@"modifyTime"];
    [aCoder encodeObject:self.extendData forKey:@"extendData"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

@end
