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

typedef NS_ENUM(NSInteger, SLIMSocketErrorCode) {
    SLIMSocketErrorCodeUnknown = 10000,//未知错误
    SLIMSocketErrorCodeOffline = 10001,//网络不可用
    SLIMSocketErrorCodeServerError = 10002,//服务器错误
    SLIMSocketErrorCodeTimeout = 10003,//socket连接超时
    SLIMSocketErrorCodeConnectionClosed = 10004, //连接被关闭
    SLIMSocketErrorCodeStreamWriting = 10005, //数据流写入出错
    SLIMSocketErrorCodeServerCert = 10006, //wss服务器证书错误
    SLIMSocketErrorCodeUnconnected = 10007, //socket连接未有效建立
};

NSString *NSStringFromSocketState(SLIMSocketState state);
NSString *NSStringFromSocketErrorCode(SLIMSocketErrorCode code);

@protocol SLIMWebSocketDelegate;

@interface SLIMSocketManager : NSObject

/** 如果设置request，需要在connect之前调用 */
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, weak  ) id<SLIMWebSocketDelegate> delegate;
/** 心跳时间间隔/分钟，默认为2分钟，范围0~10 */
@property (nonatomic, assign) NSUInteger heartbeatInterval;

/** 使用默认的URL进行连接 */
- (instancetype)initWithDelegate:(id<SLIMWebSocketDelegate>)delegate;

- (instancetype)initWithUrl:(NSURL *)url delegate:(id<SLIMWebSocketDelegate>)delegate;
- (instancetype)initWithRequest:(NSURLRequest *)request delegate:(id<SLIMWebSocketDelegate>)delegate;

- (void)connect;
- (void)disconnect;

- (void)send:(NSString *)message;

- (void)sendPing;

@end

@protocol SLIMWebSocketDelegate<NSObject>

@required
// message 格式为 text 或二进制数据，取决于服务器返回格式
- (void)webSocket:(SLIMSocketManager *)webSocket didReceiveMessage:(id)message;

@optional
- (void)webSocketDidOpen:(SLIMSocketManager *)webSocket;
- (void)webSocket:(SLIMSocketManager *)webSocket didFailWithError:(NSError *)error connectionErrorCode:(SLIMSocketErrorCode)reason;
- (void)webSocket:(SLIMSocketManager *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (void)webSocket:(SLIMSocketManager *)webSocket didReceivePong:(NSData *)pongPayload;

@end
