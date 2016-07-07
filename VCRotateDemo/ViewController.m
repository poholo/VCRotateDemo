//
//  ViewController.m
//  VCRotateDemo
//
//  Created by majiancheng on 16/7/8.
//  Copyright © 2016年 mjc. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+Rotate.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView * rotateView = [[UIView alloc] init];
    [self.view addSubview:rotateView];
    
    rotateView.backgroundColor = [UIColor redColor];
    [rotateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.width * 9.0f /16.0f);
    }];
    self.isAutorotate = YES;    //打开旋转
    self.playerView = rotateView; //旋转层
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
