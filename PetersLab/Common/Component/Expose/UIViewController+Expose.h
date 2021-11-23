//
//  UIViewController+Expose.h
//  CassECommerce
//
//  Created by suiming on 2021/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Expose)

+ (UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END
