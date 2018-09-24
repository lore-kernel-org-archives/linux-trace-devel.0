Return-Path: <SRS0=/bgX=MG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbeIXVHO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Sep 2018 17:07:14 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/27] tools lib traceevent: Add prefix tep_ to various structs filter_arg_*.
Date: Mon, 24 Sep 2018 12:02:31 -0300
Message-Id: <20180924150242.14235-17-acme@kernel.org>
In-Reply-To: <20180924150242.14235-1-acme@kernel.org>
References: <20180924150242.14235-1-acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to
to various structs filter_arg_*..

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185724.152948543@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h | 48 +++++++++++++++++++-------------------
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
2.14.4
