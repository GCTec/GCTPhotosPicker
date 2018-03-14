//
//  GCTPhotosPickerCachingImageManager.m
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import "GCTPhotosPickerCachingImageManager.h"
#import "GCTPhotosPicker.h"
#import "GCTPhotosPickerAlbum.h"

@interface GCTPhotosPickerCachingImageManager ()
@property (nonatomic, strong) NSCache *disorderlyImageCache;
@property (nonatomic, strong) NSCache *disorderlyImageInfo;
@end
@implementation GCTPhotosPickerCachingImageManager
+ (GCTPhotosPickerCachingImageManager *)defaultManager {
    GCTPhotosPickerCachingImageManager *manager = (GCTPhotosPickerCachingImageManager *)[super defaultManager];
    if (manager) {
        [manager _gct_addNotification];
    }
    return manager;
}
- (void)dealloc {
    [self _gct_removeNotification];
}
- (void)requestThumbnailImage:(PHAsset *)asset completed:(void(^)(UIImage *, NSDictionary *))completed{
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    CGSize imageSize = CGSizeMake(75 * [UIScreen mainScreen].scale, 75 * [UIScreen mainScreen].scale);
    [self requestImage:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:imageRequestOptions completed:completed];
    
}
- (void)requestThumbnailImages:(NSArray<PHAsset *> *)assets completed:(void(^)(NSArray <UIImage *> *, NSArray <NSDictionary *> *))completed {
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *infos = [NSMutableArray new];
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        [self requestThumbnailImage:asset completed:^(UIImage *image, NSDictionary *info) {
            [images addObject:image];
            [infos addObject:info];
            if (images.count == assets.count && infos.count == assets.count) {
                !completed ?: completed(images, infos);
            }
        }];
    }
}
- (void)requestPreviewImage:(PHAsset *)asset completed:(void(^)(UIImage *, NSDictionary *))completed {
    
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [self requestImage:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:imageRequestOptions completed:completed];
    
}
- (void)requestPreviewImages:(NSArray<PHAsset *> *)assets completed:(void(^)(NSArray <UIImage *> *, NSArray <NSDictionary *> *))completed{
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *infos = [NSMutableArray new];
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];

        [self requestPreviewImage:asset completed:^(UIImage *image, NSDictionary *info) {
            [images addObject:image];
            [infos addObject:info];
            if (images.count == assets.count && infos.count == assets.count) {
                !completed ?: completed(images, infos);
            }
        }];
    }
}
- (void)requestOrignalImage:(PHAsset *)asset completed:(void(^)(UIImage *, NSDictionary *))completed {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [self requestImage:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:imageRequestOptions completed:completed];
}

- (void)requestOrignalImages:(NSArray<PHAsset *> *)assets completed:(void(^)(NSArray <UIImage *> *, NSArray <NSDictionary *> *))completed {
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *infos = [NSMutableArray new];
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];

        [self requestOrignalImage:asset completed:^(UIImage *image, NSDictionary *info) {
            [images addObject:image];
            [infos addObject:info];
            if (images.count == assets.count && infos.count == assets.count) {
                !completed ?: completed(images, infos);
            }
        }];
    }
}
- (void)requestImage:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)imageRequestOptions completed:(void(^)(UIImage *, NSDictionary *))completed{
    NSString *key = [NSString stringWithFormat:@"%@%f%f%ld%@",asset.localIdentifier,targetSize.width,targetSize.height,(long)contentMode,imageRequestOptions];
    UIImage *image = [self.disorderlyImageCache objectForKey:key];
    NSDictionary *info = [self.disorderlyImageInfo objectForKey:key];
    if (image && info) {
        !completed ?: completed(image, info);
    } else {
     
        [self requestImageForAsset:asset
                        targetSize:targetSize
                       contentMode:contentMode
                           options:imageRequestOptions
                     resultHandler:^(UIImage *result, NSDictionary *info) {
                         
                         BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                         if (info && downloadFinined) {
                             if ([result isKindOfClass:[UIImage class]]) {
                                 NSString *key = [NSString stringWithFormat:@"%@%f%f%ld%@",asset.localIdentifier,targetSize.width,targetSize.height,(long)contentMode,imageRequestOptions];
                                  [self.disorderlyImageCache setObject:result forKey:key];
                                 [self.disorderlyImageInfo setObject:info forKey:key];
                             }
                             !completed ?: completed(result, info);
                         }
                     }];
    }
}

