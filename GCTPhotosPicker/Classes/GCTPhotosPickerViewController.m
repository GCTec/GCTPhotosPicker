//
//  GCTPhotosPickerViewController.m
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import "GCTPhotosPickerViewController.h"
#import <Photos/Photos.h>
#import "GCTPhotosPickerAppearance.h"
#import "GCTPhotosPickerItemCell_Extension.h"
#import "GCTPhotosPickerCachingImageManager.h"
#import "GCTPhotosPickerAlbum.h"
#import "GCTPhotosPickerItemCell.h"
#import "GCTPhotosPickerAlbumsView.h"
#import "GCTPhotosPickerActivityView.h"

static NSString *const kGCTItemCellId = @"com.geekcode.PhotosPickerItemCell.kGCTItemCellId";

static NSString *const kGCTLoadAssetsMessage = @"资源加载中...";
static NSString *const kGCTLoadAlbumsMessage = @"相册加载中...";
static NSString *const kGCTLoadDefaultMessage = @"加载中...";
static NSString *const kGCTCancel = @"退出";
static NSString *const kGCTFinish = @"完成";

static NSString *const kGCTAlbumPerfimissionSettingMessage = @"此应用没有权限访问您的相册或视频，打开“隐私设置”获取访问权限？";
static NSString *const kGCTAlertYES = @"确定";
static NSString *const kGCTAlertNO = @"取消";
static NSString *const kGCTAlertMessageForMedias = @"只能包含%@个资源。请先删除已添加的部分资源";
static NSString *const kGCTAlertMessageForVideos = @"只能包含%@个视频。请先删除已添加的部分视频";
static NSString *const kGCTAlertMessageForPhotos = @"只能包含%@个图片。请先删除已添加的部分图片";
static NSString *const kGCTAlertAlertGotIt = @"知道了";

@interface GCTPhotosPickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, GCTPhotosPickerItemCellDelegate,UIGestureRecognizerDelegate, GCTPhotosPickerAlbumsViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *headerBottomLineView;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *finishedButton;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <PHAsset *> *assets;

@property (nonatomic, strong) GCTPhotosPickerAlbum *album;
@property (nonatomic, strong) PHImageRequestOptions *imageRequestOptions;
@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, strong) GCTPhotosPickerAlbumsView *albumView;

@property (strong, nonatomic) NSIndexPath *lastAccessed;

@property (nonatomic, strong) GCTPhotosPickerActivityView *activityView;
@property (nonatomic, copy) NSString *titleString;
@end

