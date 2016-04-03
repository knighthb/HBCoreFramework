//
//  HBTableDisplayData.h
//  HBCoreFramework
//
//  Created by knight on 16/3/25.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HBTableViewDisplaySection;
@interface HBTableDisplayData : NSObject
@property (nonatomic , strong) NSMutableArray<HBTableViewDisplaySection *> * sections;
@end
