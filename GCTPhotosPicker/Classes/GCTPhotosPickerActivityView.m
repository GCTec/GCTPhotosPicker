//
//  GCTPhotosPickerActivityView.m
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import "GCTPhotosPickerActivityView.h"

@interface GCTPhotosPickerActivityView ()
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end
@implementation GCTPhotosPickerActivityView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.activityIndicator];
        [self addSubview:self.messageLabel];
        [self.activityIndicator startAnimating];
        self.alpha = 0;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize activitySize = self.activityIndicator.frame.size;
    if (CGRectGetWidth(self.bounds) - activitySize.width > 0 && CGRectGetHeight(self.bounds) - activitySize.height > 0) {
        self.activityIndicator.frame = CGRectMake((CGRectGetWidth(self.bounds) - activitySize.width)/2.f, (CGRectGetHeight(self.bounds) - activitySize.height)/2.f - 100, activitySize.width, activitySize.height);
        self.messageLabel.frame = CGRectMake(10, CGRectGetHeight(self.bounds)/2.f-60, CGRectGetWidth(self.bounds) - 20, 30);
    }

}
- (void)showWithRect:(CGRect)rect message:(NSString *)message animated:(BOOL)animated completion:(void(^)(void))completion {
    self.messageLabel.text = message;
    if (animated) {
        __weak typeof(self)weakSelf = self;
        self.frame = rect;
        if (self.alpha != 1) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.alpha = 1;
            } completion:^(BOOL finished) {
                !completion ?: completion();

            }];
        }
    } else {
        self.frame = rect;
        if (self.alpha != 1) {
            self.alpha = 1;
            !completion ?: completion();
        }
    }
}
- (void)showWithMessage:(NSString *)message animated:(BOOL)animated completion:(void(^)(void))completion {
    self.messageLabel.text = message;
    if (animated) {
        __weak typeof(self)weakSelf = self;
        if (self.alpha != 1) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.alpha = 1;
            } completion:^(BOOL finished) {
                !completion ?: completion();
                
            }];
        }
    } else {
        if (self.alpha != 1) {
            self.alpha = 1;
            !completion ?: completion();
        }
    }
}
- (void)hideAnimated:(BOOL)animated completion:(void(^)(void))completion  {
    if (animated) {
        __weak typeof(self)weakSelf = self;
        if (self.alpha != 0) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.alpha = 0;
            } completion:^(BOOL finished) {
                !completion ?: completion();
                
            }];
        }
    } else {
        if (self.alpha != 0) {
            self.alpha = 0;
            !completion ?: completion();
        }
    }
}
- (void)refreshMessage:(NSString *)message {
    self.messageLabel.text = message;
    [self layoutIfNeeded];
}
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndicator;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor colorWithRed:147.f/255 green:147.f/255 blue:147.f/255 alpha:1];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}
@end
