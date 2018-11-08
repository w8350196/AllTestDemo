//
//  ViewController.m
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/9/25.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import "ViewController.h"
#import "YDApplicationModel.h"
#import "YDAppCollectionViewCell.h"
#import "YDCollectionViewFlowLayout.h"
#import "YDApplicationHeaderReusableView.h"
#import "YDSortTool.h"
#import "YDApplicationRouter.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define KWidth  [[UIScreen mainScreen] bounds].size.width


static NSInteger ApplicationColumnNum = 4;
static CGFloat ApplicationCellHeight= 80;
static CGFloat ApplicationSectionHeight = 10;
static CGFloat HeaderHeignt = 20;

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * myApplicationArray;
@property (nonatomic,strong) NSMutableArray * moneyApplicationArray;
@property (nonatomic,strong) NSMutableArray * otherApplicationArray;
@property (nonatomic,strong) NSMutableArray * myApplicationTitleArray;

@property (nonatomic,strong) NSArray * nonEditArray;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) NSIndexPath *originalIndexPath;
@property (nonatomic, strong) NSIndexPath *moveIndexPath;
@property (nonatomic, weak) UIView *tempMoveCell;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) UIButton * rightButton;

@end

@implementation ViewController

- (void)viewDidLoad {
 
    [super viewDidLoad];
    
    [self setupUI];
    [self navigationButtonCommonInit];
    

}

