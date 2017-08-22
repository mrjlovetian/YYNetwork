//
//  YYNhainRequestAgent.m
//  MRJ
//
//  Created by YY on 2017/3/15.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYChainRequestAgent.h"

@interface YYNhainRequestAgent()

@property(strong,nonatomic) NSMutableArray<YYNhainRequest *> *requestArray;

@end

@implementation YYNhainRequestAgent

+ (YYNhainRequestAgent *)sharedAgent {
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

- (void)addChainRequest:(YYNhainRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeChainRequest:(YYNhainRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}


@end
