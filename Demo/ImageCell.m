//
//  TestCell.m
//  XLImageViewerDemo
//
//  Created by Apple on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ImageCell.h"
#import "UIImageView+WebCache.h"

@interface ImageCell ()
{
    UIImageView *_imageView;
}
@end

@implementation ImageCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = true;
    [self.contentView addSubview:_imageView];
    
    CGFloat width = self.bounds.size.width;
    _selectButton = [[UIButton alloc]initWithFrame:CGRectMake(width-width/3, 0, width/3, width/3)];
    //_selectButton.backgroundColor = [UIColor redColor];
    [_selectButton setImage:[UIImage imageNamed:@"unSelected"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectButton];
}

-(void)setCellTag:(NSInteger)cellTag{
    _selectButton.tag = cellTag;
}

-(void)setImageUrl:(NSString *)imageUrl
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
}

-(void)selectButtonClick:(UIButton *)button{
    button.selected = !button.selected;
    [self.delegate imageSelectTag:button.tag];
}
@end
