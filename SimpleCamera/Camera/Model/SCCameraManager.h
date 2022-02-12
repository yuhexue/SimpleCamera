//
//  SCCameraManager.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <GPUImage.h>

typedef void (^TakePhotoResult)(UIImage *resultImage, NSError *error);
typedef void (^RecordVideoResult)(NSString *videoPath);

@interface SCCameraManager : NSObject

/// 相机
@property (nonatomic, strong, readonly) GPUImageStillCamera *camera;

/**
 获取实例
 */
+ (SCCameraManager *)shareInstance;

/**
 添加图像输出的UI控件，不会被持有
 */
- (void)addOutputView:(GPUImageView *)outputView;

/**
 添加相机预览的滤镜，不会被持有
 */
- (void)setCameraFilters:(GPUImageOutput<GPUImageInput> *)filters;

/**
 开启相机，开启前请确保已经设置 outputView
 */
- (void)startCapturing;


- (void)rotateCamera;

/**
 拍照
 @param filters 需要添加的滤镜
 @param completion 回调
 */
- (void)takePhotoWithFilters:(GPUImageOutput<GPUImageInput> *)filters completion:(TakePhotoResult)completion;

/**
  录制视频
  @param filters 录制视频的滤镜效果
  */
 - (void)recordVideoWithFilters:(GPUImageOutput<GPUImageInput> *)filters;

 /**
  结束录制视频
  @param completion 完成回调
  */
 - (void)stopRecordVideoWithCompletion:(RecordVideoResult)completion;


@end
