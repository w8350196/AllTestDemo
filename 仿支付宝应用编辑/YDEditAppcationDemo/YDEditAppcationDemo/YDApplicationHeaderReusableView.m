//
//  YDApplicationHeaderReusableView.m
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/9/25.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import "YDApplicationHeaderReusableView.h"

@implementation YDApplicationHeaderReusableView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1];

        if(![self.subviews containsObject:self.label])
        {
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, frame.size.width, frame.size.height)];
            self.label.textColor = [UIColor redColor];
            self.label.font = [UIFont systemFontOfSize:14.0f];
          [self addSubview:self.label];
        }
        
    }
    return self;
}


@end
