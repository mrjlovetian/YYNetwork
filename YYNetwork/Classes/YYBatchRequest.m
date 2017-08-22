//
//  YYBatchRequest.m
//  MRJ
//
//  Created by YY on 2017/2/27.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYBatchRequest.h"
#import "YYNetworkPrivate.h"
#import "YYBatchRequestAgent.h"
#import "YYRequest.h"

@interface YYBatchRequest() <YYRequestDelegate>

@property (nonatomic) NSInteger finishedCount;

@end

@implementation YYBatchRequest

- (instancetype)initWithRequestArray:(NSArray<YYRequest *> *)requestArray {
    self = [super init];
    if (self) {
        _requestArray = [requestArray copy];
        _finishedCount = 0;
        for (YYRequest * req in _requestArray) {
            if (![req isKindOfClass:[YYRequest class]]) {
                YYLog(@"Error, request item must be YYRequest instance.");
                return nil;
            }
        }
    }
    return self;
}

- (void)start {
    if (_finishedCount > 0) {
        YYLog(@"Error! Batch request has already started.");
        return;
    }
    _failedRequest = nil;
    [[YYBatchRequestAgent sharedAgent] addBatchRequest:self];
    [self toggleAccessoriesWillStartCallBack];
    for (YYRequest * req in _requestArray) {
        req.delegate = self;
        [req clearCompletionBlock];
        [req start];
    }
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    _delegate = nil;
    [self clearRequest];
    [self toggleAccessoriesDidStopCallBack];
    [[YYBatchRequestAgent sharedAgent] removeBatchRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(nullable void (^)(YYBatchRequest *batchRequest))success
                                   progress:(void(^)(float percent))progress
                                    failure:(nullable void (^)(YYBatchRequest *batchRequest))failure{
    [self  setCompletionBlockWithSuccess:success progress:progress failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(YYBatchRequest *batchRequest))success
                             progress:(void(^)(float percent))progress
                              failure:(void (^)(YYBatchRequest *batchRequest))failure {
    self.successCompletionBlock = success;
    self.percentCompletionBlock = progress;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.percentCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (BOOL)isDataFromCache {
    BOOL result = YES;
    for (YYRequest *request in _requestArray) {
        if (!request.isDataFromCache) {
            result = NO;
        }
    }
    return result;
}


- (void)dealloc {
    [self clearRequest];
}

#pragma mark - Network Request Delegate

- (void)requestFinished:(YYRequest *)request {
    _finishedCount++;
    if (_finishedCount == _requestArray.count) {
        //回调完成
        if ([_delegate respondsToSelector:@selector(batchRequestPercentFinished:)]) {
            [_delegate batchRequestPercentFinished:1.0];
        }
        if(_percentCompletionBlock)
        {
            float percent = floorf(1.0);
            _percentCompletionBlock(percent);
        }
        
        //告诉调用者网络请求完成
        [self toggleAccessoriesWillStopCallBack];
        
        //回调完成
        if ([_delegate respondsToSelector:@selector(batchRequestFinished:)]) {
            [_delegate batchRequestFinished:self];
        }
        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        [self clearCompletionBlock];
        [self toggleAccessoriesDidStopCallBack];
        [[YYBatchRequestAgent sharedAgent] removeBatchRequest:self];
    }else{
        
        float percent = [[NSString stringWithFormat:@"%.2f", floorf(_finishedCount) / floorf(_requestArray.count)] floatValue];
        //回调完成百分比
        if ([_delegate respondsToSelector:@selector(batchRequestPercentFinished:)]) {
            [_delegate batchRequestPercentFinished:percent];
        }
        
        if(_percentCompletionBlock)
        {
            
            _percentCompletionBlock(percent);
        }
    }
}

- (void)requestFailed:(YYRequest *)request {
    _failedRequest = request;
    [self toggleAccessoriesWillStopCallBack];
    // Stop
    for (YYRequest *req in _requestArray) {
        [req stop];
    }
    // Callback
    if ([_delegate respondsToSelector:@selector(batchRequestFailed:)]) {
        [_delegate batchRequestFailed:self];
    }
    if (_failureCompletionBlock) {
        _failureCompletionBlock(self);
    }
    // Clear
    [self clearCompletionBlock];
    
    [self toggleAccessoriesDidStopCallBack];
    [[YYBatchRequestAgent sharedAgent] removeBatchRequest:self];
}

- (void)clearRequest {
    for (YYRequest * req in _requestArray) {
        [req stop];
    }
    [self clearCompletionBlock];
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<YYRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}


@end
