Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80629C7EE23
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Jun 2023 00:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjFFAzS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 20:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjFFAzS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 20:55:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEA1102
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Jun 2023 17:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 085C862030
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 00:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213A9C433EF
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 00:55:15 +0000 (UTC)
Date:   Mon, 5 Jun 2023 20:55:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] libtracefs tests: Add helper function to destroy dynamic
 events
Message-ID: <20230605205514.7ea9293c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Create a helper function in the test code called destroy_dynevent() that
takes the type of event and performs:

	ret = tracefs_dynevent_destroy_all(type, true);
	CU_TEST(ret == 0);
	get_dynevents_check(type, 0);

Instead of open coding those three lines over and over again.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20230605205000.1f478c26@gandalf.local.home/

 - Remove accidental addition of tracefs_kprobe_destroy() addition

 utest/tracefs-utest.c | 30 ++++++++++++++----------------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 3d88d927e320..cd2304474089 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1006,6 +1006,15 @@ static void test_synth_compare(struct test_synth *sevents, struct tracefs_dyneve
 	CU_TEST(devents == NULL || devents[i] == NULL);
 }
 
+static void destroy_dynevents(unsigned int type)
+{
+	int ret;
+
+	ret = tracefs_dynevent_destroy_all(type, true);
+	CU_TEST(ret == 0);
+	get_dynevents_check(type, 0);
+}
+
 static void test_instance_synthetic(struct tracefs_instance *instance)
 {
 	struct test_synth sevents[] = {
@@ -1025,9 +1034,7 @@ static void test_instance_synthetic(struct tracefs_instance *instance)
 	CU_TEST(tep != NULL);
 
 	/* kprobes APIs */
-	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_SYNTH, true);
-	CU_TEST(ret == 0);
-	get_dynevents_check(TRACEFS_DYNEVENT_SYNTH, 0);
+	destroy_dynevents(TRACEFS_DYNEVENT_SYNTH);
 
 	for (i = 0; i < sevents_count; i++) {
 		synth[i] = tracefs_synth_alloc(tep,  sevents[i].name,
@@ -1260,9 +1267,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	CU_TEST(tracefs_kretprobe_raw("test", "test", NULL, "test") != 0);
 
 	/* kprobes APIs */
-	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
-	CU_TEST(ret == 0);
-	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
+	destroy_dynevents(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE);
 
 	for (i = 0; i < kprobe_count; i++) {
 		dkprobe[i] = tracefs_kprobe_alloc(ktests[i].system, ktests[i].event,
@@ -1327,9 +1332,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 		tracefs_dynevent_free(dkretprobe[i]);
 
 	/* kprobes raw APIs */
-	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
-	CU_TEST(ret == 0);
-	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
+	destroy_dynevents(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE);
 
 	for (i = 0; i < kprobe_count; i++) {
 		ret = tracefs_kprobe_raw(ktests[i].system, ktests[i].event,
@@ -1365,9 +1368,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
-	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
-	CU_TEST(ret == 0);
-	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
+	destroy_dynevents(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE);
 	free(dkretprobe);
 	free(dkprobe);
 	tep_free(tep);
@@ -1392,7 +1393,6 @@ static void test_eprobes_instance(struct tracefs_instance *instance)
 	struct tep_handle *tep;
 	char *tsys, *tevent;
 	char *tmp, *sav;
-	int ret;
 	int i;
 
 	tep = tep_alloc();
@@ -1405,9 +1405,7 @@ static void test_eprobes_instance(struct tracefs_instance *instance)
 	CU_TEST(tracefs_eprobe_alloc("test", "test", NULL, "test", "test") == NULL);
 	CU_TEST(tracefs_eprobe_alloc("test", "test", "test", NULL, "test") == NULL);
 
-	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
-	CU_TEST(ret == 0);
-	get_dynevents_check(TRACEFS_DYNEVENT_EPROBE, 0);
+	destroy_dynevents(TRACEFS_DYNEVENT_EPROBE);
 
 	for (i = 0; i < count; i++) {
 		tmp = strdup(etests[i].address);
-- 
2.39.2

