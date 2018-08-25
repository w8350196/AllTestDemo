//
//  ViewController.m
//  floatValueDistortion
//
//  Created by wj on 2018/8/25.
//  Copyright © 2018年 wj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self printTest];
    [self caculateTest];
}

- (void)printTest
{
    NSLog(@"%f",[@"20.5" floatValue]);
    NSLog(@"%f",[@"20.7" floatValue]);
    NSLog(@"%f",[@"20.75" floatValue]);
    NSLog(@"%f",[@"20.76" floatValue]);
    NSLog(@"%f",[@"20.875" floatValue]);
    NSLog(@"%f",[@"20.878" floatValue]);
    NSLog(@"%f",[@"20.09375" floatValue]);
    NSLog(@"%f",[@"20.09335" floatValue]);
    NSLog(@"%f",[@"20.546875" floatValue]);
    NSLog(@"%f",[@"20.546878" floatValue]);

}

- (void)caculateTest
{
    NSString * floatStr1 =@"14.326";
    NSString * floatStr2 =@"7.540";
    
    NSDecimalNumber * num1 = [NSDecimalNumber decimalNumberWithString:floatStr1];
    NSDecimalNumber * num2 = [NSDecimalNumber decimalNumberWithString:floatStr2];

    NSDecimalNumber *num3 = [num1 decimalNumberByAdding:num2];
    CGFloat float3 = [floatStr1 floatValue] + [floatStr2 floatValue];
    NSLog(@"%@,%f",num3,float3);
    
    NSDecimalNumber *num4 = [num1 decimalNumberBySubtracting:num2];
    CGFloat float4 = [floatStr1 floatValue] - [floatStr2 floatValue];
    NSLog(@"%@,%f",num4,float4);

    NSDecimalNumber *num5 = [num1 decimalNumberByMultiplyingBy:num2];
    CGFloat float5 = [floatStr1 floatValue] * [floatStr2 floatValue];
    NSLog(@"%@,%f",num5,float5);

    NSDecimalNumber *num6 = [num1 decimalNumberByDividingBy:num2];
    CGFloat float6 = [floatStr1 floatValue] / [floatStr2 floatValue];
    NSLog(@"%@,%f",num6,float6);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
