//
//  AppDelegate.m
//  PetersLab
//
//  Created by suiming on 2021/10/30.
//

#import "AppDelegate.h"
#import "ExposeManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [ExposeManager setExposeBlock:^(ExposeItem * item) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (item.exView) {
                item.exView.backgroundColor =  [UIColor orangeColor];
                if ([item.exView isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel *)item.exView;
                    label.textColor = [UIColor orangeColor];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                item.exView.backgroundColor =  [UIColor clearColor];
                if ([item.exView isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel *)item.exView;
                    label.textColor = [UIColor blackColor];
                }
            });
        });
    }];
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
