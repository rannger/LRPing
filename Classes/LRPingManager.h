//
//  PingManager.h
//  test-objc
//
//  Created by rannger on 2018/7/26.
//  Copyright © 2018年 rannger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* LRPingManagerFastHostNotification;
extern NSString* LRPingManagerErrorNotification;

@interface LRPingManager : NSObject
+ (instancetype)shareInstance;
- (void)runWithHosts:(NSArray<NSString*>*)hosts;
@end
