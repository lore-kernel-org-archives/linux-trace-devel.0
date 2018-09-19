Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731639AbeITAgk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 20:36:40 -0400
Message-Id: <20180919185724.152948543@goodmis.org>
Date: Wed, 19 Sep 2018 14:56:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 11/15] tools/lib/traceevent: Add prefix tep_ to various structs
 filter_arg_*.
References: <20180919185643.358126338@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to
to various structs filter_arg_*..

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h | 48 +++++++++++++++---------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 64ce3eb0dcbc..1330fca2da1e 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -827,15 +827,15 @@ enum tep_filter_value_type {
 
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
@@ -843,42 +843,42 @@ struct filter_arg_value {
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
2.18.0
