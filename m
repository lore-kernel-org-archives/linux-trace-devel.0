Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4EDC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Nov 2022 16:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiKPQ5S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 11:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiKPQ4q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 11:56:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741CD7670
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 08:56:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1004161EF5
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 16:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35681C433C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 16:56:36 +0000 (UTC)
Date:   Wed, 16 Nov 2022 11:57:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix tracefs_iterate_raw_events() to handle NULL
 callback
Message-ID: <20221116115720.6badba48@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that tracefs_follow_event() and tracefs_follow_missed_events() exists,
it is no longer necessary to pass in a callback to
tracefs_iterate_raw_events(). Do not fail that function if callback is
NULL and there exists followers.

Fixes: 8da05d9697ab ("libtracefs: Add tracefs_follow_event() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index daa81c07ecb5..c2adf415342e 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -266,7 +266,8 @@ static int read_cpu_pages(struct tep_handle *tep, struct tracefs_instance *insta
 		if (j < count) {
 			if (call_followers(instance, cpus[j].event, &cpus[j].record, cpus[j].cpu))
 				break;
-			if (callback(cpus[j].event, &cpus[j].record, cpus[j].cpu, callback_context))
+			if (callback &&
+			    callback(cpus[j].event, &cpus[j].record, cpus[j].cpu, callback_context))
 				break;
 			cpus[j].event = NULL;
 			read_next_record(tep, cpus + j);
@@ -420,6 +421,7 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 {
 	bool *keep_going = instance ? &instance->iterate_keep_going :
 				      &top_iterate_keep_going;
+	struct follow_event *followers;
 	struct cpu_iterate *all_cpus;
 	int count = 0;
 	int ret;
@@ -427,7 +429,14 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 
 	(*(volatile bool *)keep_going) = true;
 
-	if (!tep || !callback)
+	if (!tep)
+		return -1;
+
+	if (instance)
+		followers = instance->followers;
+	else
+		followers = root_followers;
+	if (!callback && !followers)
 		return -1;
 
 	ret = open_cpu_files(instance, cpus, cpu_size, &all_cpus, &count);
-- 
2.35.1

