//
//  YYBatchRequestAgent.h
//  TopsTechNetWorking
//
//  Created by YY on 2017/2/27.
//  Copyright © 2017年 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class YYBatchRequest;

@interface YYBatchRequestAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared batch request agent.
+ (YYBatchRequestAgent *)sharedAgent;

///  Add a batch request.
- (void)addBatchRequest:(YYBatchRequest *)request;

///  Remove a previously added batch request.
- (void)removeBatchRequest:(YYBatchRequest *)request;


@end
NS_ASSUME_NONNULL_END
