//
//  SCCameraViewController.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCCameraViewController.h"
#import "SCCameraViewController+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation SCCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    SCCameraManager *cameraManager = [SCCameraManager shareInstance];
    [cameraManager addOutputView:self.cameraView];
    [cameraManager setCameraFilters:self.currentFilters];
    [cameraManager startCapturing];
}

#pragma mark - Public

#pragma mark - Private

- (void)commonInit {
    self.videos = [[NSMutableArray alloc] init];
    self.defaultFilterMaterials = [[SCFilterManager shareInstance] defaultFilters];
    [self setupFilters];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [self setupUI];
}

- (void)forwardToPhotoResultWith:(UIImage *)image {
    SCPhotoResultViewController *resultVC = [[SCPhotoResultViewController alloc] init];
    resultVC.resultImage = image;
    [self.navigationController pushViewController:resultVC animated:NO];
}

- (void)forwardToVideoResult {
    SCVideoResultViewController *vc = [[SCVideoResultViewController alloc] init];
    vc.videos = self.videos;
    [self.videos removeAllObjects];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Action
- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    [self setFilterBarViewHidden:YES animated:YES];
}

- (void)filterAction:(id)sender {
    [self setFilterBarViewHidden:NO animated:YES];
    // 第一次展开的时候，添加数据
    if (!self.filterBarView.defaultFilterMaterials) {
        self.filterBarView.defaultFilterMaterials = self.defaultFilterMaterials;
    }
}

#pragma mark - SCCapturingButtonDelegate

- (void)capturingButtonDidClicked:(SCCapturingButton *)button {
    if (self.modeSwitchView.type == SCCapturingModeSwitchTypeImage) {
        [self takePhoto];
    } else if (self.modeSwitchView.type == SCCapturingModeSwitchTypeVideo) {
        if (self.isRecordingVideo) {
            [self stopRecordVideo];
        } else {
            [self startRecordVideo];
        }
    }
}

#pragma mark - SCCapturingModeSwitchViewDelegate
- (void)capturingModeSwitchView:(SCCapturingModeSwitchView *)view didChangeToType:(SCCapturingModeSwitchType)type {
    
}

#pragma mark - SCFilterBarViewDelegate

- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index {
    SCCameraManager *cameraManager = [SCCameraManager shareInstance];
    SCFilterMaterialModel *model = self.defaultFilterMaterials[index];
    self.currentFilters = [[SCFilterManager shareInstance] filterWithFilterID:model.filterID];
    [cameraManager setCameraFilters:self.currentFilters];
}

#pragma mark - SCCameraTopViewDelegate
- (void)cameraTopViewDidClickRotateButton:(SCCameraTopView *)cameraTopView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SCCameraManager shareInstance] rotateCamera];
    });
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.filterBarView]) {
        return NO;
    }
    return YES;
}

@end

#pragma clang diagnostic pop