@implementation GCTPhotosPickerViewController
- (instancetype)init {
    if (self = [super init]) {
        self.pickerType = GCTPhotosPickerTypeMedias;
        self.maximumNumberOfSelectionPhotos = 1;
        self.maximumNumberOfSelectionMedias = 1;
        self.maximumNumberOfSelectionVideos = 1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.appearance.itemsCollectionBackgroundColor;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.albumView];
    [self.view addSubview:self.activityView];
    
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.arrowImageView];
    [self.headerView addSubview:self.titleButton];
    [self.headerView addSubview:self.closeButton];
    [self.headerView addSubview:self.finishedButton];
    
    self.imageRequestOptions = [[PHImageRequestOptions alloc] init];
    self.imageRequestOptions.synchronous = YES;
    CGFloat screenWidth = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    CGFloat width = (screenWidth - self.appearance.itemsPadding*(self.appearance.sigleLineItemsCount + 1))/self.appearance.sigleLineItemsCount;
    CGFloat imageWidth = width*[UIScreen mainScreen].scale;
    self.imageSize = CGSizeMake(imageWidth, imageWidth);
    [self addGestureRecognizers];
    self.titleString = kGCTLoadDefaultMessage;
    self.titleButton.enabled = NO;
    
    
    [self addNotificationObservers];
    [self.activityView showWithRect:CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44) message:kGCTLoadAssetsMessage animated:YES completion:nil];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.pickingAssets.count > 0) {
        self.finishedButton.enabled = YES;
        [self.finishedButton setTitle:[NSString stringWithFormat:@"%@(%@)",kGCTFinish, @(self.pickingAssets.count)] forState:UIControlStateNormal];
        [self layoutFinishedButton];
    } else {
        self.finishedButton.enabled = NO;
        [self.finishedButton setTitle:kGCTFinish forState:UIControlStateNormal];
        [self layoutFinishedButton];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self libraryAuthorizationCheck];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutHeaderView];
    [self layoutAlbumView];
    [self layoutActivityView];
}
- (void)dealloc {
    NSLog(@"dealloc");
}
- (BOOL)prefersStatusBarHidden {
    return !self.appearance.showStatusBar;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.appearance.statusBarStyle;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
        CGFloat screenWidth = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        CGFloat width = (screenWidth - self.appearance.itemsPadding*(self.appearance.sigleLineItemsCount + 1))/self.appearance.sigleLineItemsCount;
        self.collectionLayout.itemSize = CGSizeMake(width, width);
    self.collectionView.collectionViewLayout = self.collectionLayout;
    [self.collectionView performBatchUpdates:nil completion:nil];

}
- (void)layoutHeaderView {
    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44);
    if (_headerBottomLineView) {
        _headerBottomLineView.frame = CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 43.5, CGRectGetWidth(self.headerView.frame), 0.5);
    }
    NSString *closeButtonTitle = [self.closeButton titleForState:UIControlStateNormal];
    CGSize closeSize = [closeButtonTitle boundingRectWithSize:CGSizeMake(80, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.closeButton.titleLabel.font} context:nil].size;
    self.closeButton.frame = CGRectMake(10, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), closeSize.width, 44);
    
    [self layoutFinishedButton];
    self.collectionView.frame = CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - 44);

    [self layoutTitlesAnimated:NO];
}
- (void)layoutFinishedButton {
    NSString *finishButtonTitle = [self.finishedButton titleForState:UIControlStateNormal];
    CGSize finishSize = [finishButtonTitle boundingRectWithSize:CGSizeMake(100, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.finishedButton.titleLabel.font} context:nil].size;
    self.finishedButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - finishSize.width - 10, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), finishSize.width, 44);
    
}
- (void)layoutActivityView {
    self.activityView.frame = CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+44, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - 44);
}
- (void)layoutAlbumView {
    self.albumView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
}
- (void)layoutTitlesAnimated:(BOOL)animated {
    CGSize titleSize = [self titleSize];

    if (animated && self.appearance.albumNameChangeAnimated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.titleButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.f, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), 0 , 44);
            
            self.arrowImageView.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.f + 10, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + (44.f - CGRectGetHeight(self.arrowImageView.frame))/2.f, CGRectGetWidth(self.arrowImageView.frame), CGRectGetHeight(self.arrowImageView.frame));
        } completion:^(BOOL finished) {
            [self.titleButton setTitle:self.titleString forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                self.titleButton.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - MAX(titleSize.width, 60))/2.f, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), MAX(titleSize.width, 60) , 44);
                
                self.arrowImageView.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.f + titleSize.width/2.f + 10, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + (44.f - CGRectGetHeight(self.arrowImageView.frame))/2.f, CGRectGetWidth(self.arrowImageView.frame), CGRectGetHeight(self.arrowImageView.frame));
            }];

        }];
            } else {
        [self.titleButton setTitle:self.titleString forState:UIControlStateNormal];

        self.titleButton.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - MAX(titleSize.width, 60))/2.f, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), MAX(titleSize.width, 60) , 44);
        
        self.arrowImageView.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.f + titleSize.width/2.f + 10, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + (44.f - CGRectGetHeight(self.arrowImageView.frame))/2.f, CGRectGetWidth(self.arrowImageView.frame), CGRectGetHeight(self.arrowImageView.frame));
    }
}
#pragma mark Private Method
- (void)addAsset:(PHAsset *)asset {
    if ((self.pickerType == GCTPhotosPickerTypePhotos && self.pickingAssets.count < self.maximumNumberOfSelectionPhotos) || (self.pickerType == GCTPhotosPickerTypeMedias && self.pickingAssets.count < self.maximumNumberOfSelectionMedias) || (self.pickerType == GCTPhotosPickerTypeVideos && self.pickingAssets.count < self.maximumNumberOfSelectionVideos)) {
        [self.pickingAssets addObject:asset];
    }
    if ((self.pickerType == GCTPhotosPickerTypePhotos && self.pickingAssets.count == self.maximumNumberOfSelectionPhotos) || (self.pickerType == GCTPhotosPickerTypeVideos && self.pickingAssets.count == self.maximumNumberOfSelectionVideos) || (self.pickerType == GCTPhotosPickerTypeMedias && self.pickingAssets.count == self.maximumNumberOfSelectionMedias)) {
        [self updateCoverView];
        
    }
    if (self.pickingAssets.count > 0) {
        self.finishedButton.enabled = YES;
        [self.finishedButton setTitle:[NSString stringWithFormat:@"%@(%@)",kGCTFinish, @(self.pickingAssets.count)] forState:UIControlStateNormal];
        [self layoutFinishedButton];

    } else {
        self.finishedButton.enabled = NO;
        [self.finishedButton setTitle:kGCTFinish forState:UIControlStateNormal];
        [self layoutFinishedButton];

    }
}
- (void)updateCoverView {
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GCTPhotosPickerItemCell class]]) {
            GCTPhotosPickerItemCell *cell = (GCTPhotosPickerItemCell *)obj;
            if (cell.asset && ![self.pickingAssets containsObject:cell.asset]) {
                [cell showCover];
            }
        }
    }];
}
- (void)removeAsset:(PHAsset *)asset {
    BOOL needReload = NO;
    if ((self.pickerType == GCTPhotosPickerTypePhotos && self.pickingAssets.count == self.maximumNumberOfSelectionPhotos) || (self.pickerType == GCTPhotosPickerTypeVideos && self.pickingAssets.count == self.maximumNumberOfSelectionVideos) || (self.pickerType == GCTPhotosPickerTypeMedias && self.pickingAssets.count == self.maximumNumberOfSelectionMedias)) {
        needReload = YES;
    }
    if (self.pickingAssets.count > 0 && [self.pickingAssets containsObject:asset]) {
        [self.pickingAssets removeObject:asset];
    }
    if(needReload) {
        [self.collectionView reloadData];
    }
}
- (void)refreshTitle:(NSString *)title {
    if ([self.titleString isEqualToString:kGCTLoadDefaultMessage]) {
        self.titleString = title;
        [self layoutTitlesAnimated:NO];
    } else {
        self.titleString = title;
        [self layoutTitlesAnimated:YES];
    }

    
}
- (CGSize)titleSize {
    CGSize size = [self.titleString boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 120, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.appearance.titleFont} context:nil].size;
    return size;
}

