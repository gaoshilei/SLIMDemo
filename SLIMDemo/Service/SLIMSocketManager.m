//
//  SLIMSocketManager.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/18.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMSocketManager.h"
#import <Reachability.h>

#define SLIMWS_DEFAULTURL @"ws://10.7.128.143:9000/ichat"

NSString *const SLIMWebSocketErrorDomain = @"SLIMWebSocketErrorDomain";

@interface SLIMSocketManager()<SRWebSocketDelegate> {
    SRWebSocket     *_socket;
    Reachability    *_reachablility;
}

@property (nonatomic, assign) SLIMSocketState socketState;

@end

@implementation SLIMSocketManager

#pragma mark - life cycle

#pragma mark - public method

- (instancetype)initWithDelegate:(id<SLIMWebSocketDelegate>)delegate {
    return [self initWithUrl:[NSURL URLWithString:SLIMWS_DEFAULTURL] delegate:delegate];
}

- (instancetype)initWithUrl:(NSURL *)url delegate:(id<SLIMWebSocketDelegate>)delegate {
    return [self initWithRequest:[[NSURLRequest alloc] initWithURL:url] delegate:delegate];
}

- (instancetype)initWithRequest:(NSURLRequest *)request delegate:(id<SLIMWebSocketDelegate>)delegate {
    if (self = [super init]) {
        _request = request;
        _delegate = delegate;
        [self p_initNetworkReachability];
    }
    return self;
}

- (void)connect {
    NSLog(@"SLWebSocket is connecting...");
    if (!_reachablility.isReachable) {
        if ([self.delegate respondsToSelector:@selector(webSocket:didFailWithError:connectionErrorReason:)]) {
            [self.delegate webSocket:self didFailWithError:[NSError errorWithDomain:SLIMWebSocketErrorDomain code:100 userInfo:[NSDictionary dictionaryWithObject:@"当前网络不可用" forKey:NSLocalizedDescriptionKey]] connectionErrorReason:SLIMSocketConnectionErrorOffline];
        }
        self.socketState = SLIMSocketStateOffline;
        return;
    }
    self.socketState = SLIMSocketStateConnecting;
    [self p_initSocket];
}

- (void)disconnect {
    NSLog(@"SLWebSocket is disconnecting...");
    if (_socket) {
        [_socket close];
        self.socketState = SLIMSocketStateDisconnected;
    }
}

- (void)reconnect {
    [self disconnect];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self p_initSocket];
    });
}

- (void)send:(NSString *)message {
    if (_socketState != SLIMSocketStateConnected) {
        NSLog(@"无有效连接，无法发送消息，请稍后再试！");
        return;
    }
    [_socket send:message];
}

#pragma mark - private method

- (void)p_initSocket {
    if (!_socket) {
        _socket = [[SRWebSocket alloc] initWithURLRequest:self.request];
        _socket.delegate = self;
    }
    [_socket open];
}

- (void)p_initNetworkReachability {
    _reachablility = [Reachability reachabilityForInternetConnection];
    __weak SLIMSocketManager *weakSelf = self;
    _reachablility.unreachableBlock = ^(Reachability *reachability) {
        NSLog(@"Reachability: 当前网络不可用😭！");
        if (weakSelf) {
            weakSelf.socketState = SLIMSocketStateOffline;
        }
    };
    _reachablility.reachableBlock = ^(Reachability *reachability) {
        NSLog(@"Reachability: 当前网络可用😘！");
        if (!weakSelf) {
            return;
        }
        if (weakSelf.socketState == SLIMSocketStateOffline) {
            weakSelf.socketState = SLIMSocketStateConnecting;
        }
    };
    [_reachablility startNotifier];
    self.socketState = SLIMSocketStateConnecting;
}

#pragma mark - heart beat test
- (void)p_heartBeat {
    [_socket send:@"headrt"];
}

#pragma mark - SRWebSocketDelegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"didReceiveMessage:%@",message);
    [self.delegate webSocket:self didReceiveMessage:message];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"webSocketDidOpen");
    self.socketState = SLIMSocketStateConnected;
    if ([self.delegate respondsToSelector:@selector(webSocketDidOpen:)]) {
        [self.delegate webSocketDidOpen:self];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError:%@",error.description);
    if ([self.delegate respondsToSelector:@selector(webSocket:didFailWithError:connectionErrorReason:)]) {
        SLIMSocketConnectionError errorReason = SLIMSocketConnectionErrorUnknown;
        if (error.code == 57) {//大多数情况是应用处于后台，连接被关闭
            errorReason = SLIMSocketConnectionErrorClosed;
        }else if (error.code == 61) {//服务器拒绝连接
            errorReason = SLIMSocketConnectionErrorServerDown;
        }else if (error.code == 504) {//连接服务器超时
            errorReason = SLIMSocketConnectionErrorTimeout;
        }
        [self.delegate webSocket:self didFailWithError:error connectionErrorReason:errorReason];
    }
    self.socketState = SLIMSocketStateDisconnected;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"didCloseWithCode:%ld reason:%@",code,reason);
    if ([self.delegate respondsToSelector:@selector(webSocket:didCloseWithCode:reason:wasClean:)]) {
        [self.delegate webSocket:self didCloseWithCode:code reason:reason wasClean:wasClean];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"didReceivePong:%@",[[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding]);
    if ([self.delegate respondsToSelector:@selector(webSocket:didReceivePong:)]) {
        [self.delegate webSocket:self didReceivePong:pongPayload];
    }
}

@end
