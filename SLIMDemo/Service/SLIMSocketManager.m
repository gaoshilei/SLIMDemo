//
//  SLIMSocketManager.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/18.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMSocketManager.h"
#import <Reachability.h>

#ifdef DEBUG
#define SLIMWS_DEFAULTURL @"ws://10.7.128.143:9000/ichat"
#else
#define SLIMWS_DEFAULTURL @"ws://10.7.128.143:9000/ichat"
#endif

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
NSString *const SLIMWebSocketErrorDomain = @"SLIMWebSocketErrorDomain";

@interface SLIMTimerProxy : NSProxy

@property (nonatomic, weak) SLIMSocketManager *weakManager;

@end

@implementation SLIMTimerProxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *signature = [self.weakManager methodSignatureForSelector:sel];
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.weakManager];
}
@end

@interface SLIMSocketManager()<SRWebSocketDelegate> {
    SRWebSocket     *_socket;
    Reachability    *_reachablility;
    NSTimer         *_heartbeat;
}

@property (nonatomic, assign) SLIMSocketState socketState;
@property (nonatomic, assign) NetworkStatus   networkState;
@property (nonatomic, strong) SLIMTimerProxy  *timerProxy;

@end

@implementation SLIMSocketManager

#pragma mark - life cycle

- (void)dealloc {
    NSLog(@"%s",__func__);
    [_reachablility stopNotifier];
    [self disconnect];
    [self p_destroyHeartbeat];
}

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
    if (!_reachablility.isReachable) {
        [self webSocket:_socket didFailWithError:[self p_socketErrorWithCode:SLIMSocketErrorCodeOffline reason:@"当前网络不可用"]];
        self.socketState = SLIMSocketStateOffline;
        return;
    }
    [self disconnect];
    NSLog(@"SLWebSocket is connecting...");
    self.socketState = SLIMSocketStateConnecting;
    [self p_initSocket];
}

- (void)disconnect {
    if (_socket) {
        NSLog(@"SLWebSocket is disconnecting...");
        [_socket close];
        _socket = nil;
    }
    self.socketState = SLIMSocketStateDisconnected;
}

- (void)send:(NSString *)message {
    if (_socketState != SLIMSocketStateConnected) {
        [self webSocket:_socket didFailWithError:[self p_socketErrorWithCode:SLIMSocketErrorCodeUnconnected reason:@"socket连接未建立"]];
        return;
    }
    [_socket send:message];
}

NSString *NSStringFromSocketState(SLIMSocketState state) {
    switch (state) {
        case SLIMSocketStateOffline: return @"socket状态：网络中断";
        case SLIMSocketStateConnecting: return @"socket状态：正在连接";
        case SLIMSocketStateConnected: return @"socket状态：已连接";
        case SLIMSocketStateDisconnected: return @"socket状态：连接断开";
        default: return @"socket状态：未知状态";
    }
}

NSString *NSStringFromSocketErrorCode(SLIMSocketErrorCode code) {
    switch (code) {
        case SLIMSocketErrorCodeUnknown: return @"❌socket错误：未知错误";
        case SLIMSocketErrorCodeOffline: return @"❌socket错误：网络中断";
        case SLIMSocketErrorCodeTimeout: return @"❌socket错误：连接超时";
        case SLIMSocketErrorCodeServerError: return @"❌socket错误：服务器出错";
        case SLIMSocketErrorCodeConnectionClosed: return @"❌socket错误：连接被关闭";
        case SLIMSocketErrorCodeStreamWriting: return @"❌socket错误：数据流写入出错";
        case SLIMSocketErrorCodeServerCert: return @"❌socket错误：服务器证书错误";
        case SLIMSocketErrorCodeUnconnected: return @"❌socket错误：连接还未建立";
    }
}

#pragma mark - socket连接
- (void)p_initSocket {
    //SRWebSockets are intended for one-time-use only. Open should be called once and only once.
    //当重连时，需要创建一个新的 SRWebSocket
    _socket = [[SRWebSocket alloc] initWithURLRequest:self.request];
    _socket.delegate = self;
    [_socket open];
}

