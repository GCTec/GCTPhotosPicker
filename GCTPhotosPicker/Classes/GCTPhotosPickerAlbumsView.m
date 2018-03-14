//
//  GCTPhotosPickerAlbumsView.m
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import "GCTPhotosPickerAlbumsView.h"
#import "GCTPhotosPickerAlbum.h"
#import "GCTPhotosPickerAlbumsCell.h"
#import "GCTPhotosPickerCachingImageManager.h"
#import "GCTPhotosPickerAppearance.h"

static NSString *const kGCTPhotosPickerAlubmsCellID = @"com.geekcode.kGCTPhotosPickerAlubmsCellID";
@interface GCTPhotosPickerAlbumsView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PHImageRequestOptions *phImageRequestOptions;
@property (nonatomic, strong) UIView *backView;
@end
@implementation GCTPhotosPickerAlbumsView
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.backView];
        [self addSubview:self.tableView];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 56)];
        headerView.backgroundColor = self.backgroundColor;
        self.tableView.tableHeaderView = headerView;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setAlbums:(NSArray<GCTPhotosPickerAlbum *> *)albums {
    _albums = albums;
    [self.tableView reloadData];

    
}

- (void)showAlbumAnimation:(void(^)(void))animation completion:(void(^)(void))completion {
    if (!self.isShow) {
        CGFloat height = self.appearance.albumViewHeight > 0 ? MIN(self.appearance.albumViewHeight, CGRectGetHeight([UIScreen mainScreen].bounds) ) : CGRectGetHeight([UIScreen mainScreen].bounds);

        if (self.appearance.albumsViewAnimation == GCTPhotosPickerAlbumsViewAnimationDrop) {
            self.tableView.frame = CGRectMake(0, -height, CGRectGetWidth(self.bounds), height);
            
        } else if(self.appearance.albumsViewAnimation == GCTPhotosPickerAlbumsViewAnimationSpread){
            self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0);
        }

        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.backView.alpha = 1;
            self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), height);
            !animation ?: animation();
        } completion:^(BOOL finished) {
            self.show = YES;
            !completion ?: completion();
        }];
    }
}
- (void)dismissAlbumAnimation:(void(^)(void))animation completion:(void(^)(void))completion {
    if (self.isShow) {
        CGFloat height = self.appearance.albumViewHeight > 0 ? MIN(self.appearance.albumViewHeight, CGRectGetHeight([UIScreen mainScreen].bounds) ) : CGRectGetHeight([UIScreen mainScreen].bounds);
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.backView.alpha = 0;
            if (self.appearance.albumsViewAnimation == GCTPhotosPickerAlbumsViewAnimationDrop) {
                self.tableView.frame = CGRectMake(0, -height, CGRectGetWidth(self.bounds), height);
            } else if(self.appearance.albumsViewAnimation == GCTPhotosPickerAlbumsViewAnimationSpread){
                self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0);
            }
            !animation ?: animation();
        } completion:^(BOOL finished) {
            self.show = NO;
            !completion ?: completion();
        }];
    }
}
#pragma mark Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCTPhotosPickerAlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:kGCTPhotosPickerAlubmsCellID];
    if (!cell) {
        cell = [[GCTPhotosPickerAlbumsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kGCTPhotosPickerAlubmsCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.albums.count > indexPath.row) {
        GCTPhotosPickerAlbum *album = self.albums[indexPath.row];

        [[GCTPhotosPickerCachingImageManager defaultManager] requestImage:album.albumFetch.firstObject targetSize:CGSizeMake(self.appearance.albumCellHeight * [UIScreen mainScreen].scale, self.appearance.albumCellHeight * [UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFill options:self.phImageRequestOptions completed:^(UIImage *image, NSDictionary *info) {
            album.albumThumbnailImage = image;
            cell.album = album;
        }];
        cell.appearance = self.appearance;

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(albumsView:selectedAlbum:)]) {
        if (self.albums.count > indexPath.row) {
            [self.delegate albumsView:self selectedAlbum:self.albums[indexPath.row]];
        }
    }
}
- (void)tapBack:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(albumsViewBackViewTapdAction:)]) {
        [self.delegate albumsViewBackViewTapdAction:self];
    }
}
#pragma mark Setter/Getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _backView.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)setAppearance:(GCTPhotosPickerAppearance *)appearance {
    _appearance = appearance;
    self.tableView.rowHeight = self.appearance.albumCellHeight;
}
- (PHImageRequestOptions *)phImageRequestOptions {
    if (!_phImageRequestOptions) {
        _phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        _phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    }
    return _phImageRequestOptions;
}

@end
