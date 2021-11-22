//
//  ExposeManager.m
//  PetersLab
//
//  Created by suiming on 2021/11/20.
//

#import "ExposeManager.h"
#import "ExposeTimer.h"
#import "UIViewController+Expose.h"

@interface ExposeManager ()

@property(nonatomic, strong) ExposeTimer *timer;

@property(nonatomic, assign) NSInteger exposeTime;

@property(nonatomic, assign) CGFloat exposeInterval;

@property(nonatomic, assign) BOOL isRunningLoop;

@end



@implementation ExposeManager

- (ExposeTimer *)timer {
    if (!_timer) {
        ExposeTimer *timer = [[ExposeTimer alloc]init];
        timer.exposeTime = ExposeManager.sharedInstance.exposeTime;
        timer.exposeInterval = ExposeManager.sharedInstance.exposeInterval;
        _timer = timer;
    }
    return _timer;
}

+ (void)setExposeTime:(CGFloat)time timeInterval:(CGFloat)interval {
    ExposeManager.sharedInstance.exposeTime = time;
    ExposeManager.sharedInstance.exposeInterval = interval;
}

+ (ExposeManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static ExposeManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        _sharedObject.exposeTime = 3;
        _sharedObject.exposeInterval = 0.5;
    });

    return _sharedObject;
}

+ (void)startTracking {
    if (ExposeManager.sharedInstance.timer) {
        [ExposeManager.sharedInstance.timer stopLoop];
        ExposeManager.sharedInstance.timer = nil;
    }
    
    [ExposeManager.sharedInstance.timer startLoop];
    ExposeManager.sharedInstance.isRunningLoop = YES;
}

+ (void)stopTracking {
    if (ExposeManager.sharedInstance.isRunningLoop) {
        [ExposeManager.sharedInstance.timer stopLoop];
        ExposeManager.sharedInstance.isRunningLoop = NO;
    }
}

+ (void)trackView:(UIView *)view
    componentName:(NSString *)componentName
           dataId:(NSString *)dataid
      trackParams:(NSDictionary *)params {
    NSString *pageName = NSStringFromClass([[UIViewController getCurrentVC] class]);
    [ExposeManager removeDataFromPage:pageName componentName:componentName dataId:view.exposeId];
    [ExposeManager removeDataFromPage:pageName componentName:componentName dataId:dataid];
    view.exposeId = dataid;
    view.exposeParams = params;
    [ExposeManager addDataForPage:pageName componentName:componentName view:view];
    
    // 按需启动，节省资源
    if (!ExposeManager.sharedInstance.isRunningLoop) {
        [ExposeManager startTracking];
    }
}

+ (void)removeDataFromPage:(NSString *)pageName componentName:(NSString *)componentName dataId:(NSString *)dataid {
    [ExposeDataManager.sharedInstance removeDataFromPage:pageName componentName:componentName dataId:dataid];
}

+ (void)addDataForPage:(NSString *)pageName componentName:(NSString *)componentName view:(UIView *)view {
    [ExposeDataManager.sharedInstance addDataForPage:pageName componentName:componentName view:view];
}

+ (void)setExposeBlock:(ExposeViewBlock)exposeBlock {
    ExposeDataManager.sharedInstance.exposeBlock = exposeBlock;
}


+ (void)removePageData:(NSString *)pageName {
    [ExposeDataManager.sharedInstance removePageData:pageName];
    // 按需启动，节省资源
    if (ExposeDataManager.sharedInstance.isPageEmputy) {
        [ExposeManager stopTracking];
    }
}

- (void)removePageData:(NSString *)pageName componentName:(NSString *)componentName {
    [ExposeDataManager.sharedInstance removePageData:pageName componentName:componentName];
}


@end
