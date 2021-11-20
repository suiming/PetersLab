//
//  UIView+Expose.m
//  PetersLab
//
//  Created by suiming on 2021/11/20.
//

#import "UIView+Expose.h"
#import <objc/runtime.h>

const void * exposeViewKey = "expose_view_key";

@implementation UIView (Expose)

- (NSString *)exposeId {
    return (NSString *)objc_getAssociatedObject(self, exposeViewKey);
}

- (void)setExposeId:(NSString *)exposeId {
    objc_setAssociatedObject(self, exposeViewKey, exposeId, OBJC_ASSOCIATION_COPY);
}


- (BOOL)isExposing {
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    
    NSInteger centerX = ceil(rect.origin.x + rect.size.width /2);
    NSInteger centerY = ceil(rect.origin.y + rect.size.height /2);
    CGSize size = [UIApplication sharedApplication].keyWindow.bounds.size;
    BOOL isExposing = centerX > 0 && centerX < size.width && centerY > size.height * 0.1 && centerY < size.height * 0.9;
    return isExposing;
}

@end

