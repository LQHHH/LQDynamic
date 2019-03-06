//
//  LQSegmentView.m
//  LQShopDetailDemo
//
//  Created by hhh on 2019/3/3.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQSegmentView.h"

@interface LQSegmentView ()

@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) NSArray  *buttons;

@end

@implementation LQSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupUI];
    return self;
}

#pragma mark - UI

- (void)setupUI {
    NSArray *titles = @[@"菜单",@"评价",@"详情"];
    NSMutableArray *array = @[].mutableCopy;
    for (int i = 0; i < titles.count; i ++) {
        UIButton *button = [UIButton new];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.tag = i;
        if (i == 0) {
            button.selected = YES;
            self.lastButton = button;
        }
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset       = 50*i;
            make.top.bottom.offset = 0;
            make.width.offset      = 50;
        }];
        [array addObject:button];
    }
    self.buttons = array;
    
}

#pragma mark - click

- (void)clickButton:(UIButton *)sender {
    self.lastButton.selected = NO;
    sender.selected   = YES;
    self.lastButton   = sender;
    self.currentIndex = sender.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didClickWithIndex:)]) {
        [self.delegate segmentView:self didClickWithIndex:sender.tag];
    }
}

- (void)changeSelectedTitleWithIndex:(NSInteger)index {
    self.lastButton.selected = NO;
    UIButton *currentButton  = self.buttons[index];
    currentButton.selected = YES;
    self.lastButton   = currentButton;
    self.currentIndex = index;
}

@end
