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
    [cameraManager startCapturing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[SCCameraManager shareInstance] updateFlash];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[SCCameraManager shareInstance] closeFlashIfNeed];
}

#pragma mark - Public

#pragma mark - Private

- (void)commonInit {
    self.videos = [[NSMutableArray alloc] init];
    self.currentVideoScale = 1.0f;
    
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

- (void)cameraTopViewDidClickFlashButton:(SCCameraTopView *)cameraTopView {
    SCCameraFlashMode mode = [SCCameraManager shareInstance].flashMode;
    mode = (mode + 1) % 4;
    [SCCameraManager shareInstance].flashMode = mode;
    [self updateFlashButtonWithFlashMode:mode];
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

- (void)refreshNextButton {
    [self.nextButton setHidden:self.videos.count == 0 || self.isRecordingVideo
                      animated:YES
                    completion:NULL];
}

- (void)nextAction:(id)sender {
    [self forwardToVideoResult];
    [self refreshNextButton];
    [self.modeSwitchView setHidden:NO animated:NO completion:NULL];
}

- (void)cameraViewTapAction:(UITapGestureRecognizer *)tap {
    if (self.filterBarView.showing) {
        [self tapAction:nil];
        return;
    }

    CGPoint location = [tap locationInView:self.cameraView];
    [[SCCameraManager shareInstance] setFocusPoint:location];
    [self showFocusViewAtLocation:location];
}

- (void)cameraViewPinchAction:(UIPinchGestureRecognizer *)pinch {
    SCCameraManager *manager = [SCCameraManager shareInstance];
    CGFloat scale = pinch.scale * self.currentVideoScale;
    scale = [manager availableVideoScaleWithScale:scale];
    [manager setVideoScale:scale];

    if (pinch.state == UIGestureRecognizerStateEnded) {
        self.currentVideoScale = scale;
    }
}

#pragma mark - SCCapturingButtonDelegate

- (void)capturingButtonDidClicked:(SCCapturingButton *)button {
    if (self.modeSwitchView.type == SCCapturingModeSwitchTypeImage) {
        [self takePhoto];
    } else if (self.modeSwitchView.type == SCCapturingModeSwitchTypeVideo) {
        if (self.isRecordingVideo) {
            [self stopRecordVideo];
            button.capturingState = SCCapturingButtonStateNormal;
        } else {
            [self startRecordVideo];
            button.capturingState = SCCapturingButtonStateRecording;
        }
    }
}

#pragma mark - SCCapturingModeSwitchViewDelegate
- (void)capturingModeSwitchView:(SCCapturingModeSwitchView *)view didChangeToType:(SCCapturingModeSwitchType)type {
    
}

#pragma mark - SCFilterBarViewDelegate

- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index {
    NSArray<SCFilterMaterialModel *> *models = [self filtersWithCategoryIndex:self.filterBarView.currentCategoryIndex];
    SCFilterMaterialModel *model = models[index];
    [[SCCameraManager shareInstance].currentFilterHandler setEffectFilter:[[SCFilterManager shareInstance] filterWithFilterID:model.filterID]];
}

- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySwitchIsOn:(BOOL)isOn {
    if (isOn) {
        [self addBeautifyFilter];
    } else {
        [self removeBeautifyFilter];
    }
}

- (void)filterBarView:(SCFilterBarView *)filterBarView categoryDidScrollToIndex:(NSUInteger)index {
    if (index == 0 && !self.filterBarView.defaultFilterMaterials) {
        self.filterBarView.defaultFilterMaterials = self.defaultFilterMaterials;
    } else if (index == 1 && !self.filterBarView.tikTokFilterMaterials) {
        self.filterBarView.tikTokFilterMaterials = self.tikTokFilterMaterials;
    }
}

#pragma mark - SCCameraTopViewDelegate
- (void)cameraTopViewDidClickRotateButton:(SCCameraTopView *)cameraTopView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SCCameraManager shareInstance] rotateCamera];
        self.currentVideoScale = 1.0f;  // 切换摄像头，重置缩放比例
    });
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.filterBarView]) {
        return NO;
    }
    return YES;
}

- (NSArray<SCFilterMaterialModel *> *)defaultFilterMaterials {
    if (!_defaultFilterMaterials) {
        _defaultFilterMaterials = [[SCFilterManager shareInstance] defaultFilters];
    }
    return _defaultFilterMaterials;
}

- (NSArray<SCFilterMaterialModel *> *)tikTokFilterMaterials {
    if (!_tikTokFilterMaterials) {
        _tikTokFilterMaterials = [[SCFilterManager shareInstance] tiktokFilters];
    }
    return _tikTokFilterMaterials;
}

@end

#pragma clang diagnostic pop
