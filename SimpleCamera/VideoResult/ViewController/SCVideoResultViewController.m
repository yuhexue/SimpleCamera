//
//  SCVideoResultViewController.m
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import "SCVideoResultViewController.h"
#import "SCVideoResultViewController+Private.h"

#pragma clang diagnostic push

@implementation SCVideoResultViewController

- (void)dealloc {
    [self stopVideo];
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self commonInit];
    [self showPreview];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self playVideoWithIndex:self.currentVideoIndex];
    });
}

 #pragma mark - Private

- (void)commonInit {
    [self setupUI];
}

/// 显示视频预览
- (void)showPreview {
    NSURL *url = [NSURL fileURLWithPath:self.videos.firstObject.filePath];
    UIImage *previewImage = [SCAssetHelper videoPreviewImageWithURL:url];

    self.lastPlayerLayer = [[CALayer alloc] init];
    self.lastPlayerLayer.frame = self.playerContainerView.bounds;
    [self.playerContainerView.layer addSublayer:self.lastPlayerLayer];
    self.lastPlayerLayer.contents = (__bridge id)(previewImage.CGImage);
 }

//播放视频
- (void)playVideoWithIndex:(NSInteger)index {
    if (index >= self.videos.count) {
        return ;
    }
    NSString *path = self.videos[index].filePath;
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    self.player = [AVPlayer playerWithURL:videoURL];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.playerContainerView.bounds;
    [self.playerContainerView.layer addSublayer:self.playerLayer];
    [self.player play];
}

- (void)stopVideo {
    [self removeObserverForPlayerItem:self.player.currentItem];
    [self.player pause];
    [self.lastPlayerLayer removeFromSuperlayer];
    self.player = nil;
}

- (void)backToCamera {
    [self.navigationController popViewControllerAnimated:NO];
}

/// 添加播放结束监听
- (void)addObserverForPlayerItem:(AVPlayerItem *)playerItem {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
}

/// 移除播放结束监听
- (void)removeObserverForPlayerItem:(AVPlayerItem *)playerItem {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:playerItem];
}


// 保存视频
- (void)saveVideo:(NSString *)path completion:(void (^)(BOOL success))completion {
    NSURL *url = [NSURL fileURLWithPath:path];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(success);
            }
        });
    }];
}

#pragma mark - Action

- (void)confirmAction:(id)sender {
    void (^saveBlock)(NSString *) = ^ (NSString *path) {
        @weakify(self);
        [self saveVideo:path completion:^(BOOL success) {
            @strongify(self);
            if (success) {
                [self backToCamera];
            }
        }];
    };
    
    if (self.videos.count == 1) {
        NSString *path = [self.videos firstObject].filePath;
        saveBlock(path);
    } else {
        NSMutableArray *videoPaths = [[NSMutableArray alloc] init];
        for (SCVideoModel *model in self.videos) {
            [videoPaths addObject:model.filePath];
        }
        NSString *exportPath = [SCFileHelper randomFilePathInTmpWithSuffix:@".m4v"];
        [SCAssetHelper mergeVideos:videoPaths toExportPath:exportPath completion:^{
            saveBlock(exportPath);
        }];
    }
}

- (void)cancelAction:(id)sender {
    [self backToCamera];
}

- (void)playFinished:(NSNotification *)notification {
    [self stopVideo];
    self.currentVideoIndex = (self.currentVideoIndex + 1) % self.videos.count;
    [self playVideoWithIndex:self.currentVideoIndex];
}

@end

#pragma clang diagnostic pop
