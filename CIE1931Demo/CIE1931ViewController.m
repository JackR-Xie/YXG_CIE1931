//
//  CIE1931ViewController.m
//  CIE1931Demo
//
//  Created by  on 2018/12/17.
//  Copyright © 2018 everfine. All rights reserved.
//

#import "CIE1931ViewController.h"
#import "CIETools/CIE31_View.h"
#import "CIETools/CIE31.h"

@interface CIE1931ViewController ()

@end

@implementation CIE1931ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CIE1931";
    self.view.backgroundColor = [UIColor cyanColor];
    CIE31_View *view = [[CIE31_View alloc] initWithFrame:CGRectMake(0, 0, YXG_SCREEN_WIDTH, Make_CIE31_View_Height(YXG_SCREEN_WIDTH))];
    [self.view addSubview:view];
    if (NSFoundationVersionNumber>=NSFoundationVersionNumber_iOS_8_0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
}


@end
