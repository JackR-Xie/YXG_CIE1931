//
//  YXG_Header.h
//  SPIC-120
//
//  Created by  on 2018/10/24.
//  Copyright © 2018 everfine. All rights reserved.
//

#ifndef YXG_Header_h
#define YXG_Header_h
// 屏幕宽高
#define YXG_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define YXG_SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
// 设置颜色
// RGB颜色转换（16进制->10进制）
#define YXG_UICOLOR_HEX(hexString) [UIColor colorWithRed:((float)((hexString & 0xFF0000) >> 16))/255.0 green:((float)((hexString & 0xFF00) >> 8))/255.0 blue:((float)(hexString & 0xFF))/255.0 alpha:1.0]
// 带有RGBA的颜色设置
#define YXG_UICOLOR_RGB(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
// 随机颜色
#define YXG_UICOLOR_RANDOM  [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0]

/** 导航栏红色E41538*/
#define BaseRedColor YXG_UICOLOR_HEX(0xE41538)
/** 淡蓝色背景色 DFECF0*/
#define BaseBGColor YXG_UICOLOR_HEX(0xDFECF0)
/** 深蓝色*/
#define BaseLANColor YXG_UICOLOR_RGB(207,226,245,1)

/** WIFI OR 蓝牙*/
#define kEY_WIFI_LANYA @"kEY_WIFI_LANYA"
/** 弱灵敏度*/
#define KEY_Low_sensitivity @"KEY_Low_sensitivity"// String 不存在或者0 代表关闭弱灵敏度 1代表开启弱灵敏度
#define OpenLowSensitivity [Preference_get_string(KEY_Low_sensitivity) isEqualToString:@"1"] // 打开低灵敏度模式

// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif /* YXG_Header_h */
