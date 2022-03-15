//
//  SCFilterMaterialViewCell.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@interface SCFilterMaterialViewCell : UICollectionViewCell

@property (nonatomic, strong) SCFilterMaterialModel *filterMaterialModel;
@property (nonatomic, assign) BOOL isSelect;

@end
