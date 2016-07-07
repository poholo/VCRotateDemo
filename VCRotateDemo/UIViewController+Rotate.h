//
//  UIViewController+Rotate.h
//  VCRotateDemo
//
//  Created by majiancheng on 16/7/8.
//  Copyright © 2016年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Rotate)

@property (nonatomic, strong) UIView * playerView;
@property (nonatomic, assign) BOOL     isAutorotate;

#pragma mark - IOS 5 Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation ;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration ;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation ;

#pragma mark - IOS 6 Rotation
- (BOOL)shouldAutorotate;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations ;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation ;

#pragma mark ios7 横竖屏切换

/**
 *  根据当前屏幕方向，重新定义view的frame
 *
 *  @param orientation 屏幕方向
 *
 *  @return 适配后的frame
 */
- (CGRect)frameForOrientation:(UIInterfaceOrientation)orientation ;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration ;

#pragma IOS8 横竖屏
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator ;

@end
