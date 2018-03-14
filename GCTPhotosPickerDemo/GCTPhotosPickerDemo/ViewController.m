//
//  ViewController.m
//  GCTPhotosPickerDemo
//
//  Created by 罗树新 on 2018/3/14.
//  Copyright © 2018年 GCT. All rights reserved.
//

#import "ViewController.h"
#import "GCTPhotosPicker.h"
@interface ViewController ()<GCTPhotosPickerDelegate>
@property (nonatomic, strong) NSArray *assets;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    GCTPhotosPickerViewController *photosPicker = [[GCTPhotosPickerViewController alloc] init];
    photosPicker.pickerType = GCTPhotosPickerTypePhotos;
    photosPicker.maximumNumberOfSelectionPhotos = 20;
    photosPicker.delegate = self;
//    photosPicker.pickingAssets = [self.assets mutableCopy];
    [self presentViewController:photosPicker animated:YES completion:nil];
}
- (void)photosPicker:(GCTPhotosPickerViewController *)photosPicker didFinishedPickingAssets:(NSMutableArray<PHAsset *> *)pickingAssets {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds) - 50)/4;
    self.assets = pickingAssets;
    [[GCTPhotosPickerCachingImageManager defaultManager] requestImages:pickingAssets targetSize:CGSizeMake(width * [UIScreen mainScreen].scale, width * [UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFill options:nil completed:^(NSArray<UIImage *> *images, NSArray<NSDictionary *> *infos) {
        CGFloat x = 10;
        CGFloat y = 20;
        CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds) - 50)/4;
        CGFloat height = width;
        for (NSInteger i = 0; i < pickingAssets.count; i++) {
            x = 10 * (i%4 +1)  + i%4 * width;
            y = 20 + (10 + height) *(i/4 + 1);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x , y, width, height)];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setClipsToBounds:YES];
            imageView.image = images[i];
            [self.view addSubview:imageView];
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
