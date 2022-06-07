Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92BAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jun 2022 09:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbiFGJRy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbiFGJRv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 05:17:51 -0400
X-Greylist: delayed 322 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Jun 2022 02:17:43 PDT
Received: from mail.nearlyone.de (mail.nearlyone.de [IPv6:2a01:488:66:1000:2ea3:7291:0:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A56B643C
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 02:17:38 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4069F5DA18;
        Tue,  7 Jun 2022 11:12:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
        t=1654593139; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding; bh=lsV7Jd0vJPaEJkVrvxmoCuWg3BHHm8k2xGh+QIvGrzY=;
        b=hcOd8U/7uWdX2/AYL4RDEextTbxsxiBtRMpTCaQII4KyAW56CZKny3GkkcYeS1xI7w2fzb
        wbdUeMURm757222cwIVKxmtZl9GrWQyPeOPNC1dTSKJdTPpuIAGSvd4qICI8+tLawBIbDQ
        St+WXzD1EbVa/km+R+v/3HkXpChsII/VsNsOtTTcixF/b4StXx7VoNe5i7UT3mRvSdNXOs
        9NHfe+DOlH1xMONqYKMweeJEV0fjIiQdCBzBbTcMYqk/3KtUUbattPsP58VIlBFUHXBsBt
        1fSrAr8rjeQTNV/KjHgJ3HvHRU52Nq3e/E/LcxbsTZ2eH497VF2/FCajPjTS6A==
From:   Daniel Wagner <wagi@monom.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] tracefs: Set visibility of parser symbols as 'internal'
Date:   Tue,  7 Jun 2022 11:12:15 +0200
Message-Id: <20220607091215.24447-1-wagi@monom.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

Two declarations of an object with 'hidden' linkage refer to
the same object if they are in the same shared object.

Internal visibility is like hidden visibility, but with
additional processor specific semantics. Unless otherwise specified by
the psABI, GCC defines internal visibility to mean that a function is
never called from another module.

It was observed that an 32bit linking against libtracefs failed
because the parser symbols were missing. As the parser symbols are
supposed to be used only inside the library, mark them as internal.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---

Hi,

The rtla build with libtracefs failed with

[  192s] gcc -o rtla -ggdb src/osnoise.o src/osnoise_hist.o src/osnoise_top.o src/rtla.o src/timerlat.o src/timerlat_hist.o src/timerlat_top.o src/trace.o src/utils.o $(pkg-config --libs libtracefs) -lprocps
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `my_yyinput'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_from'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_number'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_where'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_filter'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_to'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_cast'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_compare'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `store_str'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_match'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_string'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `sql_parse_error'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_field'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `table_start'
[  196s] /usr/lib/gcc/i586-suse-linux/12/../../../../i586-suse-linux/bin/ld: /usr/lib/gcc/i586-suse-linux/12/../../../libtracefs.so: undefined reference to `add_selection'


According https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes
it seems we want the internal visibilty flag here. A quick test with this
patch resolved the build issue.

Thanks,
Daniel


 include/tracefs-local.h |  1 +
 src/tracefs-sqlhist.c   | 43 +++++++++++++++++++++--------------------
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index d0ed2abfe5e7..1213e0a49f12 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -7,6 +7,7 @@
 #define _TRACE_FS_LOCAL_H
 
 #define __hidden __attribute__((visibility ("hidden")))
+#define __internal __attribute__((visibility ("internal")))
 #define __weak __attribute__((weak))
 
 #define ARRAY_SIZE(array) (sizeof(array) / sizeof((array)[0]))
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index caf927fd5e1c..c6789a2ca6b6 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -102,7 +102,7 @@ struct sql_table {
 	struct expr		**next_selection;
 };
 
-__hidden int my_yyinput(void *extra, char *buf, int max)
+__internal int my_yyinput(void *extra, char *buf, int max)
 {
 	struct sqlhist_bison *sb = extra;
 
@@ -120,8 +120,8 @@ __hidden int my_yyinput(void *extra, char *buf, int max)
 	return max;
 }
 
-__hidden void sql_parse_error(struct sqlhist_bison *sb, const char *text,
-			      const char *fmt, va_list ap)
+__internal void sql_parse_error(struct sqlhist_bison *sb, const char *text,
+			        const char *fmt, va_list ap)
 {
 	const char *buffer = sb->buffer;
 	struct trace_seq s;
@@ -222,7 +222,7 @@ static char **add_hash(struct sqlhist_bison *sb, const char *str)
 	return &hash->str;
 }
 
-__hidden char *store_str(struct sqlhist_bison *sb, const char *str)
+__internal char *store_str(struct sqlhist_bison *sb, const char *str)
 {
 	char **pstr = add_hash(sb, str);
 
@@ -235,8 +235,8 @@ __hidden char *store_str(struct sqlhist_bison *sb, const char *str)
 	return *pstr;
 }
 
-__hidden void *add_cast(struct sqlhist_bison *sb,
-			void *data, const char *type)
+__internal void *add_cast(struct sqlhist_bison *sb,
+			  void *data, const char *type)
 {
 	struct expr *expr = data;
 	struct field *field = &expr->field;
@@ -245,8 +245,8 @@ __hidden void *add_cast(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__hidden int add_selection(struct sqlhist_bison *sb, void *select,
-			   const char *name)
+__internal int add_selection(struct sqlhist_bison *sb, void *select,
+			     const char *name)
 {
 	struct sql_table *table = sb->table;
 	struct expr *expr = select;
@@ -361,8 +361,8 @@ static void *create_expr(struct sqlhist_bison *sb,
 #define create_number(var, expr)			\
 	__create_expr(var, long, NUMBER, expr)
 
-__hidden void *add_field(struct sqlhist_bison *sb,
-			 const char *field_name, const char *label)
+__internal void *add_field(struct sqlhist_bison *sb,
+			   const char *field_name, const char *label)
 {
 	struct sql_table *table = sb->table;
 	struct expr *expr;
@@ -383,8 +383,8 @@ __hidden void *add_field(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__hidden void *add_filter(struct sqlhist_bison *sb,
-			  void *A, void *B, enum filter_type op)
+__internal void *add_filter(struct sqlhist_bison *sb,
+			    void *A, void *B, enum filter_type op)
 {
 	struct filter *filter;
 	struct expr *expr;
@@ -399,7 +399,7 @@ __hidden void *add_filter(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__hidden int add_match(struct sqlhist_bison *sb, void *A, void *B)
+__internal int add_match(struct sqlhist_bison *sb, void *A, void *B)
 {
 	struct sql_table *table = sb->table;
 	struct match *match;
@@ -416,8 +416,9 @@ __hidden int add_match(struct sqlhist_bison *sb, void *A, void *B)
 
 	return 0;
 }
-__hidden void *add_compare(struct sqlhist_bison *sb,
-			   void *A, void *B, enum compare_type type)
+
+__internal void *add_compare(struct sqlhist_bison *sb,
+			     void *A, void *B, enum compare_type type)
 {
 	struct compare *compare;
 	struct expr *expr;
@@ -432,7 +433,7 @@ __hidden void *add_compare(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__hidden int add_where(struct sqlhist_bison *sb, void *item)
+__internal int add_where(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
 	struct sql_table *table = sb->table;
@@ -449,7 +450,7 @@ __hidden int add_where(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
-__hidden int add_from(struct sqlhist_bison *sb, void *item)
+__internal int add_from(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
 
@@ -461,7 +462,7 @@ __hidden int add_from(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
-__hidden int add_to(struct sqlhist_bison *sb, void *item)
+__internal int add_to(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
 
@@ -473,7 +474,7 @@ __hidden int add_to(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
-__hidden void *add_string(struct sqlhist_bison *sb, const char *str)
+__internal void *add_string(struct sqlhist_bison *sb, const char *str)
 {
 	struct expr *expr;
 	const char **str_p;
@@ -483,7 +484,7 @@ __hidden void *add_string(struct sqlhist_bison *sb, const char *str)
 	return expr;
 }
 
-__hidden void *add_number(struct sqlhist_bison *sb, long val)
+__internal void *add_number(struct sqlhist_bison *sb, long val)
 {
 	struct expr *expr;
 	long *num;
@@ -493,7 +494,7 @@ __hidden void *add_number(struct sqlhist_bison *sb, long val)
 	return expr;
 }
 
-__hidden int table_start(struct sqlhist_bison *sb)
+__internal int table_start(struct sqlhist_bison *sb)
 {
 	struct sql_table *table;
 
-- 
2.36.1

