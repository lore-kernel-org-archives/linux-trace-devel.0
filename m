Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2C3C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Dec 2022 14:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238441AbiLNOgy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Dec 2022 09:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbiLNOgx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Dec 2022 09:36:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90BDB7ED
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 06:36:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44A0B6179A
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 14:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75970C433D2
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 14:36:51 +0000 (UTC)
Date:   Wed, 14 Dec 2022 09:36:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Fail to parse if sizeof(long) is used and
 long size is not defined
Message-ID: <20221214093649.5a8e43af@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the tep handle has not defined a long size yet, then fail to parse
sizeof(long) instead of giving a wrong answer.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c        | 11 +++++++++--
 utest/traceevent-utest.c |  8 ++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index aaa06b336efe..65937675a67f 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3544,10 +3544,17 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		if (token && strcmp(token, "long") == 0) {
 			arg->atom.atom = strdup("8");
 		} else {
-			if (event->tep->long_size == 4)
+			switch (event->tep->long_size) {
+			case 4:
 				arg->atom.atom = strdup("4");
-			else
+				break;
+			case 8:
 				arg->atom.atom = strdup("8");
+				break;
+			default:
+				/* long size not defined yet, fail to parse it */
+				goto error;
+			}
 			/* The token is the next token */
 			ok = true;
 		}
diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 954a592d5c3c..ebd5eb93efc2 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -140,6 +140,7 @@ static char cpumask_##name##_event_data[] = {                       \
 }
 #endif
 
+#define SIZEOF_LONG0_FMT "[FAILED TO PARSE] s4=0 u4=0 s8=0 u8=0x0"
 #define SIZEOF_LONG4_FMT "int=4 unsigned=4 unsigned int=4 long=4 unsigned long=4 long long=8 unsigned long long=8 s4=4 u4=4 s8=8 u8=8"
 #define SIZEOF_LONG8_FMT "int=4 unsigned=4 unsigned int=4 long=8 unsigned long=8 long long=8 unsigned long long=8 s4=4 u4=4 s8=8 u8=8"
 
@@ -372,6 +373,11 @@ static void test_parse_sizeof4(void)
 	test_parse_sizeof(4, 4, "sizeof4", SIZEOF_LONG4_FMT);
 }
 
+static void test_parse_sizeof_undef(void)
+{
+	test_parse_sizeof(0, 5, "sizeof_undef", SIZEOF_LONG0_FMT);
+}
+
 static int test_suite_destroy(void)
 {
 	tep_free(test_tep);
@@ -418,4 +424,6 @@ void test_traceevent_lib(void)
 		    test_parse_sizeof8);
 	CU_add_test(suite, "parse sizeof() 4byte values",
 		    test_parse_sizeof4);
+	CU_add_test(suite, "parse sizeof() no long size defined",
+		    test_parse_sizeof_undef);
 }
-- 
2.35.1

