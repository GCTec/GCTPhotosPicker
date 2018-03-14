//
//  GCTPhotosPickerAlbumsCell.h
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCTPhotosPickerAlbum, GCTPhotosPickerAppearance;
@interface GCTPhotosPickerAlbumsCell : UITableViewCell
@property (nonatomic, strong) GCTPhotosPickerAppearance *appearance;
@property (nonatomic, strong) GCTPhotosPickerAlbum *album;
@end