#pragma mark - CommonInit
// 设置UI界面
- (void)setupUI{
    
    self.isEditing = NO;

    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMoving:)];
    _longPress.minimumPressDuration = 1.0;
    [self.collectionView addGestureRecognizer:_longPress];

}
- (void)navigationButtonCommonInit
{
    
    //rightButtonItem
    self.rightButton = [[UIButton alloc] init];
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}
#pragma mark -  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        YDApplicationHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([YDApplicationHeaderReusableView class]) forIndexPath:indexPath];
        if (indexPath.section ==0) {
            header.label.text =@"常用应用";
        }else if(indexPath.section == 1){
            header.label.text =@"资金往来";
        }
        else if(indexPath.section == 2){
            header.label.text =@"其他应用";
        }
        
        return header;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YDAppCollectionViewCell *cell = (YDAppCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YDAppCollectionViewCell class]) forIndexPath:indexPath];
    
    NSArray * array = self.dataArray[indexPath.section];
    YDApplicationModel *model = array[indexPath.row];
    [cell updateUIWithApplicationModel:model];
    YDAppCollectionViewCellEditButtonState state = [self getEditButtonStateWithTitle:model.title];
    [cell setEditState:state];

    cell.buttonClickBlock =^(){
      
        switch (state) {
            case YDAppCollectionViewCellEditButtonStateRemove:
            {
                [self.myApplicationArray enumerateObjectsUsingBlock:^(YDApplicationModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.title isEqualToString:model.title])
                    {
                        [self.myApplicationArray removeObject:obj];
                        [self.myApplicationTitleArray removeObject:obj.title];
                        *stop = YES;
                        [collectionView reloadData];
                    }
                }];
            }
            break;
            case YDAppCollectionViewCellEditButtonStateAdd:
            {
                YDApplicationModel * applicatonModel = [model copy];
                applicatonModel.type = YDApplicationTypeCommen;
                [self.myApplicationArray addObject:model];
                [self.myApplicationTitleArray addObject:model.title];
                [collectionView reloadData];
            }
            break;
            case YDAppCollectionViewCellEditButtonStateNonRemove:
            case YDAppCollectionViewCellEditButtonStateNone:
            {
                
            }
            break;
        }
    };
    return cell;
}
- (YDAppCollectionViewCellEditButtonState )getEditButtonStateWithTitle:(NSString *)title;
{
    YDAppCollectionViewCellEditButtonState state = YDAppCollectionViewCellEditButtonStateNone;
    if(self.isEditing)
    {
        if([self.myApplicationTitleArray containsObject:title])
        {
            //删除
            if(![self.nonEditArray containsObject:title])
            {
                state = YDAppCollectionViewCellEditButtonStateRemove;
            }
            else
            {
                //静止删除.
                state = YDAppCollectionViewCellEditButtonStateNonRemove;
            }
        }
        else
        {
            //添加
            state = YDAppCollectionViewCellEditButtonStateAdd;
        }
    }
    return state;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isEditing)
    {
        return;
    }
    NSArray * array = self.dataArray[indexPath.section];
    YDApplicationModel *model = array[indexPath.row];
    [[YDApplicationRouter sharedApplicationRouter] didClickApplicaton:model];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width/ApplicationColumnNum;
    CGFloat height = ApplicationCellHeight;
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
{
    return CGSizeMake(KWidth, ApplicationSectionHeight);
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}
#pragma mark - event
// 长按应用进入编辑状态，可以进行移动删除操作
- (void)longPressMoving:(UILongPressGestureRecognizer *)longPress {
    if (!self.isEditing) {
        //非编辑状态不允许拖拽.
        return;
    }
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.originalIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            NSLog(@"UIGestureRecognizerStateBegan : %ld,%ld",self.originalIndexPath.section,self.originalIndexPath.row);

            if (self.originalIndexPath.section == 0) {
                
                
                //获取到手指所在cell
                YDAppCollectionViewCell *cell = (YDAppCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.originalIndexPath];
                UIImage *image = [self captureImageFromViewLow:cell];
                UIImageView * captureImageView = [[UIImageView alloc] initWithImage:image];
                captureImageView.backgroundColor = [UIColor redColor];
                self.tempMoveCell = captureImageView;
                CGRect frame = [self.view convertRect:cell.frame fromView:self.collectionView];
                self.tempMoveCell.frame = frame;
                cell.hidden = YES;
                [self.view addSubview:self.tempMoveCell];
                self.lastPoint = [longPress locationOfTouch:0 inView:longPress.view];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            NSLog(@"UIGestureRecognizerStateChanged : %ld,%ld",indexPath.section,indexPath.row);
            CGFloat tranX = [longPress locationOfTouch:0 inView:longPress.view].x - self.lastPoint.x;
            CGFloat tranY = [longPress locationOfTouch:0 inView:longPress.view].y - self.lastPoint.y;
            self.tempMoveCell.center = CGPointApplyAffineTransform(self.tempMoveCell.center, CGAffineTransformMakeTranslation(tranX, tranY));
            self.lastPoint = [longPress locationOfTouch:0 inView:longPress.view];
            
            if (indexPath.section == 0) {
                //只有首排才重新排
                [self moveCell];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            
                YDAppCollectionViewCell *cell = (YDAppCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.originalIndexPath];
                self.collectionView.userInteractionEnabled = NO;
                cell.hidden = NO;
                cell.alpha = 0.0;
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.tempMoveCell.center = cell.center;
                    self.tempMoveCell.alpha = 0.0;
                    cell.alpha = 1.0;
                    
                } completion:^(BOOL finished) {
                    [self.tempMoveCell removeFromSuperview];
                    self.originalIndexPath = nil;
                    self.tempMoveCell = nil;
                    self.collectionView.userInteractionEnabled = YES;
                    
                }];
        }
            break;
        default:
            break;
    }
}
- (void)moveCell{
    for (YDAppCollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        if (indexPath == self.originalIndexPath || indexPath.section != 0) {
            continue;
        }
        NSLog(@"moveCell : %ld,%ld",indexPath.section,indexPath.row);
        //计算中心距
        
        CGRect frame = [self.view convertRect:self.tempMoveCell.frame toView:self.collectionView];
        CGFloat centerX = (CGRectGetMinX(frame)+ CGRectGetMaxX(frame))/2.0;
        CGFloat centerY = (CGRectGetMinY(frame) + CGRectGetMaxY(frame))/2.0;
        CGFloat spacingX = fabs(centerX - cell.center.x);
        CGFloat spacingY = fabs(centerY - cell.center.y);
        if (spacingX <= frame.size.width / 2.0f && spacingY <= frame.size.height / 2.0f) {
            self.moveIndexPath = [self.collectionView indexPathForCell:cell];
            if (self.moveIndexPath.row <  self.myApplicationArray.count) { //超出cell范围时移动会崩溃
                //更新数据源
                [self reArrangApplication];
                //移动
                [self.collectionView moveItemAtIndexPath:self.originalIndexPath toIndexPath:self.moveIndexPath];
                //设置移动后的起始indexPath
                self.originalIndexPath = self.moveIndexPath;
            }
            
            break;
        }
    }
    
}

