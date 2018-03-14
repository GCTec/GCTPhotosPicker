//
//  GCTPhotosPickerActivityView.h
//  GCTPhotosPicker
//
//  Created by Later on 18/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCTPhotosPickerActivityView : UIView
- (void)showWithRect:(CGRect)rect message:(NSString *)message animated:(BOOL)animated completion:(void(^)(void))completion;
- (void)showWithMessage:(NSString *)message animated:(BOOL)animated completion:(void(^)(void))completion;
- (void)hideAnimated:(BOOL)animated completion:(void(^)(void))completion;
- (void)refreshMessage:(NSString *)message;
@end
