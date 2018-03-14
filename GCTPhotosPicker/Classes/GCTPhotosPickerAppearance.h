//
//  GCTPhotosPickerAppearance.h
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GCTPhotosPickerBadgePosition) {
    GCTPhotosPickerBadgePositionLeftTop = 0,
    GCTPhotosPickerBadgePositionLeftBottom,
    GCTPhotosPickerBadgePositionRightTop,
    GCTPhotosPickerBadgePositionRightBottom,
    GCTPhotosPickerBadgePositionNone
};
typedef NS_ENUM(NSInteger, GCTPhotosPickerAlbumsViewAnimation) {
    GCTPhotosPickerAlbumsViewAnimationDrop = 0,
    GCTPhotosPickerAlbumsViewAnimationSpread,
};

typedef NS_ENUM(NSInteger, GCTPhotosPickerHeaderBottomLineStyle) {
    GCTPhotosPickerHeaderBottomLineStyleLine = 0,
    GCTPhotosPickerHeaderBottomLineStyleShadow = 1,
    GCTPhotosPickerHeaderBottomLineStyleNone = 2,
    GCTPhotosPickerHeaderBottomLineStyleDefault = GCTPhotosPickerHeaderBottomLineStyleShadow,

};
@interface GCTPhotosPickerAppearance : UIView

/**
 设置照片视图背景色
 
 默认：whiteColor
 */
@property (nonatomic, strong) UIColor *itemsCollectionBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 设置头部视图背景色
 
 默认：whiteColor
 */
@property (nonatomic, strong) UIColor *headerBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 设置头部视图底线样式
 
 默认：GCTPhotosPickerHeaderBottomLineStyleDefault
 */
@property (nonatomic, assign) GCTPhotosPickerHeaderBottomLineStyle headerBottomLineStyle UI_APPEARANCE_SELECTOR;

/**
 头部视图底线样式为：GCTPhotosPickerHeaderBottomLineStyleLine时，底线颜色
 
 默认：R:0.9,G:0.9,B:0.9
 */
@property (nonatomic, strong) UIColor *headerBottomlineColor UI_APPEARANCE_SELECTOR;

/**
 头部视图底线样式为：GCTPhotosPickerHeaderBottomLineStyleShadow时，阴影颜色

 默认：R:0.9,G:0.9,B:0.9
 */
@property (nonatomic, strong) UIColor *headerBottomLineShadowColor UI_APPEARANCE_SELECTOR;

/**
 标题常态颜色
 
 默认：blackColor
 */
@property (nonatomic, strong) UIColor *normalTitleColor UI_APPEARANCE_SELECTOR;

/**
 标题高亮颜色
 
 默认：gray
 */
@property (nonatomic, strong) UIColor *highlightTitleColor UI_APPEARANCE_SELECTOR;

/**
 标题不可点击颜色
 
 默认：lightGray
 */
@property (nonatomic, strong) UIColor *disabledTitleColor UI_APPEARANCE_SELECTOR;

/**
 标题字体
 
 默认：systemFont:16
 */
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;

/**
 相册选择结束后，改变相册名字是否需要动画
 
 默认：YES
 */
@property (nonatomic, assign) BOOL albumNameChangeAnimated UI_APPEARANCE_SELECTOR;

/**
 是否显示状态栏
 
 默认：YES
 */
@property (nonatomic, assign) BOOL showStatusBar UI_APPEARANCE_SELECTOR;

/**
 状态栏样式
 
 默认：UIStatusBarStyleDefault
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle UI_APPEARANCE_SELECTOR;

/**
 取消按钮常态颜色
 
 默认：R：0.4，G：0.4，B：0.4
 */
@property (nonatomic, strong) UIColor *cancelButtonNormalTitleColor UI_APPEARANCE_SELECTOR;

/**
 取消按钮高亮颜色
 
 默认：GrayColor
 */
@property (nonatomic, strong) UIColor *cancelButtonHighlightTitleColor UI_APPEARANCE_SELECTOR;

/**
 取消按钮不可操作颜色
 
 默认：lightGrayColor
 */
@property (nonatomic, strong) UIColor *cancelButtonDisabledTitleColor UI_APPEARANCE_SELECTOR;

/**
 取消按钮字体
 
 默认：SystemFont:16
 */
@property (nonatomic, strong) UIFont *cancelButtonTitleFont UI_APPEARANCE_SELECTOR;

/**
 完成按钮常态颜色
 
 默认：R：0.4，G：0.4，B：0.4
 */
@property (nonatomic, strong) UIColor *doneButtonNormalTitleColor UI_APPEARANCE_SELECTOR;

/**
 完成按钮高亮颜色
 
 默认：GrayColor
 */
@property (nonatomic, strong) UIColor *doneButtonHighlightTitleColor UI_APPEARANCE_SELECTOR;

/**
 完成按钮不可操作颜色
 
 默认：lightGrayColor
 */
@property (nonatomic, strong) UIColor *doneButtonDisabledTitleColor UI_APPEARANCE_SELECTOR;

/**
 完成按钮字体
 
 默认：SystemFont:16
 */
@property (nonatomic, strong) UIFont *doneButtonTitleFont UI_APPEARANCE_SELECTOR;

/**
 图片间隙
 
 默认：2
 */
@property (nonatomic, assign) CGFloat itemsPadding UI_APPEARANCE_SELECTOR;

/**
 每行显示图片格式
 
 默认：4
 */
@property (nonatomic, assign) NSInteger sigleLineItemsCount UI_APPEARANCE_SELECTOR;

/**
 选中按钮位置
 
 默认：GCTPhotosPickerBadgePositionRightTop
 */
@property (nonatomic, assign) GCTPhotosPickerBadgePosition selectedBadgePosition UI_APPEARANCE_SELECTOR;

