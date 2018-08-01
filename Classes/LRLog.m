//
//  log.c
//  test-objc
//
//  Created by rannger on 2018/7/26.
//  Copyright © 2018年 rannger. All rights reserved.
//

#import "LRLog.h"
#import "DDLog.h"

//根据工程需要确定ddLogLevel

#ifdef DEBUG
const int ddLogLevel = DDLogLevelVerbose;
#else
const int ddLogLevel = DDLogLevelError;
#endif
