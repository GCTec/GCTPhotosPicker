//
//  GCTPhotosPickerAlbum.h
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PhotosTypes.h>

@class UIImage,PHFetchResult,PHAsset;

@interface GCTPhotosPickerAlbum : NSObject

/**
 相册名字
 */
@property (nonatomic, copy) NSString  *albumName;

/**
 相册的封面图（取相册内相片的最近一张图片的缩略图）
 */
@property (nonatomic, strong) UIImage   *albumThumbnailImage;

/**
 相册的总图片数
 */
@property (nonatomic, assign) NSInteger  albumPhotosCount;

/**
 相册的subType
 */
@property (nonatomic, assign) PHAssetCollectionSubtype albumCollectionSubtype;

/**
 相册图片AssetFetch
 */
@property (nonatomic, strong) PHFetchResult * albumFetch;

/**
 已选择 assets
 */
@property (nonatomic, strong) NSMutableArray <PHAsset *>*pickingAssets;
@end
