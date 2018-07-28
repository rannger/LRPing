//
//  PingManager.h
//  test-objc
//
//  Created by rannger on 2018/7/26.
//  Copyright © 2018年 rannger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const LRPingManagerFastHostNotification;
extern NSString* const LRPingManagerErrorNotification;

@interface LRPingManager : NSObject
+ (instancetype)shareInstance;
- (void)runWithHosts:(NSArray<NSString*>*)hosts;
- (void)runWithHosts:(NSArray<NSString*>*)hosts
   waitUntilFinished:(BOOL)waitUntilFinished; //default is NO
- (void)runWithHosts:(NSArray<NSString *> *)hosts
   waitUntilFinished:(BOOL)waitUntilFinished //default is NO
             timeout:(NSTimeInterval)timeout; //default is 30
- (void)cancelAll;
@end
