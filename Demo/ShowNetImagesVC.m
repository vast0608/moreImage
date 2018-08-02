//
//  ShowNetImagesDemoVC.m
//  XLImageViewerDemo
//
//  Created by Apple on 2017/2/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ShowNetImagesVC.h"
#import "XLImageViewer.h"
#import "ImageCell.h"
#import "SDImageCache.h"
#import "XLImageLoading.h"
#import "UIImageView+WebCache.h"
#import "SharedItem.h"
@interface ShowNetImagesVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,ImageSelectDelegate>
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_imageItems;
}
@property (nonatomic, strong) NSMutableDictionary *cellDicMuArr;//存储cell的ID标识符的
@property (nonatomic,strong)NSMutableArray *selectedImageMuarr;//存储所选的cell
@property (nonatomic,strong)UILabel *selectedCountLabel;//所选数量的label
@property (nonatomic,strong)NSMutableArray *imageMuarr;//存储image网络图片
@end

@implementation ShowNetImagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    self.cellDicMuArr = [[NSMutableDictionary alloc] init];
    self.selectedImageMuarr = [[NSMutableArray alloc] init];
    //构建界面
    [self buildUI];
    //底部栏
    [self bottomViewUI];
    //把URL转化成图片存储起来
    [self urlTiImagesWithCompletionHandler:^(BOOL isSuccess){}];
}

#pragma mark------初始化数据----
-(NSArray*)imageUrls
{
    return @[
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/1.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/2.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/3.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/4.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/5.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/6.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/7.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/8.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/9.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/10.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/11.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/12.png"];
}
//把URL转化成图片存储起来
-(void)urlTiImagesWithCompletionHandler:(void (^)(BOOL isSuccess))completionHandler{
    _imageMuarr = [NSMutableArray new];
    for (int i=0; i<[self imageUrls].count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [imageV sd_setImageWithURL:[NSURL URLWithString:[self imageUrls][i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.imageMuarr addObject:image];
            if (self.imageMuarr.count==[self imageUrls].count) {
                completionHandler(YES);
            }
            NSLog(@"-----%d---",i);
        }];
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            // 处理耗时操作的代码块...
//            NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:[self imageUrls][i]]];
//            UIImage *image =  [UIImage imageWithData:data];
//            [self.imageMuarr addObject:image];
//            if (self.imageMuarr.count==[self imageUrls].count) {
//                completionHandler(YES);
//            }
//            NSLog(@"-----%d---",i);
//        });
        
    }
}


#pragma mark-----构建界面---------
-(void)buildUI
{
    NSInteger ColumnNumber = 3;
    CGFloat imageMargin = 10.0f;
    CGFloat itemWidth = (self.view.bounds.size.width - (ColumnNumber + 1)*imageMargin)/ColumnNumber-0.001;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60) collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
}


#pragma mark----底部栏---------
-(void)bottomViewUI{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bottomView addSubview:lineView];
    
    //下载按钮
    UIButton *downlodButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, ([UIScreen mainScreen].bounds.size.width-120)/2, 40)];
    downlodButton.layer.cornerRadius = 5.0f;
    downlodButton.layer.masksToBounds = true;
    downlodButton.layer.borderWidth = 1;
    downlodButton.layer.borderColor = [UIColor blackColor].CGColor;
    [downlodButton setTitle:@"下载图片" forState:0];
    [downlodButton setTitleColor:[UIColor blackColor] forState:0];
    [downlodButton addTarget:self action:@selector(saveImages) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:downlodButton];
    //选择数量
    _selectedCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2, 10, 100, 40)];
    _selectedCountLabel.textAlignment = NSTextAlignmentCenter;
    _selectedCountLabel.textColor = [UIColor lightGrayColor];
    _selectedCountLabel.font = [UIFont systemFontOfSize:15];
    _selectedCountLabel.text = @"已选择0张";
    [bottomView addSubview:_selectedCountLabel];
    //转发按钮
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2+50), 10, ([UIScreen mainScreen].bounds.size.width-120)/2, 40)];
    shareButton.layer.cornerRadius = 5.0f;
    shareButton.layer.masksToBounds = true;
    shareButton.layer.borderWidth = 1;
    shareButton.layer.borderColor = [UIColor blackColor].CGColor;
    [shareButton setTitle:@"确认转发" forState:0];
    [shareButton setTitleColor:[UIColor blackColor] forState:0];
    [shareButton addTarget:self action:@selector(selectedArr) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:shareButton];
}



#pragma mark-----CollectionView代理--------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self imageUrls].count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDicMuArr objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"ImageCell", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDicMuArr setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [_collectionView registerClass:[ImageCell class]  forCellWithReuseIdentifier:identifier];
    }
    ImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.imageUrl = [self imageUrls][indexPath.row];
    cell.layer.borderWidth = 1.0f;
    cell.cellTag = indexPath.row;
    cell.delegate = self;
    cell.selectButton.selected = NO;
    for (int i=0; i<_selectedImageMuarr.count; i++) {
        if (indexPath.row==[_selectedImageMuarr[i] integerValue]) {
            cell.selectButton.selected = YES;
        }
    }
    return  cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLImageViewer *imageViews = [[XLImageViewer alloc]init];
    //利用XLImageViewer显示网络图片
    [imageViews showNetImages:[self imageUrls] index:indexPath.row fromImageContainer:[collectionView cellForItemAtIndexPath:indexPath] currentSelectImageArr:self.selectedImageMuarr];
    [imageViews selectFinishedBlock:^(NSArray *selectImageArr) {
        if (selectImageArr.count!=0) {
            self.selectedImageMuarr = [NSMutableArray arrayWithArray:selectImageArr];
            self.selectedCountLabel.text = [NSString stringWithFormat:@"已选择%lu张",(unsigned long)self.selectedImageMuarr.count];
            [self->_collectionView reloadData];
        }
    }];
}



