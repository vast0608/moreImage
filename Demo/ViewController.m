//
//  ViewController.m
//  Demo
//
//  Created by 李晓璐 on 2018/8/2.
//  Copyright © 2018年 onmmc. All rights reserved.
//

#import "ViewController.h"
#import "ShowNetImagesVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)button:(id)sender {
    ShowNetImagesVC *vc = [[ShowNetImagesVC alloc] init];
    vc.title = @"图片";
    [self.navigationController pushViewController:vc animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
