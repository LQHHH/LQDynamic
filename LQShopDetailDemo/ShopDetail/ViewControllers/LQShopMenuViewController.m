//
//  LQShopMenuViewController.m
//  LQShopDetailDemo
//
//  Created by hhh on 2019/3/3.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQShopMenuViewController.h"
#import "LQShopDetailRecommendView.h"

#define RecommendViewHeight (200)

@interface LQShopMenuViewController () <UITableViewDelegate, UITableViewDataSource, LQShopDetailRecommendViewDelegate>

@property (nonatomic, strong) LQShopDetailRecommendView *recommendView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LQShopMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    [self.view addSubview:self.recommendView];
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset=0;
        make.height.offset = RecommendViewHeight;
    }];
    
    [self.view addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.mas_equalTo(self.recommendView.mas_bottom).offset=0;
        make.width.offset=WIDTH *0.25;
        make.bottom.offset= -49;
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=WIDTH *0.25;
        make.top.mas_equalTo(self.recommendView.mas_bottom).offset=0;
        make.width.offset=WIDTH *0.75;
        make.bottom.offset=-49;
    }];
    
    UILabel *label        = [UILabel new];
    label.text            = @"此处放购物车";
    label.textAlignment   = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.top.mas_equalTo(self.tableView.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) {
        return 1;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 20;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        return 40;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 0.01;
    }
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return nil;
    }
    UILabel *view = [UILabel new];
    view.backgroundColor = [UIColor redColor];
    view.text = [NSString stringWithFormat:@"我是区头%ld号",section];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.textLabel.text  = @"xxxx";
    cell.backgroundColor = [UIColor whiteColor];
    if (tableView == self.tableView) {
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

#pragma mark - LQShopDetailRecommendViewDelegate

- (void)shopDetailRecommendView:(UIView *)view didOffsetWithDisTance:(CGFloat)distance {
    [self.recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset = -distance;
    }];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY >= 0 && offsetY <= RecommendViewHeight) {
//        [self.recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.offset = -offsetY;
//
//        }];
//    }
//    if (offsetY > RecommendViewHeight) {
//        [self.recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.offset = -RecommendViewHeight;
//
//        }];
//    }
//}

#pragma mark - lazy

- (LQShopDetailRecommendView *)recommendView {
    if (!_recommendView) {
        _recommendView = [LQShopDetailRecommendView new];
        _recommendView.backgroundColor = [UIColor cyanColor];
        _recommendView.delegate = self;
        _recommendView.maxOffsetY = RecommendViewHeight;
    }
    return _recommendView;
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate=self;
        _leftTableView.dataSource=self;
        _leftTableView.separatorInset = UIEdgeInsetsZero;
        _leftTableView.separatorColor = [UIColor grayColor];
        _leftTableView.layoutMargins = UIEdgeInsetsZero;
        _leftTableView.showsVerticalScrollIndicator=NO;
        _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftTableView.estimatedRowHeight = 50;
        _leftTableView.rowHeight = UITableViewAutomaticDimension;
        _leftTableView.scrollsToTop = NO;
        
    }
    return _leftTableView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tag = 200;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.scrollsToTop = YES;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
