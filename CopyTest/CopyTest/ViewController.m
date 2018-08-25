//
//  ViewController.m
//  CopyTest
//
//  Created by wj on 2017/8/30.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSArray+Description.h"

@interface ViewController ()

@property(nonatomic,strong) NSString * strongString;
//@property(nonatomic,copy) NSString * copyString;
//Property follows Cocoa naming convention for returning 'owned' objects
@property(nonatomic,copy) NSString * myCopyString;
@property(nonatomic,strong) Person *person;

@end

//1.copy  NSString
//2.页面跳转 直接传model  修改失败,但是原来的model已经变化
//3.上传临时赋值scanType  修改回来.

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person * p = [[Person alloc] init];
    p.name = @"re";
    p.age = @"34";
    
    Person * p1 = [p copyMyself];

    //1. NSString为什么用copy修饰？
    [self copyStrTest];
    [self copyStrTest1];
    
    //2. copy返回imutable对象；
    //mutableCopy返回mutable对象；
    [self objectCopyMutableCopyTest];
    [self setCopyMutableCopyTest];
//    [immutableObject copy]   不可变
//    [immutableObject mutableCopy] 可变
//    [mutableObject copy] //不可变
//    [mutableObject mutableCopy] //可变
//    [immutableArray copy] // 浅复制
//    [immutableArray mutableCopy] //单层深复制
//    [mutableArray copy] //单层深复制
//    [mutableArray mutableCopy] //单层深复制

    
//    //3.非集合对象的copy与mutableCopy
//    //遵循协议实现- (id)copyWithZone:(NSZone *)zone
//    //- (id)mutableCopyWithZone:(nullable NSZone *)zone
//
//    //4.集合类的实现深复制
    
    //- (instancetype)initWithArray:(NSArray<ObjectType> *)array copyItems:(BOOL)flag;
    //NSMutableArray与NSArray实现是有区别的。
//    [immutableArray yes] // 单层深复制
//    [immutableArray no] // 指向同意一象
//    [mutableArray yes] // 容器里的元素收到 copyWithZone
//    [mutableArray no] //单层深复制
    [self setCopyMutableCopyTest1];
    
    //直接暴力解归档
    [self setCopyMutableCopyTest2];
    
    //多层容器.
    [self setCopyMutableCopyTest3];
    [self setCopyMutableCopyTest4];

}

