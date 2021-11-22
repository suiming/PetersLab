//
//  UIView+Expose.h
//  PetersLab
//
//  Created by suiming on 2021/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Expose)

@property(nonatomic, copy) NSString *exposeId;

@property(nonatomic, strong) NSDictionary *exposeParams;

// 用于判断是否满足曝光条件
- (BOOL)isExposing;

// 用于判断是否在屏幕上： 不在时需要移除
- (BOOL)isOnScreen;

@end

NS_ASSUME_NONNULL_END
