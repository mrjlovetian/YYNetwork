//
//  YYBatchRequestAgent.m
//  MRJ
//
//  Created by YY on 2017/2/27.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYBatchRequestAgent.h"

#import "YYBatchRequest.h"

@interface YYBatchRequestAgent()

@property (strong,nonatomic) NSMutableArray<YYBatchRequest *> *requestArray;

@end

@implementation YYBatchRequestAgent

+ (YYBatchRequestAgent *)sharedAgent {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addBatchRequest:(YYBatchRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeBatchRequest:(YYBatchRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}


@end
