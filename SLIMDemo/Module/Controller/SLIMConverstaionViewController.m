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

@interface SLIMConverstaionViewController ()<SLIMWebSocketDelegate,SLIMChatMessageCellDelegate> {
    SLIMSocketManager *_socketManager;
}

@end

@implementation SLIMConverstaionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initWebSocket];
    [self p_initData];
}

- (void)p_initData {
    NSString *iconNameSelf = [SLAnalogDataGenerator randomIconImageName];
    NSString *iconNameOther = [SLAnalogDataGenerator randomIconImageName];
    for (NSInteger i=0; i<20; i++) {
        SLIMMessage *message = [SLIMMessage new];
        message.messageId = [NSString stringWithFormat:@"%ld",i];
        message.text = [SLAnalogDataGenerator randomMessage];
        message.imageUrl = [NSURL URLWithString:[SLAnalogDataGenerator randomWebImageUrlString]];
        int randomOwner = arc4random()%2;
        if (randomOwner == 1) {
            message.localAvatarImageName = iconNameOther;
            message.ownerType = SLIMMessageOwnerTypeSelf;
        }else {
            message.localAvatarImageName = iconNameSelf;
            message.ownerType = SLIMMessageOwnerTypeOther;
        }
        int randomMessageType = arc4random_uniform(100);
        if (randomMessageType % 2 == 0) {
            message.messageType = SLIMMessageTypeText;
        }else {
            message.messageType = SLIMMessageTypeImage;
        }
        [self.dataArray addObject:message];
    }
}

- (void)p_initWebSocket {
    _socketManager = [[SLIMSocketManager alloc] initWithDelegate:self];
    [_socketManager connect];
}

- (NSString *)p_cellIdentifierWithMessage:(SLIMMessage *)message {
    SLIMMessageOwnerType ownerType = message.ownerType;
    SLIMMessageType messageType = message.messageType;
    Class cellClass = [SLIMChatMessageCellTypeDict objectForKey:@(messageType)];
    NSString *classStr = NSStringFromClass(cellClass);
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_",classStr];
    switch (ownerType) {
        case SLIMMessageOwnerTypeSelf:
            cellIdentifier = [cellIdentifier stringByAppendingString:SLIMCellIdentifierOwnerSelf];
            break;
        case SLIMMessageOwnerTypeOther:
            cellIdentifier = [cellIdentifier stringByAppendingString:SLIMCellIdentifierOwnerOther];
            break;
        case SLIMMessageOwnerTypeSystem:
            cellIdentifier = [cellIdentifier stringByAppendingString:SLIMCellIdentifierOwnerSystem];
            break;
        case SLIMMessageOwnerTypeNone:
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
    NSLog(@"%s;%@",__func__,message);
}

- (void)webSocket:(SLIMSocketManager *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"%s;%@",__func__,reason);
}

- (void)webSocket:(SLIMSocketManager *)webSocket didFailWithError:(NSError *)error connectionErrorCode:(SLIMSocketErrorCode)reason {
    NSLog(@"%s;%@",__func__,error);
}

- (void)webSocketDidOpen:(SLIMSocketManager *)webSocket {
    NSLog(@"%s",__func__);
}

#pragma mark - SLIMMessageCellDelegate
- (void)messageImageDidDownload:(SLIMChatImageMessageCell *)messageCell {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
