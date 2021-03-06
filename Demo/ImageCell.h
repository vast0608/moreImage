//
//  TestCell.h
//  XLImageViewerDemo
//
//  Created by Apple on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSelectDelegate <NSObject>

-(void)imageSelectTag:(NSInteger)tag;

@end

@interface ImageCell : UICollectionViewCell

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,assign)NSInteger cellTag;

@property (nonatomic,strong)UIButton *selectButton;

@property(assign,nonatomic) id<ImageSelectDelegate> delegate;

@end
