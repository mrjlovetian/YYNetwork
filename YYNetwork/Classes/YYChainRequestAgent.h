//
//  YYNhainRequestAgent.h
//  MRJ
//
//  Created by YY on 2017/3/15.
//  Copyright © 2017年 YY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YYNhainRequest;

@interface YYNhainRequestAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared chain request agent.
+ (YYNhainRequestAgent *)sharedAgent;

///  Add a chain request.
- (void)addChainRequest:(YYNhainRequest *)request;

///  Remove a previously added chain request.
- (void)removeChainRequest:(YYNhainRequest *)request;

@end

NS_ASSUME_NONNULL_END
