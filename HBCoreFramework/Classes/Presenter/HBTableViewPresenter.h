//
//  HBTableViewPresenter.h
//  HBCoreFramework
//
//  Created by knight on 16/3/23.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HBTableViewPresenterProtocol.h"
@class HBContext;
@class HBTableViewInteractor;
@class HBTableDisplayData;
@protocol HBTableViewPresenterProtocol;


@interface HBTableViewPresenter : NSObject<UITableViewDataSource,HBTableViewPresenterProtocol>
@property (nonatomic , strong) HBContext * context;
@property (nonatomic , strong) HBTableViewInteractor * interactor;
@property (nonatomic , readonly, strong) HBTableDisplayData* data;

@end
