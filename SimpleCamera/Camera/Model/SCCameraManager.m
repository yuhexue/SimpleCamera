//
//  SCCameraManager.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//
#import "SCFileHelper.h"
#import "SCCameraManager.h"
#import "SCFaceDetectorManager.h"

static CGFloat const kMaxVideoScale = 6.0f;
static CGFloat const kMinVideoScale = 1.0f;
static SCCameraManager *_cameraManager;

@interface SCCameraManager () <GPUImageVideoCameraDelegate>

@property (nonatomic, strong, readwrite) GPUImageStillCamera *camera;
@property (nonatomic, weak) GPUImageView *outputView;
@property (nonatomic, strong, readwrite) SCFilterHandler *currentFilterHandler;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, copy) NSString *currentTmpVideoPath;

@end


@implementation SCCameraManager

+ (SCCameraManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cameraManager = [[SCCameraManager alloc] init];
    });
    return _cameraManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setupFilterHandler];
    _videoScale = 1;
}

/**
  初始化 FilterHandler
  */
- (void)setupFilterHandler {
    self.currentFilterHandler = [[SCFilterHandler alloc] init];
    
    [self.currentFilterHandler setEffectFilter:nil];
}

- (void)setFocusPoint:(CGPoint)focusPoint {
    _focusPoint = focusPoint;

    AVCaptureDevice *device = self.camera.inputCamera;

    // 坐标转换
    CGPoint currentPoint = CGPointMake(focusPoint.y / self.outputView.bounds.size.height, 1 - focusPoint.x / self.outputView.bounds.size.width);
    if ([self isPositionFront]) {
        currentPoint = CGPointMake(currentPoint.x, 1 - currentPoint.y);
    }

    [device lockForConfiguration:nil];

    if ([device isFocusPointOfInterestSupported] &&
        [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [device setFocusPointOfInterest:currentPoint];
        [device setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([device isExposurePointOfInterestSupported] &&
        [device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [device setExposurePointOfInterest:currentPoint];
        [device setExposureMode:AVCaptureExposureModeAutoExpose];
    }

    [device unlockForConfiguration];
}

- (CGFloat)availableVideoScaleWithScale:(CGFloat)scale {
    AVCaptureDevice *device = self.camera.inputCamera;

    CGFloat maxScale = kMaxVideoScale;
    CGFloat minScale = kMinVideoScale;
    if (@available(iOS 11.0, *)) {
     maxScale = device.maxAvailableVideoZoomFactor;
    }

    scale = MAX(scale, minScale);
    scale = MIN(scale, maxScale);

    return scale;
}

#pragma mark - Public

- (void)setVideoScale:(CGFloat)videoScale {
    _videoScale = videoScale;

    videoScale = [self availableVideoScaleWithScale:videoScale];

    AVCaptureDevice *device = self.camera.inputCamera;
    [device lockForConfiguration:nil];
    device.videoZoomFactor = videoScale;
    [device unlockForConfiguration];
}

- (void)addOutputView:(GPUImageView *)outputView {
    self.outputView = outputView;
}

- (void)rotateCamera {
    [self.camera rotateCamera];
    // 切换摄像头，同步一下闪光灯
    [self syncFlashState];
}

- (void)closeFlashIfNeed {
    AVCaptureDevice *device = self.camera.inputCamera;
    if ([device hasFlash] && device.torchMode == AVCaptureTorchModeOn) {
        [device lockForConfiguration:nil];
        device.torchMode = AVCaptureTorchModeOff;
        device.flashMode = AVCaptureFlashModeOff;
        [device unlockForConfiguration];
    }
}

- (void)updateFlash {
    [self syncFlashState];
}

- (void)startCapturing {
    if (!self.outputView) {
        NSAssert(NO, @"outputView 未被赋值");
        return;
    }
    [self setupCamera];
    [self.camera addTarget:self.currentFilterHandler.firstFilter];
    [self.currentFilterHandler.lastFilter addTarget:self.outputView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.camera startCameraCapture];
    });
}

/**
 初始化相机
 */
- (void)setupCamera {
    self.camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
    [self.camera addAudioInputsAndOutputs];
    self.camera.delegate = self;
    self.camera.frameRate = 20;
    
    self.currentFilterHandler.source = self.camera;
}

- (void)takePhotoWithCompletion:(TakePhotoResult)completion {
    GPUImageFilter *lastFilter = self.currentFilterHandler.lastFilter;
    
    [self.camera capturePhotoAsImageProcessedUpToFilter:lastFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (error && completion) {
            completion(nil, error);
            return;
        }
        
        if (completion) {
            completion(processedImage, nil);
        }
    }];
}

- (void)setFlashMode:(SCCameraFlashMode)flashMode {
    _flashMode = flashMode;

    [self syncFlashState];
}

- (void)recordVideo {
    [self setupMovieWriter];
    [self.movieWriter startRecording];
}

- (void)stopRecordVideoWithCompletion:(RecordVideoResult)completion {
    @weakify(self);
    [self.movieWriter finishRecordingWithCompletionHandler:^{
        @strongify(self);
        [self removeMovieWriter];
        if (completion) {
            completion(self.currentTmpVideoPath);
        }
    }];
}

/**
  初始化 MovieWriter
  */
- (void)setupMovieWriter {
    NSString *videoPath = [SCFileHelper  randomFilePathInTmpWithSuffix:@".m4v"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize videoSize = CGSizeMake(self.outputView.frame.size.width * screenScale,
                                  self.outputView.frame.size.height * screenScale);

    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:videoURL
                                                                size:videoSize];
    GPUImageFilter *lastFilter = self.currentFilterHandler.lastFilter;
    [lastFilter addTarget:self.movieWriter];
    self.camera.audioEncodingTarget = self.movieWriter;
    self.movieWriter.shouldPassthroughAudio = YES;

    self.currentTmpVideoPath = videoPath;
}

/**
 移除 MovieWriter
*/
- (void)removeMovieWriter {
    if (!self.movieWriter) {
        return;
    }
    [self.currentFilterHandler.lastFilter removeTarget:self.movieWriter];
    self.camera.audioEncodingTarget = nil;
    self.movieWriter = nil;
}

/**
  将 flashMode 的值同步到设备
  */
- (void)syncFlashState {
    AVCaptureDevice *device = self.camera.inputCamera;
    if (![device hasFlash] || [self isPositionFront]) {
        [self closeFlashIfNeed];
        return;
    }

    [device lockForConfiguration:nil];

    switch (self.flashMode) {
        case SCCameraFlashModeOff:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOff;
            break;
        case SCCameraFlashModeOn:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOn;
            break;
        case SCCameraFlashModeAuto:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeAuto;
            break;
        case SCCameraFlashModeTorch:
            device.torchMode = AVCaptureTorchModeOn;
            device.flashMode = AVCaptureFlashModeOff;
            break;
        default:
            break;
    }
    [device unlockForConfiguration];
}

- (BOOL)isPositionFront {
    return self.camera.cameraPosition == AVCaptureDevicePositionFront;
}

#pragma mark - GPUImageVideoCameraDelegate
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    float *facePoints = [SCFaceDetectorManager detectWithSampleBuffer:sampleBuffer isMirror:[self isPositionFront]];
    self.currentFilterHandler.facesPoints = facePoints;
}

@end
