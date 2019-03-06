//
//  ViewController.m
//  LQShopDetailDemo
//
//  Created by hhh on 2019/3/3.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "ViewController.h"
#import "LQShopDetailMainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"test";
    
    UIButton *button       = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"click to shop" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clicktoShopDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
        make.height.offset(50);
        make.width.offset(150);
    }];
}

#pragma mark - click

- (void)clicktoShopDetailVC:(UIButton *)sender {
    LQShopDetailMainViewController *shopMainVC = [LQShopDetailMainViewController new];
    [self.navigationController pushViewController:shopMainVC animated:YES];
}




@end
