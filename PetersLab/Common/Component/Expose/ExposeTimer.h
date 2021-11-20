//
//  ExposeTimer.h
//  PetersLab
//
//  Created by suiming on 2021/11/20.
//

#import <Foundation/Foundation.h>
#import "ExposeDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExposeTimer : NSObject

- (void)beginLoop;

- (void)stopLoop;

@end

NS_ASSUME_NONNULL_END
