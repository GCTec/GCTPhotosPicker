//
//  GCTPhotosPickerAlbumsView.h
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCTPhotosPickerAlbum, GCTPhotosPickerAppearance;
@protocol GCTPhotosPickerAlbumsViewDelegate;
@interface GCTPhotosPickerAlbumsView : UIView
@property (nonatomic, strong) NSArray <GCTPhotosPickerAlbum *>*albums;
@property (nonatomic, strong) GCTPhotosPickerAppearance *appearance;
@property (nonatomic, weak) id<GCTPhotosPickerAlbumsViewDelegate> delegate;
@property (nonatomic, assign, getter=isShow) BOOL show;

- (void)showAlbumAnimation:(void(^)(void))animation completion:(void(^)(void))completion;
- (void)dismissAlbumAnimation:(void(^)(void))animation completion:(void(^)(void))completion;
@end

@protocol GCTPhotosPickerAlbumsViewDelegate <NSObject>
@required
- (void)albumsView:(GCTPhotosPickerAlbumsView *)albumView selectedAlbum:(GCTPhotosPickerAlbum *)album;
@optional
- (void)albumsViewBackViewTapdAction:(GCTPhotosPickerAlbumsView *)albumView;
@end
