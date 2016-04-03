//
//  HBNetworkConfiger.h
//  HBCoreFramework
//
//  Created by knight on 16/3/26.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBNetworkConfiger : NSObject
@property (nonatomic , copy) NSString * baseURL;
@property (nonatomic , assign) BOOL debug;
@property (nonatomic , assign) NSTimeInterval * rquestTimeout;
@end
