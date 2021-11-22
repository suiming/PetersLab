//
//  ExposeTimer.m
//  PetersLab
//
//  Created by suiming on 2021/11/20.
//

#import "ExposeTimer.h"
#import "UIViewController+Expose.h"

@interface ExposeTimer ()

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong)dispatch_queue_t seriralQueue;

@property(nonatomic, strong)dispatch_queue_t concurrent;

@end



@implementation ExposeTimer

- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认
        self.exposeTime = 3;
        self.exposeInterval = 0.5;
    }
    return self;
}

// 在一个串行队列执行Timer
- (void)startLoop {
    self.seriralQueue = dispatch_queue_create("ExposeTimerQueue", DISPATCH_QUEUE_SERIAL);
    self.concurrent = dispatch_queue_create("ExposeOperation", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(self.seriralQueue, ^{
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)stopLoop {
    [self.timer invalidate];
    self.timer = nil;
}

-(NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.exposeInterval target:self selector:@selector(loopOnce) userInfo:nil repeats:YES];
    }
    return _timer;
}

// 在多线程上执行具体操作
- (void)loopOnce {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *viewController = [UIViewController getCurrentVC];
        NSString *pageName = NSStringFromClass([viewController class]);
        
        dispatch_async(self.concurrent, ^{
            [ExposeDataManager.sharedInstance loopUnsafeComponentsForPageName:pageName exposeTime:self.exposeTime timeInterVal:self.exposeInterval];
        });
    });
        
}


@end
