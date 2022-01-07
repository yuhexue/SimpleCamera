//
//  SCPhotoResultViewController+UI.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import "SCPhotoResultViewController+UI.h"
#import "SCPhotoResultViewController+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCPhotoResultViewController (UI)

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupContentImageView];
    [self setupConfirmButton];
    [self setupCancelButton];
}

- (void)setupContentImageView {
    self.contentImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.contentImageView];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupConfirmButton {
    self.confirmButton = [[UIButton alloc] init];
    self.confirmButton.backgroundColor = [UIColor redColor];
    [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        }
    }];
}

- (void)setupCancelButton {
    self.cancelButton = [[UIButton alloc] init];
    self.cancelButton.backgroundColor = [UIColor blackColor];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self.confirmButton);
        make.right.equalTo(self.confirmButton.mas_left).offset(-30);
    }];
}

@end

#pragma clang diagnostic pop
