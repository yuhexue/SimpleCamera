//
//  SCCapturingModeSwitchView.h
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import <UIKit/UIKit.h>

 typedef NS_ENUM(NSUInteger, SCCapturingModeSwitchType) {
     SCCapturingModeSwitchTypeImage,
     SCCapturingModeSwitchTypeVideo
 };

 @class SCCapturingModeSwitchView;

 @protocol SCCapturingModeSwitchViewDelegate <NSObject>

 - (void)capturingModeSwitchView:(SCCapturingModeSwitchView *)view
                 didChangeToType:(SCCapturingModeSwitchType)type;

 @end

 @interface SCCapturingModeSwitchView : UIView

 @property (nonatomic, assign, readonly) SCCapturingModeSwitchType type;

 @property (nonatomic, weak) id <SCCapturingModeSwitchViewDelegate> delegate;

 @end
