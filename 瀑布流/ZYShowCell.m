//
//  ZYShowCell.m
//  瀑布流
//
//  Created by 王志盼 on 15/7/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYShowCell.h"
#import "ZYWaterFlowView.h"
#import "ZYShowModel.h"
#import "UIImageView+WebCache.h"
#define Identifier @"showCellIdentifier"

@interface ZYShowCell ()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *priceLabel;
@end

@implementation ZYShowCell

+ (id)cellWithWaterflowView:(ZYWaterFlowView *)waterFlowView
{
    ZYShowCell *cell = [waterFlowView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[self alloc] init];
        cell.identifier = Identifier;
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];//设置背景透明色
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor whiteColor];
        [self addSubview:priceLabel];
        self.priceLabel = priceLabel;
    }
    return self;
}
- (void)setShowModel:(ZYShowModel *)showModel
{
    _showModel = showModel;
    self.priceLabel.text = showModel.price;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:showModel.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CGFloat priceX = 0;
    CGFloat priceH = 25;
    CGFloat priceY = self.bounds.size.height - priceH;
    CGFloat priceW = self.bounds.size.width;
    self.priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
}
@end
