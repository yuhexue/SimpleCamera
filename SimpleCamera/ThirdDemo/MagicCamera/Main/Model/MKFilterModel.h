//
//  MKFilterModel.h
//  MagicCamera
//
//  Created by mkil on 2019/9/4.
//  Copyright © 2019 黎宁康. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKFilterType)
{
    MKFilterTypeBeauty,         // 磨皮、瘦脸等
    MKFilterTypeStyle,          // 风格滤镜
    MKFilterTypeEffects         // 人脸特效
};

@interface MKNodeModel : NSObject
/// 模型类型
@property (nonatomic, strong) NSString *type;
/// 存放素材的文件夹名称 (素材目录下图片格式 dirname_000.png)
@property (nonatomic, strong) NSString *dirname;
/// 图片素材文件路径
@property (nonatomic, strong) NSString *filePath;
/// 贴纸中心点
@property (nonatomic, assign) NSInteger facePos;
/// 人脸起始位置
@property (nonatomic, assign) NSInteger startIndex;
/// 人脸结束位置，起始位置和结束位置用于求人脸宽度的
@property (nonatomic, assign) NSInteger endIndex;
/// 贴纸x轴偏移量
@property (nonatomic, assign) float offsetX;
/// 贴纸y轴偏移量
@property (nonatomic, assign) float offsetY;
/// 贴纸缩放倍数(相对于人脸)
@property (nonatomic, assign) float ratio;
/// 素材图片的个数
@property (nonatomic, assign) NSInteger number;
/// 素材图片的分辨率，同一个dirname下的素材图片分辨率要一致
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
/// 该dirname下所有的素材图片，每张图片的播放时间，以毫秒为单位。不同dirname下的素材图片的duration可以不同。
@property (nonatomic, assign) NSInteger duration;
/// 该dirname下所有素材图片都播放完一遍之后，是否重新循环播放。1：循环播放，0：不循环播放。
@property (nonatomic, assign) NSInteger isloop;
/// 最多支持人脸数
@property (nonatomic, assign) NSInteger maxcount;
@end

@interface MKFilterModel : NSObject

@property (nonatomic, assign) MKFilterType type;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) BOOL isAdjust;
@property (nonatomic, assign) float currentAlphaValue;
@property (nonatomic, strong) NSArray<NSString *> *textureImages;

@property (nonatomic, strong) NSArray<MKNodeModel *> *nodes;


+ (NSArray<MKFilterModel *> *)buildFilterModelsWithPath:(NSString *)path whitType:(MKFilterType)type;

@end

NS_ASSUME_NONNULL_END
