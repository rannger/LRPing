//
//  PingManager.m
//  test-objc
//
//  Created by rannger on 2018/7/26.
//  Copyright © 2018年 rannger. All rights reserved.
//

#import "LRPingManager.h"
#import "LRPingOperation.h"


NSString* LRPingManagerFastHostNotification = @"PingManagerFastHostNotification";
NSString* LRPingManagerErrorNotification = @"PingManagerErrorNotification";
NSString* kHost = @"Host";

@interface LRPingManager () <LRPingOperationDelegate>
@property (nonatomic,strong) NSOperationQueue* queue;
@property (nonatomic,strong) NSDictionary* hostMap;
@property (nonatomic,strong) NSSet* failedTag;

@end

@implementation LRPingManager

+ (instancetype)shareInstance {
    static LRPingManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LRPingManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)runWithHosts:(NSArray<NSString*>*)hosts {
    [self runWithHosts:hosts waitUntilFinished:NO];
}

- (void)runWithHosts:(NSArray<NSString*>*)hosts waitUntilFinished:(BOOL)waitUntilFinished {
    [self runWithHosts:hosts waitUntilFinished:waitUntilFinished timeout:30];
}

- (void)runWithHosts:(NSArray<NSString *> *)hosts
   waitUntilFinished:(BOOL)waitUntilFinished
             timeout:(NSTimeInterval)timeout {
    NSAssert([NSThread isMainThread], @"");
    NSMutableDictionary* map = [NSMutableDictionary dictionaryWithCapacity:hosts.count];
    for (NSString* host in hosts) {
        [map setObject:host forKey:@(host.hash)];
    }
    
    _hostMap = [NSDictionary dictionaryWithDictionary:map];
    _failedTag = [NSSet set];
    NSMutableArray* ops = [NSMutableArray arrayWithCapacity:_hostMap.count];
    for (NSNumber* key in [_hostMap allKeys]) {
        NSString* host = [_hostMap objectForKey:key];
        LRPingOperation* op = [[LRPingOperation alloc] initWithTag:[key longLongValue] host:host];
        op.timeoutLimit = timeout;
        op.delegate = self;
        [ops addObject:op];
    }
    [_queue cancelAllOperations];
    _queue.maxConcurrentOperationCount = [_hostMap count];
    [_queue addOperations:[NSArray arrayWithArray:ops] waitUntilFinished:waitUntilFinished];
}

- (void)cancelAll {
    NSAssert([NSThread isMainThread], @"");
    [self clear];
}

- (void)clear {
    [_queue cancelAllOperations];
    _hostMap = nil;
    _failedTag = nil;
}

#pragma mark - PingOperationDelegate
- (void)lrpingOperationSuccessWithTag:(uint64_t)tag
{
    NSNumber* number = [NSNumber numberWithLongLong:tag];
    __weak typeof(self) weakSelf = self;
   
    dispatch_async(dispatch_get_main_queue() , ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf lrpingOperationSuccessWithTagInternal:number];
    });
}

- (void)lrpingOperationSuccessWithTagInternal:(NSNumber*)tag
{
    NSString* fastestHost = [_hostMap objectForKey:tag];
    [self clear];
    [[NSNotificationCenter defaultCenter] postNotificationName:LRPingManagerFastHostNotification
                                                        object:nil
                                                      userInfo:@{kHost:fastestHost}];
}

- (void)lrpingOperationFailedWithTag:(uint64_t)tag
{
    NSNumber* number = [NSNumber numberWithLongLong:tag];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue() , ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf lrpingOperationFailedWithTagInternal:number];
    });
}

- (void)lrpingOperationFailedWithTagInternal:(NSNumber*)tag {
    _failedTag = [_failedTag setByAddingObject:tag];
    
    NSSet* set = [NSSet setWithArray:_hostMap.allKeys];
    if ([set isEqualToSet:_failedTag]) {
        [self clear];
        [[NSNotificationCenter defaultCenter] postNotificationName:LRPingManagerErrorNotification object:nil];
    }
}


@end
