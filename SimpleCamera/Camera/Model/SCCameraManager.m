//
//  SCCameraManager.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//
#import "SCFileHelper.h"
#import "SCCameraManager.h"

static SCCameraManager *_cameraManager;

@interface SCCameraManager ()

@property (nonatomic, strong, readwrite) GPUImageStillCamera *camera;
@property (nonatomic, weak) GPUImageView *outputView;
@property (nonatomic, weak) GPUImageOutput<GPUImageInput> *currentFilters;
@property (nonatomic, strong) GPUImageOutput <GPUImageInput> *movieWriterFilters; //movieWriter的滤镜
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

- (void)rotateCamera {
    [self.camera rotateCamera];
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

/**
 初始化相机
 */
- (void)setupCamera {
    self.camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
    [self.camera addAudioInputsAndOutputs];
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

- (void)recordVideoWithFilters:(GPUImageOutput<GPUImageInput> *)filters {
     if (filters) {
         self.movieWriterFilters = filters;
         [self.camera addTarget:filters];
     }
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
    GPUImageOutput *output = self.movieWriterFilters ? self.movieWriterFilters : self.camera;
    [output addTarget:self.movieWriter];
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
    [self.camera removeTarget:self.movieWriter];
    [self.movieWriterFilters removeTarget:self.movieWriter];
    self.camera.audioEncodingTarget = nil;
    self.movieWriter = nil;

    if (self.movieWriterFilters != self.currentFilters) {
        [self.camera removeTarget:self.movieWriterFilters];
        self.movieWriterFilters = nil;
    }
 }

@end
