//
//  SCFilterBarView.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@class SCFilterBarView;

@protocol SCFilterBarViewDelegate <NSObject>

- (void)filterBarView:(SCFilterBarView *)filterBarView categoryDidScrollToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySwitchIsOn:(BOOL)isOn;
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySliderChangeToValue:(CGFloat)value;

@end

@interface SCFilterBarView : UIView

@property (nonatomic, assign) BOOL showing;
@property (nonatomic, weak) id <SCFilterBarViewDelegate> delegate;

/// 内置滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;

/// 抖音滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *tikTokFilterMaterials;

- (NSInteger)currentCategoryIndex;

@end
