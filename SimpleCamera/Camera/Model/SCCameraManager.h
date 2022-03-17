//
//  SCCameraManager.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCFilterHandler.h"

/**
  闪光灯模式

  - SCCameraFlashModeOff: 关闭
  - SCCameraFlashModeOn: 打开
  - SCCameraFlashModeAuto: 自动
  - SCCameraFlashModeTorch: 长亮
  */
typedef NS_ENUM(NSUInteger, SCCameraFlashMode) {
    SCCameraFlashModeOff,
    SCCameraFlashModeOn,
    SCCameraFlashModeAuto,
    SCCameraFlashModeTorch
};

typedef void (^TakePhotoResult)(UIImage *resultImage, NSError *error);
typedef void (^RecordVideoResult)(NSString *videoPath);

@interface SCCameraManager : NSObject

/// 相机
@property (nonatomic, strong, readonly) GPUImageStillCamera *camera;

/// 滤镜
@property (nonatomic, strong, readonly) SCFilterHandler *currentFilterHandler;

/// 闪光灯模式，后置摄像头才有效
@property (nonatomic, assign) SCCameraFlashMode flashMode;

/// 对焦点
@property (nonatomic, assign) CGPoint focusPoint;

/// 通过调整焦距来实现视图放大缩小效果，最小是1
@property (nonatomic, assign) CGFloat videoScale;

/**
 获取实例
 */
+ (SCCameraManager *)shareInstance;

/**
 添加图像输出的UI控件，不会被持有
 */
- (void)addOutputView:(GPUImageView *)outputView;

/**
 开启相机，开启前请确保已经设置 outputView
 */
- (void)startCapturing;


- (void)rotateCamera;

/**
 拍照
 @param completion 回调
 */
- (void)takePhotoWithCompletion:(TakePhotoResult)completion;

/**
  录制视频
  */
- (void)recordVideo;

/**
 结束录制视频
 @param completion 完成回调
*/
- (void)stopRecordVideoWithCompletion:(RecordVideoResult)completion;

/**
 如果是常亮，则会关闭闪光灯，但不会修改 flashMode
 */
- (void)closeFlashIfNeed;

/**
 刷新闪光灯
 */
- (void)updateFlash;

/**
  将缩放倍数转化到可用的范围
  */
- (CGFloat)availableVideoScaleWithScale:(CGFloat)scale;

/**
  当前是否前置
  */
- (BOOL)isPositionFront;

@end
