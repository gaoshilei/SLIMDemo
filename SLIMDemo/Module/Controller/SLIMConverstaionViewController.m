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

@interface SLIMConverstaionViewController () {
//    NSMutableArray *_dataArray;
}

@end

@implementation SLIMConverstaionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initData];
}

- (void)p_initData {
    for (NSInteger i=0; i<20; i++) {
        SLIMMessage *message = [SLIMMessage new];
        message.text = [SLAnalogDataGenerator randomMessage];
        message.messageType = SLIMMessageTypeText;
        int randomOwner = arc4random_uniform(2);
        if (randomOwner == 1) {
            message.ownerType = SLIMMessageOwnerTypeSelf;
        }else {
            message.ownerType = SLIMMessageOwnerTypeOther;
        }
        [self.dataArray addObject:message];
    }
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
    return messageCell;
}

#pragma mark - UITableView Delegte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLIMMessage *message = self.dataArray[indexPath.row];
    NSString *identifier = [self p_cellIdentifierWithMessage:message];
    return [tableView fd_heightForCellWithIdentifier:identifier configuration:^(id cell) {
        [cell configureCellWithData:message];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
