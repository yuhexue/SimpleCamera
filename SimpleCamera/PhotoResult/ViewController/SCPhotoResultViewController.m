//
//  SCPhotoResultViewController.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCPhotoResultViewController.h"
#import "SCPhotoResultViewController+Private.h"
#import <Photos/Photos.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

static NSString* const kSimpleCameraAlbumName = @"SimpleCamera";

@implementation SCPhotoResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    self.contentImageView.image = self.resultImage;
}

- (void)dealloc {
     [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
 }

- (void)backToCamera {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Action
- (void)confirmAction:(id)sender {
    @weakify(self);
    [self writeImageToPhotosAlbum:self.resultImage completion:^(BOOL success) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self backToCamera];
                [self.view.window makeToast:@"保存成功"];
            } else {
                [self.view.window makeToast:@"保存失败"];
            }
        });
    }];
}

- (void)cancelAction:(id)sender {
    [self backToCamera];
}

#pragma mark - PhotosAlbum
// 保存图片到相册
- (void)writeImageToPhotosAlbum:(UIImage *)image completion:(void (^)(BOOL success))completion {
    if (!image) {
        NSLog(@"writeImageToSavedPhotosAlbum image is nil");
        return ;
    }
    PHAssetCollection *asset = [self creatPHAssetWithAlbumName:kSimpleCameraAlbumName];
    if (asset) {
        [self saveImageToAlbumWithName:kSimpleCameraAlbumName image:image completion:completion];
    }
}

- (void)saveImageToAlbumWithName:(NSString *)albumName image:(UIImage *)image completion:(void (^)(BOOL success))completion {
    //检查相册权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        [self saveImageWithImage:image albumName:albumName completion:completion];
    } else if (status == PHAuthorizationStatusDenied) {
        [self.view.window makeToast:@"请打开访问相册的权限"];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImageWithImage:image albumName:albumName completion:completion];
            }
        }];
    } else if (status == PHAuthorizationStatusRestricted) {
        [self.view.window makeToast:@"由于系统原因, 无法访问相册"];
    }
}

- (void)saveImageWithImage:(UIImage *)image albumName:(NSString *)albumName completion:(void (^)(BOOL success))completion {
    // PhotoLibrary 整个照片库（里面会有很多相册）
    // PHAssetCollection : 一个相簿 （也可以说是一个相册）
    // PHAsset : 一个资源，一个图片
    __block NSString *assetLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //1,先将图片添加到默认的相机胶卷（系统默认相册）
        assetLocalIdentifier = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@"saveImage to localIdentifier error: %s",error.description.UTF8String);
            if (completion) {
                completion(success);
            }
            return ;
        }
        
        //2,获取自定义相册
        PHAssetCollection *creatAssetCollection = [self creatPHAssetWithAlbumName:albumName];
        if (!creatAssetCollection) {
            NSLog(@"创建相册失败");
            if (completion) {
                completion(success);
            }
            return ;
        }
        
        //3，将图片从相机胶卷迁移到自定义相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:creatAssetCollection];
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                NSLog(@"saveImage to customIdentifier error: %s",error.description.UTF8String);
            }
    
            if (completion) {
                completion(success);
            }
        }];
    }];
}

- (PHAssetCollection *)creatPHAssetWithAlbumName:(NSString *)albumName {
    //从已经存在的相簿中查找应用对应的相册
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in assetCollections) {
        if ([collection.localizedTitle isEqualToString:albumName]) {
            return collection;
        }
    }
    //没找到，就创建新的相簿
    NSError *error;
    __block NSString *assetCollectionLocalIdentifier = nil;
    //这里用wait请求，保证创建成功相册后才保存进去
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        return nil;
    }
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}

@end

#pragma clang diagnostic pop

