Return-Path: <SRS0=5iTX=JO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46866 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753356AbeF1QbS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jun 2018 12:31:18 -0400
Received: by mail-wr0-f196.google.com with SMTP id t6-v6so6129410wrq.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Jun 2018 09:31:17 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 9/9] kernel-shark-qt: Add example of advanded filtering
Date: Thu, 28 Jun 2018 19:30:12 +0300
Message-Id: <20180628163012.21477-10-y.karadz@gmail.com>
In-Reply-To: <20180628163012.21477-1-y.karadz@gmail.com>
References: <20180628163012.21477-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The filtering example is extended and now demonstrates filtering
based on the content of the event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/datafilter.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/examples/datafilter.c
index e766f3d..cbb6ec9 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -107,6 +107,31 @@ int main(int argc, char **argv)
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
+	pevent_filter_add_filter_str(adv_filter, "sched/sched_wakeup:target_cpu==1");
+
+	/* The Advanced filter requires reloading the data. */
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
