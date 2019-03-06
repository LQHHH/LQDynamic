//
//  LQSegmentView.h
//  LQShopDetailDemo
//
//  Created by hhh on 2019/3/3.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LQSegmentView;

@protocol LQSegmentViewDelegate <NSObject>

- (void)segmentView:(LQSegmentView *)view didClickWithIndex:(NSInteger)index;

@end

@interface LQSegmentView : UIView

@property (nonatomic, weak) id<LQSegmentViewDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)changeSelectedTitleWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