#pragma mark------选中图片的操作------
//选中的图片
-(void)imageSelectTag:(NSInteger)tag{
    if ([self.selectedImageMuarr containsObject:[NSString stringWithFormat:@"%ld",(long)tag]] == NO){
        [self.selectedImageMuarr addObject:[NSString stringWithFormat:@"%ld",(long)tag]];
    }else if ([self.selectedImageMuarr containsObject:[NSString stringWithFormat:@"%ld",(long)tag]]){
        [self.selectedImageMuarr removeObject:[NSString stringWithFormat:@"%ld",(long)tag]];
    }
    _selectedCountLabel.text = [NSString stringWithFormat:@"已选择%lu张",(unsigned long)self.selectedImageMuarr.count];
    
    [_collectionView reloadData];
}

//把URL转化成图片存储起来
-(NSArray *)selectImages{
    NSLog(@"----------%@------%@---",_imageMuarr,self.selectedImageMuarr);
    
    NSMutableArray *muArr = [NSMutableArray new];
    for (int i=0; i<[self imageUrls].count; i++) {
        for (int j=0; j<self.selectedImageMuarr.count; j++) {
            if (i==[self.selectedImageMuarr[j] integerValue]) {
                [muArr addObject:_imageMuarr[i]];
            }
        }
    }
    return muArr;
}



#pragma mark-------转发图片--------
-(void)selectedArr{
    if (_imageMuarr.count<[self imageUrls].count) {
        [self urlTiImagesWithCompletionHandler:^(BOOL isSuccess) {
            [self selectedArr];
        }];
        return;
    }
    
    NSArray *selectImage = [self selectImages];
    if (selectImage.count==0) {
        [XLImageLoading showAlertInView:self.view message:@"请选择图片"];
        return;
    }
    //剪切板文字数据
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"开发测试...";
    //把图片存储在本地路径
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < selectImage.count; i++) {
        UIImage *imagerang = selectImage[i];
        NSString *path_sandox = NSHomeDirectory();
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.png",i]];
        [UIImagePNGRepresentation(imagerang) writeToFile:imagePath atomically:YES];
        NSURL *shareobj = [NSURL fileURLWithPath:imagePath];
        /** 这里做个解释 imagerang : UIimage 对象  shareobj:NSURL 对象 这个方法的实际作用就是 在吊起微信的分享的时候 传递给他 UIimage对象,在分享的时候 实际传递的是 NSURL对象 达到我们分享九宫格的目的 */
        SharedItem *item = [[SharedItem alloc] initWithData:imagerang andFile:shareobj];
        [array addObject:item];
    }
    //创建系统分享弹窗
    UIActivityViewController *_activityViewController =[[UIActivityViewController alloc] initWithActivityItems:array applicationActivities: nil];
    //屏蔽分享的第反方App
    _activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePrint,UIActivityTypeMessage,UIActivityTypePostToTwitter,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeOpenInIBooks,UIActivityTypeMail,UIActivityTypeCopyToPasteboard,UIActivityTypeSaveToCameraRoll,UIActivityTypeAirDrop,@"com.apple.mobilenotes.SharingExtension",@"com.apple.reminders.RemindersEditorExtension",@"com.apple.mobileslideshow.StreamShareService",@"com.google.Drive.ShareExtension"];
    
    //弹出系统分享窗口
    [XLImageLoading showAlertInView:self.view message:@"文案已复制到剪切板"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:_activityViewController animated:TRUE completion:nil];
    });
    
    //分享成功后的回掉
    __weak typeof(self) weakSelf = self;
    _activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            //成功后别忘了删除本地的文件
            pasteboard.string = @"";
            [weakSelf removeLocalImages:array.count];
            //返回上级目录
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}
//删除存储在系统文件夹的临时文件
- (void)removeLocalImages:(NSInteger)count{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (int i = 0; i < count; i++) {
        NSString *path_sandox = NSHomeDirectory();
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.png",i]];
        BOOL exists = [fileManager fileExistsAtPath:imagePath];
        if (exists) {
            NSError *err;
            [fileManager removeItemAtPath:imagePath error:&err];
        }
    }
}



#pragma mark-------保存图片到相册---------
-(void)saveImages{
    NSLog(@"***********%@",_imageMuarr);
    if (_imageMuarr.count<[self imageUrls].count) {
        [self urlTiImagesWithCompletionHandler:^(BOOL isSuccess) {
            [self saveImages];
        }];
        return;
    }
    
    NSArray *selectImage = [self selectImages];
    if (selectImage.count==0) {
        [XLImageLoading showAlertInView:self.view message:@"请选择图片"];
        return;
    }
    for (int i=0; i<selectImage.count; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            UIImageWriteToSavedPhotosAlbum(selectImage[i], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        });
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL) {return;}
    [XLImageLoading showAlertInView:self.view message:@"图片存储成功"];
}
@end