-(UIImage *)captureImageFromViewLow:(UIView *)orgView {
    //获取指定View的图片
    UIGraphicsBeginImageContextWithOptions(orgView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [orgView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//更新数据源
- (void)reArrangApplication{
    NSMutableArray *tempApplicationArray = [[NSMutableArray alloc] init];
    [tempApplicationArray addObjectsFromArray:self.myApplicationArray];
    if (self.moveIndexPath.item > self.originalIndexPath.item) {
        for (NSUInteger i = self.originalIndexPath.item; i < self.moveIndexPath.item ; i ++) {
            [tempApplicationArray exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
        }
    }else{
        for (NSUInteger i = self.originalIndexPath.item; i > self.moveIndexPath.item ; i --) {
            [tempApplicationArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
        }
    }
    self.myApplicationArray = tempApplicationArray.mutableCopy;
    self.myApplicationTitleArray = nil;
    //重新再获取吧.
    self.dataArray = nil;
    
}

- (void)editAction:(UIButton *)rightButton
{
    self.isEditing = !self.isEditing;
    //默认selected为NO.
    if(self.isEditing)
    {
        //编辑.
        [rightButton setTitle:@"完成" forState:UIControlStateNormal];
        //leftButtonItem
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        
        self.myApplicationArray = nil;
        self.dataArray = nil;
        self.myApplicationTitleArray = nil;
    }
    else
    {
        //保存.
        [[YDSortTool sharedSortTool] addApplicationModelArray:self.myApplicationArray  ApplicationType:YDApplicationTypeCommen];
        [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = nil;
        self.myApplicationArray = nil;
        self.myApplicationTitleArray = nil;
        self.dataArray = nil;
    }
    [self.collectionView reloadData];
}
- (void)cancelAction
{
    NSLog(@"点了取消恢复原样");
    self.isEditing = NO;
    self.myApplicationArray = nil;
    self.dataArray = nil;
    self.myApplicationTitleArray = nil;
    self.navigationItem.leftBarButtonItem = nil;
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.collectionView reloadData];
}
#pragma mark - lazyInit
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        // 设置布局信息
        YDCollectionViewFlowLayout *flowLayout = [[YDCollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.headerReferenceSize =CGSizeMake(KWidth, HeaderHeignt);
        flowLayout.footerReferenceSize =CGSizeMake(0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.userInteractionEnabled = YES;
        // 注册cell
        [_collectionView registerClass:[YDAppCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YDAppCollectionViewCell class])];
        [_collectionView registerClass:[YDApplicationHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([YDApplicationHeaderReusableView class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] initWithObjects:self.myApplicationArray,self.moneyApplicationArray,self.otherApplicationArray,
        nil];
    }
    return _dataArray;
}

- (NSMutableArray *)myApplicationArray
{
    if(!_myApplicationArray)
    {
        NSArray * array =  [[YDSortTool sharedSortTool] getApplicationWithType:YDApplicationTypeCommen];
        if(array.count > 0)
        {
            _myApplicationArray = [[NSMutableArray alloc] initWithArray:array];
        }
        else
        {
            _myApplicationArray = [[NSMutableArray alloc] initWithObjects:
                                   [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"转账" type:YDApplicationTypeCommen],
                                   [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"生活缴费" type:YDApplicationTypeCommen],
                                   [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"淘票票电影" type:YDApplicationTypeCommen],
                                   [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"充值中心" type:YDApplicationTypeCommen],
                                   [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"我的快递" type:YDApplicationTypeCommen],
                                   [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"余额宝" type:YDApplicationTypeCommen],
                                   [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"芝麻信用" type:YDApplicationTypeCommen],
                                   nil];
        }
    }
    return _myApplicationArray;
}
- (NSMutableArray *)otherApplicationArray
{
    if (!_otherApplicationArray){
        
        NSArray * array =  [[YDSortTool sharedSortTool] getApplicationWithType:YDApplicationTypeOther];
        if(array.count > 0)
        {
            _otherApplicationArray = [[NSMutableArray alloc] initWithArray:array];
        }
        else
        {
            _otherApplicationArray = [[NSMutableArray alloc] initWithObjects:
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"生活缴费" type:YDApplicationTypeOther],
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"淘票票电影" type:YDApplicationTypeOther],
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"充值中心" type:YDApplicationTypeOther],
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"我的快递" type:YDApplicationTypeOther],
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon"        title:@"商家服务" type:YDApplicationTypeOther],
                                      nil];
        }
        
    }
    return _otherApplicationArray;
}
- (NSMutableArray *)moneyApplicationArray
{
    if (!_moneyApplicationArray){
      
        NSArray * array =  [[YDSortTool sharedSortTool] getApplicationWithType:YDApplicationTypeMoney];
        if(array.count > 0)
        {
            _moneyApplicationArray = [[NSMutableArray alloc] initWithArray:array];
        }
        else
        {
            _moneyApplicationArray = [[NSMutableArray alloc] initWithObjects:
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"转账" type:YDApplicationTypeMoney],
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"红包" type:YDApplicationTypeMoney],
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"AA收款" type:YDApplicationTypeMoney],
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"余额宝" type:YDApplicationTypeMoney],
                                      [YDApplicationModel ApplicationModelWithImageName:@"home_masssms_icon" title:@"商家服务" type:YDApplicationTypeOther],
                                      nil];
        }
    }
    return _moneyApplicationArray;
}
- (NSMutableArray *)myApplicationTitleArray
{
    if(!_myApplicationTitleArray)
    {
        _myApplicationTitleArray =[[NSMutableArray alloc] initWithArray:[self.myApplicationArray valueForKey:@"title"]];
    }
    return _myApplicationTitleArray;
}
- (NSArray *)nonEditArray
{
    if(!_nonEditArray)
    {
        _nonEditArray = @[@"余额宝",@"转账",@"充值中心",@"生活缴费"];
    }
    return _nonEditArray;
}
@end
