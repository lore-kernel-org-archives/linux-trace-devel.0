Return-Path: <SRS0=hWWP=JT=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932668AbeGCQYd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Jul 2018 12:24:33 -0400
Message-Id: <20180703162432.177104690@goodmis.org>
Date: Tue, 03 Jul 2018 12:21:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 1/3] kernel-shark-qt: Move declarations to top in datafilter.c example
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The C style for trace-cmd and KernelShark is to follow the Linux kernel
where all declarations are done at a top of a C block and not intermingled
in the code.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark-qt/examples/datafilter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/examples/datafilter.c
index f8048bf62d32..13b088ebdc20 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -18,6 +18,8 @@ int main(int argc, char **argv)
 	size_t i, n_rows, n_tasks, n_evts, count;
 	struct kshark_context *kshark_ctx;
 	struct kshark_entry **data = NULL;
+	struct event_filter *adv_filter;
+	struct event_format *event;
 	char *entry_str;
 	bool status;
 	int *pids;
@@ -81,7 +83,6 @@ int main(int argc, char **argv)
 	puts("\n\n");
 
 	/* Show only "sched" events. */
-	struct event_format *event;
 	n_evts = kshark_ctx->pevent->nr_events;
 	for (i = 0; i < n_evts; ++i) {
 		event = kshark_ctx->pevent->events[i];
@@ -115,7 +116,7 @@ int main(int argc, char **argv)
 	kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
 
 	/* Use the Advanced filter to do event content based filtering. */
-	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
+	adv_filter = kshark_ctx->advanced_event_filter;
 	pevent_filter_add_filter_str(adv_filter,
 				     "sched/sched_wakeup:target_cpu==1");
 
-- 
2.17.1
