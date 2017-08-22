//
//  YYBetworkAgent.h
//  TopsTechNetWorking
//
//  Created by YY on 2017/2/17.
//  Copyright © 2017年 YY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYBetworkAgent : NSObject

-(instancetype)init;

+(YYBetworkAgent *)sharedAgent;

-(void)addRequest:(YYBaseRequest *)request;

-(void)cancelRequest:(YYBaseRequest *)request;

-(void)cancelAllRequests;

///  Return the constructed URL of request.
///
///  @param request The request to parse. Should not be nil.
///
///  @return The result URL.
- (NSString *)buildRequestUrl:(YYBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
