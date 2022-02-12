//
//  SCCameraTopView.m
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import "SCCameraTopView.h"

@interface SCCameraTopView()

@property (nonatomic, strong) UIButton *rotateButton;
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

@end
