//
//  SCCameraManager.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCCameraManager.h"

static SCCameraManager *_cameraManager;

@interface SCCameraManager ()

@property (nonatomic, strong, readwrite) GPUImageStillCamera *camera;
@property (nonatomic, weak) GPUImageView *outputView;
@property (nonatomic, weak) GPUImageOutput<GPUImageInput> *currentFilters;

@end


@implementation SCCameraManager

+ (SCCameraManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cameraManager = [[SCCameraManager alloc] init];
    });
    return _cameraManager;
}

#pragma mark - Public

- (void)addOutputView:(GPUImageView *)outputView {
    self.outputView = outputView;
}

- (void)setCameraFilters:(GPUImageOutput<GPUImageInput> *)filters {
    if (self.currentFilters) {
        [self.currentFilters removeTarget:self.outputView];
        [self.camera removeTarget:self.currentFilters];
    }
    
    self.currentFilters = filters;
    if (filters) {
        [self.camera addTarget:self.currentFilters];
        [self.currentFilters addTarget:self.outputView];
    }
}

- (void)startCapturing {
    if (!self.outputView) {
        NSAssert(NO, @"outputView 未被赋值");
        return;
    }
    [self setupCamera];
    //如果没有滤镜：camera->outputView
    //如果有滤镜：camera->currentFilters->outputView
    GPUImageOutput *output = self.camera;
    if (self.currentFilters) {
        [self.camera addTarget:self.currentFilters];
        output = self.currentFilters;
    }
    [output addTarget:self.outputView];
    
    [self.camera startCameraCapture];
}

- (void)takePhotoWithFilters:(GPUImageOutput<GPUImageInput> *)filters completion:(TakePhotoResult)completion {
    [self.camera capturePhotoAsJPEGProcessedUpToFilter:filters withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        if (error && completion) {
            completion(nil, error);
            return;
        }
        UIImage *image = [UIImage imageWithData:processedJPEG];
        if (completion) {
            completion(image, nil);
        }
    }];
}

#pragma mark - Private
/**
 初始化相机
 */
- (void)setupCamera {
    self.camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
}

@end
