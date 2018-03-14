//
//  GCTPhotosPickerViewController.h
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 选取资源类型

 - GCTPhotosPickerTypeMedias: 资源类型包含图片和视频，相册显示图片和视频
 - GCTPhotosPickerTypePhotos: 资源类型仅包含图片，相册只显示图片
 - GCTPhotosPickerTypeVideos: 资源类型仅包含视频，相册只显示视频
 */
typedef NS_ENUM(NSInteger, GCTPhotosPickerType) {
    GCTPhotosPickerTypeMedias = 0,
    GCTPhotosPickerTypePhotos,
    GCTPhotosPickerTypeVideos,
};

@class GCTPhotosPickerAppearance,PHAsset, PHFetchResult;
@protocol GCTPhotosPickerDelegate;
@interface GCTPhotosPickerViewController : UIViewController

/**
 选择代理回调
 */
@property (nonatomic, weak) id<GCTPhotosPickerDelegate> delegate;

/**
 选择样式配置
 */
@property (nonatomic, strong) GCTPhotosPickerAppearance *appearance;

/**
 已选择资源组
 
 如果在显示pickerVC之前配置该项，则会在pickerVC的item显示时，自动配置已选择项置为选择状态；否则，不会配置已选择项。
 */
@property (nonatomic, strong) NSMutableArray <PHAsset *>*pickingAssets;

/**
 配置选取资源类型
 */
@property (nonatomic, assign) GCTPhotosPickerType pickerType ;

/**
 在type配置为：GCTPhotosPickerTypePhotos，设置 maximumNumberOfSelectionPhotos 限制选择数量；
 在type配置为：GCTPhotosPickerTypeVideos，设置 maximumNumberOfSelectionVideos 限制选择数量；
 在type配置为：GCTPhotosPickerTypeMedias，设置 maximumNumberOfSelectionMedias 限制选择数量。
 */
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionPhotos;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionVideos;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionMedias;


@end

@protocol GCTPhotosPickerDelegate <NSObject>
@required
/**
 资源选择器选择资源点击完成
 
 @param photosPicker 资源选择器
 @param pickingAssets 已经选择资源组
 */
- (void)photosPicker:(GCTPhotosPickerViewController *)photosPicker didFinishedPickingAssets:(NSMutableArray <PHAsset *> *)pickingAssets;

@optional
/**
 资源选择器已选择达到最大值的回调

 @param picker 资源选择器
 */
- (void)photosPickerDidExceedMaximumNumberOfSelection:(GCTPhotosPickerViewController *)picker;

/**
 资源选择器取消选择资源

 @param picker 资源选择器
 */
- (void)photosPickerDidCanceled:(GCTPhotosPickerViewController *)picker;

/**
 资源选择器选择失败

 @param picker 资源选择器
 */
- (void)photosPickerDidFaildPicking:(GCTPhotosPickerViewController *)picker;
@end
