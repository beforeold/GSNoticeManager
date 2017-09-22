//
//  GSNoticeManager.h
//  GSAPNSManager
//
//  Created by 席萍萍 on 16/9/18.
//  Copyright © 2016年 Brook. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  通知事件回调
 *
 *  @param userInfo 携带的相关信息
 */
typedef void(^GSNoticeBlock)(id userInfo);


/**
 *  通知事件管理类
 */
@interface GSNoticeManager : NSObject

/**
 *  获取共享的实例
 *
 *  @return 共享实例
 */
+ (instancetype)sharedManger;

/**
 *  为特定服务注册回调事件
 *
 *  @param block    回调事件
 *  @param service  服务名称
 *  @param observer 调用的观察者
 */
- (void)registerBlock:(GSNoticeBlock)block service:(NSString *)service forObserver:(id)observer;


/**
 *  激活服务以通知观察者进行事件回调
 *
 *  @param service  服务名称
 *  @param userInfo 携带的相关信息
 */
- (void)triggerService:(NSString *)service userInfo:(id)userInfo;








/**
 *  取消特定服务回调事件的注册
 *  ！NoticeManager会对观察者observer进行弱引用
 *  所以在观察者observer生命周期结束时并不需要取消回调的注册
 *  因此该方法只在你认为确实需要取消的场景下调用
 *
 *  @param service  服务名称
 *  @param observer 调用的观察者
 */
- (void)unregisterService:(NSString *)service forObserver:(id)observer;


@end
