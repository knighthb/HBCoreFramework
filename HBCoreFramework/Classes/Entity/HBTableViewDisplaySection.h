//
//  HBTableViewDisplaySection.h
//  HBCoreFramework
//
//  Created by knight on 16/3/25.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HBEntity;
@interface HBTableViewDisplaySection : NSObject
@property (nonatomic , copy) NSString * name;
@property (nonatomic , copy) UIView * view;
@property (nonatomic , strong) NSMutableArray<HBEntity *> * items;
@end
