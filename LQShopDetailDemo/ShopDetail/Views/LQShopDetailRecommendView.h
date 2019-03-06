//
//  LQShopDetailRecommendView.h
//  LQShopDetailDemo
//
//  Created by hhh on 2019/3/3.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LQShopDetailRecommendViewDelegate <NSObject>

- (void)shopDetailRecommendView:(UIView *)view didOffsetWithDisTance:(CGFloat)distance;

@end

@interface LQShopDetailRecommendView : UIView

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat maxOffsetY;
@property (nonatomic, weak) id<LQShopDetailRecommendViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
