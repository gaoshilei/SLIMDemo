//
//  SLIMConverstaionViewController.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/2/1.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMConverstaionViewController.h"
#import "SLIMChatTextMessageCell.h"
#import "SLAnalogDataGenerator.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "SLIMSocketManager.h"
#import "NSString+SLIM.h"
#import <SVProgressHUD.h>

@interface SLIMConverstaionViewController ()<SLIMWebSocketDelegate,SLIMChatMessageCellDelegate> {
    SLIMSocketManager *_socketManager;
}

@property (nonatomic, copy) NSString *conversationId;

@end

@implementation SLIMConverstaionViewController

- (instancetype)init {
    if (self = [super init]) {
        [self p_setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initWebSocket];
    [self p_initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)p_initData {
    NSString *iconNameSelf = [SLAnalogDataGenerator randomIconImageName];
    NSString *iconNameOther = [SLAnalogDataGenerator randomIconImageName];
    for (NSInteger i=0; i<20; i++) {
        SLIMMessage *message = [SLIMMessage new];
        message.messageId = [NSString stringWithFormat:@"%ld",i];
        message.text = [SLAnalogDataGenerator randomMessage];
//        message.imageUrl = [NSURL URLWithString:[SLAnalogDataGenerator randomWebImageUrlString]];
        int randomOwner = arc4random()%2;
        if (randomOwner == 1) {
            message.localAvatarImageName = iconNameOther;
            message.sourceType = SLIMMessageSourceTypeSelf;
        }else {
            message.localAvatarImageName = iconNameSelf;
            message.sourceType = SLIMMessageSourceTypeOther;
        }
//        int randomMessageType = arc4random_uniform(100);
//        if (randomMessageType % 2 == 0) {
            message.messageType = SLIMMessageTypeText;
//        }else {
//            message.messageType = SLIMMessageTypeImage;
//        }
        [self.dataArray addObject:message];
    }
}

- (void)p_initWebSocket {
    [SVProgressHUD showWithStatus:@"正在连接服务器"];
    _socketManager = [[SLIMSocketManager alloc] initWithDelegate:self];
    [_socketManager connect];
}

- (void)p_setup {
    self.allowScrollToBottom = YES;
}

- (NSString *)p_cellIdentifierWithMessage:(SLIMMessage *)message {
    SLIMMessageSourceType sourceType = message.sourceType;
    SLIMMessageType messageType = message.messageType;
    Class cellClass = [SLIMChatMessageCellTypeDict objectForKey:@(messageType)];
    NSString *classStr = NSStringFromClass(cellClass);
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_",classStr];
    switch (sourceType) {
        case SLIMMessageSourceTypeSelf:
            cellIdentifier = [cellIdentifier stringByAppendingString:SLIMCellIdentifierOwnerSelf];
            break;
        case SLIMMessageSourceTypeOther:
            cellIdentifier = [cellIdentifier stringByAppendingString:SLIMCellIdentifierOwnerOther];
            break;
        case SLIMMessageSourceTypeSystem:
            cellIdentifier = [cellIdentifier stringByAppendingString:SLIMCellIdentifierOwnerSystem];
            break;
        case SLIMMessageSourceTypeNone:
            cellIdentifier = nil;
            break;
    }
    return cellIdentifier;
}

#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLIMMessage *message = self.dataArray[indexPath.row];
    NSString *identifier = [self p_cellIdentifierWithMessage:message];
    SLIMChatMessgaeCell *messageCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [messageCell configureCellWithData:message];
    messageCell.delegate = self;
    return messageCell;
}

#pragma mark - UITableView Delegte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLIMMessage *message = self.dataArray[indexPath.row];
    NSString *identifier = [self p_cellIdentifierWithMessage:message];
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByKey:message.messageId configuration:^(id cell) {
        [cell configureCellWithData:message];
    }];
}

#pragma mark - SLIMWebSocketDelegate
- (void)webSocket:(SLIMSocketManager *)webSocket didReceiveMessage:(id)message {
    /**
     didReceiveMessage：{
         conversationId = 250;
         data = "\U54c8\U54c8\n";
         destinationType = 1;
         from = 10062;
         hashValue = fbc6e59b84c982ee3565139977bee7c9;
         id = 998;
         receiptTime = 1520842308618;
         sendTime = 1520842545644;
         sourceType = 2;
         to = 859;
         type = 1;
     }
     */
    NSDictionary *response = [message mj_JSONObject];
    NSLog(@"didReceiveMessage：%@",response);
    SLIMMessage *msgModel = [SLIMMessage mj_objectWithKeyValues:response];
    if (!msgModel || msgModel.data.length==0) {
        NSLog(@"ERROR: 收到的消息格式错误！");
        return;
    }
    switch (msgModel.messageType) {
        case SLIMMessageTypeText:
            [self p_receiveTextMessage:msgModel];
            break;
        case SLIMMessageTypeImage:
            [self p_receiveImageMessage:msgModel];
            break;
        case SLIMMessageTypeEstablished: {
            if (msgModel.conversationId && msgModel.conversationId.length>0) {
                _conversationId = msgModel.conversationId;
            }
        }
            break;
        default:
            break;
    }
    [self.dataArray addObject:msgModel];
    [self reloadData];
}

- (void)webSocket:(SLIMSocketManager *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
}

- (void)webSocket:(SLIMSocketManager *)webSocket didFailWithError:(NSError *)error connectionErrorCode:(SLIMSocketErrorCode)reason {
    
}

- (void)webSocketDidOpen:(SLIMSocketManager *)webSocket {
    [SVProgressHUD dismiss];
}

#pragma mark - SLIMMessageCellDelegate
- (void)messageImageDidDownload:(SLIMChatImageMessageCell *)messageCell {

}

#pragma mark - SLIMChatBarDelegate
- (void)chatBar:(SLIMChatBar *)chatBar sendTextMessage:(NSString *)message {
    NSString *sendTimeStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
    NSString *encryptStr = [NSString stringWithFormat:@"from=&to=&data=%@&sendTime=%@",message,sendTimeStr];
    NSDictionary *sendMsg = @{
                              @"type": @(SLIMMessageTypeText),
                              @"conversationId": _conversationId,
                              @"data": message,
                              @"sendTime": sendTimeStr,
                              @"hashValue": [encryptStr MD5Hash]
                              };
    [_socketManager send:[sendMsg mj_JSONString]];
}

#pragma mark - 消息收发操作

- (void)p_receiveTextMessage:(SLIMMessage *)message {
    
}

- (void)p_receiveImageMessage:(SLIMMessage *)message {
    
}

@end
