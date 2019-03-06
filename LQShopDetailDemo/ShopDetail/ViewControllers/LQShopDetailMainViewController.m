//
//  LQShopDetailMainViewController.m
//  LQShopDetailDemo
//
//  Created by hhh on 2019/3/3.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQShopDetailMainViewController.h"
#import "LQShopDetailContailerView.h"
#import "LQShopDetailHeaderView.h"
#import "LQShopMenuViewController.h"
#import "LQShopEvaluateViewController.h"
#import "LQShopDetailViewController.h"

#import "DynamicItem.h"

#define MaxTopOffSet (110 + NAVIGATION_BAR_HEIGHT)
#define HeaderHeight (110)
#define MinTopOffSet (NAVIGATION_BAR_HEIGHT)
#define BottomOffSet (HEIGHT * 0.65)

@interface LQShopDetailMainViewController () <LQShopDetailContailerViewDelegate,UIDynamicAnimatorDelegate>

@property (nonatomic, strong) LQShopDetailContailerView *contailerView;
@property (nonatomic, strong) LQShopDetailHeaderView *headerView;

// contentView 距离顶部的约束高度
@property (nonatomic,assign) CGFloat offsetTop;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;

@end

@implementation LQShopDetailMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"店铺详情";
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    self.offsetTop = MaxTopOffSet;
    [self.view addSubview:self.contailerView];
    [self.contailerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset = self.offsetTop;
        make.height.offset = HEIGHT - self.offsetTop;
    }];
    
    LQShopMenuViewController *menuVC = [LQShopMenuViewController new];
    [self addChildViewController:menuVC];
    [self.contailerView addSubView:menuVC.view index:0];
    
    LQShopEvaluateViewController *evaluateVC = [LQShopEvaluateViewController new];
    [self addChildViewController:evaluateVC];
    [self.contailerView addSubView:evaluateVC.view index:1];
    
    LQShopDetailViewController *detailVC = [LQShopDetailViewController new];
    [self addChildViewController:detailVC];
    [self.contailerView addSubView:detailVC.view index:2];
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = HeaderHeight;
        make.bottom.mas_equalTo(self.contailerView.mas_top);
    }];
}

#pragma mark - LQShopDetailContailerViewDelegate

- (void)panGestureDealWith:(UIPanGestureRecognizer *)pan {
    [self.animator removeAllBehaviors];
    
    CGPoint point     = [pan translationInView:self.contailerView];
    //速度
    CGFloat velocity  = [pan velocityInView:self.contailerView].y;
    //偏移量
    CGFloat offset_y  = self.offsetTop + point.y;
    
    if (point.y > 0 && self.contailerView.tableView.contentOffset.y > 0) {//下滑
        if (self.contailerView.tableView.contentOffset.y - point.y <=0 ) {
            self.contailerView.tableView.contentOffset = CGPointZero;
        }
        else {
            self.contailerView.tableView.contentOffset = CGPointMake(0, self.contailerView.tableView.contentOffset.y - point.y);
        }
    }
    else if (point.y > 0 && self.contailerView.tableView.contentOffset.y <= 0 && (self.contailerView.currentSegmentIndex == 0 && self.contailerView.recommendView.offsetY > 0)) {
            if (self.contailerView.recommendView.offsetY > 0) {
                self.contailerView.recommendView.offsetY = self.contailerView.recommendView.offsetY -  point.y;
                self.contailerView.tableView.contentOffset = CGPointZero;
                self.offsetTop = MinTopOffSet;
            }
            if (self.contailerView.recommendView.offsetY <= 0) {
                self.contailerView.recommendView.offsetY = 0;
                self.contailerView.tableView.contentOffset = CGPointZero;
            }
        
    }
    else if (point.y < 0 && self.offsetTop == MinTopOffSet) {
        if (self.contailerView.currentSegmentIndex == 0) {
            if (self.contailerView.recommendView.offsetY < self.contailerView.recommendView.maxOffsetY) {
                self.contailerView.recommendView.offsetY = self.contailerView.recommendView.offsetY -  point.y;
            }
            if (self.contailerView.recommendView.offsetY >= self.contailerView.recommendView.maxOffsetY) {
                self.contailerView.recommendView.offsetY = self.contailerView.recommendView.maxOffsetY;
                CGFloat f = self.contailerView.tableView.contentSize.height - self.contailerView.tableView.frame.size.height;
                if (f < 0) {//不需要滑动效果
                    self.contailerView.tableView.contentOffset = CGPointZero;
                }
                else {
                    if (self.contailerView.tableView.contentSize.height - self.contailerView.tableView.contentOffset.y - HEIGHT +50 < -50 ) {
                        self.contailerView.tableView.contentOffset = CGPointMake(0, self.contailerView.tableView.contentOffset.y - point.y*0.3);
                    }
                    else {
                        self.contailerView.tableView.contentOffset = CGPointMake(0, self.contailerView.tableView.contentOffset.y - point.y);
                    }
                }
            }
        }
        else {
            CGFloat f = self.contailerView.tableView.contentSize.height - self.contailerView.tableView.frame.size.height;
            if (f < 0) {//不需要滑动效果
                self.contailerView.tableView.contentOffset = CGPointZero;
            }
            else {
                if (self.contailerView.tableView.contentSize.height - self.contailerView.tableView.contentOffset.y - HEIGHT +50 < -50 ) {
                    self.contailerView.tableView.contentOffset = CGPointMake(0, self.contailerView.tableView.contentOffset.y - point.y*0.3);
                }
                else {
                    self.contailerView.tableView.contentOffset = CGPointMake(0, self.contailerView.tableView.contentOffset.y - point.y);
                }
            }
        }
    }
    else {
        self.offsetTop = offset_y < MinTopOffSet ? MinTopOffSet : offset_y;
    }
    
    //不能滑到最底部，有个回弹的范围
    if (offset_y > BottomOffSet) {
        [pan setValue:@(UIGestureRecognizerStateEnded) forKeyPath:@"state"];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded ||
        pan.state == UIGestureRecognizerStateFailed) {
        if (self.offsetTop >= MaxTopOffSet && self.contailerView.tableView.contentOffset.y == 0) {
            self.offsetTop = MaxTopOffSet;
            [self rubberBandingAnimation];
        }
        else {
            if (self.contailerView.tableView.contentOffset.y > 0 && (self.offsetTop == MinTopOffSet || self.offsetTop == MaxTopOffSet)) {
                self.contailerView.velocity = velocity;
                
            }
            else if (velocity < 0 && self.contailerView.tableView.contentOffset.y > 0 && self.offsetTop > MinTopOffSet) {
                [self deceleratingAnimator:velocity];
            }
            else {
                [self deceleratingAnimator:velocity];
            }
        }
    }
    else {
        [self.contailerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.offsetTop);
            make.height.offset = HEIGHT - self.offsetTop;
        }];
    }
    
    [pan setTranslation:CGPointZero inView:self.contailerView];
}

