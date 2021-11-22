//
//  UIViewController+Expose.m
//  CassECommerce
//
//  Created by suiming on 2021/11/22.
//  Copyright © 2021 CassTime. All rights reserved.
//

#import "UIViewController+Expose.h"
#import <objc/runtime.h>
#import "ExposeManager.h"

@implementation UIViewController (Expose)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                       class_getInstanceMethod(self.class, @selector(expose_dealloc)));
    });
}

- (void)expose_dealloc {
    [ExposeManager removePageData:NSStringFromClass([self class])];
    [self expose_dealloc];
}

+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController * nextResponder = window.rootViewController;
    result = [self getCurrentVisibleVC:nextResponder];
    
    return result;
}


+ (UIViewController *)getCurrentVisibleVC:(id)nextResponder {
    
    UIViewController *result = nil;
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        UITabBarController * nextVc = (UITabBarController *)nextResponder;
        nextResponder = nextVc.viewControllers[nextVc.selectedIndex];
         result =  [self getCurrentVisibleVC:nextResponder];
        
    } else if([nextResponder isKindOfClass:[UINavigationController class]]) {
        UINavigationController * Navi = (UINavigationController *)nextResponder;
        result = Navi.visibleViewController;
        if (result) result = [self getCurrentVisibleVC:result];
    }
    else if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    
    return result ?: nextResponder;
}

@end