- (void)p_initNetworkReachability {
    _reachablility = [Reachability reachabilityForInternetConnection];
    __weak SLIMSocketManager *weakSelf = self;
    _reachablility.unreachableBlock = ^(Reachability *reachability) {
        weakSelf.socketState = NotReachable;
        NSLog(@"Reachability: 当前网络不可用😭！");
        if (weakSelf) {
            weakSelf.socketState = SLIMSocketStateOffline;
        }
    };
    _reachablility.reachableBlock = ^(Reachability *reachability) {
        NetworkStatus networkState = reachability.isReachableViaWWAN?ReachableViaWWAN:ReachableViaWiFi;
        NSLog(@"Reachability: 当前是%@可用😘！networkState:%ld=======weakSelf.networkState:%ld==%@",reachability.isReachableViaWWAN?@"当前是移动网络":@"当前是wifi网络",(long)networkState,(long)weakSelf.networkState,NSStringFromSocketState(weakSelf.socketState));
        if (!weakSelf) {
            return;
        }
        if (networkState != weakSelf.networkState) {
            weakSelf.networkState = networkState;
            [weakSelf p_reconnect];
        }else if (weakSelf.socketState == SLIMSocketStateOffline || weakSelf.socketState == SLIMSocketStateDisconnected) {
            [weakSelf p_reconnect];
        }
    };
    [_reachablility startNotifier];
}

- (void)p_reconnect {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"webSocket reconnecting...");
        [self connect];
    });
}

- (NSError *)p_socketErrorWithCode:(NSInteger)code reason:(NSString *)reason {
    return [NSError errorWithDomain:SLIMWebSocketErrorDomain code:code userInfo:[NSDictionary dictionaryWithObject:reason forKey:NSLocalizedDescriptionKey]];
}

#pragma mark - 心跳

- (void)p_initHeartbeat {
    dispatch_main_async_safe(^{
        [self p_destroyHeartbeat];
        self.timerProxy = [SLIMTimerProxy alloc];
        self.timerProxy.weakManager = self;
        self.heartbeatInterval = self.heartbeatInterval>0?self.heartbeatInterval<10?self.heartbeatInterval:2:2;
        _heartbeat = [NSTimer scheduledTimerWithTimeInterval:self.heartbeatInterval*60 target:self.timerProxy selector:@selector(p_heartBeat) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_heartbeat forMode:NSRunLoopCommonModes];
    })
}

- (void)p_destroyHeartbeat {
    dispatch_main_async_safe(^{
        if (_heartbeat) {
            [_heartbeat invalidate];
            _heartbeat = nil;
        }
    })
}

- (void)p_heartBeat {
    if (_socket) {
        [_socket send:@"heartbeat"];
    }
}

#pragma mark - SRWebSocketDelegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"didReceiveMessage:%@",message);
    if (!message) {
        return;
    }
    if ([message isKindOfClass:[NSString class]] && [message isEqualToString:@""]) {
        return;
    }
    [self.delegate webSocket:self didReceiveMessage:message];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"webSocketDidOpen");
    [self p_initHeartbeat];
    self.socketState = SLIMSocketStateConnected;
    if ([self.delegate respondsToSelector:@selector(webSocketDidOpen:)]) {
        [self.delegate webSocketDidOpen:self];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError:%@",error.description);
    if ([self.delegate respondsToSelector:@selector(webSocket:didFailWithError:connectionErrorCode:)]) {
        SLIMSocketErrorCode errorCode = SLIMSocketErrorCodeUnknown;
        switch (error.code) {
            case 57://连接被关闭(大多数情况是应用处于后台)
                errorCode = SLIMSocketErrorCodeConnectionClosed;
                break;
            case 61://服务器拒绝连接
            case 2132://服务器返回错误代码
            case 2133://服务器返回Sec-WebSocket-Accept请求头无效
                errorCode = SLIMSocketErrorCodeServerError;
                break;
            case 504://连接服务器超时
                errorCode = SLIMSocketErrorCodeTimeout;
                break;
            case 2145://数据流写入错误
                errorCode = SLIMSocketErrorCodeStreamWriting;
                break;
            case 10001://网络不可用
                errorCode = SLIMSocketErrorCodeOffline;
                break;
            case 10007://连接还没有建立成功
                errorCode = SLIMSocketErrorCodeUnconnected;
                break;
            case 23556://服务器证书错误
                errorCode = SLIMSocketErrorCodeServerCert;
                break;
            default:
                errorCode = SLIMSocketErrorCodeUnknown;
                break;
        }
        NSLog(@"%@",NSStringFromSocketErrorCode(errorCode));
        [self.delegate webSocket:self didFailWithError:error connectionErrorCode:errorCode];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"webSocketDidCloseWithCode:%ld reason:%@",code,reason);
    self.socketState = SLIMSocketStateDisconnected;
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
