//
//  GSNoticeManager.m
//  GSAPNSManager
//
//  Created by 席萍萍 on 16/9/18.
//  Copyright © 2016年 Brook. All rights reserved.
//

#import "GSNoticeManager.h"


#pragma mark - GSServiceMap

@interface GSServiceMap : NSObject

@property (nonatomic,   copy) NSString *service;
@property (nonatomic, strong) NSMapTable *map;

+ (instancetype)mapWithService:(NSString *)service;

@end


@implementation GSServiceMap

+ (instancetype)mapWithService:(NSString *)service {
    GSServiceMap *map = [[GSServiceMap alloc] init];
    map.service = service;
    
    return map;
}

- (NSMapTable *)map {
    if (!_map) {
        _map = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsCopyIn];
        //block的value虽然weak和strong,copy均有效，但是为了安全起见，还是使用常用的copy策略
    }
    
    return _map;
}

@end


#pragma mark - GSNoticeManager;

@interface GSNoticeManager ()

/// 这个 map 的容器其实使用字典更合适，且效果更高，以后替换为 NSMutableDictionary
@property (nonatomic, strong) NSMutableArray *mapArray;

@end

@implementation GSNoticeManager

+ (instancetype)sharedManger {
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


- (void)registerBlock:(GSNoticeBlock)block service:(NSString *)service forObserver:(id)observer {
    GSServiceMap *mapModel = [self mapForService:service];
    [mapModel.map setObject:block forKey:observer];
}


- (void)unregisterService:(NSString *)service forObserver:(id)observer {
    GSServiceMap *mapModel = [self mapForService:service];
    [mapModel.map removeObjectForKey:observer];
}

- (void)triggerService:(NSString *)service userInfo:(id)userInfo {
    GSServiceMap *mapModel = [self mapForService:service];
    NSString *key = nil;
    NSEnumerator *enumerator = [mapModel.map keyEnumerator];
    while (key = [enumerator nextObject]) {
        GSNoticeBlock block = [mapModel.map objectForKey:key];
        !block ?: block(userInfo);
    }
}

#pragma mark - private
- (GSServiceMap *)mapForService:(NSString *)service {
    for (GSServiceMap *mapModel in self.mapArray) {
        if ([mapModel.service isEqualToString:service]) {
            return mapModel;
        }
    }
    
    GSServiceMap *mapModel = [GSServiceMap mapWithService:service];
    [self.mapArray addObject:mapModel];
    
    return mapModel;
}

- (NSMutableArray *)mapArray {
    if (!_mapArray) {
        _mapArray = [NSMutableArray arrayWithCapacity:5];
    }
    
    return _mapArray;
}

@end
