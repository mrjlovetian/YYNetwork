//
//  YYBaseRequest.m
//  TopsTechNetWorking
//
//  Created by YY on 2017/2/17.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYBaseRequest.h"
#import "YYNetworkAgent.h"
#import "YYNetworkPrivate.h"

NSString *const YYRequestValidationErrorDomain = @"com.mrj.request.validation";

@interface YYBaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) id responseJSONObject;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) NSString *responseString;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@implementation YYBaseRequest

#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}

- (BOOL)isCancelled {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}



#pragma mark - Request Configuration

- (void)setCompletionBlockWithSuccess:(YYRequestCompletionBlock)success
                              failure:(YYRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (void)addAccessory:(id<YYRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

#pragma mark - Request Action

- (void)start {
    ///网络请求前回调
    [self toggleAccessoriesWillStartCallBack];
    ///网络请求开启
    [[YYNetworkAgent sharedAgent] addRequest:self];
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[YYNetworkAgent sharedAgent] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (void)startWithCompletionBlockWithSuccess:(YYRequestCompletionBlock)success
                                    failure:(YYRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

#pragma mark - Subclass Override

- (void)requestCompletePreprocessor {
}

- (void)requestCompleteFilter {
}

- (void)requestFailedPreprocessor {
}

- (void)requestFailedFilter {
}

- (NSString *)requestUrl {
    return @"";
}

- (NSString *)cdnUrl {
    return @"";
}

- (NSString *)baseUrl {
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

//- (id)requestArgument {
//    
//    return nil;
//}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}

- (YYRequestMethod)requestMethod {
    return YYRequestMethodGET;
}

- (YYRequestSerializerType)requestSerializerType {
    return YYRequestSerializerTypeHTTP;
}

- (YYResponseSerializerType)responseSerializerType {
    return YYResponseSerializerTypeJSON;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

//- (NSDictionary *)requestHeaderFieldValueDictionary {
//    return nil;
//}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)useCDN {
    return NO;
}

- (BOOL)allowsCellularAccess {
    return YES;
}

- (id)jsonValidator {
    return nil;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    return (statusCode >= 200 && statusCode <= 299);
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, self.currentRequest.URL, self.currentRequest.HTTPMethod, self.requestArgument];
}


@end
