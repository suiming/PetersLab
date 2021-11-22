//
//  ExposeDataManager.m
//  PetersLab
//
//  Created by suiming on 2021/11/20.
//

#import "ExposeDataManager.h"
#import <YYKit/YYKit.h>
#import "UIView+Expose.h"

@implementation ExposeItem

// For Debugging
- (NSString *)description {
    return [NSString stringWithFormat:@"%@:  %f",self.exDataid, self.exTime];
}

@end



@interface ExposeDataManager ()

@property (nonatomic, strong) NSMutableDictionary *pagesDict;

@end

@implementation ExposeDataManager

//单例
+ (ExposeDataManager *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static ExposeDataManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];         // or some other init method
    });

    return _sharedObject;
}



- (NSMutableDictionary *)pagesDict {
    if (!_pagesDict) {
        _pagesDict = [NSMutableDictionary dictionary];
    }
    return _pagesDict;
}


- (NSMutableDictionary *)getPageDataByPage:(NSString *)pageName {
    NSMutableDictionary *componentsDict = [self.pagesDict objectForKey:pageName];

    return componentsDict;
}

// 获取某个页面下某个组件的统计
- (NSMutableDictionary *)getComponentDataByPage:(NSString *)pageName componentName:(NSString *)componentName {
    NSMutableDictionary *componentsDict = [self getPageDataByPage:pageName];
    NSMutableDictionary *datasDict = [componentsDict objectForKey:componentName];
    return datasDict;
}

- (ExposeItem *)getDataByPage:(NSString *)pageName componentName:(NSString *)componentName dataId:(NSString *)dataid {
    if (dataid.length > 0) {
        NSMutableDictionary* datasDict = [self getComponentDataByPage:pageName componentName:componentName];
        ExposeItem *item =[datasDict objectForKey:dataid];
        return item;
    } else {
        return nil;
    }

}


- (void)setDataForPage:(NSString *)pageName componentName:(NSString *)componentName itemData:(ExposeItem *)itemData {
    NSMutableDictionary *componentsDict = [self.pagesDict objectForKey:pageName];
    if (!componentsDict) {
        componentsDict = self.pagesDict[pageName] = [NSMutableDictionary dictionary];
    }

    NSMutableDictionary *datasDict = [componentsDict objectForKey:componentName];
    if (!datasDict) {
        datasDict = componentsDict[componentName] = [NSMutableDictionary dictionary];
    }

    if (itemData && itemData.exDataid) {
        [datasDict setObject:itemData forKey:itemData.exDataid];
    }
}

// 设置时间
- (void)setTime:(CGFloat)toTime ForExposeItem:(ExposeItem *)item {
    item.exTime = toTime;
}

+ (ExposeItem *)exposeItemFromView:(UIView *)view {
    ExposeItem *item = [[ExposeItem alloc]init];
    item.exTime = 0;
    item.exDataid = view.exposeId;
    item.exView = view;
    return item;
}

// 移除 dataid 对应的数据
- (void)removeDataFromPage:(NSString *)pageName componentName:(NSString *)componentName dataId:(NSString *)dataid {
    if (dataid.length > 0) {
        NSMutableDictionary *datasDict = [self getComponentDataByPage:pageName componentName:componentName];
        [datasDict removeObjectForKey:dataid];
    }

}

- (void)resetDataFromPage:(NSString *)pageName componentName:(NSString *)componentName dataId:(NSString *)dataid {
    ExposeItem *item = [self getDataByPage:pageName componentName:componentName dataId:dataid];
    if (item) {
        [self setTime:0 ForExposeItem:item];
    }
}

// 执行这条，说明被加载进来，设置时间为0
- (void)addDataForPage:(NSString *)pageName componentName:(NSString *)componentName view:(UIView *)view {
    ExposeItem *item = [self getDataByPage:pageName componentName:componentName dataId:view.exposeId];
    if (!item) {
        item = [ExposeDataManager exposeItemFromView:view];
    } else {
        [self setTime:0 ForExposeItem:item];
    }
    [self setDataForPage:pageName componentName:componentName itemData:item];

}

// 遍历
- (void)loopUnsafeComponentsForPageName:(NSString *)pageName exposeTime:(CGFloat)exposeTime timeInterVal:(CGFloat)interval {
    // 曝光时间只能多，不能少； (当一个曝光卡在下一个遍历即将到来时，实际真实曝光为interval， 计算曝光时间为 2 * interval)
    CGFloat indidExposeTime = exposeTime + interval;
    
    // 只处理当前页面数据，减少功耗
    NSMutableDictionary *componentsDict =  [self.pagesDict objectForKey:pageName];
    [componentsDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSMutableDictionary *datasDict, BOOL * _Nonnull stop) {
         [datasDict enumerateKeysAndObjectsUsingBlock:^(NSString * data_id, ExposeItem *item, BOOL * _Nonnull stop) {
              if ([item isKindOfClass:[ExposeItem class]]) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                     if (item.exView.isOnScreen) {
                         if (item.exView.isExposing) {
                             item.exTime += interval;
                             if (item.exTime - indidExposeTime >= 0 && item.exTime - indidExposeTime < interval) {
                                 [self exposeAction:item];
                             }
                         }
                     } else {
                         [self resetDataFromPage:pageName componentName:key dataId:data_id];
                     }
                 });
              }
          }];
     }];
}

- (void)removePageData:(NSString *)pageName {
    if (pageName.length > 0) {
        [self.pagesDict removeObjectForKey:pageName];
    }
}

- (void)removePageData:(NSString *)pageName componentName:(NSString *)componentName {
    if (pageName.length > 0) {
        NSMutableDictionary *componentsDict = [self.pagesDict objectForKey:pageName];
        if (componentName.length > 0) {
            [componentsDict removeObjectForKey:componentName];
        }
    }
}

// 满足条件的曝光
- (void)exposeAction:(ExposeItem *)item {
    if (self.exposeBlock) {
        self.exposeBlock(item);
    }
}

@end
