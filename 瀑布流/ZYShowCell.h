//
//  ZYShowCell.h
//  瀑布流
//
//  Created by 王志盼 on 15/7/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYWaterFlowViewCell.h"
@class ZYShowModel,ZYWaterFlowView;
@interface ZYShowCell : ZYWaterFlowViewCell
@property (nonatomic, strong) ZYShowModel *showModel;

+ (id)cellWithWaterflowView:(ZYWaterFlowView *)waterFlowView;
@end
