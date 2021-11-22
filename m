Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178F7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 09:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238925AbhKVJkH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238829AbhKVJkG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 04:40:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 262BA604DA;
        Mon, 22 Nov 2021 09:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637573820;
        bh=ep7kjDpim82IE1kNg00+O1bFbEi691vy1bCO8AKqDmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMyzMcq1P85HpZ4mmpE8Xs4a5IPPlIiEnPx2AmdnJu+ekRzUEGZbuFuIyULfn2k01
         Jg//HgP46lRbNun6juWk98I5CDNWocHzw+M5elMY3j9ERfHs43ptKGzJzZpDO1w8l3
         D63rMmJRnKEpBpRRuizKnG/gH8p+X7GdWojUZhMxW9Ns8T7ubViiFUdfZwi97CwmLv
         c2TdnmkrtrHDmhUAmUHmlTl4p+axCS7kMHEnZVpCRvktg3xCJepHOIBhMnAG+uFvAA
         S4DVCWvHNKk4dU9hvxeUIeoEhSujC6f+lFMojjyMnS2xoncciYi3D/nTVD3bukGbL1
         n7YrXswlSAArw==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] libtraceevent: Add __rel_loc relative location attribute support
Date:   Mon, 22 Nov 2021 18:36:57 +0900
Message-Id: <163757381684.511392.14804088833440960833.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <163757380763.511392.6830680420693577369.stgit@devnote2>
References: <163757380763.511392.6830680420693577369.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add '__rel_loc' new dynamic data location attribute which encodes
the data location from the next to the field itself. This is similar
to the '__data_loc' but the location offset is not from the event
entry but from the next of the field.

This patch adds '__rel_loc' decoding support in the libtraceevent.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 src/event-parse.c  |   54 +++++++++++++++++++++++++++++++++-------------------
 src/event-parse.h  |    5 +++--
 src/parse-filter.c |    5 ++++-
 3 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 70637586bc9a..2781cac26eeb 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1529,6 +1529,14 @@ static int field_is_dynamic(struct tep_format_field *field)
 	return 0;
 }
 
