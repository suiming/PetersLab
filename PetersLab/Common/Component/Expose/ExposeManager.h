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

+ (ExposeManager *)sharedInstance;

+ (void)beginTracking;

+ (void)stopTracking;

+ (void)removeDataFromPage:(NSString *)pageName componentName:(NSString *)componentName dataId:(NSString *)dataid;

+ (void)addDataForPage:(NSString *)pageName componentName:(NSString *)componentName view:(UIView *)view;

+ (void)loopUnsafeComponentsForPageName:(NSString *)pageName;

+ (void)setExposeBlock:(ExposeViewBlock)exposeBlock;

- (void)removePageData:(NSString *)pageName;

- (void)removePageData:(NSString *)pageName componentName:(NSString *)componentName;

@end

NS_ASSUME_NONNULL_END
