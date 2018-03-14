//
//  GCTPhotosPickerItemCell.m
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import "GCTPhotosPickerItemCell.h"
#import <PhotosUI/PhotosUI.h>
#import "GCTPhotosPickerAppearance.h"
#import "GCTPhotosPickerCachingImageManager.h"
@interface GCTPhotosPickerItemCell ()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UILabel *selectedIndexNumberLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *subTypeImageView;
@property (nonatomic, assign) GCTPhotosPickerBadgePosition selectedBadgePosition;
@property (nonatomic, assign) GCTPhotosPickerBadgePosition selectedindexNumberPosition;
@property (nonatomic, assign) GCTPhotosPickerBadgePosition subTypeBadgePosition;
@property (nonatomic, strong) GCTPhotosPickerAppearance *itemAppearance;
@property (nonatomic, strong) UIView *coverView;
@end
@implementation GCTPhotosPickerItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.photoImageView];
        [self addSubview:self.subTypeImageView];
        [self addSubview:self.selectedButton];
        [self addSubview:self.selectedIndexNumberLabel];
        [self addSubview:self.coverView];
        [self addSubview:self.timeLabel];
    }
    return self;
}
- (void)prepareForReuse {
    [super prepareForReuse];
    if (!self.itemAppearance.showSelectedBadge)    self.selectedButton.selected = NO;
    if (!self.itemAppearance.showSubTypeBadge)  self.subTypeImageView.image = nil;
    if (!self.itemAppearance.showSelectedIndexNumberBadge) self.selectedIndexNumberLabel.hidden = YES;
    self.photoImageView.image = nil;
    self.coverView.alpha = 0;
    self.selectedButton.selected = NO;
    self.layer.borderWidth = 0;
    self.timeLabel.text = @"";
    self.timeLabel.frame = CGRectZero;
    self.subTypeImageView.image = nil;
    
}
- (void)showCover {
    self.coverView.hidden = NO;
    if (self.coverView.alpha != 0.5) {
        [UIView animateWithDuration:0.2 animations:^{
            self.coverView.alpha = 0.5;
        }];
    }
}
- (void)hideCover {
    if (self.coverView.alpha != 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.coverView.alpha = 0;
        } completion:^(BOOL finished) {
            self.coverView.hidden = YES;
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.photoImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.coverView.frame = self.bounds;
    [self layoutSelectedBadge];
    [self layoutSubTypeBadge];
  
  
}

- (void)layoutSelectedBadge {
    switch (self.selectedBadgePosition) {
        case GCTPhotosPickerBadgePositionLeftTop:
        {
            self.selectedButton.frame = CGRectMake(0, 0, 30, 30);
        }
            break;
        case GCTPhotosPickerBadgePositionLeftBottom:
        {
            self.selectedButton.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 30, 30, 30);
            
        }
            break;
        case GCTPhotosPickerBadgePositionRightTop:
        {
            self.selectedButton.frame = CGRectMake(CGRectGetHeight(self.bounds) - 30, 0, 30, 30);
            
        }
            break;
        case GCTPhotosPickerBadgePositionRightBottom:
        {
            self.selectedButton.frame = CGRectMake(CGRectGetHeight(self.bounds)-30, CGRectGetHeight(self.bounds) - 30, 30, 30);
            
        }
            break;
        default:
        {
            self.selectedButton.frame = CGRectMake(CGRectGetHeight(self.bounds) - 30, 0, 30, 30);
        }
            break;
    }
}
- (void)layoutSubTypeBadge {
    
    switch (self.subTypeBadgePosition) {
        case GCTPhotosPickerBadgePositionLeftTop:
        {
            self.subTypeImageView.frame = CGRectMake(0, 0, 28, 28);
            
        }
            break;
        case GCTPhotosPickerBadgePositionLeftBottom:
        {
            self.subTypeImageView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 28, 28, 28);
            
        }
            break;
        case GCTPhotosPickerBadgePositionRightTop:
        {
            self.subTypeImageView.frame = CGRectMake(CGRectGetHeight(self.bounds)-28, 0, 28, 28);
            
        }
            break;
        case GCTPhotosPickerBadgePositionRightBottom:
        {
            self.subTypeImageView.frame = CGRectMake(CGRectGetHeight(self.bounds)-28, CGRectGetHeight(self.bounds) - 28, 28, 28);
            
        }
            break;
        default:
        {
            self.subTypeImageView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 28, 28, 28);
            
        }
            break;
    }
}
- (CGRect)selectedIndexNumberLabelRect {
    if (self.selected) {
        
        if (self.index > 0) {
            NSString *indexStr = [NSString stringWithFormat:@"%@",@(self.index)];
            CGSize indexSize = [indexStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds) - 35, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
            switch (self.selectedindexNumberPosition) {
                case GCTPhotosPickerBadgePositionLeftTop:
                    return CGRectMake(5, 5, MAX(indexSize.width, 20) , 20);
                    break;
                case GCTPhotosPickerBadgePositionRightTop:
                    return CGRectMake(CGRectGetWidth(self.bounds) - MAX(indexSize.width, 20) - 5, 5, MAX(indexSize.width, 20), 20);
                    break;
                case GCTPhotosPickerBadgePositionLeftBottom:
                    return CGRectMake(5, CGRectGetHeight(self.bounds) - 25, MAX(indexSize.width, 18), 18);
                    break;
                case GCTPhotosPickerBadgePositionRightBottom:
                    return CGRectMake(CGRectGetWidth(self.bounds) - MAX(indexSize.width, 20) - 5, CGRectGetHeight(self.bounds) - 25, MAX(indexSize.width, 20), 20);
                    break;
                default:
                    return CGRectMake(5, 5, MAX(indexSize.width, 20), 20);
                    
                    break;
            }
        } else {
            switch (self.selectedindexNumberPosition) {
                case GCTPhotosPickerBadgePositionLeftTop:
                    return CGRectMake(15, 15, 0, 0);
                    break;
                case GCTPhotosPickerBadgePositionRightTop:
                    return CGRectMake(CGRectGetWidth(self.bounds) - 15, 15, 0, 0);
                    break;
                case GCTPhotosPickerBadgePositionLeftBottom:
                    return CGRectMake(15, CGRectGetHeight(self.bounds) - 15, 0, 0);
                    break;
                case GCTPhotosPickerBadgePositionRightBottom:
                    return CGRectMake(CGRectGetWidth(self.bounds) - 15, CGRectGetHeight(self.bounds) - 15, 0, 0);
                    break;
                default:
                    return CGRectMake(15, 15, 0, 0);
                    
                    break;
            }
        }
    } else {
        NSString *indexStr = [NSString stringWithFormat:@"%@",@(self.index)];
        CGSize indexSize = [indexStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds) - 35, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        switch (self.selectedindexNumberPosition) {
            case GCTPhotosPickerBadgePositionLeftTop:
                return CGRectMake(5 + MAX(indexSize.width, 20)/2.f, 15, 0 , 0);
                break;
            case GCTPhotosPickerBadgePositionRightTop:
                return CGRectMake(CGRectGetWidth(self.bounds) - MAX(indexSize.width, 20) - 5 + MAX(indexSize.width, 20)/2.f, 15, 0,0);
                break;
            case GCTPhotosPickerBadgePositionLeftBottom:
                return CGRectMake(5 + MAX(indexSize.width, 18)/2.f, CGRectGetHeight(self.bounds) - 25 + 9, 0, 0);
                break;
            case GCTPhotosPickerBadgePositionRightBottom:
                return CGRectMake(CGRectGetWidth(self.bounds) - MAX(indexSize.width, 20) - 5 + MAX(indexSize.width, 20)/2.f, CGRectGetHeight(self.bounds) - 15, 0, 0);
                break;
            default:
                return CGRectMake(5 + MAX(indexSize.width, 20)/2.f, 15, 0 , 0);
                break;
        }
    }
}
- (void)refreshAsset {
    
    if (@available(iOS 9.1, *)) {
        if ( self.asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
            self.subTypeImageView.image = [self livePhotoBadge];
            self.timeLabel.text = @"";
            self.timeLabel.frame = CGRectZero;
        }
    } else  if (self.asset.mediaType & PHAssetMediaTypeVideo) {
        self.timeLabel.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%@", @(self.asset.duration)]];
        CGSize timeSize = [self.timeLabel.text boundingRectWithSize:CGSizeMake(40, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.timeLabel.font} context:nil].size;
        switch (self.subTypeBadgePosition) {
            case GCTPhotosPickerBadgePositionLeftTop:
            {
                self.timeLabel.frame = CGRectMake(0, 0, 6+timeSize.width + 6, 24);

                
            }
                break;
            case GCTPhotosPickerBadgePositionLeftBottom:
            {
                self.timeLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 24, 6+timeSize.width + 6, 24);

                
            }
                break;
            case GCTPhotosPickerBadgePositionRightTop:
            {
                self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - 12 - timeSize.width, 0, 12+timeSize.width , 24);

                
            }
                break;
            case GCTPhotosPickerBadgePositionRightBottom:
            {
                self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - 12 - timeSize.width, CGRectGetHeight(self.bounds) - 24, 12+timeSize.width , 24);

                
            }
                break;
            default:
            {
                self.timeLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 24, 12+timeSize.width , 24);
                
            }
                break;
        }
       
    }
    [self layoutIfNeeded];
}
#pragma mark Action
- (void)selectedButtonClicked {
    
    if ([self.delegate respondsToSelector:@selector(pickerItemCellSelectedButtonClicked:)]) {
        [self.delegate pickerItemCellSelectedButtonClicked:self];
    }

}
- (void)selected:(BOOL)selected animated:(BOOL)animated {
    self.selected = selected;
//    if (self.selected != selected) {
//        [super setSelected:selected];
//    }
    if (self.selected && self.selectedButton.selected) {
        if (self.itemAppearance.showSelectedIndexNumberBadge) {
            self.selectedIndexNumberLabel.frame = [self selectedIndexNumberLabelRect];
            
        }
        if (self.itemAppearance.showSelectedBoard) {
            self.layer.borderWidth = self.itemAppearance.slelectedBoardWidth;
            self.layer.borderColor = self.itemAppearance.selectedBoardColor.CGColor;
        }
    }
    if (self.selected && !self.selectedButton.selected) {
        if([self.selectedButton.layer.animationKeys containsObject:@"transformAnimation"]) {
            [self.selectedButton.layer removeAnimationForKey:@"transformAnimation"];
        }
        if([self.selectedIndexNumberLabel.layer.animationKeys containsObject:@"transformAnimation"]) {
            [self.selectedIndexNumberLabel.layer removeAnimationForKey:@"transformAnimation"];
        }
        self.selectedIndexNumberLabel.frame = [self selectedIndexNumberLabelRect];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            if (self.itemAppearance.showSelectedBoard) {
                self.layer.borderWidth = self.itemAppearance.slelectedBoardWidth;
                self.layer.borderColor = self.itemAppearance.selectedBoardColor.CGColor;
                
            }
            if (self.itemAppearance.showSelectedBadge) {
                if (animated) {
                    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                    animation.values = @[@(0) , @(1.0)];
                    animation.duration = 0.2;
                    [self.selectedButton.layer addAnimation:animation forKey:@"transformAnimation"];
                }
            }
            if (self.itemAppearance.showSelectedIndexNumberBadge) {
                self.selectedIndexNumberLabel.hidden = NO;
                if (animated) {
                    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                    animation.values = @[@(0) , @(1.0)];
                    animation.duration = 0.2;
                    [self.selectedIndexNumberLabel.layer addAnimation:animation forKey:@"transformAnimation"];
                }
            }
            
        } completion:^(BOOL finished) {
            self.selectedButton.selected = self.selected;
            
            if ([self.delegate respondsToSelector:@selector(pickerItemCell:didSelected:)]) {
                [self.delegate pickerItemCell:self didSelected:self.selectedButton.selected];
            }
        }];
    }
    if (!self.selected && self.selectedButton.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (self.itemAppearance.showSelectedBoard) {
                self.layer.borderWidth = self.itemAppearance.unSlelectedBoardWidth;
                self.layer.borderColor = self.itemAppearance.unSelectedBoardColor.CGColor;
                
            }
            
            if (self.itemAppearance.showSelectedIndexNumberBadge) {
                self.selectedIndexNumberLabel.hidden = YES;
            }
            
        } completion:^(BOOL finished) {
            self.selectedButton.selected = self.selected;
            
            if ([self.delegate respondsToSelector:@selector(pickerItemCell:didSelected:)]) {
                [self.delegate pickerItemCell:self didSelected:self.selectedButton.selected];
            }
        }];
    }
    if (!self.selected && !self.selectedButton.selected) {
        //无操作
    }

}
- (void)refreshSelected {
    
    
}
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",(long)seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)seconds%60];
    //format of time
    if (seconds/3600 > 0) {
        return [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];

    } else {
        return [NSString stringWithFormat:@"%@:%@",str_minute,str_second];

    }
    
    
}
#pragma mark Setter/Getter
- (void)setIndex:(NSInteger)index {
    if (index > 0) {
        _index = index;
        self.selectedIndexNumberLabel.text = [NSString stringWithFormat:@"%@",@(_index)];
    } else {
        _index = 0;
        self.selectedIndexNumberLabel.text = @"";
        
    }
}
//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    if (selected) {
//        [self selected:selected animated:YES];
//    }
//}
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.backgroundColor = [UIColor whiteColor];
        [_photoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_photoImageView setClipsToBounds:YES];
    }
    return _photoImageView;
}
- (UIImageView *)subTypeImageView {
    if (!_subTypeImageView) {
        _subTypeImageView = [[UIImageView alloc] init];
//        _subTypeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _subTypeImageView;
}
- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setImage:[GCTPhotosPickerAppearance appearance].selectedImage forState:UIControlStateSelected];
        [_selectedButton setImage:[GCTPhotosPickerAppearance appearance].unSelectedImage forState:UIControlStateNormal];
        [_selectedButton addTarget:self action:@selector(selectedButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _selectedButton;
}
- (UILabel *)selectedIndexNumberLabel {
    if (!_selectedIndexNumberLabel) {
        _selectedIndexNumberLabel = [[UILabel alloc] init];
        _selectedIndexNumberLabel.textAlignment = NSTextAlignmentCenter;
        _selectedIndexNumberLabel.font = [UIFont systemFontOfSize:12];
    }
    return _selectedIndexNumberLabel;
}
- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    [self refreshAsset];
}
#pragma mark Images
//- (UIImage *)videoImageBadge {
//    return [UIImage imageNamed:@"GCTPhotosPicker.bundle/gct_photos_picker_item_mediaType_Video"];
//}
- (UIImage *)livePhotoBadge {
    if (@available(iOS 9.1, *)) {
        return [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
    }
    return nil;
}
#pragma mark Extension
- (void)setItemAppearance:(GCTPhotosPickerAppearance *)itemAppearance {
    _itemAppearance = itemAppearance;
    self.selectedButton.hidden = !itemAppearance.showSelectedBadge;
    self.selectedBadgePosition = itemAppearance.selectedBadgePosition;
    self.subTypeImageView.hidden = !itemAppearance.showSubTypeBadge;
    self.subTypeBadgePosition = itemAppearance.subTypeBadgePosition;
    
    self.layer.borderColor = itemAppearance.unSelectedBoardColor.CGColor;
    self.selectedIndexNumberLabel.hidden = !itemAppearance.showSelectedIndexNumberBadge;
    self.selectedIndexNumberLabel.layer.cornerRadius = !itemAppearance.selectedIndexNumberBadgeCornerRadius;
    self.selectedindexNumberPosition = itemAppearance.selectedIndexNumberBadgePosition;
    
    self.selectedIndexNumberLabel.backgroundColor = self.itemAppearance.selectedIndexNumberBadgeBackgroundColor;
    self.selectedIndexNumberLabel.textColor = self.itemAppearance.selectedIndexNumberBadgeTitleColor;
    self.selectedIndexNumberLabel.layer.cornerRadius = self.itemAppearance.selectedIndexNumberBadgeCornerRadius;
    self.selectedIndexNumberLabel.layer.borderColor = self.itemAppearance.selectedIndexNumberBadgeBackgroundColor.CGColor;
    self.selectedIndexNumberLabel.clipsToBounds = YES;
    
    [self.selectedButton setImage:itemAppearance.selectedImage forState:UIControlStateSelected];
    [self.selectedButton setImage:itemAppearance.unSelectedImage forState:UIControlStateNormal];
    switch (self.selectedindexNumberPosition) {
        case GCTPhotosPickerBadgePositionLeftTop:
            self.selectedIndexNumberLabel.frame = CGRectMake(15, 15, 0, 0);
            break;
        case GCTPhotosPickerBadgePositionRightTop:
            self.selectedIndexNumberLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - 15, 15, 0, 0);
            break;
        case GCTPhotosPickerBadgePositionLeftBottom:
            self.selectedIndexNumberLabel.frame = CGRectMake(15, CGRectGetHeight(self.bounds) - 15, 0, 0);
            break;
        case GCTPhotosPickerBadgePositionRightBottom:
            self.selectedIndexNumberLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - 15, CGRectGetHeight(self.bounds) - 15, 0, 0);
            break;
        default:
            self.selectedIndexNumberLabel.frame = CGRectMake(15, 15, 0, 0);
            
            break;
    }
    
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _coverView.hidden = YES;
    }
    return _coverView;
}
@end
