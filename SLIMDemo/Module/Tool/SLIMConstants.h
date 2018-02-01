//
//  SLIMConstants.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/29.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <Foundation/Foundation.h>

//消息类型
typedef NS_ENUM(NSInteger, SLIMMessageType) {
    /** 未知类型消息 */
    SLIMMessageTypeNone     = 0,
    /** 纯文本消息 */
    SLIMMessageTypeText     = 1,
    /** 图片消息 */
    SLIMMessageTypeImage    = 2,
    /** 语音消息（预留） */
    SLIMMessageTypeAudio    = 3,
    /** 视频消息（预留） */
    SLIMMessageTypeVideo    = 4,
    /** 位置消息（预留） */
    SLIMMessageTypeLocation = 5,
    /** 系统消息 */
    SLIMMessageTypeSystem   = 6,
};

//消息归属类型
typedef NS_ENUM(NSInteger, SLIMMessageOwnerType) {
    /** 未知类型消息 */
    SLIMMessageOwnerTypeNone    = 100,
    /** 发出的消息 */
    SLIMMessageOwnerTypeSelf    = 101,
    /** 收到的消息 */
    SLIMMessageOwnerTypeOther   = 102,
    /** 系统消息 */
    SLIMMessageOwnerTypeSystem  = 103,
};

//消息发送状态
typedef NS_ENUM(NSInteger, SLIMMessageSendStatus) {
    /** 未知状态 */
    SLIMMessageSendStatusNone       = 201,
    /** 消息发送中 */
    SLIMMessageSendStatusSending    = 202,
    /** 消息发送成功 */
    SLIMMessageSendStatusSent       = 203,
    /** 消息已送达 */
    SLIMMessageSendStatusDelivered  = 204,
    /** 消息发送失败 */
    SLIMMessageSendStatusFailed     = 205,
    /** 对方已读消息 */
    SLIMMessageSendStatusRead       = 206,
};

//储存不同类型的cell class
FOUNDATION_EXPORT NSMutableDictionary const * SLIMChatMessageCellTypeDict;

static NSString *const SLIMCellIdentifierOwnerSelf      = @"SLIMCellIdentifierOwnerSelf";
static NSString *const SLIMCellIdentifierOwnerOther     = @"SLIMCellIdentifierOwnerOther";
static NSString *const SLIMCellIdentifierOwnerSystem    = @"SLIMCellIdentifierOwnerSystem";

static CGFloat const SLIMCellMessageContentCapInsetsTopAndBottom = 12.f;
static CGFloat const SLIMCellMessageContentCapInsetsLeftAndRight = 15.f;

#pragma mark - SQL

#define SLIMConversationTableName                   @"SLIMConversation"
#define SLIMConversationTableKeyID                  @"hash"
#define SLIMConversationTablekeyData                @"data"
#define SLIMConversationTablekeyLocalTimestamp      @"timestamp_local"
#define SLIMConversationTablekeyServerTimestamp     @"timestamp_server"

#define SLIMConversationTableCreateSQL \
@"CREATE TABLE IF NOT EXISTS " SLIMConversationTableName @"("   \
SLIMConversationTableKeyID  @" VARCHAR(63) PRIMARY KEY AUTOINCREMENT, "    \
LCCKConversationTableKeyData    @" BLOB NOT NULL ," \
SLIMConversationTablekeyLocalTimestamp @" TIMESTAMP, " \
SLIMConversationTablekeyServerTimestamp @" TIMESTAMP" \
@")"

#define SLIMConversationTableInsertSQL  \
@"INSERT OR IGNORE INTO " SLIMConversationTableName @" ("    \
SLIMConversationTableKeyID               @", "           \
LCCKConversationTableKeyData             @", "           \
SLIMConversationTablekeyLocalTimestamp   @" , "   \
SLIMConversationTablekeyServerTimestamp \
@") VALUES(?, ?, ?, ?)"

#define SLIMConversationTableWhereClause \
@" WHERE " SLIMConversationTableKeyID         @" = ?"

#define SLIMConversationTableDeleteSQL                     \
@"DELETE FROM " SLIMConversationTableName             \
SLIMConversationTableWhereClause

#define SLIMDeleteConversationTable                \
@"DELETE FROM " SLIMConversationTableName

#define SLIMConversationTableUpdateServerTimestamp           \
@"UPDATE " SLIMConversationTableName         @" "            \
@"SET " SLIMConversationTablekeyServerTimestamp  @" = ?"          \
SLIMConversationTableWhereClause
