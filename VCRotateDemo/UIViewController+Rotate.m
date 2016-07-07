//
//  UIViewController+Rotate.m
//  VCRotateDemo
//
//  Created by majiancheng on 16/7/8.
//  Copyright © 2016年 mjc. All rights reserved.
//

#import "UIViewController+Rotate.h"
#import <objc/runtime.h>
#import <Masonry.h>

#define ScreenWidth9Division16 [UIScreen mainScreen].bounds.size.width * 9.0f / 16.0f

@implementation UIViewController (Rotate)

#pragma mark - IOS 5 Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//}
//
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//}

#pragma mark - IOS 6 Rotation

- (BOOL)shouldAutorotate {
    return self.isAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark ios7 横竖屏切换

/**
 *  根据当前屏幕方向，重新定义view的frame
 *
 *  @param orientation 屏幕方向
 *
 *  @return 适配后的frame
 */
- (CGRect)frameForOrientation:(UIInterfaceOrientation)orientation {
    CGRect frame;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) { //全屏
        CGRect bounds = [UIScreen mainScreen].bounds;
        frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
        //        self.playerView.frame = frame;
        [self rotate2Landscape];
        
    } else { //竖屏
        frame = [UIScreen mainScreen].bounds;
        //        self.playView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth9Division16);
        [self rotate2Portrait];
    }
    
    return frame;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.9f) {  //>= iOS8
        return;
    }
    
    self.playerView.frame = [self frameForOrientation:interfaceOrientation];
}

#pragma IOS8 横竖屏
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) { //横屏
            [self rotate2Landscape];
        } else { //竖屏
            [self rotate2Portrait];
        }
        
    }                            completion:nil];
}


#pragma mark -
#pragma mark setter getter
- (void)setIsAutorotate:(BOOL)isAutorotate {
    objc_setAssociatedObject(self, @selector(isAutorotate), @(isAutorotate), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isAutorotate {
    return [objc_getAssociatedObject(self, @selector(isAutorotate)) boolValue];
}

- (void)setPlayerView:(UIView *)playerView {
    objc_setAssociatedObject(self, @selector(playerView), playerView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)playerView {
    return objc_getAssociatedObject(self, @selector(playerView));
}

- (void)rotate2Landscape {
    [self setStatusBarHidden:YES];
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    //TODO:: 更新播放器界面布局
    /*
    [self.playerView setPlayerStyle:WQPlayerStyleSizeClassCompact];
    [self.playerView layoutIfNeeded];
     */
}

- (void)rotate2Portrait {
//    [self.playerView updateFullScreenBtn];
    [self setStatusBarHidden:NO];
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(ScreenWidth9Division16);
    }];
    
    //更新播放器界面布局
    /*
    [self.playerView setPlayerStyle:WQPlayerStyleSizeClassRegularHalf];
    [self.playerView layoutIfNeeded];
     */
}

- (void)rotate2PortraitFullScreen {
//    [self.playerView updateFullScreenBtn];
    [self setStatusBarHidden:YES];
    [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    //更新播放器布局
    /*
    [self.playerView setPlayerStyle:WQPlayerStyleSizeClassRegular];
    [self.playerView layoutIfNeeded];
     */
}

- (void)setStatusBarHidden:(BOOL)isHidden {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden animated:YES];
#pragma clang diagnostic pop
}


//设置横竖屏

- (void)updatePlayerRegularHalf {
    //横屏时切换竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [self setStatusBarHidden:NO];
}

- (void)updatePlayerRegular {
    //竖屏时切换成横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [self setStatusBarHidden:YES];
}

- (void)updatePlayerCompact {
    //横屏时切换竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [self setStatusBarHidden:NO];
    
}


@end
