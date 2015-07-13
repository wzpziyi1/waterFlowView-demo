//
//  ZYWaterFlowView.h
//  瀑布流
//
//  Created by 王志盼 on 15/7/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZYWaterFlowViewMarginTypeTop,
    ZYWaterFlowViewMarginTypeLeft,
    ZYWaterFlowViewMarginTypeBottom,
    ZYWaterFlowViewMarginTypeRight,
    ZYWaterFlowViewMarginTypeRow,
    ZYWaterFlowViewMarginTypeColumn
    
}ZYWaterFlowViewMarginType;

@class ZYWaterFlowView, ZYWaterFlowViewCell;

@protocol ZYWaterFlowViewDataSource <NSObject>

@required
//返回cell的数目
- (NSInteger)numberOfCellsInWaterFlowView:(ZYWaterFlowView *)waterFlowView;
//返回index位置对应的cell
- (ZYWaterFlowViewCell *)waterFlowView:(ZYWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index;

@optional
//一共多少列
- (NSInteger)numberOfColumnsInWaterFlowView:(ZYWaterFlowView *)waterFlowView;
@end


@protocol ZYWaterFlowViewDelegate <UIScrollViewDelegate>

@optional
//返回index的cell的高度
- (CGFloat)waterFlowView:(ZYWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index;

//各种间距
- (CGFloat)waterFlowView:(ZYWaterFlowView *)waterFlowView marginForType:(ZYWaterFlowViewMarginType)type;

//返回被选中的（孩子~~）cell
- (ZYWaterFlowViewCell*)waterFlowView:(ZYWaterFlowView *)waterFlowView didSelectedAtIndex:(NSUInteger)index;

@end

@interface ZYWaterFlowView : UIScrollView
//数据源
@property (nonatomic, weak) id<ZYWaterFlowViewDataSource> dataSource;
//代理
@property (nonatomic, weak) id<ZYWaterFlowViewDelegate> delegate;

//刷新数据
- (void)reloadData;

//需要根据标示符去缓存池找到对应的cell
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
