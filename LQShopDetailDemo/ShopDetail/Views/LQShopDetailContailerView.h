//
//  LQShopDetailContailerView.h
//  LQShopDetailDemo
//
//  Created by hhh on 2019/3/3.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQShopDetailRecommendView.h"
NS_ASSUME_NONNULL_BEGIN



@protocol LQShopDetailContailerViewDelegate <NSObject>

@optional
-(void)panGestureDealWith:(UIPanGestureRecognizer *)pan;
-(void)velocityOfTableViewWhenTableIsTop:(CGFloat)speed;
@end

@interface LQShopDetailContailerView : UIView

@property (nonatomic, assign) float velocity;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LQShopDetailRecommendView *recommendView;
@property (nonatomic, weak) id<LQShopDetailContailerViewDelegate> delegate;
@property (nonatomic, assign) NSInteger currentSegmentIndex;

- (void)addSubView:(UIView *)view index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