- (void)copyStrTest
{
     NSLog(@"copyStrTest");
    NSMutableString * str =[[NSMutableString alloc] initWithString:@"h这只是一个小测试"];
    self.strongString = str;
    self.myCopyString = str;
    NSLog(@"%p,%@,%p,%@,%p,%@",str,str,self.strongString,self.strongString,self.myCopyString,self.myCopyString);
    [str appendFormat:@"iOS组"];
    NSLog(@"%p,%@,%p,%@,%p,%@",str,str,self.strongString,self.strongString,self.myCopyString,self.myCopyString);
}
- (void)copyStrTest1
{
    NSLog(@"copyStrTest1");
    NSMutableString * str =[NSMutableString stringWithFormat: @"h这只是一个小测试"];
    self.strongString = [str copy];
    self.myCopyString = [str copy];
    NSLog(@"%p,%@,%p,%@,%p,%@",str,str,self.strongString,self.strongString,self.myCopyString,self.myCopyString);
    [str appendFormat:@"iOS组"];
    NSLog(@"%p,%@,%p,%@,%p,%@",str,str,self.strongString,self.strongString,self.myCopyString,self.myCopyString);
}
- (void)objectCopyMutableCopyTest
{
     NSLog(@"copyMutableCopyTest");
     NSMutableString * str =[[NSMutableString alloc] initWithString:@"h这只是一个小测试"];
     NSString * str2 = [str copy];
     NSString * str3 = [str mutableCopy];
     NSMutableString * str4 = [str copy];
     NSMutableString * str5 = [str mutableCopy];
     NSLog(@"%p,%p,%p,%p,%p",str,str2,str3,str4,str5);
     //0x6040002586f0,0x604000258990,0x604000258180,0x604000258720,0x6040002585a0
     [str appendFormat:@"ios"];
//     [str2 performSelector:@selector(appendFormat:) withObject:@"ios"]; // 崩溃
     [str3 performSelector:@selector(appendFormat:) withObject:@"ios"];
//     [str4 appendFormat:@"ios"];  //崩溃
     [str5 appendFormat:@"ios"];
    
     NSString * str1 = @"h这只是一个小测试";
     NSString * str6 = [str1 copy];
     NSString * str7 = [str1 mutableCopy];
     NSMutableString * str8 = [str1 copy];
     NSMutableString * str9 = [str1 mutableCopy];
     NSLog(@"%p,%p,%p,%p,%p",str1,str6,str7,str8,str9);
    //0x1069ad100,0x1069ad100,0x60000024bb80,0x1069ad100,0x604000450710     [str9 appendFormat:@"ios"];
//    [str6 performSelector:@selector(appendFormat:) withObject:@"ios"]; //崩溃
    [str7 performSelector:@selector(appendFormat:) withObject:@"ios"];
//    [str8 appendFormat:@"ios"];//崩溃
    [str9 appendFormat:@"ios"];//崩溃
}
- (void)setCopyMutableCopyTest
{
    
    NSLog(@"setCopyMutableCopyTest");
    Person * p = [[Person alloc]init];
    NSArray * arr = @[p];
    NSArray * arr2 = [arr copy];
    NSArray * arr3 = [arr mutableCopy];
    NSMutableArray * arr4 = [arr copy];
    NSMutableArray * arr5 = [arr mutableCopy];
    NSLog(@" %@,%@,%@,%@,%@",arr,arr2,arr3,arr4,arr5);
//    NSArray 0x600000005ff0,0x600000038f40,
//    NSArray 0x600000005ff0,0x600000038f40,
//    NSArray 0x60000004f750,0x600000038f40,
//    NSArray 0x600000005ff0,0x600000038f40,
//    NSArray 0x600000257be0,0x600000038f40

//    [arr2 performSelector:@selector(addObject:) withObject:@"1"]; //崩溃
    [arr3 performSelector:@selector(addObject:) withObject:@"1"];
//    [arr4 addObject:@"1"]; //崩溃
    [arr5 addObject:@"5"];
//
    NSMutableArray * arr1 = [[NSMutableArray alloc]initWithObjects:p , nil];
    NSArray * arr6 = [arr1 copy];
    NSArray * arr7 = [arr1 mutableCopy];
    NSMutableArray * arr8 = [arr1 copy];
    NSMutableArray * arr9 = [arr1 mutableCopy];
    NSLog(@" %@,%@,%@,%@,%@",arr1,arr6,arr7,arr8,arr9);
    p.name = @"jack";
//    NSArray 0x6000004527e0,0x6000004262c0,
//    NSArray 0x600000018940,0x6000004262c0,
//    NSArray 0x600000452720,0x6000004262c0,
//    NSArray 0x6000002035c0,0x6000004262c0,
//    NSArray 0x600000452780,0x6000004262c0
    
//     [arr6 performSelector:@selector(addObject:) withObject:@"1"];
     [arr7 performSelector:@selector(addObject:) withObject:@"1"];
//     [arr8 addObject:@"1"];
     [arr9 addObject:@"5"];
    

}
- (void)setCopyMutableCopyTest1
{
    NSLog(@"setCopyMutableCopyTest1");
    Person * p = [[Person alloc]init];
    Person * p1 = [[Person alloc]init];
    Person * p2 = [[Person alloc]init];
   
    //If YES, each object in array receives a copyWithZone: message to create a copy of the object—objects must conform to the NSCopying protocol. In a managed memory environment, this is instead of the retain message the object would otherwise receive. The object copy is then added to the returned array.
    //If NO, then in a managed memory environment each object in array simply receives a retain message when it is added to the returned array.

    NSArray * arr = [[NSArray alloc]initWithObjects:p, p1, p2 , nil];
    NSArray * arr2 = [[NSArray alloc]initWithArray:arr copyItems:YES];
    NSArray * arr3 = [[NSArray alloc]initWithArray:arr copyItems:NO];
    NSMutableArray * arr4 = [[NSMutableArray alloc]initWithArray:arr copyItems:YES];
    NSMutableArray * arr5 = [[NSMutableArray alloc]initWithArray:arr copyItems:NO];
    NSLog(@" %@,%@,%@,%@,%@",arr,arr2,arr3,arr4,arr5);
//    NSArray 0x600000252a80,0x600000233300,0x600000233160,0x600000230980,
//    NSArray 0x600000252540,0x600000232880,0x6000002331e0,0x6000002305c0,
//    NSArray 0x600000252a80,0x600000233300,0x600000233160,0x600000230980,
//    NSArray 0x600000252750,0x600000231e00,0x600000233280,0x600000232b00,
//    NSArray 0x6000002528d0,0x600000233300,0x600000233160,0x600000230980
    
}

