//
//  GCTPhotosPickerItemCell_Extension.h
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import "GCTPhotosPickerItemCell.h"
#import "GCTPhotosPickerAppearance.h"

@interface GCTPhotosPickerItemCell ()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, assign) NSInteger index;
- (void)showCover;
- (void)hideCover;
- (void)selected:(BOOL)selected animated:(BOOL)animated;
@property (nonatomic, strong) GCTPhotosPickerAppearance *itemAppearance;
@end
