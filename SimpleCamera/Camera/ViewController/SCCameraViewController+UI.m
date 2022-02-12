//
//  SCCameraViewController+UI.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import "SCCameraViewController+UI.h"
#import "SCCameraViewController+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

static CGFloat const kFilterBarViewHeight = 200.0f;  // 滤镜栏高度

@implementation SCCameraViewController (UI)

- (void)setupUI {
    [self setupCameraView];
    [self setupCapturingButton];
    [self setupFilterButton];
    [self setupCameraTopView];
    [self setupModeSwitchView];
}

- (void)setupCameraView {
    self.cameraView = [[GPUImageView alloc] init];
    [self.view addSubview:self.cameraView];
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height);
    }];
}

- (void)setupCapturingButton {
    self.capturingButton = [[SCCapturingButton alloc] init];
    self.capturingButton.delegate = self;
    
    [self.view addSubview:self.capturingButton];
    [self.capturingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        }
    }];
}

- (void)setupFilterButton {
    self.filterButton = [[UIButton alloc] init];
    [self.filterButton setImage:[UIImage imageNamed:@"btn_filter"]
                            forState:UIControlStateNormal];
    [self.filterButton addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.filterButton];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(self.capturingButton);
        make.right.equalTo(self.capturingButton.mas_left).offset(-35);
    }];
}

- (void)setupFilterBarView {
    self.filterBarView = [[SCFilterBarView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
    self.filterBarView.delegate = self;
    self.filterBarView.showing = NO;
    [self.view addSubview:self.filterBarView];
    [self.filterBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    [self.filterBarView layoutIfNeeded];
}

- (void)setupCameraTopView {
    self.cameraTopView = [[SCCameraTopView alloc] init];
     self.cameraTopView.delegate = self;
     [self.view addSubview:self.cameraTopView];
     [self.cameraTopView mas_makeConstraints:^(MASConstraintMaker *make) {
         if (@available(iOS 11.0, *)) {
             make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
         } else {
             make.top.mas_equalTo(self.view.mas_top);
         }
         make.left.right.equalTo(self.view);
         make.height.mas_equalTo(60);
     }];
}

- (void)setupModeSwitchView {
    self.modeSwitchView = [[SCCapturingModeSwitchView alloc] init];
    self.modeSwitchView.delegate = self;
    [self.view addSubview:self.modeSwitchView];
    [self.modeSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.capturingButton);
        make.top.equalTo(self.capturingButton.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}
#pragma mark - Update

- (void)setFilterBarViewHidden:(BOOL)hidden animated:(BOOL)animated {
    if (!hidden && !self.filterBarView) {
        [self setupFilterBarView];
    }
    
    void (^updateBlock)(void) = ^ {
        [self.filterBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            if (hidden) {
                make.top.mas_equalTo(self.view.mas_bottom).offset(0);
            } else {
                if (@available(iOS 11.0, *)) {
                    make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-kFilterBarViewHeight);
                } else {
                    make.top.mas_equalTo(self.view.mas_bottom).offset(-kFilterBarViewHeight);
                }
            }
        }];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            updateBlock();
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.filterBarView.showing = !hidden;
        }];
    } else {
        updateBlock();
        self.filterBarView.showing = !hidden;
    }
}

@end

#pragma clang diagnostic pop
