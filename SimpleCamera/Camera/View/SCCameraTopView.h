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

@end

@interface SCCameraTopView : UIView

@property (nonatomic, weak) id<SCCameraTopViewDelegate> delegate;

@end
