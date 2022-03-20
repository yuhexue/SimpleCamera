//
//  SCFilterManager.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <GPUImage.h>
#import <Foundation/Foundation.h>
#import "SCFilterMaterialModel.h"

@interface SCFilterManager : NSObject

/// GPUImage 自带滤镜列表
@property (nonatomic, strong, readonly) NSArray<SCFilterMaterialModel *> *defaultFilters;
/// 抖音滤镜列表
@property (nonatomic, strong, readonly) NSArray<SCFilterMaterialModel *> *tiktokFilters;
/// 分屏滤镜列表
@property (nonatomic, strong, readonly) NSArray<SCFilterMaterialModel *> *splitFilters;

/**
 获取实例
 */
+ (SCFilterManager *)shareInstance;

/**
 通过滤镜 ID 返回滤镜对象
 */
- (GPUImageFilter *)filterWithFilterID:(NSString *)filterID;

@end
