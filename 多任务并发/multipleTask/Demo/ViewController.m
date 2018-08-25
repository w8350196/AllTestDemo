//
//  ViewController.m
//  Demo
//
//  Created by 陈小勇 on 2018/7/23.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * url1;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.url = @"https://www.baidu.com";
    self.url1 = @"https://www.baidu.com";

    [self test];
    [self test1];
    [self test2];
    [self test3];
    [self test4];

}
- (void)test
{
    // 创建队列组
    dispatch_group_t group =  dispatch_group_create();
    // 创建并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 开子线程，任务1
    dispatch_group_async(group, queue, ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];
        NSLog(@"任务1 完成，线程：%@", [NSThread currentThread]);
    });
    
    // 开子线程，任务2
    dispatch_group_async(group, queue, ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url1]];
        NSLog(@"任务2 完成，线程：%@", [NSThread currentThread]);
    });
    
    // 全部完成
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"全部完成，线程：%@", [NSThread currentThread]);
        });
    });
}

- (void)test1
{
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 任务1
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url1]];
        NSLog(@"任务1 完成，线程：%@", [NSThread currentThread]);
    }];
    
    // 任务2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url1]];
        NSLog(@"任务2 完成，线程：%@", [NSThread currentThread]);
    }];
    
    // 任务3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url1]];
        NSLog(@"任务3 完成，线程：%@", [NSThread currentThread]);
    }];
    
    // 添加操作依赖，注意不能循环依赖
    [op1 addDependency:op2];
    [op3 addDependency:op1];

    op1.completionBlock = ^{
        NSLog(@"全部完成，线程：%@", [NSThread currentThread]);
    };
    
    // 添加操作到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];


}

- (void)test2
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建队列组
    dispatch_group_t group =  dispatch_group_create();
    // 创建并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 任务1
    dispatch_group_async(group, queue, ^{
        NSURLSessionDataTask *task1 = [session dataTaskWithURL:[NSURL URLWithString:self.url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"任务1 完成，线程：%@", [NSThread currentThread]);
        }];
        [task1 resume];
    });

    // 任务2
    dispatch_group_async(group, queue, ^{
        NSURLSessionDataTask *task2 = [session dataTaskWithURL:[NSURL URLWithString:self.url1] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"任务2 完成，线程：%@", [NSThread currentThread]);
        }];
        [task2 resume];
    });
    
    // 全部完成
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"全部完成，线程：%@", [NSThread currentThread]);
        });
    });

}

- (void)test3
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 任务1
    dispatch_group_enter(group);
    NSURLSessionDataTask *task1 = [session dataTaskWithURL:[NSURL URLWithString:self.url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"任务1 完成，线程：%@", [NSThread currentThread]);
        dispatch_group_leave(group);
    }];
    [task1 resume];
    
    // 任务2
    dispatch_group_enter(group);
    NSURLSessionDataTask *task2 = [session dataTaskWithURL:[NSURL URLWithString:self.url1] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"任务2 完成，线程：%@", [NSThread currentThread]);
        dispatch_group_leave(group);
    }];
    [task2 resume];
    // 任务2
    dispatch_group_enter(group);
    NSURLSessionDataTask *task3 = [session dataTaskWithURL:[NSURL URLWithString:self.url1] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"任务3 完成，线程：%@", [NSThread currentThread]);
        dispatch_group_leave(group);
    }];
    [task3 resume];

    
    // 全部完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        NSLog(@"全部完成，线程：%@", [NSThread currentThread]);
    });

}

- (void)test4
{
    dispatch_group_t group = dispatch_group_create();

    for(int i = 0 ; i< 10; i ++)
    {
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            NSLog(@"%@", [NSString stringWithFormat: @"任务%d 开始，线程：%@",i, [NSThread currentThread] ]);
            
            NSURLSessionDataTask *task2 = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:self.url1] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"%@", [NSString stringWithFormat: @"任务%d 完成，线程：%@",i, [NSThread currentThread] ]);
                dispatch_semaphore_signal(semaphore);
                
            }];
            [task2 resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        NSLog(@"全部完成，线程：%@", [NSThread currentThread]);
//    });

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
