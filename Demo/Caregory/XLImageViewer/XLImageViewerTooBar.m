//
//  XLImageViewerTooBar.m
//  XLImageViewerDemo
//
//  Created by MengXianLiang on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XLImageViewerTooBar.h"

@implementation XLImageViewerTooBar{
    
    UILabel *_pageLabel;
    
    UIButton *_saveButton;
    
    UIButton *_selectButton;
    
    VoidBlock _saveBlock;
    
    ImageBlock _selectBlock;
    
    NSMutableArray *_imageMuArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self buildUI];
    }
    return self;
}

-(void)buildUI{
    //显示分页的label
    CGFloat viewWidth = 50.0f;
    CGFloat viewHeignt = 28.0f;
    CGFloat viewMargin = 5.0f;
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - viewWidth)/2, (self.bounds.size.height - viewHeignt)/2, viewWidth, viewHeignt)];
    //_pageLabel.center = CGPointMake(_pageLabel.center.x, viewHeignt/2.0f);
//    _pageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//    _pageLabel.layer.cornerRadius = 5.0f;
//    _pageLabel.layer.masksToBounds = true;
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont systemFontOfSize:16];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pageLabel];
    
    //保存按钮
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(viewMargin, (self.bounds.size.height - viewHeignt)/2, viewWidth, viewHeignt);
    //_saveButton.center = CGPointMake(_saveButton.center.x, viewHeignt/2.0f);
//    _saveButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//    _saveButton.layer.cornerRadius = 5.0f;
//    _saveButton.layer.masksToBounds = true;
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveImageMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveButton];

    //保存按钮
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(self.bounds.size.width - viewWidth - viewMargin, (self.bounds.size.height - viewHeignt)/2, viewWidth, viewHeignt);
    //_selectButton.center = CGPointMake(_selectButton.center.x, viewHeignt/2.0f);
//    _selectButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//    _selectButton.layer.cornerRadius = 5.0f;
//    _selectButton.layer.masksToBounds = true;
    _selectButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_selectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_selectButton setImage:[UIImage imageNamed:@"unSelected"] forState:UIControlStateNormal];
    [_selectButton addTarget:self action:@selector(selectImageMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectButton];

    self.alpha = 0;
}


-(void)saveImageMethod{
    _saveBlock();
}

-(void)selectImageMethod:(UIButton *)button{
    button.selected = !button.selected;
    NSArray *strArr = [_pageLabel.text componentsSeparatedByString:@"/"];
    if (button.selected) {
        [_imageMuArr addObject:[NSString stringWithFormat:@"%ld",[strArr[0] integerValue]-1]];
    }else{
        [_imageMuArr removeObject:[NSString stringWithFormat:@"%ld",[strArr[0] integerValue]-1]];
    }
    _selectBlock(_imageMuArr);
}

-(void)addSaveBlock:(VoidBlock)saveBlock{
    _saveBlock = saveBlock;
}

-(void)addSelectBlock:(ImageBlock)selectBlock{
    _selectBlock = selectBlock;
}

-(void)setText:(NSString *)text{
    _pageLabel.text = text;

    _selectButton.selected = NO;
    NSArray *strArr = [_pageLabel.text componentsSeparatedByString:@"/"]; //从字符/中分隔成2个元素的数组
    for (int i=0; i<_imageMuArr.count; i++) {
        if ([_imageMuArr[i] integerValue]==[strArr[0] integerValue]-1) {
            _selectButton.selected = YES;
        }
    }
}

-(void)setCurrentSelectImageArr:(NSArray *)currentSelectImageArr{
    _imageMuArr = [NSMutableArray arrayWithArray:currentSelectImageArr];
}

-(void)show{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1;
    }];
}

-(void)hide{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
    }];
}

@end
