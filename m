Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D49FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 09:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbhKVJdu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:33:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238782AbhKVJdt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 04:33:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE7D760E08;
        Mon, 22 Nov 2021 09:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637573442;
        bh=VF8jdC+j6iS0sOZaXcru+KzZqDdc4I8hp+j7RfsWukY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIZ6ZjRtyNEVotfv4d7VW05+LPfeTQqiLVlv9mYcXDjS7WRadeJGt8BcdhlxTDi3/
         wQJ37LI5uQOtX5km3GeoVFvTK9UzfPeTGq6svfLOWu57PW6woygi1f6/T5cLAEuMJE
         52As3u6JOws9T/GrTioNj/IOXuNmMpAB9v4w43tHYdMOqKXZSB9rtJNUrbcaeX5e/j
         e1WwjgVHqqrd6wmH508waRrhioxX5f1IzBGtG2KfoHp0Sb615Sh42p2Jtr99IMUQJY
         Bg1Dvz0TUatObBZqNySqdAqa7rc+VF1irfPD65WimCtRu32kMm8YGr1UXFbpnDWQs+
         8XPon7T3e1mEw==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/5] libtraceevent: Add __rel_loc relative location attribute support
Date:   Mon, 22 Nov 2021 18:30:40 +0900
Message-Id: <163757343994.510314.13241077597729303802.stgit@devnote2>
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
the data location from the next to the field itself. This is similar
to the '__data_loc' but the location offset is not from the event
entry but from the next of the field.

This patch adds '__rel_loc' decoding support in the libtraceevent.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v2:
   - Fix to use TEP_FIELD_IS_RELATIVE instead of TEP_FIELD_IS_REL_DYNAMIC.
   - Correctly handles the bitmask and print routine.
---
 tools/lib/traceevent/event-parse.c  |   59 ++++++++++++++++++++++++-----------
 tools/lib/traceevent/event-parse.h  |    5 ++-
 tools/lib/traceevent/parse-filter.c |    5 ++-
 3 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index fe58843d047c..8e24c4c78c7f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1367,6 +1367,14 @@ static int field_is_dynamic(struct tep_format_field *field)
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
@@ -1622,6 +1630,8 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 			field->flags |= TEP_FIELD_IS_STRING;
 		if (field_is_dynamic(field))
 			field->flags |= TEP_FIELD_IS_DYNAMIC;
+		if (field_is_relative_dynamic(field))
+			field->flags |= TEP_FIELD_IS_DYNAMIC | TEP_FIELD_IS_RELATIVE;
 		if (field_is_long(field))
 			field->flags |= TEP_FIELD_IS_LONG;
 
@@ -2928,7 +2938,7 @@ process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 
 	arg->type = TEP_PRINT_STRING;
 	arg->string.string = token;
-	arg->string.offset = -1;
+	arg->string.field = NULL;
 
 	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
@@ -2957,7 +2967,7 @@ process_bitmask(struct tep_event *event __maybe_unused, struct tep_print_arg *ar
 
 	arg->type = TEP_PRINT_BITMASK;
 	arg->bitmask.bitmask = token;
-	arg->bitmask.offset = -1;
+	arg->bitmask.field = NULL;
 
 	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
@@ -3123,19 +3133,23 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
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
@@ -4163,14 +4177,16 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_STRING: {
 		int str_offset;
 
-		if (arg->string.offset == -1) {
-			struct tep_format_field *f;
+		if (!arg->string.field)
+			arg->string.field = tep_find_any_field(event, arg->string.string);
+		if (!arg->string.field)
+			break;
 
-			f = tep_find_any_field(event, arg->string.string);
-			arg->string.offset = f->offset;
-		}
-		str_offset = data2host4(tep, *(unsigned int *)(data + arg->string.offset));
+		str_offset = data2host4(tep,
+				*(unsigned int *)(data + arg->string.field->offset));
 		str_offset &= 0xffff;
+		if (arg->string.field->flags & TEP_FIELD_IS_RELATIVE)
+			str_offset += arg->string.field->offset + arg->string.field->size;
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
 	}
@@ -4181,15 +4197,16 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		int bitmask_offset;
 		int bitmask_size;
 
-		if (arg->bitmask.offset == -1) {
-			struct tep_format_field *f;
-
-			f = tep_find_any_field(event, arg->bitmask.bitmask);
-			arg->bitmask.offset = f->offset;
-		}
-		bitmask_offset = data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
+		if (!arg->bitmask.field)
+			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
+		if (!arg->bitmask.field)
+			break;
+		bitmask_offset = data2host4(tep,
+				*(unsigned int *)(data + arg->bitmask.field->offset));
 		bitmask_size = bitmask_offset >> 16;
 		bitmask_offset &= 0xffff;
+		if (arg->bitmask.field->flags & TEP_FIELD_IS_RELATIVE)
+			bitmask_offset += arg->bitmask.field->offset + arg->bitmask.field->size;
 		print_bitmask_to_seq(tep, s, format, len_arg,
 				     data + bitmask_offset, bitmask_size);
 		break;
@@ -5109,6 +5126,8 @@ void tep_print_field(struct trace_seq *s, void *data,
 			offset = val;
 			len = offset >> 16;
 			offset &= 0xffff;
+			if (field->flags & TEP_FIELD_IS_RELATIVE)
+				offset += field->offset + field->size;
 		}
 		if (field->flags & TEP_FIELD_IS_STRING &&
 		    is_printable_array(data + offset, len)) {
@@ -6987,6 +7006,8 @@ void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 					 data + offset, field->size);
 		*len = offset >> 16;
 		offset &= 0xffff;
+		if (field->flags & TEP_FIELD_IS_RELATIVE)
+			offset += field->offset + field->size;
 	} else
 		*len = field->size;
 
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index a67ad9a5b835..41d4f9f6a843 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
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
+	struct tep_format_field *field;
 };
 
 struct tep_print_arg_bitmask {
 	char			*bitmask;
-	int			offset;
+	struct tep_format_field *field;
 };
 
 struct tep_print_arg_field {
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 368826bb5a57..5df177070d53 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
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

