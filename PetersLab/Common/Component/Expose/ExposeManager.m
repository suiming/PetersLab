//
//  ExposeManager.m
//  PetersLab
//
//  Created by suiming on 2021/11/20.
//

#import "ExposeManager.h"
#import "ExposeTimer.h"

@interface ExposeManager ()

@property(nonatomic, strong) ExposeTimer *timer;

@end



@implementation ExposeManager

+ (ExposeManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static ExposeManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });

    return _sharedObject;
}

+ (void)beginTracking {
    if (ExposeManager.sharedInstance.timer) {
        [ExposeManager.sharedInstance.timer stopLoop];
        ExposeManager.sharedInstance.timer = nil;
    }
    ExposeTimer *timer = [[ExposeTimer alloc]init];
    ExposeManager.sharedInstance.timer = timer;
    [timer beginLoop];
}

+ (void)stopTracking {
    [ExposeManager.sharedInstance.timer stopLoop];
}

+ (void)removeDataFromPage:(NSString *)pageName componentName:(NSString *)componentName dataId:(NSString *)dataid {
    [ExposeDataManager.sharedInstance removeDataFromPage:pageName componentName:componentName dataId:dataid];
}

+ (void)addDataForPage:(NSString *)pageName componentName:(NSString *)componentName view:(UIView *)view {
    [ExposeDataManager.sharedInstance addDataForPage:pageName componentName:componentName view:view];
}

+ (void)loopUnsafeComponentsForPageName:(NSString *)pageName {
    [ExposeDataManager.sharedInstance loopUnsafeComponentsForPageName:pageName];
}

+ (void)setExposeBlock:(ExposeViewBlock)exposeBlock {
    ExposeDataManager.sharedInstance.exposeBlock = exposeBlock;
}


- (void)removePageData:(NSString *)pageName {
    [ExposeDataManager.sharedInstance removePageData:pageName];
}

- (void)removePageData:(NSString *)pageName componentName:(NSString *)componentName {
    [ExposeDataManager.sharedInstance removePageData:pageName componentName:componentName];
}


@end
