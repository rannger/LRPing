//
//  PingOperation.h
//  test-objc
//
//  Created by rannger on 2018/7/26.
//  Copyright © 2018年 rannger. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LRPingOperationDelegate <NSObject>
- (void)lrpingOperationSuccessWithTag:(uint64_t)tag;
- (void)lrpingOperationFailedWithTag:(uint64_t)tag;
@end

@interface LRPingOperation : NSOperation
@property (nonatomic,assign) uint64_t tag;
@property (nonatomic,copy) NSString* hostName;
@property (nonatomic,assign) NSTimeInterval timeoutLimit; // default is 30s
@property (nonatomic,weak) id<LRPingOperationDelegate> delegate;

- (instancetype)initWithTag:(uint64_t)tag host:(NSString*)host;
@end
