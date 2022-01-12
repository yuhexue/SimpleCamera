//
//  SCFilterMaterialViewCell.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <GPUImage.h>

#import "SCFilterHelper.h"
#import "SCFilterManager.h"

#import "SCFilterMaterialViewCell.h"

@interface SCFilterMaterialViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SCFilterMaterialViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private

- (void)commonInit {
    [self setupImageView];
    [self setupTitleLabel];
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 80));
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self);
    }];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - Custom Accessor

- (void)setFilterMaterialModel:(SCFilterMaterialModel *)filterMaterialModel {
    _filterMaterialModel = filterMaterialModel;
    
    UIImage *image = [UIImage imageNamed:@"filter_sample.jpg"];
    GPUImageFilter *filter = [[SCFilterManager shareInstance] filterWithFilterID:filterMaterialModel.filterID];
    self.imageView.image = [SCFilterHelper imageWithFilter:filter
                                               originImage:image];
    
    self.titleLabel.text = filterMaterialModel.filterName;
}

@end






