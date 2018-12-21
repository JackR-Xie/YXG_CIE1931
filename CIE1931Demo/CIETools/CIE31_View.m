//
//  CIE31_View.m
//  CIE1931Demo
//
//  Created by  on 2018/12/17.
//  Copyright © 2018 jack. All rights reserved.
//

#import "CIE31_View.h"
#import "YXG_Header.h"


@implementation CIE31_View

- (void)dealloc {
    NSLog(@"🔥CIE31_View释放");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self drawAsync];
    }
    return self;
}

// 异步绘制
- (void)drawAsync {
    // 主线程获取正方形的区域
    CGRect frame = self.frame;
    CGRect squareFrame = CGRectMake(Square_x_y, Square_x_y, Square_width, Square_Height);
    float unitY = Square_Height/9.0;
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSRunLoop currentRunLoop] run];
        // 设置绘制区域
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
        // 获取上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        // 修改当前上下文的画笔颜色和宽度 并保存状态
        CGContextSetLineWidth(context, 1);
        [[UIColor blackColor] setStroke];
        CGContextSaveGState(context);
        // 绘制正方形
        CGContextAddRect(context, squareFrame);
        CGContextStrokePath(context);
        /* 恢复当前上下文的状态 */
        CGContextRestoreGState(context);
        
        // 绘制
        for (NSInteger i = 0; i < 8; i ++) {
            float y = X_OR_Y + unitY + unitY*i;
            // 设置线条的样式
            CGContextSetLineCap(context,kCGLineCapRound);
            // 绘制线的宽度
            CGContextSetLineWidth(context,1.0);
            // 线的颜色
            CGContextSetStrokeColorWithColor(context, BlackColor.CGColor);
            // 开始绘制
            CGContextBeginPath(context);
            // 设置虚线绘制起点
            CGContextMoveToPoint(context,X_OR_Y + 1, y);
            // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
            CGFloat lengths[] = {5,5};
            CGContextSetLineDash(context,0, lengths,1);
            // 绘制虚线的终点
            CGContextAddLineToPoint(context,Square_width + X_OR_Y - 1,y);
            // CGContextClosePath在CGContextStrokePath之前执行，否则会出现错误：CGContextClosePath: no current point.因为CGContextStrokePath、CGContextFillPath、CGContextEOFillPath会置空当前点
            CGContextClosePath(context);
            // 绘制
            CGContextStrokePath(context);
        }
        
        for (NSInteger i = 0; i < 7; i ++) {
            float unitX = Square_width/8.0;
            float x = X_OR_Y + unitX + unitX*i;
            // 设置线条的样式
            CGContextSetLineCap(context,kCGLineCapRound);
            // 绘制线的宽度
            CGContextSetLineWidth(context,1.0);
            // 线的颜色
            CGContextSetStrokeColorWithColor(context, BlackColor.CGColor);
            // 开始绘制
            CGContextBeginPath(context);
            // 设置虚线绘制起点
            CGContextMoveToPoint(context, x,X_OR_Y + 1);
            // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
            CGFloat lengths[] = {5,5};
            CGContextSetLineDash(context,0, lengths,1);
            // 绘制虚线的终点
            CGContextAddLineToPoint(context,x, X_OR_Y + Square_Height - 1);
            // CGContextClosePath在CGContextStrokePath之前执行，否则会出现错误：CGContextClosePath: no current point.因为CGContextStrokePath、CGContextFillPath、CGContextEOFillPath会置空当前点
            CGContextClosePath(context);
            // 绘制
            CGContextStrokePath(context);
            
        }
        
        for (NSInteger i = 0; i < 9; i ++) {
            float unit = Square_Height/45.0;
            float from_x = X_OR_Y + 1;
            float to_x = X_OR_Y + 1 + 2;
            float right_from_x = X_OR_Y + Square_width - 2;
            float right_to_x = X_OR_Y + Square_width;
            for (NSInteger j = 0; j < 4; j ++) {
                float y = X_OR_Y + i*unitY + unit + unit*j;
                // 设置起点
                CGContextMoveToPoint(context, from_x, y);
                // 增加点
                CGContextAddLineToPoint(context, to_x, y);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathStroke);
                
                // 设置起点
                CGContextMoveToPoint(context, right_from_x, y);
                // 增加点
                CGContextAddLineToPoint(context, right_to_x, y);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathStroke);
            }
            
            
        }
        
        for (NSInteger i = 0; i < 8; i ++) {
            float unitX = Square_width/8.0;
            float unit = Square_width/40.0;
            float from_y = X_OR_Y + 1;
            float to_y = X_OR_Y + 1 + 2;
            float bottom_from_x = X_OR_Y + Square_Height - 2;
            float bottom_to_x = X_OR_Y + Square_Height;
            for (NSInteger j = 0; j < 4; j ++) {
                float x = X_OR_Y + i*unitX + unit + unit*j;
                // 设置起点
                CGContextMoveToPoint(context, x, from_y);
                // 增加点
                CGContextAddLineToPoint(context, x, to_y);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathStroke);
                
                // 设置起点
                CGContextMoveToPoint(context, x, bottom_from_x);
                // 增加点
                CGContextAddLineToPoint(context, x, bottom_to_x);
                CGContextClosePath(context);
                CGContextDrawPath(context, kCGPathStroke);
            }
        }
        
        for (NSInteger i = 0; i < 10; i ++) {
            NSString *text = [NSString stringWithFormat:@"%.1f",i/10.0];
            float text_y = X_OR_Y + Square_Height - i*unitY - 13;
            [text drawAtPoint:CGPointMake(X_OR_Y - 22.5, text_y) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        }
        
        for (NSInteger i = 0; i < 9; i ++) {
            float unitX = Square_width/8.0;
            NSString *text = [NSString stringWithFormat:@"%.1f",i/10.0];
            float text_x = X_OR_Y + i*unitX;
            [text drawAtPoint:CGPointMake(text_x, X_OR_Y + Square_Height + 2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        }
        
        CGPoint X_point = CGPointMake(X_OR_Y+1,X_OR_Y- 27);// 绘制Y
        CGPoint y_point = CGPointMake(X_OR_Y + Square_width + 2, X_OR_Y + Square_Height - 22);// 绘制X
        CGPoint name_point = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0 - 30, 10);
        NSString *text_X = @"x";
        NSString *text_Y = @"y";
        NSString *name = @"CIE1931";
        [text_X drawAtPoint:y_point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]}];
        [text_Y drawAtPoint:X_point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]}];
        [name drawAtPoint:name_point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
        
        // 遍历坐标内所有的点 判断是否在马蹄形内部 若在则获取其颜色 并绘制一个点
        for (NSInteger i = 0; i < (NSInteger)Square_width; i ++) {
            for (NSInteger j = 0; j < (NSInteger)Square_Height; j ++) {
                // 如果不在主线程 确保开启了子线程的RunLoop
                @autoreleasepool {
                    // 用于绘图的坐标
                    float x = X_OR_Y + i;
                    float y = X_OR_Y + Square_Height - j;
                    // 判断改点是否在马蹄形内部
                    float getX = GET_X(i);
                    float getY = GET_Y(j);
                    BOOL result = [CIE31 isAtCIE1931:getX y:getY];
                    if (result) {// 绘制点
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        // 以矩形frame为依据画圆
                        CGRect pointframe = CGRectMake(x, y, 1, 1);
                        CGContextAddEllipseInRect(context, pointframe);
                        NSDictionary *dic = [CIE31 XYZ_2_RGB:getX y:getY z:1-getX - getY];
                        float r = [[dic objectForKey:@"r"] floatValue];
                        float g = [[dic objectForKey:@"g"] floatValue];
                        float b = [[dic objectForKey:@"b"] floatValue];
                        UIColor *color = YXG_UICOLOR_RGB(r, g, b, 1);
                        [color set];// 填充色
                        CGContextFillPath(context);
                    }
                }
            }
        }
        
        // 从当前上下文获取绘制内容
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong CIE31_View *strongSelf = weakSelf;
            strongSelf.image = image;
        });
        NSLog(@"哈哈哈====%@",image);
        // 关闭上下文
        UIGraphicsEndImageContext();
    });
}


@end


