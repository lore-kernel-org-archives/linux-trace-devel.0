Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B821AC7EE23
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 06:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjE3GVU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 02:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjE3GVS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 02:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65F5BF
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 23:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AAB560F6D
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 06:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4A2C433D2
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 06:21:14 +0000 (UTC)
Date:   Tue, 30 May 2023 02:21:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs/utest: Do not use synth for test_synth element
Message-ID: <20230530022111.25bd25de@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The test_synth_compare() function is confusing as it uses "synth" for the
test_synth structure. "synth" should only be used for tracefs_synth
descriptors. Rename it to "sevents" to match the variable of the calling
function.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 9cfafdbd039c..0f4075679ec4 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -983,7 +983,7 @@ struct test_synth {
 	char *match_name;
 };
 
-static void test_synth_compare(struct test_synth *synth, struct tracefs_dynevent **devents)
+static void test_synth_compare(struct test_synth *sevents, struct tracefs_dynevent **devents)
 {
 	enum tracefs_dynevent_type stype;
 	char *format;
@@ -996,9 +996,9 @@ static void test_synth_compare(struct test_synth *synth, struct tracefs_dynevent
 		CU_TEST(stype == TRACEFS_DYNEVENT_SYNTH);
 		if (stype != TRACEFS_DYNEVENT_SYNTH)
 			continue;
-		CU_TEST(event && synth[i].name && strcmp(event, synth[i].name) == 0);
-		if (synth[i].match_name) {
-			CU_TEST(strstr(format, synth[i].match_name) != NULL);
+		CU_TEST(event && sevents[i].name && strcmp(event, sevents[i].name) == 0);
+		if (sevents[i].match_name) {
+			CU_TEST(strstr(format, sevents[i].match_name) != NULL);
 		}
 		free(event);
 		free(format);
-- 
2.39.2