- (void)becomeActive:(NSNotification *)notification {
    [self libraryAuthorizationCheck];
    
}
- (void)libraryAuthorizationCheck{
    

    __weak typeof(self)weakSelf = self;
    
    [GCTPhotosPickerCachingImageManager libraryAuthorizationCompleted:^(BOOL hasAuthorization) {
        if (hasAuthorization) {
            
            [weakSelf _gct_assetsGroups];
        } else {
            // 更新界面
            [weakSelf openSetting];
            
        }
    }];
    
    
}
- (void)openSetting {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:kGCTAlbumPerfimissionSettingMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:kGCTAlertYES style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 100000)
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
#else
            [[UIApplication sharedApplication] openURL:url];
#endif
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kGCTAlertNO style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)_gct_assetsGroups {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        switch (self.pickerType) {
            case GCTPhotosPickerTypeVideos:
            {
                self.album = [GCTPhotosPickerCachingImageManager cameraAlbumWithType:GCTPhotosPickerCachingImageTypeVideos];

            }
                break;

            case GCTPhotosPickerTypePhotos:
            {
                self.album = [GCTPhotosPickerCachingImageManager cameraAlbumWithType:GCTPhotosPickerCachingImageTypePhotos];

            }
                break;
            case GCTPhotosPickerTypeMedias:
            default:
            {
                self.album = [GCTPhotosPickerCachingImageManager cameraAlbumWithType:GCTPhotosPickerCachingImageTypeMedias];

            }
                break;
        }
        [self allAssetsWithAlbum:self.album];
        [self refreshAlbum];
    });
}
- (void)refreshAlbum {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        [self.activityView hideAnimated:YES completion:nil];
        [self refreshTitle:self.album.albumName];
        self.titleButton.enabled = YES;
        self.lastAccessed = nil;
        [self.collectionView reloadData];
        
    });
    
}
- (void)allAssetsWithAlbum:(GCTPhotosPickerAlbum *)album{
    NSMutableArray *assets = [NSMutableArray new];
    __block typeof(assets)blockAssets = assets;
    [album.albumFetch enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            [blockAssets addObject:obj];
        }
    }];
    self.assets = assets;
}
- (void)showReachToMaxAlert {
    NSString *message = [NSString stringWithFormat:kGCTAlertMessageForMedias,@(self.maximumNumberOfSelectionMedias)];
    switch (self.pickerType) {
        case GCTPhotosPickerTypeVideos:
        {
            message = [NSString stringWithFormat:kGCTAlertMessageForVideos,@(self.maximumNumberOfSelectionVideos)];
            
        }
            break;
        case GCTPhotosPickerTypePhotos:
        {
            message = [NSString stringWithFormat:kGCTAlertMessageForPhotos,@(self.maximumNumberOfSelectionPhotos)];

        }
            break;
        case GCTPhotosPickerTypeMedias:
        default:
            break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kGCTAlertAlertGotIt style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)addGestureRecognizers
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanForSelection:)];
        pan.delegate = self;
        [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapForSelection:)];
    tap.delegate = self;
    [self.collectionView addGestureRecognizer:tap];
}
- (void)onTapForSelection:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.albumView.isShow) {
        return;
    }
    double fX = [gestureRecognizer locationInView:self.collectionView].x;
    double fY = [gestureRecognizer locationInView:self.collectionView].y;
    
    for (GCTPhotosPickerItemCell *cell in self.collectionView.visibleCells)
    {
        
        float fSX = cell.frame.origin.x;
        float fEX = cell.frame.origin.x + cell.frame.size.width;
        float fSY = cell.frame.origin.y;
        float fEY = cell.frame.origin.y + cell.frame.size.height;
        BOOL canResponse = YES;
        
        if (fX >= fSX && fX <= fEX && fY >= fSY && fY <= fEY)
        {
            
            switch (self.pickerType) {
                case GCTPhotosPickerTypePhotos: {
                    if (self.pickingAssets.count == self.maximumNumberOfSelectionPhotos && !cell.selected) {
                        canResponse = NO;
                        if ([self.delegate respondsToSelector:@selector(photosPickerDidExceedMaximumNumberOfSelection:)]) {
                            [self.delegate photosPickerDidExceedMaximumNumberOfSelection:self];
                        } else {
                            if (self.maximumNumberOfSelectionPhotos != 1) {
                                [self showReachToMaxAlert];
                            }
                        }
                    }
                }
                    break;
                case GCTPhotosPickerTypeVideos: {
                    if (self.pickingAssets.count == self.maximumNumberOfSelectionVideos && !cell.selected) {
                        canResponse = NO;
                        if ([self.delegate respondsToSelector:@selector(photosPickerDidExceedMaximumNumberOfSelection:)]) {
                            [self.delegate photosPickerDidExceedMaximumNumberOfSelection:self];
                        } else {
                            if (self.maximumNumberOfSelectionVideos != 1) {
                                [self showReachToMaxAlert];
                            }                        }
                    }
                }
                    break;
                    
                case GCTPhotosPickerTypeMedias:
                default: {
                    if (self.pickingAssets.count == self.maximumNumberOfSelectionMedias && !cell.selected) {
                        canResponse = NO;
                        if ([self.delegate respondsToSelector:@selector(photosPickerDidExceedMaximumNumberOfSelection:)]) {
                            [self.delegate photosPickerDidExceedMaximumNumberOfSelection:self];
                        } else {
                            if (self.maximumNumberOfSelectionMedias != 1) {
                                [self showReachToMaxAlert];
                            }
                        }
                    }
                }
                    break;
            }
            
            if (canResponse) {
                NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
                if (self.lastAccessed != indexPath) {
                    [self tryToSelectItemWithCell:cell indexPath:indexPath];
                }
                self.lastAccessed = indexPath;
            }
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.lastAccessed = nil;
        self.collectionView.scrollEnabled = YES;
    }

}
#pragma mark - Pan
- (void)onPanForSelection:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.albumView.isShow) {
        return;
    }
    double fX = [gestureRecognizer locationInView:self.collectionView].x;
    double fY = [gestureRecognizer locationInView:self.collectionView].y;
    
    for (GCTPhotosPickerItemCell *cell in self.collectionView.visibleCells) {
        
        float fSX = cell.frame.origin.x;
        float fEX = cell.frame.origin.x + cell.frame.size.width;
        float fSY = cell.frame.origin.y;
        float fEY = cell.frame.origin.y + cell.frame.size.height;
        BOOL canResponse = YES;
        
        if (fX >= fSX && fX <= fEX && fY >= fSY && fY <= fEY)
        {
         
            switch (self.pickerType) {
                case GCTPhotosPickerTypePhotos: {
                    if (self.pickingAssets.count == self.maximumNumberOfSelectionPhotos && !cell.selected) {
                        canResponse = NO;
                        if ([self.delegate respondsToSelector:@selector(photosPickerDidExceedMaximumNumberOfSelection:)]) {
                            [self.delegate photosPickerDidExceedMaximumNumberOfSelection:self];
                        } else {
                            if (self.maximumNumberOfSelectionPhotos != 1) {
                                [self showReachToMaxAlert];
                            }
                        }
                    }
                }
                    break;
                case GCTPhotosPickerTypeVideos: {
                    if (self.pickingAssets.count == self.maximumNumberOfSelectionVideos && !cell.selected) {
                        canResponse = NO;
                        if ([self.delegate respondsToSelector:@selector(photosPickerDidExceedMaximumNumberOfSelection:)]) {
                            [self.delegate photosPickerDidExceedMaximumNumberOfSelection:self];
                        } else {
                            if (self.maximumNumberOfSelectionVideos != 1) {
                                [self showReachToMaxAlert];
                            }                        }
                    }
                }
                    break;
                    
                case GCTPhotosPickerTypeMedias:
                default: {
                    if (self.pickingAssets.count == self.maximumNumberOfSelectionMedias && !cell.selected) {
                        canResponse = NO;
                        if ([self.delegate respondsToSelector:@selector(photosPickerDidExceedMaximumNumberOfSelection:)]) {
                            [self.delegate photosPickerDidExceedMaximumNumberOfSelection:self];
                        } else {
                            if (self.maximumNumberOfSelectionMedias != 1) {
                                [self showReachToMaxAlert];
                            }
                        }
                    }
                }
                    break;
            }
       
            if (canResponse) {
                NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
                if (self.lastAccessed != indexPath) {
                    [self tryToSelectItemWithCell:cell indexPath:indexPath];
                }
                self.lastAccessed = indexPath;
            }
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.lastAccessed = nil;
        self.collectionView.scrollEnabled = YES;
    }
}

