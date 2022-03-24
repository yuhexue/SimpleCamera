//
//  SCFilterBarView.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@class SCFilterBarView;

typedef NS_ENUM(NSInteger, SCFilterBarViewFilterType) {
    SCFilterBarViewFilterTypeDefault = 0,
    SCFilterBarViewFilterTypeBeautify,
    SCFilterBarViewFilterTypeColor,
};

@protocol SCFilterBarViewDelegate <NSObject>

- (void)filterBarView:(SCFilterBarView *)filterBarView categoryDidScrollToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView enableBeautify:(BOOL)enable;
- (void)filterBarView:(SCFilterBarView *)filterBarView type:(SCFilterBarViewFilterType)type sliderChangeToValue:(CGFloat)value;

@end

@interface SCFilterBarView : UIView

@property (nonatomic, assign) BOOL showing;
@property (nonatomic, weak) id <SCFilterBarViewDelegate> delegate;

/// 内置滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;
/// 抖音滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *tikTokFilterMaterials;
/// 分屏滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *splitFilterMaterials;
/// 颜色滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *colorFilterMaterials;

- (NSInteger)currentCategoryIndex;

@end
