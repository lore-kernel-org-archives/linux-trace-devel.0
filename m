Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5174C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241042AbhLPVkA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbhLPVj7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:39:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08E0C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 13:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E1DE61F98
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF38BC36AE7;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dZ-TC;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 07/10] libraceevent: Add unit test to test print_fmt with dynamic strings
Date:   Thu, 16 Dec 2021 16:39:53 -0500
Message-Id: <20211216213956.13934-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a unit test that calls tep_print_event() with the TEP_PRINT_INFO with
an event that has dynamic strings (with both the old and new formats).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 utest/traceevent-utest.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index f4fdc86664ca..a0d808e5c1a5 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -26,6 +26,7 @@
 #define DYN_STR_EVENT_SYSTEM		"irq"
 #define DYN_STR_FIELD			"name"
 #define DYN_STRING			"hello"
+#define DYN_STRING_FMT			"irq=0 handler=hello"
 static const char dyn_str_event[] =
 	"name: irq_handler_entry\n"
 	"ID: 1\n"
@@ -107,6 +108,9 @@ static void parse_dyn_str(const char *dyn_str, void *data)
 {
 	struct tep_format_field *field;
 	struct tep_event *event;
+	struct tep_record record;
+
+	record.data = data;
 
 	CU_TEST(tep_parse_format(test_tep, &event,
 				 dyn_str, strlen(dyn_str),
@@ -117,6 +121,11 @@ static void parse_dyn_str(const char *dyn_str, void *data)
 	trace_seq_reset(test_seq);
 	tep_print_field(test_seq, data, field);
 	CU_TEST(strcmp(test_seq->buffer, DYN_STRING) == 0);
+
+	trace_seq_reset(test_seq);
+	tep_print_event(test_tep, test_seq, &record, "%s", TEP_PRINT_INFO);
+	trace_seq_do_printf(test_seq);
+	CU_TEST(strcmp(test_seq->buffer, DYN_STRING_FMT) == 0);
 }
 
 static void test_parse_dyn_str_event(void)
-- 
2.33.0