#pragma mark Notification
- (void)addNotificationObservers {
    [self removeNotificationObservers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)removeNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Delegate
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCTPhotosPickerItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGCTItemCellId forIndexPath:indexPath];
    cell.delegate = self;
    cell.itemAppearance = self.appearance;
    cell.asset = self.assets[indexPath.row];
    __weak typeof(cell)weakCell = cell;
    [[GCTPhotosPickerCachingImageManager defaultManager] requestImage:self.assets[indexPath.row] targetSize:self.imageSize contentMode:PHImageContentModeAspectFill options:nil completed:^(UIImage *image, NSDictionary *info) {
        weakCell.photoImageView.image = image;
    }];
    if ([self.pickingAssets containsObject:cell.asset]) {
        cell.index = [self.pickingAssets indexOfObject:cell.asset]+1;
        [cell selected:YES animated:NO];
        [cell hideCover];;
    } else {
        cell.index = 0;
        [cell selected:NO animated:NO];

        if ((self.pickerType == GCTPhotosPickerTypePhotos && self.pickingAssets.count == self.maximumNumberOfSelectionPhotos) || (self.pickerType == GCTPhotosPickerTypeVideos && self.pickingAssets.count == self.maximumNumberOfSelectionVideos) || (self.pickerType == GCTPhotosPickerTypeMedias && self.pickingAssets.count == self.maximumNumberOfSelectionMedias)) {
            [cell showCover];
        } else {
            [cell hideCover];
        }
    }
    return cell;
    
}

