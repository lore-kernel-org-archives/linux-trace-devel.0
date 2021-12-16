Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9859C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbhLPVkA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52964 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbhLPVkA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:40:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB13361F9C
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4554C36AED;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dW-SX;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 06/10] libtraceveent: Add testing of old dynamic string event layout
Date:   Thu, 16 Dec 2021 16:39:52 -0500
Message-Id: <20211216213956.13934-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When running against old trace.dat files, the output would not print
strings. This was due to a change that did not take into account the old
dynamic format that did not have strings as an array.

Add a unit test to cover this case so that it does not break again.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 utest/traceevent-utest.c | 54 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 2910b95d01e6..f4fdc86664ca 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -63,26 +63,72 @@ static char dyn_str_data[] = {
 };
 static void *dyn_str_event_data = (void *)dyn_str_data;
 
+static const char dyn_str_old_event[] =
+	"name: irq_handler_entry\n"
+	"ID: 2\n"
+	"format:\n"
+	"\tfield:unsigned short common_type;\toffset:0;\tsize:2;\n"
+	"\tfield:unsigned char common_flags;\toffset:2;\tsize:1;\n"
+	"\tfield:unsigned char common_preempt_count;\toffset:3;\tsize:1;\n"
+	"\tfield:int common_pid;\toffset:4;\tsize:4;\n"
+	"\n"
+        "\tfield:int irq;\toffset:8;\tsize:4;\n"
+        "\tfield:__data_loc name;\toffset:12;\tsize:2;\n"
+	"\n"
+	"print fmt: \"irq=%d handler=%s\", REC->irq, __get_str(name)\n";
+
+static char dyn_str_old_data[] = {
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	/* common type */		2, 0x00,
+#else
+	/* common type */		0x00, 2
+#endif
+	/* common flags */		0x00,
+	/* common_preempt_count */	0x00,
+	/* common_pid */		0x00, 0x00, 0x00, 0x00,
+	/* irq */			0x00, 0x00, 0x00, 0x00,
+
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	/* name : offset */		16, 0x00,
+#else
+	/* name : offset */		0x00, 16,
+#endif
+	/* padding */			0x00, 0x00,
+	/* name */			'h', 'e', 'l', 'l', 'o', '\0',
+	/* padding */			0x00, 0x00, 0x00
+};
+static void *dyn_str_old_event_data = (void *)dyn_str_old_data;
+
 static struct tep_handle *test_tep;
 static struct trace_seq *test_seq;
 static struct trace_seq seq_storage;
 
-static void test_parse_dyn_str_event(void)
+static void parse_dyn_str(const char *dyn_str, void *data)
 {
 	struct tep_format_field *field;
 	struct tep_event *event;
 
 	CU_TEST(tep_parse_format(test_tep, &event,
-				 dyn_str_event, strlen(dyn_str_event),
+				 dyn_str, strlen(dyn_str),
 				DYN_STR_EVENT_SYSTEM) == TEP_ERRNO__SUCCESS);
 
 	field = tep_find_any_field(event, DYN_STR_FIELD);
 	CU_TEST(field != NULL);
 	trace_seq_reset(test_seq);
-	tep_print_field(test_seq, dyn_str_event_data, field);
+	tep_print_field(test_seq, data, field);
 	CU_TEST(strcmp(test_seq->buffer, DYN_STRING) == 0);
 }
 
+static void test_parse_dyn_str_event(void)
+{
+	parse_dyn_str(dyn_str_event, dyn_str_event_data);
+}
+
+static void test_parse_dyn_str_old_event(void)
+{
+	parse_dyn_str(dyn_str_old_event, dyn_str_old_event_data);
+}
+
 static int test_suite_destroy(void)
 {
 	tep_free(test_tep);
@@ -111,4 +157,6 @@ void test_traceevent_lib(void)
 	}
 	CU_add_test(suite, "parse dynamic string event",
 		    test_parse_dyn_str_event);
+	CU_add_test(suite, "parse old dynamic string event",
+		    test_parse_dyn_str_old_event);
 }
-- 
2.33.0

