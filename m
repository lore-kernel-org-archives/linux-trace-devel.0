Return-Path: <SRS0=8H7y=JS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55763 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752355AbeGBOFP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Jul 2018 10:05:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id v16-v6so9217912wmv.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Jul 2018 07:05:14 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 9/9] kernel-shark-qt: Add example of advanded filtering
Date: Mon,  2 Jul 2018 17:04:24 +0300
Message-Id: <20180702140424.23221-9-y.karadz@gmail.com>
In-Reply-To: <20180702140424.23221-1-y.karadz@gmail.com>
References: <20180702140424.23221-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The filtering example is extended and now demonstrates filtering
based on the content of the event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/datafilter.c | 29 +++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/examples/datafilter.c
index e2039ca..f8048bf 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -108,6 +108,35 @@ int main(int argc, char **argv)
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
