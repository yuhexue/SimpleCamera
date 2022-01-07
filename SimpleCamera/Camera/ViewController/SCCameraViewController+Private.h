//
//  SCCameraViewController+Private.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import "SCCameraViewController.h"
#import <GPUImage.h>
#import "SCCapturingButton.h"
#import "SCCameraManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCameraViewController () <SCCapturingButtonDelegate>

@property (nonatomic, strong) GPUImageView *cameraView;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *currentFilters;
@property (nonatomic, strong) SCCapturingButton *capturingButton;

#pragma mark - UI

- (void)setupCameraView;
- (void)setupCapturingButton;

#pragma mark - Filter

- (void)setupFilters;

#pragma mark - TakePhoto

- (void)takePhoto;

@end

NS_ASSUME_NONNULL_END
