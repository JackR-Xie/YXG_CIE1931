//
//  AppDelegate.m
//  CIE1931Demo
//
//  Created by  on 2018/12/13.
//  Copyright © 2018 everfine. All rights reserved.
//

#import "AppDelegate.h"
#import "CIETools/CIE31.h"
#import "CIETools/CIE31.h"
#import "CIETools/CIE31.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"\n➡️\n➡️\n➡️");// 防止控制台遮挡
    [CIE31 sharedInstance];
    
    // 读取边界数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xybound" ofType:@"plist"];
    NSMutableDictionary *dic = [[[NSDictionary alloc] initWithContentsOfFile:path] mutableCopy];
    // 计算x=0.1734右侧的最小值并加入
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString *key in dic.allKeys) {
            @autoreleasepool {
                if ([key floatValue] > bound_x_left) {
                    NSMutableArray *arr = [[dic objectForKey:key] mutableCopy];
                    double lineValue = [CIE31 lineFix:[key doubleValue]];
                    NSString *lineValueStr = [NSString stringWithFormat:@"%.4f",lineValue];
                    [arr addObject:lineValueStr];
                    [dic setObject:arr forKey:key];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [CIE31 sharedInstance].sourceDic = dic;
        });
    });
    
    
    // TODO
//    [self readFromText];
    
    return YES;
}


#pragma mark -

/**
 
 
 这部分代码 实现了 从.txt海量文件转化为精简有效的.plist数据  勿删勿删
 
 
 
 */

- (void)readFromText{
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong AppDelegate *strongSelf = weakSelf;
        [[NSRunLoop currentRunLoop] run];
        NSError *error;
        NSString *textFieldContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"xy001" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        NSArray *lines=[textFieldContents componentsSeparatedByString:@"\n"];
        [strongSelf screenData:lines];
    });
}

#pragma mark - 筛选
- (void)screenData:(NSArray *)lines {
    NSMutableArray *list = [lines mutableCopy];
    [list removeLastObject];// 扔掉最后一个空格数据
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *str in list) {
        @autoreleasepool {
            NSString *string = str;
            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSArray *arr = [string componentsSeparatedByString:@" "];
            NSString *value = arr[0];
            NSString *key = [NSString stringWithFormat:@"%@,%@",arr[1],arr[2]];
            [dic setObject:value forKey:key];
        }
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *key in dic.allKeys) {
        @autoreleasepool {
            NSString *value = [dic objectForKey:key];
            NSArray *arr = [key componentsSeparatedByString:@","];
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@",value,arr[0],arr[1]];
            [result addObject:str];
        }
    }
    [self getEffectiveValue:[result mutableCopy]];
}

#pragma mark - 第二步分组
- (void)getEffectiveValue:(NSMutableArray *)newSource{
    NSMutableArray *newSource_x = [NSMutableArray array];// 存放x<=0.1734的数据 临时
    NSMutableArray *newSource_home = [NSMutableArray array];// 存放首部数字是整数的数据 最终需要用到
    for (NSString *str in newSource) {
        @autoreleasepool {
            NSString *string = str;
            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSArray *arr = [string componentsSeparatedByString:@" "];
            float x = [arr[1] floatValue];
            // 尖点左侧
            if (x <= 0.1734) {
                [newSource_x addObject:str];
            } else {
                [newSource_home addObject:str];
            }
        }
    }
    
    // 取出不重复的标签数组
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *str in newSource_x) {
        @autoreleasepool {
            NSString *string = str;
            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSArray *arr = [string componentsSeparatedByString:@" "];
            NSString *x_str = arr[1];
            [dic setObject:@"xuxu" forKey:x_str];
        }
    }
    NSArray *tags = [dic allKeys];
    
    // 只保留不同的值 这个过程大概需要几分钟的时间 一次就好
    NSMutableArray *arr_max_min = [NSMutableArray array];
    for (NSString *x in tags) {
        @autoreleasepool {
            NSMutableDictionary *dic_max_min = [NSMutableDictionary dictionary];
            for (NSString *str in newSource_x) {
                @autoreleasepool {
                    NSString *string = str;
                    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    NSArray *arr = [string componentsSeparatedByString:@" "];
                    NSString *x_str = arr[1];
                    if ([x_str floatValue] == [x floatValue]) {
                        // 前半部分，只保留三位小数的key
                        float x_2_float = [x floatValue];
                        [dic_max_min setObject:[NSString stringWithFormat:@"%.4f",x_2_float] forKey:arr[2]];
                    }
                }
            }
            [arr_max_min addObject:dic_max_min];
        }
    }
    
    // 只保留最大值最小值
    NSMutableDictionary *zuiZhongDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dddic in arr_max_min) {
        @autoreleasepool {
            NSArray *allKeys = [dddic allKeys];
            NSString *value0 = [allKeys objectAtIndex:0];
            NSString *key = [dddic objectForKey:value0];
            // 获取最大值 最小值
            float max = 0;
            float min = 0;
            NSMutableArray *storeMaxMinArr = [NSMutableArray array];
            for (NSInteger i = 0; i < allKeys.count; i ++) {
                @autoreleasepool {
                    NSString *str = allKeys[i];
                    if (i == 0) {
                        min = [str floatValue];
                    } else {
                        if (min > [str floatValue]) {
                            min = [str floatValue];
                        }
                    }
                    if (max < [str floatValue]) {
                        max = [str floatValue];
                    }
                    
                }
            }
            [storeMaxMinArr addObject:[NSString stringWithFormat:@"%.4f",max]];
            [storeMaxMinArr addObject:[NSString stringWithFormat:@"%.4f",min]];
            [zuiZhongDic setObject:storeMaxMinArr forKey:key];
        }
    }
    
    // 把home数据加入进来
    for (NSString *str in newSource_home) {
        @autoreleasepool {
            NSString *string = str;
            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSArray *arr = [string componentsSeparatedByString:@" "];
            NSString *key = arr[1];
            NSString *value = arr[2];
            // 如果是尖角右侧数据 则改写key保留三位
            if ([key floatValue] > bound_x_left) {
                float key_float = [key floatValue];
                key = [NSString stringWithFormat:@"%.4f",key_float];
                [zuiZhongDic setObject:@[value] forKey:key];
            } else {
                [zuiZhongDic setObject:@[value] forKey:key];
            }
        }
    }
    
    // 路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"xybound.plist"];
    BOOL result = [zuiZhongDic writeToFile:filePath atomically:YES];
    if (result) {
        NSLog(@"哈哈哈成功了=====%@",filePath);
    }
}
#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
