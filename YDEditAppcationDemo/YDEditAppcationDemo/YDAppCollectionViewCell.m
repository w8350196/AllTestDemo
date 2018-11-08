//
//  YDAppCollectionViewCell.m
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/9/25.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import "YDAppCollectionViewCell.h"
#import "YDApplicationModel.h"

@interface YDAppCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@end

@implementation YDAppCollectionViewCell


// 通过注册cell的方式加载，调用此方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self =  [super initWithFrame:frame];
    if (self) {
        
       
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
//        self.backgroundColor = [UIColor lightGrayColor];
        [self bringSubviewToFront:self.editButton]; 
        return self;
    }
    
    return self;
}

- (IBAction)buttonDidClicked:(id)sender
{
    if(self.buttonClickBlock)
    {
        self.buttonClickBlock();
    }
}
- (void)updateUIWithApplicationModel:(YDApplicationModel *)model;
{
    self.imageView.image = [UIImage imageNamed:model.imageName] ;
    self.titlelabel.text = model.title;
    [self setEditState:YDAppCollectionViewCellEditButtonStateNone];
}
//没有图标,将就吧.
- (void)setEditState:(YDAppCollectionViewCellEditButtonState)state
{
    self.editButton.hidden = NO;
    self.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:246.0/255.0 blue:248.0/255.0 alpha:1];
    switch (state) {
        case YDAppCollectionViewCellEditButtonStateNone:
            self.editButton.hidden = YES;
            self.backgroundColor = [UIColor whiteColor];
            break;
        case YDAppCollectionViewCellEditButtonStateAdd:
            [self.editButton setImage:[UIImage imageNamed:@"tooledit_add_icon"] forState:UIControlStateNormal];
            break;
        case YDAppCollectionViewCellEditButtonStateRemove:
            [self.editButton setImage:[UIImage imageNamed:@"tooledit_delete_icon"] forState:UIControlStateNormal];
            break;
        case YDAppCollectionViewCellEditButtonStateNonRemove:
            [self.editButton setImage:[UIImage imageNamed:@"tooledit_deletegary_icon"] forState:UIControlStateNormal];
            break;
    }
    
}
@end
