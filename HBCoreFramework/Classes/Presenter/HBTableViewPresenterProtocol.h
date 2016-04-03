//
//  HBTableViewPresenterProtocol.h
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  UITableView;
@protocol HBTableViewPresenterProtocol <NSObject>
@property (nonatomic , strong) NSDictionary * components;
@required
- (void)refresh;
- (void)loadMore;
- (void)registerCellToTableView:(UITableView *)tableView;
@end
