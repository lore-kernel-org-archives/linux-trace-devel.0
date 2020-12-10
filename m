Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E75CC4167B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E2323C44
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgLJCbH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgLJCbG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 21:31:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADF1E23C82;
        Thu, 10 Dec 2020 02:29:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knBiB-0004AJ-LX; Wed, 09 Dec 2020 21:29:43 -0500
Message-ID: <20201210022943.538427964@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 09 Dec 2020 21:29:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>
Subject: [PATCH 5/9] libtracefs: Extend tracefs_iterate_raw_events() to iterate per CPU
References: <20201210022906.112066412@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir (VMware) Stoyanov" <tz.stoyanov@gmail.com>

There are some use cases where only raw events from particular CPUs
should be iterated. An additional parameter is added to this API which
allows only trace buffers for specified CPUs to be iterated.

Link: https://lore.kernel.org/linux-trace-devel/20201204084739.555327-1-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
[ Ported to work with trace-cmd ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs/tracefs.h    | 2 ++
 lib/tracefs/tracefs-events.c | 6 ++++++
 tracecmd/trace-record.c      | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 3358e33d9f11..ce8b09ca5bd0 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -6,6 +6,7 @@
 #ifndef _TRACE_FS_H
 #define _TRACE_FS_H
 
+#include <sched.h>
 #include "traceevent/event-parse.h"
 
 char *tracefs_get_tracing_file(const char *name);
@@ -44,6 +45,7 @@ char **tracefs_event_systems(const char *tracing_dir);
 char **tracefs_system_events(const char *tracing_dir, const char *system);
 int tracefs_iterate_raw_events(struct tep_handle *tep,
 				struct tracefs_instance *instance,
+				cpu_set_t *cpus, int cpu_size,
 				int (*callback)(struct tep_event *,
 						struct tep_record *,
 						int, void *),
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index a4e5215f8971..ba640a9e162c 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -116,6 +116,9 @@ get_events_in_page(struct tep_handle *tep, void *page,
  *				per CPU trace buffers
  * @tep: a handle to the trace event parser context
  * @instance: ftrace instance, can be NULL for the top instance
+ * @cpus: Iterate only through the buffers of CPUs, set in the mask.
+ *	  If NULL, iterate through all CPUs.
+ * @cpu_size: size of @cpus set
  * @callback: A user function, called for each record from the file
  * @callback_context: A custom context, passed to the user callback function
  *
@@ -126,6 +129,7 @@ get_events_in_page(struct tep_handle *tep, void *page,
  */
 int tracefs_iterate_raw_events(struct tep_handle *tep,
 				struct tracefs_instance *instance,
+				cpu_set_t *cpus, int cpu_size,
 				int (*callback)(struct tep_event *,
 						struct tep_record *,
 						int, void *),
@@ -166,6 +170,8 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 		if (strlen(name) < 4 || strncmp(name, "cpu", 3) != 0)
 			continue;
 		cpu = atoi(name + 3);
+		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
+			continue;
 		sprintf(file, "%s/%s", path, name);
 		ret = stat(file, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode))
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3a63f1bdda97..f8baed7dcd47 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4585,7 +4585,7 @@ static unsigned long long find_time_stamp(struct tep_handle *tep)
 {
 	unsigned long long ts = 0;
 
-	if (!tracefs_iterate_raw_events(tep, NULL, find_ts, &ts))
+	if (!tracefs_iterate_raw_events(tep, NULL, NULL, 0, find_ts, &ts))
 		return ts;
 
 	return 0;
-- 
2.29.2


