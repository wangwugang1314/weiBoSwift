//
//  YBNavScanCodeController.m
//  test
//
//  Created by MAC on 15/11/29.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBNavScanCodeController.h"
#import "YBScanCode.h"

@interface YBNavScanCodeController ()

/// 扫码控制器
@property(nonatomic, weak) YBScanCode *scanCodeController;

@end

@implementation YBNavScanCodeController

- (instancetype)init{
    // 创建扫码控制器
    YBScanCode *scanCode = [YBScanCode new];
    if (self = [super initWithRootViewController:scanCode]) {
        
    }
    self.scanCodeController = scanCode;
    return self;
}

/// 对象销毁
- (void)dealloc {
    NSLog(@"%s - 销毁",__FUNCTION__);
}

@end
