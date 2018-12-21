//
//  CIE31.h
//  CIE1931Demo
//
//  Created by  on 2018/12/14.
//  Copyright © 2018 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXG_Header.h"

#define GET_Z(x,y) 1-x-y
#define BlackColor [UIColor blackColor] // 黑色

#define X_OR_Y 50
#define Make_CIE31_View_Height(width) width+width/8.0
#define Square_width  (YXG_SCREEN_WIDTH-2*X_OR_Y)
#define Square_Height (Square_width/8.0 + Square_width)
#define Square_x_y (YXG_SCREEN_WIDTH - Square_width)/2.0
#define Make_y_imageinary(i) (i/45.0)
#define Make_x_imageInary(i) (i/40.0)

#define GET_X(i) (i/Square_width)*0.8;// 得到坐标X
#define GET_Y(j) (j/Square_Height)*0.9;// 得到坐标Y

#define k_max_x 0.734700
#define k_max_y 0.834100
#define k_min_x 0.003600
#define k_min_y 0.004800

// 两个尖角x值
#define bound_x_left 0.1734
#define bound_x_right 0.7347

#define SourceDic [CIE31 sharedInstance].sourceDic
NS_ASSUME_NONNULL_BEGIN

@interface CIE31 : UIView

@property (nonatomic, strong)NSDictionary *sourceDic;
/** x,y,z的转换矩阵
 x,y 是像素点的坐标
 x+y+z = 1; 由此计算出z
 */
+ (NSDictionary *)XYZ_2_RGB:(float)x y:(float)y z:(float)z;
/** 判断一个点是否在马蹄形内部*/
+ (BOOL)isAtCIE1931:(float)x y:(float)y;
+ (instancetype)sharedInstance;
+ (float)estimateValue:(float)value;
+ (double)lineFix:(double)x;// 计算出直线上的y

@end

/** 两个尖角点
 (0.1734,0.0048)
 (0.7347,0.2653)
 代入计算出a,b
 y = a*x +b
 a = 0.46410119
 b = -0.07567514
 得到直线：y =0.46410119*x - 0.07567514;
 */

NS_ASSUME_NONNULL_END
