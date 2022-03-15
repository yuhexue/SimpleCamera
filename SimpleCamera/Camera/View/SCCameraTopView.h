//
//  SCCameraTopView.h
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import <UIKit/UIKit.h>

@class SCCameraTopView;

@protocol SCCameraTopViewDelegate <NSObject>

- (void)cameraTopViewDidClickRotateButton:(SCCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickFlashButton:(SCCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickCloseButton:(SCCameraTopView *)cameraTopView;

@end

@interface SCCameraTopView : UIView

@property (nonatomic, weak) id<SCCameraTopViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIButton *rotateButton;  // 切换前后置按钮
@property (nonatomic, strong, readonly) UIButton *flashButton;  // 闪光灯按钮
@property (nonatomic, strong, readonly) UIButton *closeButton;  // 关闭按钮

@end
