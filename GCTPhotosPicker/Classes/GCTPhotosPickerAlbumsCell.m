//
//  GCTPhotosPickerAlbumsCell.m
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import "GCTPhotosPickerAlbumsCell.h"
#import "GCTPhotosPickerAlbum.h"
#import "GCTPhotosPickerAppearance.h"

@interface GCTPhotosPickerAlbumsCell ()

@property (nonatomic, strong) UIImageView *albumPhoto;
@property (nonatomic, strong) UILabel *albumTitle;
@property (nonatomic, strong) UILabel *assetsCountLabel;
@property (nonatomic, strong) UILabel *pickingAssetsCountLabel;
@property (nonatomic, strong) UIView *separatorLine;
@end
@implementation GCTPhotosPickerAlbumsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.albumPhoto];
        [self.albumPhoto addSubview:self.pickingAssetsCountLabel];
        [self addSubview:self.albumTitle];
        [self addSubview:self.assetsCountLabel];
        [self addSubview:self.separatorLine];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
    self.pickingAssetsCountLabel.text = nil;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.pickingAssetsCountLabel.font = self.appearance.albumCellPickingAssetsCountFont;
    self.pickingAssetsCountLabel.layer.cornerRadius = self.appearance.albumCellPickingAssetsCountCornerRadius;
    self.pickingAssetsCountLabel.clipsToBounds = YES;
    self.separatorLine.frame = CGRectMake(10, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds) - 10, 0.5);
    
    self.albumPhoto.frame = CGRectMake(10, 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds));
    self.albumTitle.frame = CGRectMake(CGRectGetMaxX(self.albumPhoto.frame) + 10, CGRectGetHeight(self.bounds)/2.f - 22, CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.albumPhoto.frame) - 20, 20);
    self.assetsCountLabel.frame = CGRectMake(self.albumTitle.frame.origin.x, CGRectGetMaxY(self.albumTitle.frame) + 2, CGRectGetWidth(self.albumTitle.frame), 15);
    if (self.pickingAssetsCountLabel.text.length > 0) {
        CGSize indexSize = [self.pickingAssetsCountLabel.text boundingRectWithSize:CGSizeMake(CGRectGetHeight(self.bounds) - 10, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _pickingAssetsCountLabel.font} context:nil].size;

        switch (self.appearance.albumCellPickingCountPosition) {
                
            case GCTPhotosPickerBadgePositionLeftTop:
            {
                self.pickingAssetsCountLabel.frame = CGRectMake(5, 5, MAX(indexSize.width, 20) , 20);
                
            }
                break;
            case GCTPhotosPickerBadgePositionLeftBottom:
            {
                self.pickingAssetsCountLabel.frame = CGRectMake(5, CGRectGetHeight(self.albumPhoto.bounds) - 25, MAX(indexSize.width, 18), 18);
                
            }
                break;
            case GCTPhotosPickerBadgePositionRightTop:
            {
                self.pickingAssetsCountLabel.frame = CGRectMake(CGRectGetWidth(self.albumPhoto.bounds) - MAX(indexSize.width, 20) - 5, 5, MAX(indexSize.width, 20), 20);
                
            }
                break;
            case GCTPhotosPickerBadgePositionRightBottom:
            {
                self.pickingAssetsCountLabel.frame = CGRectMake(CGRectGetWidth(self.albumPhoto.bounds) - MAX(indexSize.width, 20) - 5, CGRectGetHeight(self.bounds) - 25, MAX(indexSize.width, 20), 20);
                
            }
                break;
            case GCTPhotosPickerBadgePositionNone:
            {
                self.pickingAssetsCountLabel.frame = CGRectZero;
            }
                break;
            default:
            {
                self.pickingAssetsCountLabel.frame = CGRectZero;
                
            }
                break;
        }
    }
    

}
- (void)setAlbum:(GCTPhotosPickerAlbum *)album {
    _album = album;
    self.albumTitle.text = album.albumName;
    self.assetsCountLabel.text = [NSString stringWithFormat:@"%@",@(_album.albumPhotosCount)];
    self.albumPhoto.image = _album.albumThumbnailImage;
    if (_album.pickingAssets.count > 0) {
        self.pickingAssetsCountLabel.text = [NSString stringWithFormat:@"%@", @(_album.pickingAssets.count)];
        self.pickingAssetsCountLabel.hidden = NO;
    } else {
        self.pickingAssetsCountLabel.hidden = YES;
        self.pickingAssetsCountLabel.text = @"";

    }
    [self layoutIfNeeded];
}

