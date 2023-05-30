Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF47C77B73
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 04:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjE3EUN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 00:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjE3EUC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 00:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAC2FF
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 21:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A1160ED6
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 04:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBACC433EF;
        Tue, 30 May 2023 04:19:54 +0000 (UTC)
Date:   Tue, 30 May 2023 00:19:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] libtracefs: Do not use hwlat tracer and fdb_delete event
 for tests
Message-ID: <20230530001951.2070c879@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_reset() test required the hwlat tracer and the fdb_delete event to
exist on the system to succeed. But that trace and event are uncommon, and will
cause a failure when they are not part of the system. Instead, pick the first
tracer returned by tracefs_tracers() and also the "sched_switch" event as that
will make the test more robust with different kernel configs.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 47f65cbaa4fe..47fc9570a473 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1768,6 +1768,7 @@ static void test_instance_reset(void)
 {
 	struct tracefs_instance *instance = NULL;
 	const char *name = get_rand_str();
+	char **tracers;
 
 	CU_TEST(tracefs_instance_exists(name) == false);
 	instance = tracefs_instance_create(name);
@@ -1775,8 +1776,13 @@ static void test_instance_reset(void)
 
 	CU_TEST(test_instance_check_default_state(instance) == true);
 
-	CU_TEST(tracefs_tracer_set(instance, TRACEFS_TRACER_HWLAT) == 0);
-	CU_TEST(tracefs_event_enable(instance, "bridge", "fdb_delete") == 0);
+	tracers = tracefs_tracers(NULL);
+	CU_TEST(tracers != NULL);
+	if (tracers) {
+		CU_TEST(tracefs_tracer_set(instance, TRACEFS_TRACER_CUSTOM, tracers[0]) == 0);
+		tracefs_list_free(tracers);
+	}
+	CU_TEST(tracefs_event_enable(instance, "sched", "sched_switch") == 0);
 	CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_pid", "5") > 0);
 	CU_TEST(tracefs_instance_file_write(instance, "trace_clock", "global") > 0);
 	CU_TEST(tracefs_instance_file_write(instance, "set_event_pid", "5") > 0);
@@ -1785,9 +1791,9 @@ static void test_instance_reset(void)
 	CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_notrace",
 						      "schedule:stacktrace") > 0);
 	CU_TEST(tracefs_instance_file_write(instance, "tracing_cpumask", "0f") > 0);
-	CU_TEST(tracefs_instance_file_write(instance, "events/syscalls/sys_exit_read/trigger",
+	CU_TEST(tracefs_event_file_write(instance, "syscalls", "sys_exit_read", "trigger",
 						      "enable_event:kmem:kmalloc:1") > 0);
-	CU_TEST(tracefs_instance_file_write(instance, "events/bridge/fdb_delete/filter",
+	CU_TEST(tracefs_event_file_write(instance, "sched", "sched_switch", "filter",
 						      "common_pid == 5") > 0);
 
 	CU_TEST(test_instance_check_default_state(instance) == false);
-- 
2.39.2

