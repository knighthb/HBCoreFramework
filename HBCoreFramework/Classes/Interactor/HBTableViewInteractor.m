//
//  HBTableViewInteractor.m
//  HBCoreFramework
//
//  Created by knight on 16/3/24.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBTableViewInteractor.h"
#import "HBEntity.h"
#import "HBTableViewDisplaySection.h"
#import "HBTableDisplayData.h"
@implementation HBTableViewInteractor
- (HBTableDisplayData *)refreshData {
   return [self hb_fecthDataWithRequest:self.request append:NO];
}

- (HBTableDisplayData *)loadMoreData {
   return [self hb_fecthDataWithRequest:self.request append:YES];
}

- (HBTableDisplayData *)hb_fecthDataWithRequest:(id)request append:(BOOL)isAppend {
    //根据request的url先从缓存里取数据(get data from cache by request'url firstly)
    //1.如果能命中缓存直接从缓存取 (if hits the cache, then fetch data from cache)
    //2.如果不能命中则去服务器请求 (otherwise,request server)
    //3.服务器请求回来之后,根据缓存策略存缓存 (when data come back from server ,cache data according to the cache policity)
    if (isAppend) {
        //loadMore
    }else {
        //refresh
    }
    return nil;
}

- (id)customRequest {
    return nil;
}

- (void)parseDataFromResponce:(id)response {
    
}
@end
