//
//  SCVideoResultViewController+UI.m
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import "SCVideoResultViewController+Private.h"
#import "SCVideoResultViewController+UI.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCVideoResultViewController (UI)

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPlayerContainerView];
    [self setupConfirmButton];
    [self setupCancelButton];
    
    [self.view layoutIfNeeded];
}

- (void)setupPlayerContainerView {
    self.playerContainerView = [[UIView alloc] init];
    [self.view addSubview:self.playerContainerView];
    [self.playerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupConfirmButton {
    self.confirmButton = [[UIButton alloc] init];
    [self.confirmButton setImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
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
    [self.cancelButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    UIView *layoutGuide = [[UIView alloc] init];
    layoutGuide.userInteractionEnabled = NO;
    [self.view addSubview:layoutGuide];
    [layoutGuide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.confirmButton.mas_left);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(self.confirmButton);
        make.centerX.equalTo(layoutGuide);
    }];
}

@end

#pragma clang diagnostic pop
