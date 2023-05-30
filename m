Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C57C7EE2F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 06:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjE3G4e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 02:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjE3G4d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 02:56:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C49B2
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 23:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AED961E61
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 06:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B93AC433D2
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 06:56:30 +0000 (UTC)
Date:   Tue, 30 May 2023 02:56:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs/utest: Fix crashing of synth test when synths
 exist
Message-ID: <20230530025627.19df3714@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If a synthetic event already exists when running the synthetic event test,
it does a SEGFAULT. This is because the sevents passed into
test_synth_compare() is dependent on the devents size. If there's
already a synthetic event, devents will be bigger than sevents, and the
sevents will read out of bounds. Check for devents to be the same size as
sevents before calling test_synth_compare()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 0f4075679ec4..3d88d927e320 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1047,6 +1047,12 @@ static void test_instance_synthetic(struct tracefs_instance *instance)
 
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_SYNTH, sevents_count);
 	CU_TEST(devents != NULL);
+	if (!devents)
+		goto out;
+	CU_TEST(devents[sevents_count] == NULL);
+	if (devents[sevents_count])
+		goto out;
+
 	test_synth_compare(sevents, devents);
 	tracefs_dynevent_list_free(devents);
 
@@ -1057,6 +1063,7 @@ static void test_instance_synthetic(struct tracefs_instance *instance)
 
 	get_dynevents_check(TRACEFS_DYNEVENT_SYNTH, 0);
 
+ out:
 	for (i = 0; i < sevents_count; i++)
 		tracefs_synth_free(synth[i]);
 
-- 
2.39.2

