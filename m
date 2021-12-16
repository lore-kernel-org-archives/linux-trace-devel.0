Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF601C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241625AbhLPVkD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39076 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241637AbhLPVkC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:40:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 348E0B82658
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC97C36AEF;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003df-UR;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 09/10] libtraceevent: Replace tep_print_field() with tep_print_field_content()
Date:   Thu, 16 Dec 2021 16:39:55 -0500
Message-Id: <20211216213956.13934-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The API tep_print_field() does not let the user define the size of the
payload that is being parsed. This can lead to dangerous code if the data
itself is untrusted. It could define a string and offset to read other
parts of the application.

Add a new tep_print_field_content() that adds the size variable that can
be used to prevent accesses outside the data.

Note, there is still many ways to circumvent the size limitation that
needs to be fixed, but having an API that will not let you fix it is a
problem.

Also fixed at formatting issue with print_field() that had void before the
"static inline".

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-field_print.txt | 10 +++++-----
 Documentation/libtraceevent.txt             |  2 +-
 include/traceevent/event-parse.h            |  8 ++++++--
 src/event-parse.c                           | 21 ++++++++++++++++++++-
 utest/traceevent-utest.c                    |  2 +-
 5 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/Documentation/libtraceevent-field_print.txt b/Documentation/libtraceevent-field_print.txt
index c201c134c42e..05b458b29e8e 100644
--- a/Documentation/libtraceevent-field_print.txt
+++ b/Documentation/libtraceevent-field_print.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_print_field, tep_print_fields, tep_print_num_field, tep_print_func_field, tep_record_print_fields, tep_record_print_selected_fields -
+tep_print_field_content, tep_print_fields, tep_print_num_field, tep_print_func_field, tep_record_print_fields, tep_record_print_selected_fields -
 Print the field content.
 
 SYNOPSIS
@@ -13,7 +13,7 @@ SYNOPSIS
 *#include <event-parse.h>*
 *#include <trace-seq.h>*
 
-void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, struct tep_format_field pass:[*]_field_);
+void *tep_print_field_content*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int size, struct tep_format_field pass:[*]_field_);
 void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int _size_, struct tep_event pass:[*]_event_);
 int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
 int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
@@ -25,7 +25,7 @@ DESCRIPTION
 -----------
 These functions print recorded field's data, according to the field's type.
 
-The _tep_print_field()_ function extracts from the recorded raw _data_ value of
+The _tep_print_field_content()_ function extracts from the recorded raw _data_ value of
 the _field_ and prints it into _s_, according to the field type.
 
 The _tep_print_fields()_ prints each field name followed by the record's field
@@ -34,7 +34,7 @@ value according to the field's type:
 --
 "field1_name=field1_value field2_name=field2_value ..."
 --
-It iterates all fields of the _event_, and calls _tep_print_field()_ for each of
+It iterates all fields of the _event_, and calls _tep_print_field_content()_ for each of
 them.
 
 The _tep_print_num_field()_ function prints a numeric field with given format
@@ -83,7 +83,7 @@ void process_record(struct tep_record *record)
 	trace_seq_reset(&seq);
 
 	/* Print the value of "common_pid" */
-	tep_print_field(&seq, record->data, field_pid);
+	tep_print_field_content(&seq, record->data, record->size, field_pid);
 
 	/* Print all fields of the "hrtimer_start" event */
 	tep_print_fields(&seq, record->data, record->size, event);
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 01014b7ca719..95465521bcf4 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -76,7 +76,7 @@ APIs related to fields from event's format files:
 	int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, const void pass:[*]_data_, unsigned long long pass:[*]_value_);
 
 Event fields printing:
-	void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, struct tep_format_field pass:[*]_field_);
+	void *tep_print_field_content*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int size, struct tep_format_field pass:[*]_field_);
 	void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int _size_, struct tep_event pass:[*]_event_);
 	int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
 	int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 97234062a057..27cba06f55cb 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -544,8 +544,8 @@ struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *tep, const char *c
 					   struct tep_cmdline *next);
 int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline);
 
-void tep_print_field(struct trace_seq *s, void *data,
-		     struct tep_format_field *field);
+void tep_print_field_content(struct trace_seq *s, void *data, int size,
+			     struct tep_format_field *field);
 void tep_record_print_fields(struct trace_seq *s,
 			     struct tep_record *record,
 			     struct tep_event *event);
@@ -770,4 +770,8 @@ enum tep_loglevel {
 };
 void tep_set_loglevel(enum tep_loglevel level);
 
+/* DEPRECATED */
+void tep_print_field(struct trace_seq *s, void *data,
+		     struct tep_format_field *field);
+
 #endif /* _PARSE_EVENTS_H */
diff --git a/src/event-parse.c b/src/event-parse.c
index 62afe86f2c6d..40af92f4295f 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5423,7 +5423,7 @@ static void print_field_raw(struct trace_seq *s, void *data, int size,
 static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
 			    void *data, int size, struct tep_event *event);
 
-void static inline print_field(struct trace_seq *s, void *data, int size,
+static inline void print_field(struct trace_seq *s, void *data, int size,
 				    struct tep_format_field *field,
 				    struct tep_print_parse **parse_ptr)
 {
@@ -5481,6 +5481,25 @@ void static inline print_field(struct trace_seq *s, void *data, int size,
 	print_field_raw(s, data, size, field);
 }
 
+/**
+ * tep_print_field_content - write out the raw content of a field
+ * @s:    The trace_seq to write the content into
+ * @data: The payload to extract the field from.
+ * @size: The size of the payload.
+ * @field: The field to extract
+ *
+ * Use @field to find the field content from within @data and write it
+ * in human readable format into @s.
+ *
+ * It will not write anything on error (s->len will not move)
+ */
+void tep_print_field_content(struct trace_seq *s, void *data, int size,
+			     struct tep_format_field *field)
+{
+	print_field(s, data, size, field, NULL);
+}
+
+/** DEPRECATED **/
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field)
 {
diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 0f4f17e655ae..99900de50355 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -120,7 +120,7 @@ static void parse_dyn_str(const char *dyn_str, void *data, int size)
 	field = tep_find_any_field(event, DYN_STR_FIELD);
 	CU_TEST(field != NULL);
 	trace_seq_reset(test_seq);
-	tep_print_field(test_seq, data, field);
+	tep_print_field_content(test_seq, data, size, field);
 	CU_TEST(strcmp(test_seq->buffer, DYN_STRING) == 0);
 
 	trace_seq_reset(test_seq);
-- 
2.33.0

