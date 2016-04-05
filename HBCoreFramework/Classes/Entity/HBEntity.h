//
//  HBEntity.h
//  HBCoreFramework
//
//  Created by knight on 16/3/25.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HBStorage;
@protocol HBEntityProtocol <NSObject>
@optional
+ (NSDictionary *)hb_transferDic;

+ (NSDictionary *)hb_objectClassForKeyDic;

@end
@interface HBEntity : NSObject<HBEntityProtocol>
@property (atomic , copy)NSString * entityName;
@property (nonatomic , strong) NSString *entityNum;
//@property (nonatomic , strong,setter=setEntityAge2:) HBStorage *entityAge;
//@property (nonatomic , strong) NSMutableArray<HBStorage *> * storage;
+ (instancetype)transferEntityWithDic:(NSDictionary *)dic;

@end
