Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076BFC25B0C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240810AbiHEPku (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240710AbiHEPkr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4C21A82D
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37066B8295E
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE943C433B5;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRJ-008S4P-30;
        Fri, 05 Aug 2022 11:40:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/9] tracecmd library: Add tracecmd_iterate_events()
Date:   Fri,  5 Aug 2022 11:40:33 -0400
Message-Id: <20220805154040.2014381-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154040.2014381-1-rostedt@goodmis.org>
References: <20220805154040.2014381-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a helper function that will iterate over a list of events for a given
handle. Requires the handle to be opened and ready for reading.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h |  7 ++++
 lib/trace-cmd/trace-input.c   | 70 +++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 5d71e8bab186..b91235751d64 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -48,6 +48,13 @@ int tracecmd_buffer_instances(struct tracecmd_input *handle);
 const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
 
+int tracecmd_iterate_events(struct tracecmd_input *handle,
+			    cpu_set_t *cpus, int cpu_size,
+			    int (*callback)(struct tracecmd_input *handle,
+					    struct tep_record *,
+					    int, void *),
+			    void *callback_data);
+
 void tracecmd_set_loglevel(enum tep_loglevel level);
 
 #endif /* _TRACE_CMD_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0fef2ca7bb70..e990600ad6b1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2511,6 +2511,76 @@ tracecmd_read_next_data(struct tracecmd_input *handle, int *rec_cpu)
 	return tracecmd_read_data(handle, next_cpu);
 }
 
+/**
+ * tracecmd_iterate_events - iterate events over a given handle
+ * @handle: The handle to iterate over
+ * @cpus: The CPU set to filter on (NULL for all CPUs)
+ * @cpu_size: The size of @cpus (ignored if @cpus is NULL)
+ * @callback: The callback function for each event
+ * @callback_data: The data to pass to the @callback.
+ *
+ * Will loop over all events in @handle (filtered by the given @cpus),
+ * and will call @callback for each event in order of the event's records
+ * timestamp.
+ *
+ * Returns the -1 on error, or the value of the callbacks.
+ */
+int tracecmd_iterate_events(struct tracecmd_input *handle,
+			    cpu_set_t *cpus, int cpu_size,
+			    int (*callback)(struct tracecmd_input *handle,
+					    struct tep_record *,
+					    int, void *),
+			    void *callback_data)
+{
+	struct tep_record **records;
+	struct tep_record *record;
+	unsigned long long last_timestamp = 0;
+	int next_cpu;
+	int cpu;
+	int ret = 0;
+
+	records = calloc(handle->max_cpu, sizeof(*records));
+	if (!records)
+		return -1;
+
+	for (cpu = 0; cpu < handle->max_cpu; cpu++) {
+		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
+			continue;
+
+		records[cpu] = tracecmd_peek_data(handle, cpu);
+	}
+
+	do {
+		next_cpu = -1;
+		for (cpu = 0; cpu < handle->max_cpu; cpu++) {
+			record = records[cpu];
+			if (!record)
+				continue;
+
+			if (next_cpu < 0 || record->ts < last_timestamp) {
+				next_cpu = cpu;
+				last_timestamp = record->ts;
+			}
+		}
+		if (next_cpu >= 0) {
+			/* Need to call read_data to increment to the next record */
+			record = tracecmd_read_data(handle, next_cpu);
+			records[next_cpu] = tracecmd_peek_data(handle, next_cpu);
+
+			ret = callback(handle, record, next_cpu, callback_data);
+			tracecmd_free_record(record);
+		}
+
+	} while (next_cpu >= 0 && ret >= 0);
+
+	for (cpu = 0; cpu < handle->max_cpu; cpu++)
+		tracecmd_free_record(records[cpu]);
+
+	free(records);
+
+	return ret;
+}
+
 /**
  * tracecmd_peek_next_data - return the next record
  * @handle: input handle to the trace.dat file
-- 
2.35.1

