//
//  ZYWaterFlowViewCell.h
//  瀑布流
//
//  Created by 王志盼 on 15/7/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYWaterFlowViewCell : UIView
@property (nonatomic, copy) NSString *identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier;
@end
