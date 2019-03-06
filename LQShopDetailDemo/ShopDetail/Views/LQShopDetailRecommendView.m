//
//  LQShopDetailRecommendView.m
//  LQShopDetailDemo
//
//  Created by hhh on 2019/3/3.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQShopDetailRecommendView.h"

@implementation LQShopDetailRecommendView

#pragma mark - setter

- (void)setOffsetY:(CGFloat)offsetY {
    _offsetY = offsetY;
    [self.delegate shopDetailRecommendView:self didOffsetWithDisTance:offsetY];
}

@end
