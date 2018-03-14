//
//  GCTPhotosPickerAppearance.m
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import "GCTPhotosPickerAppearance.h"

@implementation GCTPhotosPickerAppearance

@end
@implementation GCTPhotosPickerAppearance (GCTUIAppearanceCategory)
- (instancetype)init {
    if (self = [super init]) {
        GCTPhotosPickerAppearance *appearance = [GCTPhotosPickerAppearance appearance];
        self.itemsCollectionBackgroundColor = appearance.itemsCollectionBackgroundColor;
        self.headerBottomLineStyle = appearance.headerBottomLineStyle;

        self.headerBottomlineColor = appearance.headerBottomlineColor;
        self.headerBottomLineShadowColor = appearance.headerBottomlineColor;
        
        
        self.headerBackgroundColor = appearance.headerBackgroundColor;
        self.normalTitleColor = appearance.normalTitleColor;
        self.highlightTitleColor = appearance.highlightTitleColor;
        self.disabledTitleColor = appearance.disabledTitleColor;
        self.titleFont = appearance.titleFont;
        self.albumNameChangeAnimated = appearance.albumNameChangeAnimated;

        self.showStatusBar = appearance.showStatusBar;
        self.statusBarStyle = appearance.statusBarStyle;

        self.cancelButtonNormalTitleColor = appearance.cancelButtonNormalTitleColor;
        self.cancelButtonHighlightTitleColor = appearance.cancelButtonHighlightTitleColor;
        self.cancelButtonDisabledTitleColor = appearance.cancelButtonDisabledTitleColor;
        self.cancelButtonTitleFont = appearance.cancelButtonTitleFont;
        
        self.doneButtonTitleFont = appearance.doneButtonTitleFont;
        self.doneButtonNormalTitleColor = appearance.doneButtonNormalTitleColor;
        self.doneButtonHighlightTitleColor = appearance.doneButtonHighlightTitleColor;
        self.doneButtonDisabledTitleColor = appearance.doneButtonDisabledTitleColor;
        
        self.itemsPadding = appearance.itemsPadding;
        self.sigleLineItemsCount = appearance.sigleLineItemsCount;
        self.selectedBadgePosition = appearance.selectedBadgePosition;
        self.showSelectedBadge = appearance.showSelectedBadge;
        
        self.showSelectedBoard = appearance.showSelectedBoard;
        self.selectedBoardColor = appearance.selectedBoardColor;
        self.slelectedBoardWidth = appearance.slelectedBoardWidth;
        
        self.unSlelectedBoardWidth = appearance.unSlelectedBoardWidth;
        self.unSelectedBoardColor = appearance.unSelectedBoardColor;
        
        self.showSubTypeBadge = appearance.showSubTypeBadge;
        self.subTypeBadgePosition = appearance.subTypeBadgePosition;
        
        
        
        self.showSelectedIndexNumberBadge = appearance.showSelectedIndexNumberBadge;
        self.selectedIndexNumberBadgePosition = appearance.selectedIndexNumberBadgePosition;
        self.selectedIndexNumberBadgeBackgroundColor = appearance.selectedIndexNumberBadgeBackgroundColor;
        self.selectedIndexNumberBadgeTitleColor = appearance.selectedIndexNumberBadgeTitleColor;
        self.selectedIndexNumberBadgeCornerRadius = appearance.selectedIndexNumberBadgeCornerRadius;
        
        self.albumCellHeight = appearance.albumCellHeight;
        self.albumViewHeight = appearance.albumViewHeight;

        self.albumCellPickingCountPosition = appearance.albumCellPickingCountPosition;

        self.albumCellTitleFont = appearance.albumCellTitleFont;
        self.albumCellTitleTextColor = appearance.albumCellTitleTextColor;
        self.albumCellTitleFont =appearance.albumCellTitleFont;
        self.albumCellAssetsCountTextFont = appearance.albumCellAssetsCountTextFont;
        self.albumCellAssetsCountTextColor = appearance.albumCellAssetsCountTextColor;

        self.albumCellSeparatorLineColor = appearance.albumCellSeparatorLineColor;
        
        self.albumCellPickingAssetsCountFont = appearance.albumCellPickingAssetsCountFont;
        self.albumCellPickingAssetsCountTextColor = appearance.albumCellPickingAssetsCountTextColor;
        self.albumCellPickingAssetsCountBackgroundColor = appearance.albumCellPickingAssetsCountBackgroundColor;
        self.albumCellPickingAssetsCountCornerRadius = appearance.albumCellPickingAssetsCountCornerRadius;
        self.albumsViewAnimation = appearance.albumsViewAnimation;
        self.topDropdownImage = appearance.topDropdownImage;
        self.selectedImage = appearance.selectedImage;
        self.unSelectedImage = appearance.unSelectedImage;

    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.albumViewHeight <= 0) {
        self.albumViewHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - 64;
    }
}
- (void)setAlbumViewHeight:(CGFloat)albumViewHeight {
    if (albumViewHeight < 0) {
        _albumViewHeight = 0;
    } else {
        _albumViewHeight = albumViewHeight;
    }
}
- (void)setAlbumCellHeight:(CGFloat)albumCellHeight {
    if (albumCellHeight <= 0) {
        _albumCellHeight = 75;
    } else {
        _albumCellHeight = albumCellHeight;
    }
}
- (void)setItemsPadding:(CGFloat)itemsPadding {
    if (itemsPadding < 0) {
        _itemsPadding = 2;
    }else {
        _itemsPadding = itemsPadding;
    }
}
- (void)setSigleLineItemsCount:(NSInteger)sigleLineItemsCount {
    if (sigleLineItemsCount <= 0) {
        _sigleLineItemsCount = 1;
    } else {
        _sigleLineItemsCount = sigleLineItemsCount;
    }
}
- (void)setSlelectedBoardWidth:(CGFloat)slelectedBoardWidth {
    if (slelectedBoardWidth < 0) {
        _slelectedBoardWidth = 8;
    }else {
        _slelectedBoardWidth = slelectedBoardWidth;
    }
}
- (void)setUnSlelectedBoardWidth:(CGFloat)unSlelectedBoardWidth {
    if (unSlelectedBoardWidth < 0) {
        _unSlelectedBoardWidth = 8;
    }else {
        _unSlelectedBoardWidth = unSlelectedBoardWidth;
    }
}
- (void)setSelectedIndexNumberBadgeCornerRadius:(CGFloat)selectedIndexNumberBadgeCornerRadius {
    if (selectedIndexNumberBadgeCornerRadius < 0) {
        _selectedIndexNumberBadgeCornerRadius = 0;
    }else if (selectedIndexNumberBadgeCornerRadius > 10) {
        _selectedIndexNumberBadgeCornerRadius = 10;
    }else{
        _selectedIndexNumberBadgeCornerRadius = selectedIndexNumberBadgeCornerRadius;
    }
}
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _gct_setDefaultAppearance];
    });
}
+ (void)_gct_setDefaultAppearance {
    GCTPhotosPickerAppearance *appearance = [GCTPhotosPickerAppearance appearance];
    appearance.itemsCollectionBackgroundColor = [UIColor whiteColor];
    
    appearance.showStatusBar = YES;
    appearance.statusBarStyle = UIStatusBarStyleDefault;

    appearance.headerBackgroundColor = [UIColor whiteColor];
    appearance.headerBottomLineStyle = GCTPhotosPickerHeaderBottomLineStyleDefault;
    
    appearance.headerBottomlineColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    appearance.headerBottomLineShadowColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    appearance.normalTitleColor = [UIColor blackColor];
    appearance.highlightTitleColor = [UIColor grayColor];
    appearance.disabledTitleColor = [UIColor lightGrayColor];
    appearance.titleFont = [UIFont systemFontOfSize:16];
    appearance.albumNameChangeAnimated = YES;
    
    appearance.cancelButtonTitleFont = [UIFont systemFontOfSize:16];
    appearance.cancelButtonNormalTitleColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];;
    appearance.cancelButtonHighlightTitleColor = [UIColor grayColor];
    appearance.cancelButtonDisabledTitleColor = [UIColor lightGrayColor];
    
    appearance.doneButtonTitleFont = [UIFont systemFontOfSize:16];
    appearance.doneButtonNormalTitleColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];;
    appearance.doneButtonHighlightTitleColor = [UIColor grayColor];
    appearance.doneButtonDisabledTitleColor = [UIColor lightGrayColor];

    
    appearance.itemsPadding = 1;
    appearance.sigleLineItemsCount = 4;
    appearance.selectedBadgePosition = GCTPhotosPickerBadgePositionRightTop;
    appearance.showSelectedBadge = YES;
    
    appearance.showSelectedBoard = YES;
    appearance.slelectedBoardWidth = 4;
    
    appearance.selectedBoardColor = [UIColor colorWithRed:85.f/255 green:171.f/255 blue:228.f/255 alpha:1];
    appearance.unSlelectedBoardWidth = 0;
    appearance.unSelectedBoardColor = [UIColor clearColor];
    
    appearance.showSubTypeBadge = YES;
    appearance.subTypeBadgePosition = GCTPhotosPickerBadgePositionLeftBottom;
    
    
    appearance.showSelectedIndexNumberBadge = YES;
    appearance.selectedIndexNumberBadgePosition = GCTPhotosPickerBadgePositionLeftTop;
    appearance.selectedIndexNumberBadgeBackgroundColor = [UIColor colorWithRed:85.f/255 green:171.f/255 blue:228.f/255 alpha:1];
    appearance.selectedIndexNumberBadgeTitleColor = [UIColor whiteColor];
    appearance.selectedIndexNumberBadgeCornerRadius = 10;

    appearance.albumViewHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    appearance.albumCellHeight = 75;
    
    appearance.albumCellPickingCountPosition = GCTPhotosPickerBadgePositionRightTop;
    appearance.albumCellTitleFont = [UIFont systemFontOfSize:18];
    appearance.albumCellTitleTextColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    appearance.albumCellTitleFont = [UIFont systemFontOfSize:12];

    appearance.albumCellAssetsCountTextFont = [UIFont systemFontOfSize:12];
    appearance.albumCellAssetsCountTextColor = [UIColor blackColor];
    
    appearance.albumCellSeparatorLineColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    appearance.albumCellPickingAssetsCountFont = [UIFont systemFontOfSize:12];
    appearance.albumCellPickingAssetsCountTextColor = [UIColor whiteColor];
    appearance.albumCellPickingAssetsCountBackgroundColor = [UIColor colorWithRed:85.f/255 green:171.f/255 blue:228.f/255 alpha:1];
    appearance.albumCellPickingAssetsCountCornerRadius = 10;
    appearance.albumsViewAnimation = GCTPhotosPickerAlbumsViewAnimationDrop;
    
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:@"GCTPhotosPickerAsset.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *topDropdownImage = [UIImage imageNamed:@"gct_photos_picker_arrow_upload" inBundle:resource_bundle compatibleWithTraitCollection:nil];
    
    UIImage *selectImage = [UIImage imageNamed:@"gct_photos_picker_item_selected" inBundle:resource_bundle compatibleWithTraitCollection:nil];
    UIImage *unSelectImage = [UIImage imageNamed:@"gct_photos_picker_item_unSelected" inBundle:resource_bundle compatibleWithTraitCollection:nil];

    appearance.topDropdownImage = topDropdownImage;
    appearance.selectedImage = selectImage;
    appearance.unSelectedImage = unSelectImage;
}


@end
