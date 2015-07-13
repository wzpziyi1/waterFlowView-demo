//
//  ZYShowViewController.m
//  瀑布流
//
//  Created by 王志盼 on 15/7/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYShowViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "ZYShowCell.h"
#import "ZYShowModel.h"
#import "ZYWaterFlowView.h"

@interface ZYShowViewController () <ZYWaterFlowViewDataSource, ZYWaterFlowViewDelegate>
@property (nonatomic, strong)NSMutableArray *showModels;
@property (nonatomic, weak) ZYWaterFlowView *waterFlowView;
@end

@implementation ZYShowViewController

- (NSMutableArray *)showModels
{
    if (_showModels == nil) {
        NSArray *array = [ZYShowModel objectArrayWithFilename:@"2.plist"];
        _showModels = [NSMutableArray arrayWithArray:array];
    }
    return _showModels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor yellowColor]];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    ZYWaterFlowView *waterFlowView = [[ZYWaterFlowView alloc] initWithFrame:self.view.frame];
    waterFlowView.dataSource = self;
    waterFlowView.delegate = self;
    [self.view addSubview:waterFlowView];
    self.waterFlowView = waterFlowView;
    [waterFlowView setBackgroundColor:[UIColor yellowColor]];
    [self addConstraint];
    
    //集成下拉刷新控件
    waterFlowView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshForPullDown)];
    //集成上拉刷新控件
    waterFlowView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshForPullUp)];
}

- (void)refreshForPullDown
{
    NSArray *array = [ZYShowModel objectArrayWithFilename:@"1.plist"];
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, array.count)];
    [self.showModels insertObjects:array atIndexes:set];
    [self.waterFlowView reloadData];
    self.waterFlowView.header.hidden = YES;
}

- (void)refreshForPullUp
{
    NSArray *array = [ZYShowModel objectArrayWithFilename:@"3.plist"];
    [self.showModels addObjectsFromArray:array];
    [self.waterFlowView reloadData];
    self.waterFlowView.footer.hidden = YES;
}
- (void)addConstraint
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.waterFlowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.waterFlowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.waterFlowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.waterFlowView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:constraint];
}

//数据源方法
- (NSInteger)numberOfCellsInWaterFlowView:(ZYWaterFlowView *)waterFlowView
{
    return self.showModels.count;
}

- (ZYWaterFlowViewCell *)waterFlowView:(ZYWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index
{
    ZYShowCell *cell = [ZYShowCell cellWithWaterflowView:waterFlowView];
    cell.showModel = self.showModels[index];
    return cell;
}

- (NSInteger)numberOfColumnsInWaterFlowView:(ZYWaterFlowView *)waterFlowView
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        // 竖屏
        return 3;
    } else {
        return 5;
    }
}

//代理方法
- (CGFloat)waterFlowView:(ZYWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index
{
    ZYShowModel *showModel = self.showModels[index];
    
    return waterFlowView.cellWidth / showModel.w * showModel.h;
}
@end