+static int field_is_relative_dynamic(struct tep_format_field *field)
+{
+	if (strncmp(field->type, "__rel_loc", 9) == 0)
+		return 1;
+
+	return 0;
+}
+
 static int field_is_long(struct tep_format_field *field)
 {
 	/* includes long long */
@@ -1784,6 +1792,8 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 			field->flags |= TEP_FIELD_IS_STRING;
 		if (field_is_dynamic(field))
 			field->flags |= TEP_FIELD_IS_DYNAMIC;
+		if (field_is_relative_dynamic(field))
+			field->flags |= TEP_FIELD_IS_DYNAMIC | TEP_FIELD_IS_RELATIVE;
 		if (field_is_long(field))
 			field->flags |= TEP_FIELD_IS_LONG;
 
@@ -3113,7 +3123,7 @@ process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 
 	arg->type = TEP_PRINT_STRING;
 	arg->string.string = token;
-	arg->string.offset = -1;
+	arg->string.field = NULL;
 
 	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
@@ -3142,7 +3152,7 @@ process_bitmask(struct tep_event *event __maybe_unused, struct tep_print_arg *ar
 
 	arg->type = TEP_PRINT_BITMASK;
 	arg->bitmask.bitmask = token;
-	arg->bitmask.offset = -1;
+	arg->bitmask.field = NULL;
 
 	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
@@ -3308,19 +3318,23 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		free_token(token);
 		return process_int_array(event, arg, tok);
 	}
-	if (strcmp(token, "__get_str") == 0) {
+	if (strcmp(token, "__get_str") == 0 ||
+	    strcmp(token, "__get_rel_str") == 0) {
 		free_token(token);
 		return process_str(event, arg, tok);
 	}
-	if (strcmp(token, "__get_bitmask") == 0) {
+	if (strcmp(token, "__get_bitmask") == 0 ||
+	    strcmp(token, "__get_rel_bitmask") == 0) {
 		free_token(token);
 		return process_bitmask(event, arg, tok);
 	}
-	if (strcmp(token, "__get_dynamic_array") == 0) {
+	if (strcmp(token, "__get_dynamic_array") == 0 ||
+	    strcmp(token, "__get_rel_dynamic_array") == 0) {
 		free_token(token);
 		return process_dynamic_array(event, arg, tok);
 	}
-	if (strcmp(token, "__get_dynamic_array_len") == 0) {
+	if (strcmp(token, "__get_dynamic_array_len") == 0 ||
+	    strcmp(token, "__get_rel_dynamic_array_len") == 0) {
 		free_token(token);
 		return process_dynamic_array_len(event, arg, tok);
 	}
@@ -3886,6 +3900,8 @@ static inline void dynamic_offset_field(struct tep_handle *tep,
 					unsigned int *len)
 {
 	dynamic_offset(tep, field->size, data + field->offset, offset, len);
+	if (field->flags & TEP_FIELD_IS_RELATIVE)
+		offset += field->offset + field->size;
 }
 
 static unsigned long long
@@ -4398,13 +4414,11 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_TYPE:
 		break;
 	case TEP_PRINT_STRING: {
-		if (arg->string.offset == -1) {
-			struct tep_format_field *f;
-
-			f = tep_find_any_field(event, arg->string.string);
-			arg->string.offset = f->offset;
-		}
-		dynamic_offset(tep, 4, data + arg->string.offset, &offset, &len);
+		if (!arg->string.field)
+			arg->string.field = tep_find_any_field(event, arg->string.string);
+		if (!arg->string.field)
+			break;
+		dynamic_offset_field(tep, arg->string.field, data, &offset, &len);
 		/* Do not attempt to save zero length dynamic strings */
 		if (!len)
 			break;
@@ -4415,13 +4429,11 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
 	case TEP_PRINT_BITMASK: {
-		if (arg->bitmask.offset == -1) {
-			struct tep_format_field *f;
-
-			f = tep_find_any_field(event, arg->bitmask.bitmask);
-			arg->bitmask.offset = f->offset;
-		}
-		dynamic_offset(tep, 4, data + arg->bitmask.offset, &offset, &len);
+		if (!arg->bitmask.field)
+			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
+		if (!arg->bitmask.field)
+			break;
+		dynamic_offset_field(tep, arg->bitmask.field, data, &offset, &len);
 		print_bitmask_to_seq(tep, s, format, len_arg,
 				     data + offset, len);
 		break;
@@ -7343,6 +7355,8 @@ void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 					 data + offset, field->size);
 		*len = offset >> 16;
 		offset &= 0xffff;
+		if (field->flags & TEP_FIELD_IS_RELATIVE)
+			offset += field->offset + field->size;
 	} else
 		*len = field->size;
 
diff --git a/src/event-parse.h b/src/event-parse.h
index 083389358127..db8bc6db5431 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -125,6 +125,7 @@ enum tep_format_flags {
 	TEP_FIELD_IS_LONG	= 32,
 	TEP_FIELD_IS_FLAG	= 64,
 	TEP_FIELD_IS_SYMBOLIC	= 128,
+	TEP_FIELD_IS_RELATIVE	= 256,
 };
 
 struct tep_format_field {
@@ -153,12 +154,12 @@ struct tep_print_arg_atom {
 
 struct tep_print_arg_string {
 	char			*string;
-	int			offset;
+	struct tep_format_field	*field;
 };
 
 struct tep_print_arg_bitmask {
 	char			*bitmask;
-	int			offset;
+	struct tep_format_field	*field;
 };
 
 struct tep_print_arg_field {
diff --git a/src/parse-filter.c b/src/parse-filter.c
index 368826bb5a57..5df177070d53 100644
--- a/src/parse-filter.c
+++ b/src/parse-filter.c
@@ -1712,8 +1712,11 @@ static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *
 
 		if (arg->str.field->flags & TEP_FIELD_IS_DYNAMIC) {
 			addr = *(unsigned int *)val;
-			val = record->data + (addr & 0xffff);
 			size = addr >> 16;
+			addr &= 0xffff;
+			if (arg->str.field->flags & TEP_FIELD_IS_RELATIVE)
+				addr += arg->str.field->offset + arg->str.field->size;
+			val = record->data + addr;
 		}
 
 		/*

