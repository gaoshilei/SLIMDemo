//
//  SLIMSocketManager.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/18.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>

typedef NS_ENUM(NSInteger, SLIMSocketState) {
    /** 没有网络 */
    SLIMSocketStateOffline = 101,
    /** 正在连接 */
    SLIMSocketStateConnecting = 102,
    /** 已连接 */
    SLIMSocketStateConnected = 103,
    /** 连接断开 */
    SLIMSocketStateDisconnected = 104
};

typedef NS_ENUM(NSInteger, SLIMSocketConnectionError) {
    /** 未知错误 */
    SLIMSocketConnectionErrorUnknown = 200,
    /** 断线 */
    SLIMSocketConnectionErrorOffline = 201,
    /** 服务器错误 */
    SLIMSocketConnectionErrorServerDown = 202,
    /** 连接超时 */
    SLIMSocketConnectionErrorTimeout = 203,
    /** 连接被关闭 */
    SLIMSocketConnectionErrorClosed = 204
};

@protocol SLIMWebSocketDelegate;

@interface SLIMSocketManager : NSObject

/** 如果设置request，需要在connect之前调用 */
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, weak  ) id<SLIMWebSocketDelegate> delegate;

/** 使用默认的URL进行连接 */
- (instancetype)initWithDelegate:(id<SLIMWebSocketDelegate>)delegate;

- (instancetype)initWithUrl:(NSURL *)url delegate:(id<SLIMWebSocketDelegate>)delegate;
- (instancetype)initWithRequest:(NSURLRequest *)request delegate:(id<SLIMWebSocketDelegate>)delegate;

- (void)connect;
- (void)disconnect;
- (void)reconnect;

- (void)send:(NSString *)message;

@end

@protocol SLIMWebSocketDelegate<NSObject>

@required
// message 格式为 text 或二进制数据，取决于服务器返回格式
- (void)webSocket:(SLIMSocketManager *)webSocket didReceiveMessage:(id)message;

@optional
- (void)webSocketDidOpen:(SLIMSocketManager *)webSocket;
- (void)webSocket:(SLIMSocketManager *)webSocket didFailWithError:(NSError *)error connectionErrorReason:(SLIMSocketConnectionError)rason;
- (void)webSocket:(SLIMSocketManager *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (void)webSocket:(SLIMSocketManager *)webSocket didReceivePong:(NSData *)pongPayload;

@end
