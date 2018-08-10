Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:40291 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbeHJPrx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:53 -0400
Received: by mail-wm0-f50.google.com with SMTP id y9-v6so1882388wma.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Aug 2018 06:17:59 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 11/14] tools/lib/traceevent: Add prefix tep_ to various structs filter_arg_*.
Date: Fri, 10 Aug 2018 16:17:29 +0300
Message-Id: <20180810131732.24677-12-tz.stoyanov@gmail.com>
In-Reply-To: <20180810131732.24677-1-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to
to various structs filter_arg_*..

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.h | 48 +++++++++++++++---------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index f80fc779042a..6ba226b4d166 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -869,15 +869,15 @@ enum tep_filter_value_type {
 
 struct tep_filter_arg;
 
-struct filter_arg_boolean {
+struct tep_filter_arg_boolean {
 	enum tep_filter_boolean_type	value;
 };
 
-struct filter_arg_field {
-	struct tep_format_field	*field;
+struct tep_filter_arg_field {
+	struct tep_format_field		*field;
 };
 
-struct filter_arg_value {
+struct tep_filter_arg_value {
 	enum tep_filter_value_type	type;
 	union {
 		char			*str;
@@ -885,42 +885,42 @@ struct filter_arg_value {
 	};
 };
 
-struct filter_arg_op {
-	enum tep_filter_op_type	type;
-	struct tep_filter_arg	*left;
-	struct tep_filter_arg	*right;
+struct tep_filter_arg_op {
+	enum tep_filter_op_type		type;
+	struct tep_filter_arg		*left;
+	struct tep_filter_arg		*right;
 };
 
-struct filter_arg_exp {
+struct tep_filter_arg_exp {
 	enum tep_filter_exp_type	type;
 	struct tep_filter_arg		*left;
 	struct tep_filter_arg		*right;
 };
 
-struct filter_arg_num {
+struct tep_filter_arg_num {
 	enum tep_filter_cmp_type	type;
-	struct tep_filter_arg	*left;
-	struct tep_filter_arg	*right;
+	struct tep_filter_arg		*left;
+	struct tep_filter_arg		*right;
 };
 
-struct filter_arg_str {
+struct tep_filter_arg_str {
 	enum tep_filter_cmp_type	type;
-	struct tep_format_field	*field;
-	char			*val;
-	char			*buffer;
-	regex_t			reg;
+	struct tep_format_field		*field;
+	char				*val;
+	char				*buffer;
+	regex_t				reg;
 };
 
 struct tep_filter_arg {
 	enum tep_filter_arg_type		type;
 	union {
-		struct filter_arg_boolean	boolean;
-		struct filter_arg_field		field;
-		struct filter_arg_value		value;
-		struct filter_arg_op		op;
-		struct filter_arg_exp		exp;
-		struct filter_arg_num		num;
-		struct filter_arg_str		str;
+		struct tep_filter_arg_boolean	boolean;
+		struct tep_filter_arg_field	field;
+		struct tep_filter_arg_value	value;
+		struct tep_filter_arg_op	op;
+		struct tep_filter_arg_exp	exp;
+		struct tep_filter_arg_num	num;
+		struct tep_filter_arg_str	str;
 	};
 };
 
-- 
2.17.1
