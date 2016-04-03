//
//  HBStorageItem.h
//  HBCoreFramework
//
//  Created by knight on 16/3/29.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBStorageItem : NSObject<NSCoding>
@property (nonatomic , strong) id<NSCopying> key;
@property (nonatomic , strong) id value;
@property (nonatomic , copy)NSString *path;
@property (nonatomic , assign) NSTimeInterval accessTime;//访问时间
@property (nonatomic , assign) NSTimeInterval modifyTime;//修改时间
@property (nonatomic , strong) id extendData;
@end
