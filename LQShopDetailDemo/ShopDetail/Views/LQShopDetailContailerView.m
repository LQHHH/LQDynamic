//
//  LQShopDetailContailerView.m
//  LQShopDetailDemo
//
//  Created by hhh on 2019/3/3.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQShopDetailContailerView.h"
#import "LQSegmentView.h"
#import "LQScrollView.h"
#import "DynamicItem.h"

@interface LQShopDetailContailerView () <LQSegmentViewDelegate,UIScrollViewDelegate,UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) LQSegmentView *segment;
@property (nonatomic, strong) LQScrollView  *scrollView;
@property (nonatomic, strong) NSMutableArray   *views;
@property (nonatomic, assign) BOOL is_scroll;

@property (nonatomic, strong) UIDynamicAnimator  *animator;
@property (nonatomic, strong) UIDynamicItemBehavior *inertialBehavior;

@end

@implementation LQShopDetailContailerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupUI];
    
    // 添加拖动手势，处理滚动效果
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    return self;
}

#pragma mark - setter

- (void)setVelocity:(float)velocity {
    _velocity = velocity;
    CGFloat f = self.tableView.contentSize.height - self.tableView.frame.size.height;
    if (f <= 0) {
        return;
    }
    
    if (self.inertialBehavior != nil) {
        [self.animator removeBehavior:self.inertialBehavior];
    }
    
    DynamicItem *item = [[DynamicItem alloc] init];
    item.center = CGPointMake(0, 0);
    
    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[item]];
    [inertialBehavior addLinearVelocity:CGPointMake(0, velocity * 0.025) forItem:item];
    inertialBehavior.resistance = 2;
    
    __weak typeof(self)wself = self;
    [inertialBehavior setAction:^{
        CGFloat maxOffset = wself.tableView.contentSize.height - wself.tableView.bounds.size.height;
        CGPoint contentOffset = wself.tableView.contentOffset;
        CGFloat speed = [wself.inertialBehavior linearVelocityForItem:item].y;
        CGFloat offset = contentOffset.y - speed;
        
        if (offset >= maxOffset && maxOffset > 0) {
            [wself.animator removeAllBehaviors];
            wself.inertialBehavior = nil;
            
//            CGFloat height = 0.0;
//            if (self.segment.currentIndex == 0) {
//                height = 45;
//            }
            
            [UIView animateWithDuration:0.15 animations:^{
                wself.tableView.contentOffset = CGPointMake(contentOffset.x, offset);
            } completion:^(BOOL finished) {
                [wself.tableView setContentOffset:CGPointMake(contentOffset.x, maxOffset) animated:YES];
            }];
        }
        else {
             offset = offset <= 0?0:offset;
             wself.tableView.contentOffset = CGPointMake(contentOffset.x, offset);
            if (offset == 0) {
                [wself.animator removeBehavior:self.inertialBehavior];
                wself.inertialBehavior = nil;
                if (self.delegate && [self.delegate respondsToSelector:@selector(velocityOfTableViewWhenTableIsTop:)]) {
                    [self.delegate velocityOfTableViewWhenTableIsTop:speed];
                }
            }
        }
    }];
    self.inertialBehavior = inertialBehavior;
    [self.animator addBehavior:inertialBehavior];
}

#pragma mark - UI

- (void)setupUI {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor purpleColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 40;
    }];
    
    [view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset    = 0;
        make.left.offset   = 20;
        make.right.offset  = -20;
        make.height.offset = 40;
    }];
    
    [self addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.mas_equalTo(view.mas_bottom);
        make.height.offset   = 50;
    }];
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=90;
        make.width.offset=WIDTH;
        make.height.mas_equalTo(self.mas_height).offset = -90;
    }];
}

#pragma mark - LQSegmentViewDelegate

- (void)segmentView:(LQSegmentView *)view didClickWithIndex:(NSInteger)index {
    self.is_scroll = YES;
    [self.animator removeAllBehaviors];
    [self.scrollView setContentOffset:CGPointMake(index * WIDTH, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.is_scroll) {
        return;
    }
    [self.animator removeAllBehaviors];
    NSInteger offsetpage = scrollView.contentOffset.x/WIDTH;
    [self.segment changeSelectedTitleWithIndex:offsetpage];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.is_scroll = NO;
}

#pragma mark - add three view

- (void)addSubView:(UIView *)view index:(NSInteger)index {
    [self.scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset  = WIDTH * index;
        make.top.offset   = 0;
        make.width.offset = WIDTH;
        make.height.mas_equalTo(self.scrollView.mas_height);
    }];
    [self.views addObject:view];
}

#pragma mark - UI

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(panGestureDealWith:)]) {
        [self.delegate panGestureDealWith:pan];
    }
}

#pragma mark - lazy

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"搜索事件通过代理回调出去";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _textField;
}

- (LQSegmentView *)segment {
    if (!_segment) {
        _segment = [LQSegmentView new];
        _segment.delegate = self;
        _segment.backgroundColor = [UIColor orangeColor];
    }
    
    return _segment;
}



- (LQScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [LQScrollView new];
        _scrollView.contentSize = CGSizeMake(WIDTH * 3, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] init];
        _animator.delegate = self;
    }
    return _animator;
}

- (NSMutableArray *)views {
    if (!_views) {
        _views = @[].mutableCopy;
    }
    return _views;
}

- (UITableView *)tableView {
    if (self.views.count == 3) {
    UIViewController *vc = [self viewControllerForView:self.views[self.segment.currentIndex]];
        
       _tableView = [vc valueForKeyPath:@"tableView"];
    }
    return _tableView;
}

- (LQShopDetailRecommendView *)recommendView {
    UIViewController *vc = [self viewControllerForView:self.views[0]];
    return [vc valueForKey:@"recommendView"];
}

- (UIViewController *)viewControllerForView:(UIView *)view {
    for (UIView* next = view; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (NSInteger)currentSegmentIndex {
    return self.segment.currentIndex;
}

@end
