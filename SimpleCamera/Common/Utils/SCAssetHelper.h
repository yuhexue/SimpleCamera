//
//  SCAssetHelper.h
//  SimpleCamera
//
//  Created by maxslma on 2022/2/11.
//

#import <Foundation/Foundation.h>

@interface SCAssetHelper : NSObject

/// 获取视频的第一帧
+ (UIImage *)videoPreviewImageWithURL:(NSURL *)url;

/// 合并视频
+ (void)mergeVideos:(NSArray *)videoPaths toExportPath:(NSString *)exportPath completion:(void (^)(void))completion;

@end
