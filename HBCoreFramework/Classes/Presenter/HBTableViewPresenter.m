//
//  HBTableViewPresenter.m
//  HBCoreFramework
//
//  Created by knight on 16/3/23.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBTableViewPresenter.h"
#import "HBTableViewInteractor.h"
#import "HBTableDisplayData.h"
#import "HBTableViewDisplaySection.h"
#define EMPTY_STRING @""
@interface HBTableViewPresenter ()
@property (nonatomic , weak) UITableView * tableView; //UserInterface
@property (nonatomic , readwrite , strong) HBTableDisplayData * data;


@end

@implementation HBTableViewPresenter
@dynamic components;

#pragma mark - HBTableViewPresenterProtocol
- (NSDictionary *)components {
    return @{@"":@""};
}

- (void)refresh {
   self.data = [self.interactor refreshData];
}


- (void)loadMore {
  self.data = [self.interactor loadMoreData];
}

- (void)registerCellToTableView:(UITableView *)tableView {
    for (NSString * key in [self.components allKeys]) {
        NSString * identifier = self.components[key];
        NSString * nibName = [NSString stringWithFormat:@"%@Cell",identifier];
        NSString * xibPath = [NSBundle pathForResource:nibName ofType:@"nib" inDirectory:[NSBundle mainBundle].bundlePath];
        UINib * nib = [UINib nibWithNibName:nibName bundle:nil];
        if (xibPath && ![xibPath isEqualToString:EMPTY_STRING]) {
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
        }else {
            [tableView registerClass:NSClassFromString(nibName) forCellReuseIdentifier:identifier];
        }
    }
}

#pragma mark -UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.sections[section].items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.sections.count;
}


@end
