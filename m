Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE6FC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Dec 2022 13:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLNNlV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Dec 2022 08:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbiLNNlU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Dec 2022 08:41:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948A126AB2
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 05:41:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43922B818B4
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 13:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F43C433EF
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 13:41:15 +0000 (UTC)
Date:   Wed, 14 Dec 2022 08:41:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add test to test sizeof() processing
Message-ID: <20221214084113.211924a7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that some sizeof() calls can be parsed, create a unit test to test the
process_sizeof() algorithm.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/traceevent-utest.c | 88 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 4fc09e552ce4..954a592d5c3c 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -140,6 +140,45 @@ static char cpumask_##name##_event_data[] = {                       \
 }
 #endif
 
+#define SIZEOF_LONG4_FMT "int=4 unsigned=4 unsigned int=4 long=4 unsigned long=4 long long=8 unsigned long long=8 s4=4 u4=4 s8=8 u8=8"
+#define SIZEOF_LONG8_FMT "int=4 unsigned=4 unsigned int=4 long=8 unsigned long=8 long long=8 unsigned long long=8 s4=4 u4=4 s8=8 u8=8"
+
+static const char size_of_event[] =
+	"name: sizeof_event\n"
+	"ID: 23\n"
+	"format:\n"
+	"\tfield:unsigned short common_type;\toffset:0;\tsize:2;\tsigned:0;\n"
+	"\tfield:unsigned char common_flags;\toffset:2;\tsize:1;\tsigned:0;\n"
+	"\tfield:unsigned char common_preempt_count;\toffset:3;\tsize:1;\tsigned:0;\n"
+	"\tfield:int common_pid;\toffset:4;\tsize:4;\tsigned:1;\n"
+	"\n"
+        "\tfield:int s4;\toffset:8;\tsize:4;\tsigned:1;\n"
+        "\tfield:unsigned int u4;\toffset:12;\tsize:4;\tsigned:0;\n"
+        "\tfield:long long s8;\toffset:16;\tsize:8;\tsigned:1;\n"
+        "\tfield:unsigned long long u8;\toffset:24;\tsize:8;\tsigned:0;\n"
+	"\n"
+	"print fmt: \"int=%d unsigned=%d unsigned int=%d long=%d unsigned long=%d long long=%d unsigned long long=%d s4=%d u4=%d s8=%d u8=%d\", "
+	"sizeof(int), sizeof(unsigned), sizeof(unsigned int), sizeof(long), sizeof(unsigned long), "
+	"sizeof(long long), sizeof(unsigned long long), sizeof(REC->s4), "
+	"sizeof(REC->u4), sizeof(REC->s8), sizeof(REC->u8))\n";
+static char sizeof_data[] = {
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	/* common type */		23, 0x00,
+#else
+	/* common type */		0x00, 23
+#endif
+	/* common flags */		0x00,
+	/* common_preempt_count */	0x00,
+	/* common_pid */		0x00, 0x00, 0x00, 0x00,
+	/* irq */			0x00, 0x00, 0x00, 0x00,
+
+	/* s4 */			0x00, 0x00, 0x00, 0x00,
+	/* u4 */			0x00, 0x00, 0x00, 0x00,
+	/* s8 */			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	/* u8 */			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+static void *sizeof_event_data = (void *)sizeof_data;
+
 DECL_CPUMASK_EVENT_DATA(full, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff);
 #define CPUMASK_FULL     "ARRAY[ff, ff, ff, ff, ff, ff, ff, ff]"
 #define CPUMASK_FULL_FMT "cpumask=0-63"
@@ -288,6 +327,51 @@ static void test_parse_cpumask_bytepn(void)
 		      CPUMASK_BYTEPN, CPUMASK_BYTEPN_FMT);
 }
 
+static void test_parse_sizeof(int long_size, int value, const char *system,
+			      const char *test_str)
+{
+	struct tep_event *event;
+	struct tep_record record;
+	char *sizeof_event;
+	char *p;
+
+	tep_set_long_size(test_tep, long_size);
+
+	record.data = sizeof_event_data;
+	record.size = sizeof(sizeof_data);
+
+	sizeof_event = strdup(size_of_event);
+	CU_TEST(sizeof_event != NULL);
+
+	/* Set a new id */
+	p = strstr(sizeof_event, "ID: 2");
+	p[5] = '0' + value;
+
+	/* Handles endianess */
+	*(unsigned short *)sizeof_data = 20 + value;
+
+	CU_TEST(tep_parse_format(test_tep, &event, sizeof_event,
+				 strlen(sizeof_event),
+				 system) == TEP_ERRNO__SUCCESS);
+
+	trace_seq_reset(test_seq);
+	tep_print_event(test_tep, test_seq, &record, "%s", TEP_PRINT_INFO);
+	trace_seq_do_printf(test_seq);
+	CU_TEST(strcmp(test_seq->buffer, test_str) == 0);
+
+	free(sizeof_event);
+}
+
+static void test_parse_sizeof8(void)
+{
+	test_parse_sizeof(8, 3, "sizeof8", SIZEOF_LONG8_FMT);
+}
+
+static void test_parse_sizeof4(void)
+{
+	test_parse_sizeof(4, 4, "sizeof4", SIZEOF_LONG4_FMT);
+}
+
 static int test_suite_destroy(void)
 {
 	tep_free(test_tep);
@@ -330,4 +414,8 @@ void test_traceevent_lib(void)
 		    test_parse_cpumask_bytep2);
 	CU_add_test(suite, "parse cpumask spanning all bytes",
 		    test_parse_cpumask_bytepn);
+	CU_add_test(suite, "parse sizeof() 8byte values",
+		    test_parse_sizeof8);
+	CU_add_test(suite, "parse sizeof() 4byte values",
+		    test_parse_sizeof4);
 }
-- 
2.35.1

