//
//  YDApplicationRouter.m
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/10/24.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import "YDApplicationRouter.h"
#import "YDApplicationModel.h"
#import "UIViewController+Extension.h"

@implementation YDApplicationRouter

static YDApplicationRouter * applicationRouter = nil;

+ (YDApplicationRouter *)sharedApplicationRouter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        applicationRouter = [[self alloc] init];
    });
    return applicationRouter;
    
}

- (void)didClickApplicaton:(YDApplicationModel *)model
{
    UIViewController * currentVC =  [self getCurrentViewController];
    NSString * title = model.title;
    Class pushViewController = [self getPushViewControllerClassForTitle:title];
    if(pushViewController)
    {
        //直接跳转.
        [currentVC.navigationController pushViewController:[[pushViewController alloc] init] animated:YES];
    }
    else
    {
        //自定义操作的一些页面.
       
    }
}
- (UIViewController *)getCurrentViewController
{
    UIViewController * currentVC =  [[UIViewController alloc] init];
    currentVC  = [currentVC getCurrentViewController];
    return currentVC;
}
- (Class)getPushViewControllerClassForTitle:(NSString *)title
{
    //页面跳转关系.
    NSDictionary * dic = @{@"余额宝":[UIViewController class],
                           @"转账":[UIViewController class],
                           @"充值中心":[UIViewController class],
                           @"生活缴费":[UIViewController class],
                           };
    Class VCClass = [dic valueForKey:title];
    return VCClass;
}
@end
