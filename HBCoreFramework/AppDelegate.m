//
//  AppDelegate.m
//  HBCoreFramework
//
//  Created by knight on 16/3/23.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "HBArchiveStorage.h"
#import "HBStorageItem.h"
#import "HBEntity.h"
#import "HBTestPerson.h"
#import "HBArrayTestEntity.h"

@interface AppDelegate ()
@property (nonatomic , strong) HBArchiveStorage * storage;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"http://www.baidu.com === count=%ld",manager.tasks.count);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"http://www.baidu.com === count=%ld",manager.tasks.count);

    }];
    [manager GET:@"http://www.sina.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"http://www.sina.com === count=%ld",manager.tasks.count);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"http://www.sina.com === count=%ld",manager.tasks.count);

    }];
    NSLog(@"http://totoal === count=%ld",manager.tasks.count);
  NSString * filePath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * fileName = [filePath stringByAppendingPathComponent:@"storageTest"];
    NSLog(@"fileName = %@",fileName);
    self.storage = [[HBArchiveStorage alloc]  initWithPath:fileName];
    for (int i = 0; i< 10; i++) {
        
        NSString * key = [NSString stringWithFormat:@"key%d",i];
//        HBStorageItem * item = [[HBStorageItem alloc] init];
//        item.key = key;
//        item.value = @"hahahahaaha";
//        [self.storage setValue:item forKey:key];
     HBStorageItem * item = [self.storage objectForKey:key];
        NSLog(@"key = %@ | value = %@",item.key,item.value);
    }
    NSNumber * number = [NSNumber numberWithInteger:34];
    
    HBTestPerson * entity = [HBTestPerson transferEntityWithDic:@{@"entityname":@"hehe",
                                                          @"entitynum":@"1",
                                                          @"testEntity":@{@"name":@"xiaoming",
                                                                          @"age":@(34)
                                                                         
                                                                  },
                                                                  @"testEntities":@[@{@"name":@"xiaoming",
                                                                                      @"age":@(34)
                                                                                      
                                                                                      },
                                                                                    @{@"name":@"xiaoming",
                                                                                      @"age":@(34)
                                                                                      
                                                                                      },
                                                                                    @{@"name":@"xiaoming",
                                                                                      @"age":@(34)
                                                                                      
                                                                                      }]}];
    NSLog(@"%@======",entity.testEntity.name);
    if (entity.testEntities.count > 0) {
        for (HBTestEntity * testEntity in entity.testEntities) {
            NSLog(@"name = %@ | value = %ld",testEntity.name,testEntity.age);
        }
    }
    HBArrayTestEntity * arrayTestEntity = [HBArrayTestEntity transferEntityWithObject:@[@{@"name":@"xiaoming",
                                                                                          @"age":@(34)
                                                                                          
                                                                                          },
                                                                                        @{@"name":@"xiaoming",
                                                                                          @"age":@(34)
                                                                                          
                                                                                          },
                                                                                        @{@"name":@"xiaoming",
                                                                                          @"age":@(34)
                                                                                          
                                                                                          }]];
    NSLog(@"%@",arrayTestEntity);
    
    return YES;
}
 /*
 @"testEntities":@[@{@"name":@"xiaoming",
 @"age":@(34)
 
 },
 @{@"name":@"xiaoming",
 @"age":@(34)
 
 },
 @{@"name":@"xiaoming",
 @"age":@(34)
 
 }]
 
 
 */


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