- (void)setCopyMutableCopyTest2
{
    NSLog(@"setCopyMutableCopyTest1");
    Person * p = [[Person alloc]init];
    Person * p1 = [[Person alloc]init];
    Person * p2 = [[Person alloc]init];
    
    NSArray * arr = [[NSArray alloc]initWithObjects:p, p1, p2 , nil];
    NSArray * arr2 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:arr]] ;
    NSMutableArray * arr3 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:arr]] ;
    NSLog(@" %@,%@,%@",arr,arr2,arr3);
    //NSArray 0x6040002562f0,0x6040004224e0,0x6040004225a0,0x6040000325c0,
    //NSArray 0x604000256650,0x604000421d40,0x604000422640,0x604000421fa0,
    //NSArray 0x604000051460,0x6040004227e0,0x604000422360,0x604000421ca0
}
- (void)setCopyMutableCopyTest3
{
    NSLog(@"setCopyMutableCopyTest1");
    Person * p = [[Person alloc]init];
    Person * p1 = [[Person alloc]init];
    Person * p2 = [[Person alloc]init];
    NSArray * array = [[NSArray alloc]initWithObjects:@[p, p1], p2 , nil];
    NSArray * arr2 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:array]] ;
    NSLog(@"%@,%@,%@,%@",array,arr2,array[0],arr2[0]);
//    NSArray 0x60000022b060,0x60000022b140,0x60000022b120,
//    NSArray 0x60000022b240,0x60000022b040,0x60000022b2c0,
//    NSArray 0x60000022b140,0x60000022b160,0x60000022b080,
//    NSArray 0x60000022b040,0x604000225800,0x60000022b320

}
- (void)setCopyMutableCopyTest4
{
    NSLog(@"setCopyMutableCopyTest1");
    Person * p = [[Person alloc]init];
    Person * p1 = [[Person alloc]init];
    Person * p2 = [[Person alloc]init];
    NSArray * array = [[NSArray alloc]initWithObjects:@[p, p1], p2 , nil];
    NSArray * arr2 = [[NSArray alloc]initWithArray:array copyItems:YES];
    NSLog(@"%@,%@,%@,%@",array,arr2,array[0],arr2[0]);
//    NSArray 0x60000022b320,0x60000022b120,0x6000000300c0,
//    NSArray 0x60000022b2c0,0x60000022b120,0x60000022b080,
//    NSArray 0x60000022b120,0x6000000325c0,0x60000022af00,
//    NSArray 0x60000022b120,0x6000000325c0,0x60000022af00

    
    NSMutableArray * arr1 = [[NSMutableArray alloc]initWithObjects:p, p1, nil];
    NSArray * array1 = [[NSArray alloc]initWithObjects:arr1, p2 , nil];
    NSMutableArray * arr3 = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
    NSLog(@"%@,%@,%@,%@",array1,arr3,array1[0],arr3[0]);
//    NSArray 0x60000022b2a0,0x6000002553f0,0x6000000300c0,
//    NSArray 0x600000255570,0x60000022b120,0x60000022b160,
//    NSArray 0x6000002553f0,0x6000000325c0,0x60000022af00,
//    NSArray 0x60000022b120,0x6000000325c0,0x60000022af00

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end



