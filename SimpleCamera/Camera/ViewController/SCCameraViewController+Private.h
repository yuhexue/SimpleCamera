//
//  SCCameraViewController+Private.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import "SCCameraViewController.h"
#import <GPUImage.h>
#import "SCCapturingButton.h"
#import "SCFilterBarView.h"
#import "SCCameraManager.h"
#import "SCFilterManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCameraViewController () <SCCapturingButtonDelegate, SCFilterBarViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) GPUImageView *cameraView;
@property (nonatomic, strong) SCCapturingButton *capturingButton;
@property (nonatomic, strong) SCFilterBarView *filterBarView;
@property (nonatomic, strong) UIButton *filterButton;

@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *currentFilters;
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;

#pragma mark - UI

- (void)setupUI;

/**
 设置滤镜栏显示或隐藏
 @param hidden 显示或隐藏
 @param animated 是否有动画
 */
- (void)setFilterBarViewHidden:(BOOL)hidden animated:(BOOL)animated;

#pragma mark - Filter

- (void)setupFilters;

#pragma mark - TakePhoto

- (void)takePhoto;

#pragma mark - Action

- (void)filterAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
