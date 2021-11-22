//
//  ExposeManager.h
//  PetersLab
//
//  Created by suiming on 2021/11/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Expose.h"
#import "ExposeDataManager.h"

NS_ASSUME_NONNULL_BEGIN



@interface ExposeManager : NSObject

+ (void)setExposeTime:(CGFloat)time timeInterval:(CGFloat)interval;

+ (ExposeManager *)sharedInstance;

+ (void)startTracking;

+ (void)stopTracking;

+ (void)setExposeBlock:(ExposeViewBlock)exposeBlock;

+ (void)trackView:(UIView *)view
    componentName:(NSString *)componentName
           dataId:(NSString *)dataid
      trackParams:(NSDictionary *)params;

+ (void)removePageData:(NSString *)pageName;

- (void)removePageData:(NSString *)pageName componentName:(NSString *)componentName;

@end

NS_ASSUME_NONNULL_END
