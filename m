Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765B0CCA47B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Jul 2022 16:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiGKQpQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 12:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiGKQpP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 12:45:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950623C8E5
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 09:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B01EB810AB
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 16:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DA2C341C8;
        Mon, 11 Jul 2022 16:45:11 +0000 (UTC)
Date:   Mon, 11 Jul 2022 12:45:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, Daniel Wagner <wagi@monom.org>
Subject: [PATCH] revert: 0de961e74f96 ("libtracefs: Set visibility of parser
 symbols as 'internal'")
Message-ID: <20220711124510.763371d7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

With the addition of commit b64dc07ca44c ("libtracefs: Unbreak parallel
build"), the build works fine without using "internal" variables. We can
revert that commit.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---

[ Daniel, can you test to make sure this is true. Thanks ]

 include/tracefs-local.h |  1 -
 src/tracefs-sqlhist.c   | 43 ++++++++++++++++++++---------------------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 1652a27ebeb8..678b9870d03e 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -7,7 +7,6 @@
 #define _TRACE_FS_LOCAL_H
 
 #define __hidden __attribute__((visibility ("hidden")))
-#define __internal __attribute__((visibility ("internal")))
 #define __weak __attribute__((weak))
 
 #define ARRAY_SIZE(array) (sizeof(array) / sizeof((array)[0]))
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 27c9c82647e4..5205356356a5 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -109,7 +109,7 @@ struct sql_table {
 	struct expr		**next_selection;
 };
 
-__internal int my_yyinput(void *extra, char *buf, int max)
+__hidden int my_yyinput(void *extra, char *buf, int max)
 {
 	struct sqlhist_bison *sb = extra;
 
@@ -127,8 +127,8 @@ __internal int my_yyinput(void *extra, char *buf, int max)
 	return max;
 }
 
-__internal void sql_parse_error(struct sqlhist_bison *sb, const char *text,
-			        const char *fmt, va_list ap)
+__hidden void sql_parse_error(struct sqlhist_bison *sb, const char *text,
+			      const char *fmt, va_list ap)
 {
 	const char *buffer = sb->buffer;
 	struct trace_seq s;
@@ -229,7 +229,7 @@ static char **add_hash(struct sqlhist_bison *sb, const char *str)
 	return &hash->str;
 }
 
-__internal char *store_str(struct sqlhist_bison *sb, const char *str)
+__hidden char *store_str(struct sqlhist_bison *sb, const char *str)
 {
 	char **pstr = add_hash(sb, str);
 
@@ -242,8 +242,8 @@ __internal char *store_str(struct sqlhist_bison *sb, const char *str)
 	return *pstr;
 }
 
-__internal void *add_cast(struct sqlhist_bison *sb,
-			  void *data, const char *type)
+__hidden void *add_cast(struct sqlhist_bison *sb,
+			void *data, const char *type)
 {
 	struct expr *expr = data;
 	struct field *field = &expr->field;
@@ -252,8 +252,8 @@ __internal void *add_cast(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__internal int add_selection(struct sqlhist_bison *sb, void *select,
-			     const char *name)
+__hidden int add_selection(struct sqlhist_bison *sb, void *select,
+			   const char *name)
 {
 	struct sql_table *table = sb->table;
 	struct expr *expr = select;
@@ -368,8 +368,8 @@ static void *create_expr(struct sqlhist_bison *sb,
 #define create_number(var, expr)			\
 	__create_expr(var, long, NUMBER, expr)
 
-__internal void *add_field(struct sqlhist_bison *sb,
-			   const char *field_name, const char *label)
+__hidden void *add_field(struct sqlhist_bison *sb,
+			 const char *field_name, const char *label)
 {
 	struct sql_table *table = sb->table;
 	struct expr *expr;
@@ -390,8 +390,8 @@ __internal void *add_field(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__internal void *add_filter(struct sqlhist_bison *sb,
-			    void *A, void *B, enum filter_type op)
+__hidden void *add_filter(struct sqlhist_bison *sb,
+			  void *A, void *B, enum filter_type op)
 {
 	struct filter *filter;
 	struct expr *expr;
@@ -406,7 +406,7 @@ __internal void *add_filter(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__internal int add_match(struct sqlhist_bison *sb, void *A, void *B)
+__hidden int add_match(struct sqlhist_bison *sb, void *A, void *B)
 {
 	struct sql_table *table = sb->table;
 	struct match *match;
@@ -423,9 +423,8 @@ __internal int add_match(struct sqlhist_bison *sb, void *A, void *B)
 
 	return 0;
 }
-
-__internal void *add_compare(struct sqlhist_bison *sb,
-			     void *A, void *B, enum compare_type type)
+__hidden void *add_compare(struct sqlhist_bison *sb,
+			   void *A, void *B, enum compare_type type)
 {
 	struct compare *compare;
 	struct expr *expr;
@@ -440,7 +439,7 @@ __internal void *add_compare(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__internal int add_where(struct sqlhist_bison *sb, void *item)
+__hidden int add_where(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
 	struct sql_table *table = sb->table;
@@ -457,7 +456,7 @@ __internal int add_where(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
-__internal int add_from(struct sqlhist_bison *sb, void *item)
+__hidden int add_from(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
 
@@ -469,7 +468,7 @@ __internal int add_from(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
-__internal int add_to(struct sqlhist_bison *sb, void *item)
+__hidden int add_to(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
 
@@ -481,7 +480,7 @@ __internal int add_to(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
-__internal void *add_string(struct sqlhist_bison *sb, const char *str)
+__hidden void *add_string(struct sqlhist_bison *sb, const char *str)
 {
 	struct expr *expr;
 	const char **str_p;
@@ -491,7 +490,7 @@ __internal void *add_string(struct sqlhist_bison *sb, const char *str)
 	return expr;
 }
 
-__internal void *add_number(struct sqlhist_bison *sb, long val)
+__hidden void *add_number(struct sqlhist_bison *sb, long val)
 {
 	struct expr *expr;
 	long *num;
@@ -501,7 +500,7 @@ __internal void *add_number(struct sqlhist_bison *sb, long val)
 	return expr;
 }
 
-__internal int table_start(struct sqlhist_bison *sb)
+__hidden int table_start(struct sqlhist_bison *sb)
 {
 	struct sql_table *table;
 
-- 
2.35.1

