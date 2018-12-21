//
//  CIE31.m
//  CIE1931Demo
//
//  Created by  on 2018/12/14.
//  Copyright © 2018 everfine. All rights reserved.
//

#import "CIE31.h"

@implementation CIE31

+ (instancetype)sharedInstance {
    static CIE31 *cie = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cie = [[CIE31 alloc] init];
    });
    return cie;
}

+ (NSDictionary *)XYZ_2_RGB:(float)x y:(float)y z:(float)z {
    double dr = 0;
    double dg = 0;
    double db = 0;
    dr = 3.0627*x - 1.3928*y - 0.4759*z;
    dg = -0.9689*x + 1.8756*y + 0.0417*z;
    db = 0.0677*x - 0.2286*y + 1.069*z;
    
    double max = 0;
    max = dr > dg ? dr  : dg;
    max = max > db ? max : db;
    
    dr = dr/max*255;
    dg = dg/max*255;
    db = db/max*255;
    
    dr = dr > 0 ? dr : 0;
    dg = dg > 0 ? dg : 0;
    db = db > 0 ? db : 0;
    
    if (dr > 255) {
        dr = 255;
    }
    if (dg > 255) {
        dg = 255;
    }
    if (db > 255) {
        db = 255;
    }
    int r = (int)(dr + 0.5);
    int g = (int)(dg + 0.5);
    int b = (int)(db + 0.5);
    return @{@"r":@(r),@"g":@(g),@"b":@(b)};
}

+ (BOOL)isAtCIE1931:(float)x y:(float)y {
    
    // 第一步去除边界值之外的点
    if (x > k_max_x || x < k_min_x) {
        return NO;
    }
    if (y > k_max_y || y < k_min_y) {
        return NO;
    }
    float estimateX = [self estimateValue:x];
    NSString *key = nil;
    key = [NSString stringWithFormat:@"%.4f",estimateX];
    NSArray *arr = [SourceDic objectForKey:key];
    if (arr.count > 1) {
        float maxY = [arr.firstObject floatValue];
        float minY = [arr.lastObject floatValue];
        if (y >= minY && y < maxY) {
            return YES;
        } else if (y == maxY) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

+ (double)lineFix:(double)x {
    return 0.46410119*x - 0.07567514;
}


#pragma mark - tools

+ (float)estimateValue:(float)value {
    NSString *str_value = [NSString stringWithFormat:@"%.4f",value];
    return [str_value floatValue];
}


@end