- (void)updateAllSelectedCellAppearanceSelected:(BOOL)addSelected {
    __weak typeof(self) weakSelf = self;
    [self.pickingAssets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [self.assets indexOfObject:obj];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        GCTPhotosPickerItemCell *cell = (GCTPhotosPickerItemCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
        cell.index = [self.pickingAssets indexOfObject:cell.asset]+1;
        if (addSelected) {
            [cell selected:YES animated:YES];
        } else {
            [cell selected:YES animated:NO];
        }

    }];
    if (self.pickingAssets.count > 0) {
        self.finishedButton.enabled = YES;
        [self.finishedButton setTitle:[NSString stringWithFormat:@"%@(%@)",kGCTFinish, @(self.pickingAssets.count)] forState:UIControlStateNormal];
        [self layoutFinishedButton];
    } else {
        self.finishedButton.enabled = NO;
        [self.finishedButton setTitle:kGCTFinish forState:UIControlStateNormal];
        [self layoutFinishedButton];
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
        if (((self.pickerType == GCTPhotosPickerTypePhotos &&  self.maximumNumberOfSelectionPhotos == 1) || (self.pickerType == GCTPhotosPickerTypeVideos &&  self.maximumNumberOfSelectionVideos == 1) || (self.pickerType == GCTPhotosPickerTypeMedias &&  self.maximumNumberOfSelectionMedias == 1))&& self.lastAccessed!=nil) {
            [self.collectionView deselectItemAtIndexPath:self.lastAccessed animated:NO];
            [self collectionView:self.collectionView didDeselectItemAtIndexPath:self.lastAccessed];
            [self addAsset:self.assets[indexPath.row]];
            [self updateAllSelectedCellAppearanceSelected:YES];
        }else
        {
            [self addAsset:self.assets[indexPath.row]];
            [self updateAllSelectedCellAppearanceSelected:YES];
        }
        self.lastAccessed = indexPath;



}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (((self.pickerType == GCTPhotosPickerTypePhotos &&  self.maximumNumberOfSelectionPhotos == 1) || (self.pickerType == GCTPhotosPickerTypeVideos &&  self.maximumNumberOfSelectionVideos == 1) || (self.pickerType == GCTPhotosPickerTypeMedias &&  self.maximumNumberOfSelectionMedias == 1))&&self.lastAccessed == indexPath) {
        return NO;
    } else {
        return YES;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.pickingAssets containsObject:self.assets[indexPath.row]]) {
        [self removeAsset:self.assets[indexPath.row]];
        GCTPhotosPickerItemCell *cell = (GCTPhotosPickerItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell selected:NO animated:NO];
        [self updateAllSelectedCellAppearanceSelected:NO];
    }
}


