//
//  HBTableViewInteractor.h
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HBTableViewDataManager;
@class HBTableDisplayData;
@class HBEntity;
@interface HBTableViewInteractor : NSObject
@property (nonatomic , strong) HBTableViewDataManager * dataManager;
@property (nonatomic , strong) id request;
@property (nonatomic , strong) HBEntity * entity;

- (HBTableDisplayData *)refreshData;

- (HBTableDisplayData *)loadMoreData;

@end
