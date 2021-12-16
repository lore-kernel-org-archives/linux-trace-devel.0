Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926B5C4167B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241298AbhLPVkC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39056 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241571AbhLPVkB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:40:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 920C0B82653
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B73C36AEC;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dc-Tp;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 08/10] libtraceevent: Account for old dynamic string formats and honor size
Date:   Thu, 16 Dec 2021 16:39:54 -0500
Message-Id: <20211216213956.13934-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Old kernels that started with dynamic strings did not place the length of
the dynamic string into the place holder. Instead, it only had a two byte
offset to where the string was located in the data payload.

It just worked by shear luck that the reading of the string would look at
he length (which was just random numbers) and if it wasn't zero, it would
print the string normally. With the update to include rel_loc, the size of
the place holder is no longer hard coded as 4, and the actual size is used
(2 for the old format). This caused the length of the string to always be
zero, which triggered the check to not bother printing strings of size
zero. Hence the strings stopped being printed.

Start using the size of the data payload to limit the string parsing. More
work needs to be done in this regard, but having an application trust the
size of the payload of unknown data can be dangerous. Use this as an
opportunity to parse by size. Make the length of the string from the old
format the rest of the data payload, and not depend on it ending with
'\0'.

Note, tep_print_field() does not allow the user to pass in the size of the
data to parse. Currently use 4096, but this will need to be deprecated.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-parse.c        | 67 ++++++++++++++++++++++++++--------------
 utest/traceevent-utest.c |  7 +++--
 2 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 34d6c9616f08..62afe86f2c6d 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3878,9 +3878,10 @@ static unsigned long long test_for_symbol(struct tep_handle *tep,
 #define TEP_LEN_SHIFT			16
 
 static void dynamic_offset(struct tep_handle *tep, int size, void *data,
-			   unsigned int *offset, unsigned int *len)
+			   int data_size, unsigned int *offset, unsigned int *len)
 {
 	unsigned long long val;
+	unsigned int o, l;
 
 	/*
 	 * The total allocated length of the dynamic array is
@@ -3889,19 +3890,36 @@ static void dynamic_offset(struct tep_handle *tep, int size, void *data,
 	 */
 	val = tep_read_number(tep, data, size);
 
+	/* Check for overflows */
+	o = (unsigned int)(val & TEP_OFFSET_LEN_MASK);
+
+	/* If there's no length, then just make the length the size of the data */
+	if (size == 2)
+		l = data_size - o;
+	else
+		l = (unsigned int)((val >> TEP_LEN_SHIFT) & TEP_OFFSET_LEN_MASK);
+
 	if (offset)
-		*offset = (unsigned int)(val & TEP_OFFSET_LEN_MASK);
+		*offset = o > data_size ? 0 : o;
 	if (len)
-		*len = (unsigned int)((val >> TEP_LEN_SHIFT) & TEP_OFFSET_LEN_MASK);
+		*len = o + l > data_size ? 0 : l;
 }
 
 static inline void dynamic_offset_field(struct tep_handle *tep,
 					struct tep_format_field *field,
-					void *data,
+					void *data, int size,
 					unsigned int *offset,
 					unsigned int *len)
 {
-	dynamic_offset(tep, field->size, data + field->offset, offset, len);
+	/* Test for overflow */
+	if (field->offset + field->size > size) {
+		if (*offset)
+			*offset = 0;
+		if (*len)
+			*len = 0;
+		return;
+	}
+	dynamic_offset(tep, field->size, data + field->offset, size, offset, len);
 	if (field->flags & TEP_FIELD_IS_RELATIVE)
 		*offset += field->offset + field->size;
 }
@@ -3978,7 +3996,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			switch (larg->type) {
 			case TEP_PRINT_DYNAMIC_ARRAY:
 				dynamic_offset_field(tep, larg->dynarray.field, data,
-						     &offset, NULL);
+						     size, &offset, NULL);
 				offset += right;
 				if (larg->dynarray.field->elementsize)
 					field_size = larg->dynarray.field->elementsize;
