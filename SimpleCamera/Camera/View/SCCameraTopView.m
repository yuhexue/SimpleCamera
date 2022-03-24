//
//  SCCameraTopView.m
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import "SCCameraTopView.h"

@interface SCCameraTopView()

@property (nonatomic, strong, readwrite) UIButton *rotateButton;
@property (nonatomic, strong, readwrite) UIButton *flashButton;
@property (nonatomic, strong, readwrite) UIButton *closeButton;
@property (nonatomic, assign) BOOL isRotating;

@end


@implementation SCCameraTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.rotateButton = [[UIButton alloc] init];
    [self.rotateButton setImage:[UIImage imageNamed:@"btn_rotato"]
                        forState:UIControlStateNormal];
    [self.rotateButton addTarget:self action:@selector(rotateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.rotateButton];
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
         make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.flashButton = [[UIButton alloc] init];
    [self addSubview:self.flashButton];
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.flashButton addTarget:self
                        action:@selector(flashAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.flashButton setImage:[UIImage imageNamed:@"btn_flash_off"]
                    forState:UIControlStateNormal];
    
    
    self.closeButton = [[UIButton alloc] init];
    self.closeButton.hidden = YES;
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setImage:[UIImage imageNamed:@"btn_close"]
                    forState:UIControlStateNormal];
}

#pragma mark - Action
- (void)rotateAction:(UIButton *)button {
    if (self.isRotating) {
        return;
    }
    self.isRotating = YES;

    [UIView animateWithDuration:0.25f animations:^{
        self.rotateButton.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    } completion:^(BOOL finished) {
        self.rotateButton.transform = CGAffineTransformIdentity;
        self.isRotating = NO;
    }];
    
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickRotateButton:)]) {
        [self.delegate cameraTopViewDidClickRotateButton:self];
    }
}

- (void)flashAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickFlashButton:)]) {
        [self.delegate cameraTopViewDidClickFlashButton:self];
    }
}

- (void)closeAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickCloseButton:)]) {
        [self.delegate cameraTopViewDidClickCloseButton:self];
    }
}

@end