- (void)velocityOfTableViewWhenTableIsTop:(CGFloat)speed {
    [self deceleratingAnimator:speed * 30];
}

- (void)removeBehaviors {
    [self.animator removeAllBehaviors];
}

#pragma mark - 减速

- (void)deceleratingAnimator:(CGFloat)velocity {
    if (self.itemBehavior != nil) {
        [self.animator removeBehavior:self.itemBehavior];
    }
    DynamicItem *item = [[DynamicItem alloc] init];
    item.center = CGPointMake(0, self.offsetTop);
    
    UIDynamicItemBehavior *itembehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[item]];
    [itembehavior addLinearVelocity:CGPointMake(0, velocity) forItem:item];
    itembehavior.resistance = 2;
    
    __weak typeof(self)wself = self;
    
    static CGFloat lastTop = 0;
    [itembehavior setAction:^{
        CGFloat itemTop = item.center.y;
        itemTop = itemTop < MinTopOffSet? MinTopOffSet: itemTop;
        if (fabs(itemTop - lastTop) < 1 && velocity > 0) {
            [wself.animator removeBehavior:wself.itemBehavior];
            wself.itemBehavior = nil;
            return;
        }
        lastTop = itemTop;
        if (wself.contailerView.currentSegmentIndex == 0) {
        
            wself.offsetTop = itemTop;
            [wself.contailerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(wself.view).offset(wself.offsetTop);
                make.height.offset = HEIGHT - wself.offsetTop;
            }];
            
            if (self.contailerView.recommendView.offsetY < self.contailerView.recommendView.maxOffsetY && velocity < 0) {
                CGFloat speed = [wself.itemBehavior linearVelocityForItem:item].y;
                self.contailerView.recommendView.offsetY = self.contailerView.recommendView.offsetY-speed/40;
                if (self.contailerView.recommendView.offsetY >= self.contailerView.recommendView.maxOffsetY) {
                    self.contailerView.recommendView.offsetY = self.contailerView.recommendView.maxOffsetY;
                }
            }
            
            if (velocity > 0 && self.contailerView.recommendView.offsetY > 0) {
                CGFloat speed = [wself.itemBehavior linearVelocityForItem:item].y;
                self.contailerView.recommendView.offsetY = self.contailerView.recommendView.offsetY-speed/40;
                if (self.contailerView.recommendView.offsetY <= 0) {
                    self.contailerView.recommendView.offsetY = 0;
                }
            }
            
            if (itemTop == MinTopOffSet && self.contailerView.recommendView.offsetY == self.contailerView.recommendView.maxOffsetY) {
                CGFloat velocity = [wself.itemBehavior linearVelocityForItem:item].y;
                wself.contailerView.velocity = velocity;
                [wself.animator removeBehavior:wself.itemBehavior];
                wself.itemBehavior = nil;
            }
            
            if (itemTop >= BottomOffSet) {
                [wself.animator removeBehavior:wself.itemBehavior];
                wself.itemBehavior = nil;
            }
        }
        else
        {
            wself.offsetTop = itemTop;
            [wself.contailerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(wself.view).offset(wself.offsetTop);
                make.height.offset = HEIGHT - wself.offsetTop;
            }];
            
            if (itemTop == MinTopOffSet) {
                CGFloat velocity = [wself.itemBehavior linearVelocityForItem:item].y;
                wself.contailerView.velocity = velocity;
                [wself.animator removeBehavior:wself.itemBehavior];
                wself.itemBehavior = nil;
            }
            
            if (itemTop >= BottomOffSet) {
                [wself.animator removeBehavior:wself.itemBehavior];
                wself.itemBehavior = nil;
            }
        }
        
    }];
    self.itemBehavior = itembehavior;
    [self.animator addBehavior:itembehavior];
}

#pragma mark - 模拟回弹

- (void)rubberBandingAnimation {
    [UIView animateWithDuration:0.35 animations:^{
        [self.contailerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset = self.offsetTop;
            make.height.offset = HEIGHT - self.offsetTop;
        }];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UIDynamicAnimatorDelegate

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    if (self.offsetTop > MaxTopOffSet) {
        self.offsetTop = MaxTopOffSet;
        [self rubberBandingAnimation];
    }
}

#pragma mark - lazy

- (LQShopDetailContailerView *)contailerView {
    if (!_contailerView) {
        _contailerView = [LQShopDetailContailerView new];
        _contailerView.delegate = self;
    }
    return _contailerView;
}

- (LQShopDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [LQShopDetailHeaderView new];
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    return _animator;
}

@end
