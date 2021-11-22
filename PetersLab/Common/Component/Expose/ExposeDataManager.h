//
//  ExposeDataManager.h
//  PetersLab
//
//  Created by suiming on 2021/11/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExposeItem : NSObject

// 曝光时间
@property(nonatomic, assign)  CGFloat exTime;

// 曝光视图
@property(nonatomic, weak)  UIView * exView;

// 广告数据唯一id
@property(nonatomic, copy)  NSString * exDataid;


@end


typedef void (^ExposeViewBlock)(ExposeItem *);

@interface ExposeDataManager : NSObject

@property(nonatomic, copy) ExposeViewBlock exposeBlock;

+ (ExposeDataManager *)sharedInstance;

- (void)removeDataFromPage:(NSString *)pageName componentName:(NSString *)componentName dataId:(NSString *)dataid;

- (void)resetDataFromPage:(NSString *)pageName componentName:(NSString *)componentName dataId:(NSString *)dataid;

- (void)addDataForPage:(NSString *)pageName componentName:(NSString *)componentName view:(UIView *)view;

- (void)loopUnsafeComponentsForPageName:(NSString *)pageName exposeTime:(CGFloat)exposeTime timeInterVal:(CGFloat)interval;

- (void)removePageData:(NSString *)pageName;

- (void)removePageData:(NSString *)pageName componentName:(NSString *)componentName;

@end

NS_ASSUME_NONNULL_END
