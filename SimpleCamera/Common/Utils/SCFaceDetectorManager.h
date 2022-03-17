//
//  SCFaceDetectorManager.h
//  SimpleCamera
//
//  Created by maxslma on 2022/3/11.
//

#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>

@interface SCFaceDetectorManager : NSObject

/// 获取人脸点，前置是镜像
+ (float *)detectWithSampleBuffer:(CMSampleBufferRef)sampleBuffer isMirror:(BOOL)isMirror;

/// 人脸点个数
+ (int)facePointCount;

@end
