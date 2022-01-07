//
//  SCCapturingButton.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCCapturingButton.h"

@implementation SCCapturingButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

#pragma mark - Private

- (void)commonInit {
    [self setImage:[UIImage imageNamed:@"btn_capture"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)touchUpInsideAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(capturingButtonDidClicked:)]) {
        [self.delegate capturingButtonDidClicked:self];
    }
}

@end
