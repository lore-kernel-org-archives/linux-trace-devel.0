Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4684AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 09:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhKVJdX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhKVJdW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 04:33:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E2860F22;
        Mon, 22 Nov 2021 09:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637573415;
        bh=CI39Wya/1DOmkGYDak1/hiG5NiD02hRPPh13swYvbpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4rTMQEcsePCTd53yu+f6Gf8Je2nbbvUpLO+kwQeQ4aaP8N6L1VEXC0LQqFhNo4cs
         e6TgsGTp9EOnJMhHlFV8xKhk5kr7ptuzYe1FM3R2DPOpBsXQjgZ3mF+R4+7EM4oFHL
         RkqWSHCmML1iXTVBFlCCL5MacwaiEqNc15YZ+cCF70Ub7AKos3yX9DQ2RPwHmeyuUU
         M0Ghn5DGAb43jCyU9Ve4vHF91s3mag1tcBG4houlWkJ09Kf6qpgZbOxITlgprZzftp
         M5arjzgYgN9x6U9r0dHSgPZlEkKzU9mGtEZ6Xnuf2EAzjWVvWIOcmf1WmqwtNdZmiT
         L+sxnEaUjL84A==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/5] tracing: Support __rel_loc relative dynamic data location attribute
Date:   Mon, 22 Nov 2021 18:30:12 +0900
Message-Id: <163757341258.510314.4214431827833229956.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <163757340321.510314.9399950115238632705.stgit@devnote2>
References: <163757340321.510314.9399950115238632705.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add '__rel_loc' new dynamic data location attribute which encodes
the data location from the next to the field itself.

The '__data_loc' is used for encoding the dynamic data location on
the trace event record. But '__data_loc' is not useful if the writer
doesn't know the event header (e.g. user event), because it records
the dynamic data offset from the entry of the record, not the field
itself.

This new '__rel_loc' attribute encodes the data location relatively
from the next of the field. For example, when there is a record like
below (the number in the parentheses is the size of fields)

 |header(N)|common(M)|fields(K)|__data_loc(4)|fields(L)|data(G)|

In this case, '__data_loc' field will be

 __data_loc = (G << 16) | (N+M+K+4+L)

If '__rel_loc' is used, this will be

 |header(N)|common(M)|fields(K)|__rel_loc(4)|fields(L)|data(G)|

where

 __rel_loc = (G << 16) | (L)

This case shows L bytes after the '__rel_loc' attribute  field,
if there is no fields after the __rel_loc field, L must be 0.

