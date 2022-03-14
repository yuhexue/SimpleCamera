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
#import "SCCameraTopView.h"
#import "SCVideoModel.h"
#import "SCPhotoResultViewController.h"
#import "SCVideoResultViewController.h"
#import "SCCapturingModeSwitchView.h"
#import "UIView+Extention.h"
#import "GPUImageBeautifyFilter.h"
#import "SCFilterHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCameraViewController () <SCCapturingButtonDelegate, SCFilterBarViewDelegate, SCCameraTopViewDelegate, SCCapturingModeSwitchViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) GPUImageView *cameraView;
@property (nonatomic, strong) SCCapturingButton *capturingButton;
@property (nonatomic, strong) SCFilterBarView *filterBarView;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) SCCameraTopView *cameraTopView;
@property (nonatomic, strong) SCCapturingModeSwitchView *modeSwitchView;
@property (nonatomic, strong) UIView *cameraFocusView;  // 聚焦框
@property (nonatomic, assign) CGFloat currentVideoScale;  // 当前预览屏的缩放倍数，默认1

@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *tikTokFilterMaterials;

@property (nonatomic, assign) BOOL isRecordingVideo;  // 是否正在录制视频
@property (nonatomic, strong) NSMutableArray<SCVideoModel *> *videos;

#pragma mark - UI

- (void)setupUI;

/**
 设置滤镜栏显示或隐藏
 @param hidden 显示或隐藏
 @param animated 是否有动画
 */
- (void)setFilterBarViewHidden:(BOOL)hidden animated:(BOOL)animated;

/// 刷新下一步按钮的显示状态
- (void)refreshNextButton;

/// 刷新闪光灯按钮
- (void)updateFlashButtonWithFlashMode:(SCCameraFlashMode)mode;
/// 显示聚焦框
- (void)showFocusViewAtLocation:(CGPoint)location;

#pragma mark - Filter
/// 添加美颜滤镜，会做为滤镜链的第一个
- (void)addBeautifyFilter;
/// 移除美颜滤镜
- (void)removeBeautifyFilter;
/// 根据分类索引，获取滤镜列表
- (NSArray<SCFilterMaterialModel *> *)filtersWithCategoryIndex:(NSInteger)index;

#pragma mark - TakePhoto

- (void)takePhoto;

- (void)startRecordVideo;

- (void)stopRecordVideo;

- (void)forwardToPhotoResultWith:(UIImage *)image;

- (void)forwardToVideoResult;

#pragma mark - Action

- (void)filterAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
