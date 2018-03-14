//
//  GCTPhotosPickerItemCell.h
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@protocol GCTPhotosPickerItemCellDelegate;
@interface GCTPhotosPickerItemCell : UICollectionViewCell
@property (nonatomic, weak) id<GCTPhotosPickerItemCellDelegate> delegate;
@property (nonatomic, strong) PHAsset *asset;

@end

@protocol GCTPhotosPickerItemCellDelegate <NSObject>
- (void)pickerItemCell:(GCTPhotosPickerItemCell *)cell didSelected:(BOOL)selected;
- (void)pickerItemCellSelectedButtonClicked:(GCTPhotosPickerItemCell *)cell;
@end