This is relatively easy (and no need to consider the kernel header
change) when the event data fields are composed by user who doesn't
know header and common fields.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 include/linux/trace_events.h       |    1 +
 kernel/trace/trace.h               |    1 +
 kernel/trace/trace_events_filter.c |   32 ++++++++++++++++++++++++++++++--
 kernel/trace/trace_events_hist.c   |   21 +++++++++++++++++++--
 kernel/trace/trace_events_inject.c |   11 +++++++++--
 5 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 50453b287615..d5b20540ff98 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -782,6 +782,7 @@ enum {
 	FILTER_OTHER = 0,
 	FILTER_STATIC_STRING,
 	FILTER_DYN_STRING,
+	FILTER_RDYN_STRING,
 	FILTER_PTR_STRING,
 	FILTER_TRACE_FN,
 	FILTER_COMM,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6b60ab9475ed..4fd292c3a062 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1453,6 +1453,7 @@ struct filter_pred {
 static inline bool is_string_field(struct ftrace_event_field *field)
 {
 	return field->filter_type == FILTER_DYN_STRING ||
+	       field->filter_type == FILTER_RDYN_STRING ||
 	       field->filter_type == FILTER_STATIC_STRING ||
 	       field->filter_type == FILTER_PTR_STRING ||
 	       field->filter_type == FILTER_COMM;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c9124038b140..996920ed1812 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -706,6 +706,29 @@ static int filter_pred_strloc(struct filter_pred *pred, void *event)
 	return match;
 }
 
+/*
+ * Filter predicate for relative dynamic sized arrays of characters.
+ * These are implemented through a list of strings at the end
+ * of the entry as same as dynamic string.
+ * The difference is that the relative one records the location offset
+ * from the field itself, not the event entry.
+ */
+static int filter_pred_strrelloc(struct filter_pred *pred, void *event)
+{
+	u32 *item = (u32 *)(event + pred->offset);
+	u32 str_item = *item;
+	int str_loc = str_item & 0xffff;
+	int str_len = str_item >> 16;
+	char *addr = (char *)(&item[1]) + str_loc;
+	int cmp, match;
+
+	cmp = pred->regex.match(addr, &pred->regex, str_len);
+
+	match = cmp ^ pred->not;
+
+	return match;
+}
+
 /* Filter predicate for CPUs. */
 static int filter_pred_cpu(struct filter_pred *pred, void *event)
 {
@@ -756,7 +779,7 @@ static int filter_pred_none(struct filter_pred *pred, void *event)
  *
  * Note:
  * - @str might not be NULL-terminated if it's of type DYN_STRING
- *   or STATIC_STRING, unless @len is zero.
+ *   RDYN_STRING, or STATIC_STRING, unless @len is zero.
  */
 
 static int regex_match_full(char *str, struct regex *r, int len)
@@ -1083,6 +1106,9 @@ int filter_assign_type(const char *type)
 	if (strstr(type, "__data_loc") && strstr(type, "char"))
 		return FILTER_DYN_STRING;
 
+	if (strstr(type, "__rel_loc") && strstr(type, "char"))
+		return FILTER_RDYN_STRING;
+
 	if (strchr(type, '[') && strstr(type, "char"))
 		return FILTER_STATIC_STRING;
 
@@ -1318,8 +1344,10 @@ static int parse_pred(const char *str, void *data,
 			pred->fn = filter_pred_string;
 			pred->regex.field_len = field->size;
 
-		} else if (field->filter_type == FILTER_DYN_STRING)
+		} else if (field->filter_type == FILTER_DYN_STRING) {
 			pred->fn = filter_pred_strloc;
+		} else if (field->filter_type == FILTER_RDYN_STRING)
+			pred->fn = filter_pred_strrelloc;
 		else
 			pred->fn = filter_pred_pchar;
 		/* go past the last quote */
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 6a9fa34e2785..2c225f13f820 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -217,6 +217,20 @@ static u64 hist_field_dynstring(struct hist_field *hist_field,
 	return (u64)(unsigned long)addr;
 }
 
+static u64 hist_field_reldynstring(struct hist_field *hist_field,
+				   struct tracing_map_elt *elt,
+				   struct trace_buffer *buffer,
+				   struct ring_buffer_event *rbe,
+				   void *event)
+{
+	u32 *item = event + hist_field->field->offset;
+	u32 str_item = *item;
+	int str_loc = str_item & 0xffff;
+	char *addr = (char *)&item[1] + str_loc;
+
+	return (u64)(unsigned long)addr;
+}
+
 static u64 hist_field_pstring(struct hist_field *hist_field,
 			      struct tracing_map_elt *elt,
 			      struct trace_buffer *buffer,
@@ -1956,8 +1970,10 @@ static struct hist_field *create_hist_field(struct hist_trigger_data *hist_data,
 		if (field->filter_type == FILTER_STATIC_STRING) {
 			hist_field->fn = hist_field_string;
 			hist_field->size = field->size;
-		} else if (field->filter_type == FILTER_DYN_STRING)
+		} else if (field->filter_type == FILTER_DYN_STRING) {
 			hist_field->fn = hist_field_dynstring;
+		} else if (field->filter_type == FILTER_RDYN_STRING)
+			hist_field->fn = hist_field_reldynstring;
 		else
 			hist_field->fn = hist_field_pstring;
 	} else {
@@ -4952,7 +4968,8 @@ static inline void add_to_key(char *compound_key, void *key,
 		struct ftrace_event_field *field;
 
 		field = key_field->field;
-		if (field->filter_type == FILTER_DYN_STRING)
+		if (field->filter_type == FILTER_DYN_STRING ||
+		    field->filter_type == FILTER_RDYN_STRING)
 			size = *(u32 *)(rec + field->offset) >> 16;
 		else if (field->filter_type == FILTER_STATIC_STRING)
 			size = field->size;
diff --git a/kernel/trace/trace_events_inject.c b/kernel/trace/trace_events_inject.c
index c188045c5f97..d6b4935a78c0 100644
--- a/kernel/trace/trace_events_inject.c
+++ b/kernel/trace/trace_events_inject.c
@@ -168,10 +168,14 @@ static void *trace_alloc_entry(struct trace_event_call *call, int *size)
 			continue;
 		if (field->filter_type == FILTER_STATIC_STRING)
 			continue;
-		if (field->filter_type == FILTER_DYN_STRING) {
+		if (field->filter_type == FILTER_DYN_STRING ||
+		    field->filter_type == FILTER_RDYN_STRING) {
 			u32 *str_item;
 			int str_loc = entry_size & 0xffff;
 
+			if (field->filter_type == FILTER_RDYN_STRING)
+				str_loc -= field->offset + field->size;
+
 			str_item = (u32 *)(entry + field->offset);
 			*str_item = str_loc; /* string length is 0. */
 		} else {
@@ -214,7 +218,8 @@ static int parse_entry(char *str, struct trace_event_call *call, void **pentry)
 
 			if (field->filter_type == FILTER_STATIC_STRING) {
 				strlcpy(entry + field->offset, addr, field->size);
-			} else if (field->filter_type == FILTER_DYN_STRING) {
+			} else if (field->filter_type == FILTER_DYN_STRING ||
+				   field->filter_type == FILTER_RDYN_STRING) {
 				int str_len = strlen(addr) + 1;
 				int str_loc = entry_size & 0xffff;
 				u32 *str_item;
@@ -229,6 +234,8 @@ static int parse_entry(char *str, struct trace_event_call *call, void **pentry)
 
 				strlcpy(entry + (entry_size - str_len), addr, str_len);
 				str_item = (u32 *)(entry + field->offset);
+				if (field->filter_type == FILTER_RDYN_STRING)
+					str_loc -= field->offset + field->size;
 				*str_item = (str_len << 16) | str_loc;
 			} else {
 				char **paddr;

