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
#import "NSString+SLIM.h"
#import <SVProgressHUD.h>
#import <JSONKit.h>
@interface SLIMConverstaionViewController ()<SLIMWebSocketDelegate,SLIMChatMessageCellDelegate> {
    SLIMSocketManager *_socketManager;
}

@property (nonatomic, copy) NSString *conversationId;

@end

@implementation SLIMConverstaionViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)init {
    if (self = [super init]) {
        [self p_setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initWebSocket];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)p_initData {
//    NSString *iconNameSelf = [SLAnalogDataGenerator randomIconImageName];
//    NSString *iconNameOther = [SLAnalogDataGenerator randomIconImageName];
//    for (NSInteger i=0; i<20; i++) {
//        SLIMMessage *message = [SLIMMessage new];
//        message.hashValue = [NSString stringWithFormat:@"%ld",i];
//        message.text = [SLAnalogDataGenerator randomMessage];
////        message.imageUrl = [NSURL URLWithString:[SLAnalogDataGenerator randomWebImageUrlString]];
//        int randomOwner = arc4random()%2;
//        if (randomOwner == 1) {
//            message.localAvatarImageName = iconNameOther;
//            message.sourceType = SLIMMessageSourceTypeSelf;
//        }else {
//            message.localAvatarImageName = iconNameSelf;
//            message.sourceType = SLIMMessageSourceTypeOther;
//        }
////        int randomMessageType = arc4random_uniform(100);
////        if (randomMessageType % 2 == 0) {
//            message.type = SLIMMessageTypeText;
////        }else {
////            message.messageType = SLIMMessageTypeImage;
////        }
//        [self.dataArray addObject:message];
//    }
    //cid:859
    NSDictionary *data = @{
                          @"cid": @"859"
                          };
    SLIMMessage *sendMessage = [[SLIMMessage alloc] init];
    sendMessage.type = SLIMMessageTypeSync;
    sendMessage.data = [data JSONString];
    NSDictionary *sendMsgDict = [sendMessage mj_keyValues];
    [_socketManager send:[sendMsgDict JSONString]];
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
    SLIMMessageType messageType = message.type;
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
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByKey:message.hashValue configuration:^(id cell) {
        [cell configureCellWithData:message];
    }];
}

#pragma mark - SLIMWebSocketDelegate
- (void)webSocket:(SLIMSocketManager *)webSocket didReceiveMessage:(id)message {
    NSDictionary *response = [message objectFromJSONString];
    SLIMMessage *msgModel = [SLIMMessage mj_objectWithKeyValues:response];
    if (!msgModel) {
        NSLog(@"ERROR: 收到的消息格式错误！");
        return;
    }
    switch (msgModel.type) {
            /** 文本类消息 */
        case SLIMMessageTypeText:
        case SLIMMessageTypeTextCard:
            [self p_receiveTextMessage:msgModel];
            break;
            /** 图片消息 */
        case SLIMMessageTypeImage:
            [self p_receiveImageMessage:msgModel];
            break;
            
            /** === 非内容类消息 === */
        case SLIMMessageTypeSystem: {
            [self p_receiveSystemMessage:msgModel];
        }
            break;
        case SLIMMessageTypeEstablished: {
            if (msgModel.conversationId && msgModel.conversationId.length>0) {
                _conversationId = msgModel.conversationId;
            }
            msgModel.data = @"会话已建立";
            [self p_receiveSystemMessage:msgModel];
        }
            break;
        case SLIMMessageTypeAck: {
            msgModel.data = @"收到服务器ack";
            [self p_receiveSystemMessage:msgModel];
        }
            break;
        case SLIMMessageTypeHistoryReceived: {
            NSDictionary *dataDic = [msgModel.data objectFromJSONString];
            NSArray *beanList = dataDic[@"beanList"];
            NSArray<SLIMMessage *> *models = [SLIMMessage mj_objectArrayWithKeyValuesArray:beanList];
            [models enumerateObjectsUsingBlock:^(SLIMMessage * msg, NSUInteger idx, BOOL * _Nonnull stop) {
                if (msg.type == SLIMMessageTypeImage) {
                    NSLog(@"%@",msg.data);
                    NSDictionary *imageInfo = [msg.data objectFromJSONString];
                    msg.imageThumbUrl = [NSURL URLWithString:imageInfo[@"compressImageUrl"]];
                    msg.imageUrl = [NSURL URLWithString:imageInfo[@"constantImageUrl"]];
                }
            }];
            [self.dataArray addObjectsFromArray:models];
            [self reloadDataWithAnimated:NO];
        }
            break;
        case SLIMMessageTypeClosed: {
//            msgModel.data = @"会话已被关闭";
//            [self p_receiveSystemMessage:msgModel];
        }
            break;
        default:
            break;
    }
    if (msgModel.type == SLIMMessageTypeText || msgModel.type == SLIMMessageTypeImage || msgModel.type == SLIMMessageTypeSystem) {
        [self.dataArray addObject:msgModel];
        [self reloadDataWithAnimated:YES];
    }
}

- (void)webSocket:(SLIMSocketManager *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (code == SLIMSocketEventEndEncountered) {
        
    }
}

- (void)webSocket:(SLIMSocketManager *)webSocket didFailWithError:(NSError *)error connectionErrorCode:(SLIMSocketErrorCode)reason {
    
}

- (void)webSocketDidOpen:(SLIMSocketManager *)webSocket {
    [SVProgressHUD dismiss];
    [self p_initData];
}

#pragma mark - SLIMMessageCellDelegate
- (void)messageImageDidDownload:(SLIMChatImageMessageCell *)messageCell {
    
}

#pragma mark - SLIMChatBarDelegate
- (void)chatBar:(SLIMChatBar *)chatBar sendTextMessage:(NSString *)message {
    [_socketManager send:[self p_textMessageFormat:message]];
    [self reloadDataWithAnimated:YES];
}

#pragma mark - 各类消息收发操作

- (NSString *)p_textMessageFormat:(NSString *)message {
    NSString *sendTimeStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
    NSString *encryptStr = [NSString stringWithFormat:@"from=&to=&data=%@&sendTime=%@",message,sendTimeStr];
    SLIMMessage *sendMessage = [[SLIMMessage alloc] init];
    sendMessage.type = SLIMMessageTypeText;
    sendMessage.sourceType = SLIMMessageSourceTypeSelf;
    sendMessage.conversationId = _conversationId;
    sendMessage.sendTime = sendTimeStr;
    sendMessage.hashValue = [encryptStr MD5Hash];
    sendMessage.data = message;
    sendMessage.text = message;
    NSDictionary *sendMsgDict = [sendMessage mj_keyValues];
    NSLog(@"%@",sendMsgDict);
    [self.dataArray addObject:sendMessage];
    return [sendMsgDict JSONString];
}

- (void)p_receiveTextMessage:(SLIMMessage *)message {
    if (message.data.length>0) {
        message.text = message.data;
    }
    message.type = SLIMMessageTypeText;
    message.sourceType = SLIMMessageSourceTypeOther;
    if (message.hashValue.length==0) {
        message.hashValue = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
    }
}

- (void)p_receiveImageMessage:(SLIMMessage *)message {
    
}

- (void)p_receiveSystemMessage:(SLIMMessage *)message {
    if (message.data.length>0) {
        message.text = message.data;
    }
    message.sourceType = SLIMMessageSourceTypeSystem;
    message.type = SLIMMessageTypeSystem;
//    if (message.hashValue.length==0) {
    message.hashValue = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
//    }
}

@end