-(void)tryToSelectItemWithCell:(GCTPhotosPickerItemCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (cell) {
        if (![self.pickingAssets containsObject:cell.asset]) {
            [cell selected:YES animated:YES];
            [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
        } else {
            [cell selected:NO animated:NO];
            [self collectionView:self.collectionView didDeselectItemAtIndexPath:indexPath];
        }
    }
}

#pragma mark - GCTPhotosPickerItemCellDelegate
- (void)pickerItemCell:(GCTPhotosPickerItemCell *)cell didSelected:(BOOL)selected {
    if (selected) {
        if(![self.pickingAssets containsObject:cell.asset]) {
            [self addAsset:cell.asset];
        }
    } else {
        if([self.pickingAssets containsObject:cell.asset]) {
            [self removeAsset:cell.asset];
        }
    }
    
}
- (void)pickerItemCellSelectedButtonClicked:(GCTPhotosPickerItemCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self tryToSelectItemWithCell:cell indexPath:indexPath];
}
#pragma mark - GCTPhotosPickerAlbumsViewDelegate
- (void)albumsView:(GCTPhotosPickerAlbumsView *)albumView selectedAlbum:(GCTPhotosPickerAlbum *)album {
    [self titleButtonClicked:self.titleButton];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.album = album;
        [self allAssetsWithAlbum:self.album];
        [self refreshAlbum];
    });
    
}

