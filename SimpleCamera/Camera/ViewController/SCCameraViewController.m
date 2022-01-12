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
    self.defaultFilterMaterials = [[SCFilterManager shareInstance] defaultFilters];
    [self setupFilters];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [self setupUI];
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
    [self takePhoto];
}

#pragma mark - SCFilterBarViewDelegate

- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index {
    SCCameraManager *cameraManager = [SCCameraManager shareInstance];
    SCFilterMaterialModel *model = self.defaultFilterMaterials[index];
    self.currentFilters = [[SCFilterManager shareInstance] filterWithFilterID:model.filterID];
    [cameraManager setCameraFilters:self.currentFilters];
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
