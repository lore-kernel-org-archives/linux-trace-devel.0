Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34ABC43334
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Jul 2022 14:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbiGWOX2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 23 Jul 2022 10:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbiGWOXN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 23 Jul 2022 10:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C415122B0E
        for <linux-trace-devel@vger.kernel.org>; Sat, 23 Jul 2022 07:22:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B73EB801B9
        for <linux-trace-devel@vger.kernel.org>; Sat, 23 Jul 2022 14:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE937C341C0
        for <linux-trace-devel@vger.kernel.org>; Sat, 23 Jul 2022 14:22:34 +0000 (UTC)
Date:   Sat, 23 Jul 2022 10:22:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Set the number of CPUs in
 tracefs_local_events_system()
Message-ID: <20220723102232.1ba19aa6@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When tracefs_local_events() (which also uses tracefs_local_events_system())
is called, it does not set the CPU count for the tep handler. It should do
so, so make that happen.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
This is added on top of:
     https://lore.kernel.org/all/20220722142803.24919c8a@gandalf.local.home/

 src/tracefs-events.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 86395101c96a..9dbeeac938b4 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -945,6 +945,33 @@ out:
 	return ret;
 }
 
+static void set_tep_cpus(const char *tracing_dir, struct tep_handle *tep)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	int cpus = sysconf(_SC_NPROCESSORS_CONF);
+	int max_cpu = 0;
+	int ret;
+	int i;
+
+	if (!tracing_dir)
+		tracing_dir = tracefs_tracing_dir();
+
+	for (i = 0; !cpus || i < cpus; i++) {
+		snprintf(path, PATH_MAX, "%s/per_cpu/cpu%d", tracing_dir, i);
+		ret = stat(path, &st);
+		if (!ret && S_ISDIR(st.st_mode))
+			max_cpu = i + 1;
+		else if (i >= cpus)
+			break;
+	}
+
+	if (!max_cpu)
+		max_cpu = cpus;
+
+	tep_set_cpus(tep, max_cpu);
+}
+
 /**
  * tracefs_local_events_system - create a tep from the events of the specified subsystem.
  *
@@ -969,6 +996,8 @@ struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
 		tep = NULL;
 	}
 
+	set_tep_cpus(tracing_dir, tep);
+
 	/* Set the long size for this tep handle */
 	tep_set_long_size(tep, tep_get_header_page_size(tep));
 
-- 
2.35.1