- (void)requestImages:(NSArray<PHAsset *> *)assets targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)imageRequestOptions completed:(void(^)(NSArray <UIImage *> *, NSArray <NSDictionary *> *))completed{
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *infos = [NSMutableArray new];
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];

        [self requestImage:asset targetSize:targetSize contentMode:contentMode options:imageRequestOptions completed:^(UIImage * image, NSDictionary * info) {
            [images addObject:image];
            
            [infos addObject:info];
            if (images.count == assets.count && infos.count == assets.count) {
                !completed ?: completed(images, infos);
            }
        }];
    }
}
+ (void)getAlbumsWithType:(GCTPhotosPickerCachingImageType)type completion:(void (^)(BOOL ret, NSArray <GCTPhotosPickerAlbum *> *))completion{
    NSMutableArray <GCTPhotosPickerAlbum *> *albums = [[NSMutableArray alloc] init];
    
    //添加相机相册
    GCTPhotosPickerAlbum *cameraAlbum = [self cameraAlbumWithType:type];
    if (cameraAlbum) {
        [albums addObject:cameraAlbum];
    }
    if (@available(iOS 9.0, *)) {
        //添加屏幕截屏相册
        GCTPhotosPickerAlbum *screenAlbum = [self screenshotsAlbumWithType:type];
        if (screenAlbum) {
            [albums addObject:screenAlbum];
        }
    }
    //添加同步的相册
    [albums addObjectsFromArray:[self syncedAlbumsWithType:type]];
    !completion ?: completion(YES, albums);
}
+ (GCTPhotosPickerAlbum *)cameraAlbumWithType:(GCTPhotosPickerCachingImageType)type {
    PHFetchResult  *cameraFetch = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                           subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                           options:nil];
    PHAssetCollection *assetCollection  = [cameraFetch lastObject];
    PHFetchResult *fetchR    = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                             options:[self _gct_optionsWithType:type]];
    GCTPhotosPickerAlbum *obj = [[GCTPhotosPickerAlbum alloc] init];
    obj.albumCollectionSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    obj.albumName = assetCollection.localizedTitle;
    obj.albumPhotosCount = fetchR.count;
    obj.albumFetch = fetchR;
    if(obj.albumPhotosCount)
        return obj;
    return nil;
}
+ (GCTPhotosPickerAlbum *)screenshotsAlbumWithType:(GCTPhotosPickerCachingImageType)type {
    if (@available(iOS 9.0, *)) {

    PHFetchResult  *screenShot = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots
                                                                          options:nil];
    PHAssetCollection *assetCollection = [screenShot lastObject];
    PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                         options:[self _gct_optionsWithType:type]];
    GCTPhotosPickerAlbum *sObj = [[GCTPhotosPickerAlbum alloc] init];
        sObj.albumCollectionSubtype = PHAssetCollectionSubtypeSmartAlbumScreenshots;
    sObj.albumName = assetCollection.localizedTitle;
    sObj.albumPhotosCount = fetch.count;
    sObj.albumFetch = fetch;
    if(sObj.albumPhotosCount)
        return sObj;
        return nil;
    } else {
        return nil;
    }
}
+ (NSArray <GCTPhotosPickerAlbum *> *)syncedAlbumsWithType:(GCTPhotosPickerCachingImageType)type {
    NSMutableArray <GCTPhotosPickerAlbum *> *fetchs = [NSMutableArray new];
    PHAssetCollectionSubtype subtype = PHAssetCollectionSubtypeAlbumSyncedAlbum | PHAssetCollectionSubtypeAlbumRegular;
    PHFetchResult *assetCollectionTypeAlbum  = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                                        subtype:subtype
                                                                                        options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollectionTypeAlbum)
    {
        @autoreleasepool
        {
            PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                 options:[self _gct_optionsWithType:type]];
            
            GCTPhotosPickerAlbum *obj = [GCTPhotosPickerAlbum new];
            obj.albumCollectionSubtype = assetCollection.assetCollectionSubtype;
            obj.albumName = assetCollection.localizedTitle;
            obj.albumFetch = fetch;
            obj.albumPhotosCount = fetch.count;
            
            if (fetch.count > 0)
                [fetchs addObject:obj]; // drop empty album
        }
    }
    return fetchs;
}
+ (PHFetchOptions *)_gct_optionsWithType:(GCTPhotosPickerCachingImageType)type{
    PHFetchOptions *options   = [[PHFetchOptions alloc] init];
    switch (type) {
        case GCTPhotosPickerCachingImageTypeVideos:
        {
            options.predicate         = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeVideo];

        }
            break;
        case GCTPhotosPickerCachingImageTypePhotos:
        {
            options.predicate         = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];

        }
            break;
        case GCTPhotosPickerCachingImageTypeMedias:
        default:
        {
            options.predicate         = [NSPredicate predicateWithFormat:@"mediaType = %d || mediaType = %d", PHAssetMediaTypeImage, PHAssetMediaTypeVideo];

        }
            break;
    }
    options.sortDescriptors   = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    return options;
}
+ (void)libraryAuthorizationCompleted:(void(^)(BOOL))completed {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
            
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    switch (status) {
                        case PHAuthorizationStatusAuthorized: {
                            !completed ?: completed(YES);
                            break;
                        }
                        default: {
                            !completed ?: completed(NO);
                            break;
                        }
                    }
                });

            }];
            
            break;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied: {
            dispatch_async(dispatch_get_main_queue(), ^{

            !completed ?: completed(NO);
            });
            break;
        }
        case PHAuthorizationStatusAuthorized:
        default: {
            dispatch_async(dispatch_get_main_queue(), ^{

            !completed ?: completed(YES);
            });
            break;
        }
    }

}
- (void)_gct_addNotification {
    // Subscribe to app events
    [self _gct_removeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAllCaches)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAllCaches)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAllCaches)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}
- (void)_gct_removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)removeAllCaches {
    [self.disorderlyImageCache removeAllObjects];
}

- (NSCache *)disorderlyImageCache {
    if (!_disorderlyImageCache) {
        _disorderlyImageCache = [[NSCache alloc] init];
        _disorderlyImageCache.totalCostLimit = 3;
    }
    return _disorderlyImageCache;
}
- (NSCache *)disorderlyImageInfo {
    if (!_disorderlyImageInfo) {
        _disorderlyImageInfo = [[NSCache alloc] init];
        _disorderlyImageInfo.totalCostLimit = 3;
    }
    return _disorderlyImageInfo;
}
@end
