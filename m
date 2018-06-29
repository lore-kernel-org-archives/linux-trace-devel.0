Return-Path: <SRS0=62yJ=JP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:40845 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935222AbeF2P0l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jun 2018 11:26:41 -0400
Received: by mail-wr0-f194.google.com with SMTP id l2-v6so8655457wro.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jun 2018 08:26:41 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 9/9] kernel-shark-qt: Add example of advanded filtering
Date: Fri, 29 Jun 2018 18:25:41 +0300
Message-Id: <20180629152541.10109-10-y.karadz@gmail.com>
In-Reply-To: <20180629152541.10109-1-y.karadz@gmail.com>
References: <20180629152541.10109-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The filtering example is extended and now demonstrates filtering
based on the content of the event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/datafilter.c | 29 +++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/examples/datafilter.c
index 70f814a..3d09360 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -107,6 +107,35 @@ int main(int argc, char **argv)
 		++i;
 	}
 
+	puts("\n\n");
+
+	/* Clear all filters. */
+	kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
+	kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
+
+	/* Use the Advanced filter to do event content based filtering. */
+	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
+	pevent_filter_add_filter_str(adv_filter,
+				     "sched/sched_wakeup:target_cpu==1");
+
+	/* The Advanced filter requires reloading the data. */
+	for (i = 0; i < n_rows; ++i)
+		free(data[i]);
+
+	n_rows = kshark_load_data_entries(kshark_ctx, &data);
+
+	count = 0;
+	for (i = 0; i < n_rows; ++i) {
+		if (data[i]->visible & KS_EVENT_VIEW_FILTER_MASK) {
+			entry_str = kshark_dump_entry(data[i]);
+			puts(entry_str);
+			free(entry_str);
+
+			if(++count > 10)
+				break;
+		}
+	}
+
 	/* Free the memory. */
 	for (i = 0; i < n_rows; ++i)
 		free(data[i]);
-- 
2.17.1