- (UILabel *)pickingAssetsCountLabel {
    if (!_pickingAssetsCountLabel) {
        _pickingAssetsCountLabel = [[UILabel alloc] init];
        _pickingAssetsCountLabel.backgroundColor = self.appearance.albumCellPickingAssetsCountBackgroundColor;
        _pickingAssetsCountLabel.textColor = self.appearance.albumCellPickingAssetsCountTextColor;
        _pickingAssetsCountLabel.font = self.appearance.albumCellPickingAssetsCountFont;
        _pickingAssetsCountLabel.layer.cornerRadius = self.appearance.albumCellPickingAssetsCountCornerRadius;
        _pickingAssetsCountLabel.layer.borderColor = self.appearance.albumCellPickingAssetsCountBackgroundColor.CGColor;
        _pickingAssetsCountLabel.textAlignment = NSTextAlignmentCenter;
        _pickingAssetsCountLabel.clipsToBounds = YES;
        

    }
    return _pickingAssetsCountLabel;
}
- (UIImageView *)albumPhoto {
    if (!_albumPhoto) {
        _albumPhoto = [[UIImageView alloc] init];
    }
    return _albumPhoto;
}
- (UILabel *)albumTitle {
    if (!_albumTitle) {
        _albumTitle = [[UILabel alloc] init];
        _albumTitle.font = self.appearance.albumCellTitleFont;
        _albumTitle.textColor = self.appearance.albumCellTitleTextColor;
    }
    return _albumTitle;
}
- (UILabel *)assetsCountLabel {
    if (!_assetsCountLabel) {
        _assetsCountLabel = [[UILabel alloc] init];
        _assetsCountLabel.font = self.appearance.albumCellAssetsCountTextFont;
        _assetsCountLabel.textColor = self.appearance.albumCellAssetsCountTextColor;
    }
    return _assetsCountLabel;
}
- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = self.appearance.albumCellSeparatorLineColor;

    }
    return _separatorLine;
}
- (void)setAppearance:(GCTPhotosPickerAppearance *)appearance {
    _appearance = appearance;
    
    if (_albumTitle) {
        self.albumTitle.font = self.appearance.albumCellTitleFont;
        self.albumTitle.textColor = self.appearance.albumCellTitleTextColor;
    }
    if (_assetsCountLabel) {
        self.assetsCountLabel.font = self.appearance.albumCellAssetsCountTextFont;
        self.assetsCountLabel.textColor = self.appearance.albumCellAssetsCountTextColor;
    }
    
    if (_pickingAssetsCountLabel) {
        self.pickingAssetsCountLabel.backgroundColor = self.appearance.albumCellPickingAssetsCountBackgroundColor;
        self.pickingAssetsCountLabel.layer.borderColor = self.appearance.albumCellPickingAssetsCountBackgroundColor.CGColor;

        self.pickingAssetsCountLabel.textColor = self.appearance.albumCellPickingAssetsCountTextColor;
        self.pickingAssetsCountLabel.font = self.appearance.albumCellPickingAssetsCountFont;
        self.pickingAssetsCountLabel.layer.cornerRadius = self.appearance.albumCellPickingAssetsCountCornerRadius;
        self.pickingAssetsCountLabel.clipsToBounds = YES;
    }
    if (_separatorLine) {
        self.separatorLine.backgroundColor = appearance.albumCellSeparatorLineColor;

    }
}
@end
