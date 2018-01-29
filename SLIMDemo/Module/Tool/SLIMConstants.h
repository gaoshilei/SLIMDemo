//
//  SLIMConstants.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/29.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <Foundation/Foundation.h>

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



