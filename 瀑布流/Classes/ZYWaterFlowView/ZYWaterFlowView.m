//
//  ZYWaterFlowView.m
//  瀑布流
//
//  Created by 王志盼 on 15/7/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYWaterFlowView.h"
#import "ZYWaterFlowViewCell.h"
#define ZYWaterFlowViewDefaultNumberOfColumns 3
#define ZYWaterFlowViewDefaultCellH 65
#define ZYWaterFlowViewDefaultMargin 10

@interface ZYWaterFlowView ()
//存放所有cell的frame
@property (nonatomic, strong)NSMutableArray *cellFrames;
//存放在scrollView的cell，之所以用字典，因为可以用key来存取，方便添加和移除
//当，发现当前key值得cell在字典里面（也就是还在scrollView上，也许正在屏幕上，也许没有在屏幕上，但在scrollView上），直接从字典中取出即可，如果字典中不存在
//则去缓存池里取，如果缓存池没有，那么创建cell
@property (nonatomic, strong)NSMutableDictionary *displayingCells;

//“缓存池”，存放离开屏幕的cell
@property (nonatomic, strong)NSMutableSet *reusableCells;
@end

@implementation ZYWaterFlowView

- (NSMutableArray *)cellFrames
{
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells
{
    if (_displayingCells == nil) {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

- (NSMutableSet *)reusableCells
{
    if (_reusableCells == nil) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

//刷新数据
- (void)reloadData
{
    int numberOfCells = (int)[self.dataSource numberOfCellsInWaterFlowView:self];
    
    int numberOfColumns = (int)[self numberOfColumns];
    
    CGFloat marginOfTop = [self marginForType:ZYWaterFlowViewMarginTypeTop];
    CGFloat marginOfLeft = [self marginForType:ZYWaterFlowViewMarginTypeLeft];
    CGFloat marginOfBottom = [self marginForType:ZYWaterFlowViewMarginTypeBottom];
    CGFloat marginOfRight = [self marginForType:ZYWaterFlowViewMarginTypeRight];
    CGFloat marginOfRow = [self marginForType:ZYWaterFlowViewMarginTypeRow];
    CGFloat marginOfColumn = [self marginForType:ZYWaterFlowViewMarginTypeColumn];
    
    //这里，使用一个c语言数组，来装载每一列的最大高度
    //为什么不是oc数组？因为oc数组要装对象，还不能预先开好位置
    CGFloat maxYOfColumns[numberOfColumns];
    for (int i = 0; i < numberOfColumns; i++) {
        maxYOfColumns[i] = 0.0;
    }
    
    CGFloat cellW = (self.frame.size.width - (numberOfColumns - 1) * marginOfColumn - marginOfLeft - marginOfRight) / numberOfColumns;
    
    for (int i = 0; i < numberOfCells; i++) {
        //最小的y所在列
        int minYAtCol = 0;
        //所有列中最小的y
        CGFloat minY = maxYOfColumns[minYAtCol];
        
        for (int j = 1; j < numberOfColumns; j++) {
            if (minY > maxYOfColumns[j]) {
                minY = maxYOfColumns[j];
                minYAtCol = j;
            }
        }
        CGFloat cellH = [self cellHeightAtIndex:i];
        
        CGFloat cellX = marginOfLeft + minYAtCol * (cellW + marginOfColumn);
        
        CGFloat cellY = 0;
        
        if (minY == 0.0) {
            cellY = marginOfTop;
        }else
        {
            cellY = minY + marginOfRow;
        }
        
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        //更新这一行的y
        maxYOfColumns[minYAtCol] = CGRectGetMaxY(cellFrame);
    }
    
    //设置scrollView的滚动范围
    CGFloat maxY = maxYOfColumns[0];
    for (int i = 1; i < numberOfColumns; i++) {
        if (maxY < maxYOfColumns[i]) {
            maxY = maxYOfColumns[i];
        }
    }
    maxY += marginOfBottom;
    self.contentSize = CGSizeMake(0, maxY);
}

//当scrollView滚动，除了会调用它的代理方法之外，还会时时调用这个方法
//所以，在这个方法里面拿到当前显示在屏幕的cell，设置尺寸~~
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int numberOfCells = (int)[self.dataSource numberOfCellsInWaterFlowView:self];
    
    for (int i = 0; i < numberOfCells; i++) {
        //先在scrollView上存在的cell里看当前cell是否存在scrollView上
        ZYWaterFlowViewCell *cell = self.displayingCells[@(i)];
        CGRect cellF = [self.cellFrames[i] CGRectValue];
        
        if ([self isInScreen:cellF]) { //判断当前cell是否有在屏幕展示（注意，这里与在scrollView上展示不同）
            if (cell == nil) {  //需要在屏幕展示，所以cell不存在的时候需要创建
                cell = [self.dataSource waterFlowView:self cellAtIndex:i];
                cell.frame = cellF;
                [self addSubview:cell];
                self.displayingCells[@(i)] = cell;  //添加到了scrollView上，所以将它加入数组
            }
        }else
        {
            if (cell) { //没在屏幕上，所以不需要cell，把它放入缓存池
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                
                //放入缓存池
                [self.reusableCells addObject:cell];
            }
        }
        
    }
}

//需要根据标示符去缓存池找到对应的cell
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block ZYWaterFlowViewCell *cell;
    [self.reusableCells enumerateObjectsUsingBlock:^(ZYWaterFlowViewCell *obj, BOOL *stop) {
        if ([obj.identifier isEqualToString:identifier]) {
            cell = obj;
            *stop = YES;
        }
    }];
    
    if (cell) {  //被用了，就从缓存池中移除
        [self.reusableCells removeObject:cell];
    }
    return cell;
}

#pragma Private方法

//判断是否在屏幕上，只需要，最大的y大于contentOffset.y，最小的y小于contentOffset.y + self高度
- (BOOL)isInScreen:(CGRect)rect
{
    return (CGRectGetMaxY(rect) > self.contentOffset.y) && (CGRectGetMinY(rect) < self.contentOffset.y + self.frame.size.height);
}

- (CGFloat)cellHeightAtIndex:(int)index
{
    if ([self.delegate respondsToSelector:@selector(waterFlowView:heightAtIndex:)]) {
        return [self.delegate waterFlowView:self heightAtIndex:index];
    }
    
    return ZYWaterFlowViewDefaultCellH;
}

- (int)numberOfColumns
{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterFlowView:)]) {
        return (int)[self.dataSource numberOfColumnsInWaterFlowView:self];
    }
    
    return ZYWaterFlowViewDefaultNumberOfColumns;
}

- (CGFloat)marginForType:(ZYWaterFlowViewMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterFlowView:marginForType:)]) {
        return [self.delegate waterFlowView:self marginForType:type];
    }
    
    return ZYWaterFlowViewDefaultMargin;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //如果没有实现此代理，直接返回
    if (![self.delegate respondsToSelector:@selector(waterFlowView:didSelectedAtIndex:)]) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    __block NSNumber *index = nil;
    //判断触摸点在哪个cell上，没必要遍历所有的cell，只需要遍历，当前展示在scrollView的cell（屏幕更好）
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id key, ZYWaterFlowViewCell *obj, BOOL *stop) {
        if (CGRectContainsPoint(obj.frame, currentPoint)) {
            index = key;
            *stop = YES;
        }
    }];
    if (index) {
        [self.delegate waterFlowView:self didSelectedAtIndex:index.unsignedIntegerValue];
    }
}

//当view将要移到superView时，刷新数据，避免手动刷新
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}
@end