/**
 显示选中按钮
 
 默认：YES
 */
@property (nonatomic, assign) BOOL showSelectedBadge UI_APPEARANCE_SELECTOR;

/**
 子类型图标位置
 
 默认：GCTPhotosPickerBadgePositionLeftBottom
 */
@property (nonatomic, assign) GCTPhotosPickerBadgePosition subTypeBadgePosition UI_APPEARANCE_SELECTOR;

/**
 显示子类型图标
 
 默认：YES
 */
@property (nonatomic, assign) BOOL showSubTypeBadge UI_APPEARANCE_SELECTOR;

/**
 选中 indexNumber 位置
 
 默认：GCTPhotosPickerBadgePositionLeftTop
 */
@property (nonatomic, assign) GCTPhotosPickerBadgePosition selectedIndexNumberBadgePosition UI_APPEARANCE_SELECTOR;

/**
 选中 indexNumber 标示背景颜色
 
 默认：[UIColor colorWithRed:85.f/255 green:171.f/255 blue:228.f/255 alpha:1]
 */
@property (nonatomic, strong) UIColor *selectedIndexNumberBadgeBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 选中 indexNumber 标示字体颜色
 
 默认：whiteColor
 */
@property (nonatomic, strong) UIColor *selectedIndexNumberBadgeTitleColor UI_APPEARANCE_SELECTOR;

/**
 选中 indexNumber 圆角 （0~10）
 
 默认：10
 */
@property (nonatomic, assign) CGFloat selectedIndexNumberBadgeCornerRadius UI_APPEARANCE_SELECTOR;
/**
 是否显示选中 indexNumber
 
 默认：YES
 */
@property (nonatomic, assign) BOOL showSelectedIndexNumberBadge UI_APPEARANCE_SELECTOR;

/**
 选中图片边框宽度
 
 默认：5
 */
@property (nonatomic, assign) CGFloat slelectedBoardWidth UI_APPEARANCE_SELECTOR;

/**
 选中图片边框颜色
 
 默认：[UIColor colorWithRed:85.f/255 green:171.f/255 blue:228.f/255 alpha:1]
 */
@property (nonatomic, strong) UIColor *selectedBoardColor UI_APPEARANCE_SELECTOR;

/**
 图片非选中边框宽度
 
 默认：0
 */
@property (nonatomic, assign) CGFloat unSlelectedBoardWidth UI_APPEARANCE_SELECTOR;

/**
 图片非选中边框颜色
 
 默认：[UIColor colorWithRed:85.f/255 green:171.f/255 blue:228.f/255 alpha:1]
 */
@property (nonatomic, strong) UIColor *unSelectedBoardColor UI_APPEARANCE_SELECTOR;

/**
 是否显示选中边框
 
 默认：YES
 */
@property (nonatomic, assign) BOOL showSelectedBoard UI_APPEARANCE_SELECTOR;

/**
 相册列表视图高度
 
 默认：ScreenHeight - 64
 */
@property (nonatomic, assign) CGFloat albumViewHeight UI_APPEARANCE_SELECTOR;

/**
 相册列表视图，item 高度
 
 默认：75
 */
@property (nonatomic, assign) CGFloat albumCellHeight UI_APPEARANCE_SELECTOR;

/**
 相册选中图片个数标示位置
 
 默认：GCTPhotosPickerBadgePositionRightTop
 */
@property (nonatomic, assign) GCTPhotosPickerBadgePosition albumCellPickingCountPosition UI_APPEARANCE_SELECTOR;

/**
 相册标题字体
 
 默认：systemFont:18
 */
@property (nonatomic, strong) UIFont *albumCellTitleFont UI_APPEARANCE_SELECTOR;

/**
 相册标题颜色
 
 默认：R：0.4，G：0.4，B：0.4
 */
@property (nonatomic, strong) UIColor *albumCellTitleTextColor UI_APPEARANCE_SELECTOR;

/**
 相册图片个数标示字体颜色
 
 默认：blackColor
 */
@property (nonatomic, strong) UIColor *albumCellAssetsCountTextColor UI_APPEARANCE_SELECTOR;

/**
 相册图片个数标示字体
 
 默认：SystemFont:12
 */
@property (nonatomic, strong) UIFont *albumCellAssetsCountTextFont UI_APPEARANCE_SELECTOR;

/**
 相册分割线颜色
 
 默认：R:0.9,G:0.9,B:0.9
 */
@property (nonatomic, strong) UIColor *albumCellSeparatorLineColor UI_APPEARANCE_SELECTOR;

/**
 相册选中图片个数标示字体
 
 默认：systemFont:12
 */
@property (nonatomic, strong) UIFont *albumCellPickingAssetsCountFont UI_APPEARANCE_SELECTOR;

/**
 相册选中图片个数标示字体颜色
 
 默认：whiteColor
 */
@property (nonatomic, strong) UIColor *albumCellPickingAssetsCountTextColor UI_APPEARANCE_SELECTOR;

/**
 相册选中图片个数标示背景色
 
 默认：[UIColor colorWithRed:85.f/255 green:171.f/255 blue:228.f/255 alpha:1];
 */
@property (nonatomic, strong) UIColor *albumCellPickingAssetsCountBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 相册选中图片个数标示圆角（0~10）
 
 默认：10
 */
@property (nonatomic, assign) CGFloat albumCellPickingAssetsCountCornerRadius UI_APPEARANCE_SELECTOR;

/**
 显示相册动画类型
 
 默认：GCTPhotosPickerAlbumsViewAnimationDrop
 */
@property (nonatomic, assign) GCTPhotosPickerAlbumsViewAnimation albumsViewAnimation UI_APPEARANCE_SELECTOR;
@end