@@ -4100,13 +4118,13 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		}
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY_LEN:
-		dynamic_offset_field(tep, arg->dynarray.field, data,
+		dynamic_offset_field(tep, arg->dynarray.field, data, size,
 				     NULL, &field_size);
 		val = field_size;
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY:
 		/* Without [], we pass the address to the dynamic data */
-		dynamic_offset_field(tep, arg->dynarray.field, data,
+		dynamic_offset_field(tep, arg->dynarray.field, data, size,
 				     &offset, NULL);
 		val = (unsigned long long)((unsigned long)data + offset);
 		val = (unsigned long)data + offset;
@@ -4348,7 +4366,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_HEX_STR:
 		if (arg->hex.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
 			dynamic_offset_field(tep, arg->hex.field->dynarray.field, data,
-				             &offset, NULL);
+				             size, &offset, NULL);
 			hex = data + offset;
 		} else {
 			field = arg->hex.field->field.field;
@@ -4375,7 +4393,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 
 		if (arg->int_array.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
 			dynamic_offset_field(tep, arg->int_array.field->dynarray.field, data,
-					     &offset, NULL);
+					     size, &offset, NULL);
 			num = data + offset;
 		} else {
 			field = arg->int_array.field->field.field;
@@ -4420,7 +4438,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			arg->string.field = tep_find_any_field(event, arg->string.string);
 		if (!arg->string.field)
 			break;
-		dynamic_offset_field(tep, arg->string.field, data, &offset, &len);
+		dynamic_offset_field(tep, arg->string.field, data, size, &offset, &len);
 		/* Do not attempt to save zero length dynamic strings */
 		if (!len)
 			break;
@@ -4435,7 +4453,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
 		if (!arg->bitmask.field)
 			break;
-		dynamic_offset_field(tep, arg->bitmask.field, data, &offset, &len);
+		dynamic_offset_field(tep, arg->bitmask.field, data, size, &offset, &len);
 		print_bitmask_to_seq(tep, s, format, len_arg,
 				     data + offset, len);
 		break;
@@ -5312,7 +5330,7 @@ static int print_raw_buff_arg(struct trace_seq *s, const char *ptr,
 		return ret;
 	}
 
-	dynamic_offset_field(event->tep, arg->dynarray.field, data,
+	dynamic_offset_field(event->tep, arg->dynarray.field, data, size,
 			     &offset, &arr_len);
 	buf = data + offset;
 
@@ -5339,7 +5357,7 @@ static int is_printable_array(char *p, unsigned int len)
 	return 1;
 }
 
-static void print_field_raw(struct trace_seq *s, void *data,
+static void print_field_raw(struct trace_seq *s, void *data, int size,
 			     struct tep_format_field *field)
 {
 	struct tep_handle *tep = field->event->tep;
@@ -5348,7 +5366,7 @@ static void print_field_raw(struct trace_seq *s, void *data,
 
 	if (field->flags & TEP_FIELD_IS_ARRAY) {
 		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
-			dynamic_offset_field(tep, field, data, &offset, &len);
+			dynamic_offset_field(tep, field, data, size, &offset, &len);
 		} else {
 			offset = field->offset;
 			len = field->size;
@@ -5405,7 +5423,7 @@ static void print_field_raw(struct trace_seq *s, void *data,
 static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
 			    void *data, int size, struct tep_event *event);
 
-void static inline print_field(struct trace_seq *s, void *data,
+void static inline print_field(struct trace_seq *s, void *data, int size,
 				    struct tep_format_field *field,
 				    struct tep_print_parse **parse_ptr)
 {
@@ -5460,17 +5478,18 @@ void static inline print_field(struct trace_seq *s, void *data,
 
  out:
 	/* Not found. */
-	print_field_raw(s, data, field);
+	print_field_raw(s, data, size, field);
 }
 
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field)
 {
-	print_field(s, data, field, NULL);
+	/* unsafe to use, should pass in size */
+	print_field(s, data, 4096, field, NULL);
 }
 
 static inline void
-print_selected_fields(struct trace_seq *s, void *data,
+print_selected_fields(struct trace_seq *s, void *data, int size,
 		      struct tep_event *event,
 		      unsigned long long ignore_mask)
 {
@@ -5484,14 +5503,14 @@ print_selected_fields(struct trace_seq *s, void *data,
 			continue;
 
 		trace_seq_printf(s, " %s=", field->name);
-		print_field(s, data, field, &parse);
+		print_field(s, data, size, field, &parse);
 	}
 }
 
 void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct tep_event *event)
+		      int size, struct tep_event *event)
 {
-	print_selected_fields(s, data, event, 0);
+	print_selected_fields(s, data, size, event, 0);
 }
 
 /**
@@ -5505,7 +5524,7 @@ void tep_record_print_fields(struct trace_seq *s,
 			     struct tep_record *record,
 			     struct tep_event *event)
 {
-	print_selected_fields(s, record->data, event, 0);
+	print_selected_fields(s, record->data, record->size, event, 0);
 }
 
 /**
@@ -5523,7 +5542,7 @@ void tep_record_print_selected_fields(struct trace_seq *s,
 {
 	unsigned long long ignore_mask = ~select_mask;
 
-	print_selected_fields(s, record->data, event, ignore_mask);
+	print_selected_fields(s, record->data, record->size, event, ignore_mask);
 }
 
 static int print_function(struct trace_seq *s, const char *format,
diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index a0d808e5c1a5..0f4f17e655ae 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -104,13 +104,14 @@ static struct tep_handle *test_tep;
 static struct trace_seq *test_seq;
 static struct trace_seq seq_storage;
 
-static void parse_dyn_str(const char *dyn_str, void *data)
+static void parse_dyn_str(const char *dyn_str, void *data, int size)
 {
 	struct tep_format_field *field;
 	struct tep_event *event;
 	struct tep_record record;
 
 	record.data = data;
+	record.size = size;
 
 	CU_TEST(tep_parse_format(test_tep, &event,
 				 dyn_str, strlen(dyn_str),
@@ -130,12 +131,12 @@ static void parse_dyn_str(const char *dyn_str, void *data)
 
 static void test_parse_dyn_str_event(void)
 {
-	parse_dyn_str(dyn_str_event, dyn_str_event_data);
+	parse_dyn_str(dyn_str_event, dyn_str_event_data, sizeof(dyn_str_data));
 }
 
 static void test_parse_dyn_str_old_event(void)
 {
-	parse_dyn_str(dyn_str_old_event, dyn_str_old_event_data);
+	parse_dyn_str(dyn_str_old_event, dyn_str_old_event_data, sizeof(dyn_str_old_data));
 }
 
 static int test_suite_destroy(void)
-- 
2.33.0

