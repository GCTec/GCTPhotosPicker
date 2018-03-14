//
//  GCTPhotosPickerCachingImageManager.h
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import <Photos/Photos.h>
@class GCTPhotosPickerAlbum;

typedef NS_ENUM(NSInteger, GCTPhotosPickerCachingImageType) {
    GCTPhotosPickerCachingImageTypeMedias = 0,
    GCTPhotosPickerCachingImageTypePhotos,
    GCTPhotosPickerCachingImageTypeVideos
};

@interface GCTPhotosPickerCachingImageManager : PHCachingImageManager
+ (GCTPhotosPickerCachingImageManager *)defaultManager;

/**
 获取asset的缩略图
 
 @param asset     asset
 @param completed 缩略图获取的block回调
 */
- (void)requestThumbnailImage:(PHAsset *)asset completed:(void(^)(UIImage *, NSDictionary *))completed;

/**
 获取一组asset的缩略图
 
 @param assets    assets
 @param completed 一组缩略图获取的block
 */
- (void)requestThumbnailImages:(NSArray<PHAsset *> *)assets completed:(void(^)(NSArray <UIImage *> *, NSArray <NSDictionary *> *))completed;

/**
 获取asset预览图
 
 @param asset     asset
 @param completed 预览图获取的block回调
 */
- (void)requestPreviewImage:(PHAsset *)asset completed:(void(^)(UIImage *, NSDictionary *))completed;

/**
 获取一组asset的预览图
 
 @param assets    assets
 @param completed 一组预览图获取的block回调
 */
- (void)requestPreviewImages:(NSArray<PHAsset *> *)assets completed:(void(^)(NSArray <UIImage *> *, NSArray <NSDictionary *> *))completed;

/**
 获取一个asset的原始图片
 
 @param asset     asset
 @param completed 原始图片获取的block回调
 */
- (void)requestOrignalImage:(PHAsset *)asset completed:(void(^)(UIImage *, NSDictionary *))completed;

/**
 获取一组assets的原图
 
 @param assets    assets
 @param completed 原图获取的block回调
 */
- (void)requestOrignalImages:(NSArray<PHAsset *> *)assets completed:(void(^)(NSArray <UIImage *> *, NSArray <NSDictionary *> *))completed;

/**
 获取单个图片
 
 @param asset               图片的asset
 @param targetSize          获取图片的targetSize
 @param contentMode         获取图片的contentMode
 @param imageRequestOptions 获取图片的options
 @param completed           获取图片的block
 */
- (void)requestImage:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)imageRequestOptions completed:(void(^)(UIImage *, NSDictionary *))completed;

/**
 获取一组图片

 @param assets              一组图片的asset
 @param targetSize          获取图片的targetSize
 @param contentMode         获取图片的contentMode
 @param imageRequestOptions 获取图片的options
 @param completed           获取图片结束的block回调
 */
- (void)requestImages:(NSArray<PHAsset *> *)assets targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)imageRequestOptions completed:(void(^)(NSArray <UIImage *> *, NSArray <NSDictionary *> *))completed;

/**
 清理掉缓存
 */
- (void)removeAllCaches;

/**
 读取相册的权限

 @param completed 是否有读取相册的权限
 */
+ (void)libraryAuthorizationCompleted:(void(^)(BOOL))completed;

/**
 获取所需要的相册
 
 @param completion 获取相册的block回调
 */
+ (void)getAlbumsWithType:(GCTPhotosPickerCachingImageType)type completion:(void (^)(BOOL ret, NSArray <GCTPhotosPickerAlbum *> *))completion;

/**
 获取相机相册
 
 @return 相机相册数组
 */
+ (GCTPhotosPickerAlbum *)cameraAlbumWithType:(GCTPhotosPickerCachingImageType)type;

/**
 获取截屏相册
 
 @return 截屏相册
 */
+ (GCTPhotosPickerAlbum *)screenshotsAlbumWithType:(GCTPhotosPickerCachingImageType)type;

/**
 获取同步相册
 
 @return 同步相册数组
 */
+ (NSArray <GCTPhotosPickerAlbum *> *)syncedAlbumsWithType:(GCTPhotosPickerCachingImageType)type;
@end