- (void)albumsViewBackViewTapdAction:(GCTPhotosPickerAlbumsView *)albumView {
    [self titleButtonClicked:self.titleButton];
}
#pragma mark Action
#pragma mark - TitleButtonAction
- (void)titleButtonClicked:(UIButton *)button {
    
    if (!self.albumView.isShow) {
        button.userInteractionEnabled = NO;
        self.albumView.hidden = NO;
        if (self.albumView.albums.count == 0) {
            [self.activityView showWithRect:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 64) message:kGCTLoadAlbumsMessage  animated:YES completion:nil];
        }
        [self.albumView showAlbumAnimation:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);

        } completion:^{
            button.userInteractionEnabled = YES;
            GCTPhotosPickerCachingImageType cachingtype = GCTPhotosPickerCachingImageTypeMedias;
            switch (self.pickerType) {
                case GCTPhotosPickerTypePhotos:
                {
                    cachingtype = GCTPhotosPickerCachingImageTypePhotos;
                }
                    break;
                case GCTPhotosPickerTypeVideos:
                {
                    cachingtype = GCTPhotosPickerCachingImageTypeVideos;
                }
                    break;
                case GCTPhotosPickerTypeMedias:
                default:
                    break;
            }
            __weak typeof(self)weakSelf = self;
          
            
            [GCTPhotosPickerCachingImageManager getAlbumsWithType:cachingtype completion:^(BOOL ret, NSArray<GCTPhotosPickerAlbum *> *albums) {
                if (ret) {
                    [albums enumerateObjectsUsingBlock:^(GCTPhotosPickerAlbum * _Nonnull album, NSUInteger albumsIdx, BOOL * _Nonnull albumsStop) {
                        
                        NSMutableArray *pickingAssets = [NSMutableArray new];
                        __block typeof(pickingAssets)blockAssets = pickingAssets;
                        [album.albumFetch enumerateObjectsUsingBlock:^(id  _Nonnull fetchObj, NSUInteger fetchIdx, BOOL * _Nonnull fetchStop) {
                            
                            if ([fetchObj isKindOfClass:[PHAsset class]] && [self.pickingAssets containsObject:fetchObj]) {
                                [pickingAssets addObject:fetchObj];
                            }
                            if (album.albumFetch.count > 0 && fetchIdx == album.albumFetch.count - 1) {
                                album.pickingAssets = [pickingAssets copy];
                                blockAssets = [NSMutableArray new];
                            }
                        }];
                        if (albums.count > 0 && albumsIdx == albums.count - 1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                weakSelf.albumView.albums = albums;
                                [weakSelf.activityView hideAnimated:YES completion:nil];
                            });
                            
                        }
                        
                    }];
                }
            }];
        }];
    
    } else {
        button.userInteractionEnabled = NO;

        [self.activityView hideAnimated:YES completion:nil];
        [self.albumView dismissAlbumAnimation:^{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        } completion:^{
            button.userInteractionEnabled = YES;
            self.albumView.hidden = YES;
        }];
    }
    
}
#pragma mark - CloseButtonAction
- (void)closeButtonClicked:(UIButton *)button {
    __weak typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(photosPickerDidCanceled:)]) {
            [weakSelf.delegate photosPickerDidCanceled:self];
        }
    }];
}
- (void)finishedButtonClicked:(UIButton *)button {
    __weak typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(photosPicker:didFinishedPickingAssets:)]) {
            [weakSelf.delegate photosPicker:self didFinishedPickingAssets:weakSelf.pickingAssets];
        }
    }];
}
#pragma mark Setter/Getter
#pragma mark - System Setter/Gtter
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [self refreshTitle:title];
}
#pragma mark - Property
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44)];
        _headerView.backgroundColor = self.appearance.headerBackgroundColor;
        switch (self.appearance.headerBottomLineStyle) {
            case GCTPhotosPickerHeaderBottomLineStyleShadow:
            {
                _headerView.layer.shadowColor = self.appearance.headerBottomLineShadowColor.CGColor;
                _headerView.layer.shadowOffset = CGSizeMake(0, 3);
                _headerView.layer.shadowOpacity = 0.5;
                _headerView.layer.shadowRadius = 3;//阴影半径，默认3

            }
                break;
            case GCTPhotosPickerHeaderBottomLineStyleLine:
            {
                [_headerView addSubview:self.headerBottomLineView];
            }
                break;
            case GCTPhotosPickerHeaderBottomLineStyleNone:
            default:
                break;
        }
    }
    return _headerView;
}
- (UIView *)headerBottomLineView {
    if (!_headerBottomLineView) {
        _headerBottomLineView = [[UIView alloc] init];
        _headerBottomLineView.backgroundColor = self.appearance.headerBottomlineColor;
    }
    return _headerBottomLineView;
}
- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitleColor:self.appearance.normalTitleColor forState:UIControlStateNormal];
        
        [_titleButton setTitleColor:self.appearance.highlightTitleColor forState:UIControlStateHighlighted];
        [_titleButton setTitleColor:self.appearance.disabledTitleColor forState:UIControlStateDisabled];
        _titleButton.titleLabel.font = self.appearance.titleFont;
        [_titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:self.appearance.topDropdownImage];;
    }
    return _arrowImageView;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.titleLabel.font = self.appearance.cancelButtonTitleFont;
        [_closeButton setTitleColor:self.appearance.cancelButtonNormalTitleColor forState:UIControlStateNormal];
        [_closeButton setTitleColor:self.appearance.cancelButtonHighlightTitleColor forState:UIControlStateHighlighted];
        [_closeButton setTitleColor:self.appearance.cancelButtonDisabledTitleColor forState:UIControlStateDisabled];
        [_closeButton setTitle:kGCTCancel forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIButton *)finishedButton {
    if (!_finishedButton) {
        _finishedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishedButton.titleLabel.font = self.appearance.doneButtonTitleFont;
        [_finishedButton setTitleColor:self.appearance.doneButtonNormalTitleColor forState:UIControlStateNormal];
        [_finishedButton setTitleColor:self.appearance.doneButtonHighlightTitleColor forState:UIControlStateHighlighted];
        [_finishedButton setTitleColor:self.appearance.doneButtonDisabledTitleColor forState:UIControlStateDisabled];
        [_finishedButton setTitle:kGCTFinish forState:UIControlStateNormal];
        [_finishedButton addTarget:self action:@selector(finishedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishedButton;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionLayout];
        self.collectionView.contentInset = UIEdgeInsetsMake(0, self.appearance.itemsPadding, 0, self.appearance.itemsPadding);
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.bounces = YES;
        self.collectionView.alwaysBounceVertical = YES;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.appearance.itemsCollectionBackgroundColor;
        [_collectionView registerClass:GCTPhotosPickerItemCell.class forCellWithReuseIdentifier:kGCTItemCellId];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)collectionLayout {
    if (!_collectionLayout) {
        _collectionLayout =  [[UICollectionViewFlowLayout alloc] init];
        CGFloat screenWidth = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        CGFloat width = (screenWidth - self.appearance.itemsPadding*(self.appearance.sigleLineItemsCount + 1))/self.appearance.sigleLineItemsCount;
        _collectionLayout.itemSize = CGSizeMake(width, width);
        _collectionLayout.minimumLineSpacing = self.appearance.itemsPadding;
        _collectionLayout.minimumInteritemSpacing = self.appearance.itemsPadding;
    }
    return _collectionLayout;
}
- (GCTPhotosPickerAppearance *)appearance {
    if (!_appearance) {
        _appearance = [[GCTPhotosPickerAppearance alloc] init];
    }
    return _appearance;
}

- (NSMutableArray<PHAsset *> *)pickingAssets {
    if (!_pickingAssets) {
        _pickingAssets = [[NSMutableArray alloc] init];
    }
    return _pickingAssets;
}
- (void)setMaximumNumberOfSelectionPhotos:(NSInteger)maximumNumberOfSelectionPhotos {
    if (maximumNumberOfSelectionPhotos < 1) {
        _maximumNumberOfSelectionPhotos = 1;
    } else {
        _maximumNumberOfSelectionPhotos = maximumNumberOfSelectionPhotos;
    }
}
- (void)setMaximumNumberOfSelectionVideos:(NSInteger)maximumNumberOfSelectionVideos {
    if (maximumNumberOfSelectionVideos < 1) {
        _maximumNumberOfSelectionVideos = 1;
    } else {
        _maximumNumberOfSelectionVideos = maximumNumberOfSelectionVideos;
    }
}
- (void)setMaximumNumberOfSelectionMedias:(NSInteger)maximumNumberOfSelectionMedias {
    if (maximumNumberOfSelectionMedias < 1) {
        _maximumNumberOfSelectionMedias = 1;
    } else {
        _maximumNumberOfSelectionMedias = maximumNumberOfSelectionMedias;
    }
}
- (GCTPhotosPickerAlbumsView *)albumView {
    if (!_albumView) {
        _albumView = [[GCTPhotosPickerAlbumsView alloc] init];
        _albumView.appearance = self.appearance;
        _albumView.delegate = self;
        _albumView.hidden = YES;
        _albumView.backgroundColor = [UIColor clearColor];
    }
    return _albumView;
}
- (GCTPhotosPickerActivityView *)activityView {
    if (!_activityView) {
        _activityView = [[GCTPhotosPickerActivityView alloc] init];
        _activityView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    }
    return _activityView;
}
- (BOOL)shouldAutorotate {
    return YES;
}
//返回直接支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
//返回最优先显示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
@end

