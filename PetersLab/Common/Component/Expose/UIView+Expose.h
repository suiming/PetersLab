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

- (BOOL)isExposing;

@end

NS_ASSUME_NONNULL_END
