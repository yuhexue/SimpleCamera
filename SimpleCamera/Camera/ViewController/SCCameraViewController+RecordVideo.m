//
//  SCCameraViewController+RecordVideo.m
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import "SCCameraManager.h"
#import "SCCameraViewController+RecordVideo.h"
#import "SCCameraViewController+Private.h"

 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

 @implementation SCCameraViewController (RecordVideo)

 - (void)startRecordVideo {
     if (self.isRecordingVideo) {
         return;
     }
     self.isRecordingVideo = YES;
     [self.modeSwitchView setHidden:YES animated:YES completion:NULL];
     [[SCCameraManager shareInstance] recordVideoWithFilters:self.currentFilters];
 }

 - (void)stopRecordVideo {
     if (!self.isRecordingVideo) {
         return;
     }
     
     [self.modeSwitchView setHidden:NO animated:YES completion:NULL];
     @weakify(self);
     [[SCCameraManager shareInstance] stopRecordVideoWithCompletion:^(NSString *videoPath) {
         @strongify(self);
         self.isRecordingVideo = NO;
         SCVideoModel *videoModel = [[SCVideoModel alloc] init];
         videoModel.filePath = videoPath;
         [self.videos addObject:videoModel];

         dispatch_async(dispatch_get_main_queue(), ^{
             SCVideoResultViewController *vc = [[SCVideoResultViewController alloc] init];
             vc.videos = self.videos;
             [self.navigationController pushViewController:vc animated:NO];
             [self forwardToVideoResult];
         });
     }];
 }

 @end

 #pragma clang diagnostic pop
