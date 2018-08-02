//
//  SharedItem.m
//  xingjiang
//
//  Created by 吴德明 on 16/7/14.
//  Copyright © 2016年 吴德明. All rights reserved.
//

#import "SharedItem.h"

@implementation SharedItem

-(instancetype)initWithData:(UIImage *)img andFile:(NSURL *)file
{
    self = [super init];
    if (self) {
        _img = img;
        _path = file;
    }
    return self;
}

#pragma mark - UIActivityItemSource
-(id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return _img;
}

-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return _path;
}

@end
