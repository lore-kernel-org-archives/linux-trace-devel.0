Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D4FC3F6B0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbiHEPku (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240721AbiHEPks (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9E025597
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A057B82961
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C34C4347C;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRJ-008S4V-39;
        Fri, 05 Aug 2022 11:40:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/9] tracecmd library: Add tracecmd_iterate_events_multi()
Date:   Fri,  5 Aug 2022 11:40:35 -0400
Message-Id: <20220805154040.2014381-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154040.2014381-1-rostedt@goodmis.org>
References: <20220805154040.2014381-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a helper function that takes an array of tracecmd_input handles and
calls the callback for each event in order of the record's timestamp for
each handle.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h |  6 +++
 lib/trace-cmd/trace-input.c   | 91 +++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index b91235751d64..86a3486972cc 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -54,6 +54,12 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 					    struct tep_record *,
 					    int, void *),
 			    void *callback_data);
+int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
+				  int nr_handles,
+				  int (*callback)(struct tracecmd_input *handle,
+						  struct tep_record *,
+						  int, void *),
+				  void *callback_data);
 
 void tracecmd_set_loglevel(enum tep_loglevel level);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e990600ad6b1..5df10716013d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -170,6 +170,7 @@ struct tracecmd_input {
 	int			page_map_size;
 	int			max_cpu;
 	int			cpus;
+	int			start_cpu;
 	int			ref;
 	int			nr_buffers;	/* buffer instances */
 	bool			use_trace_clock;
@@ -2581,6 +2582,96 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 	return ret;
 }
 
+struct record_handle {
+	struct tep_record		*record;
+	struct tracecmd_input		*handle;
+};
+
+/**
+ * tracecmd_iterate_events_multi - iterate events over multiple handles
+ * @handles: An array of handles to iterate over
+ * @nr_handles: The number of handles in the @handles array.
+ * @callback: The callback function for each event
+ * @callback_data: The data to pass to the @callback.
+ *
+ * Will loop over all CPUs for each handle in @handles and call the
+ * @callback in the order of the timestamp for each event's record
+ * for each handle.
+ *
+ * Returns the -1 on error, or the value of the callbacks.
+ */
+int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
+				  int nr_handles,
+				  int (*callback)(struct tracecmd_input *handle,
+						  struct tep_record *,
+						  int, void *),
+				  void *callback_data)
+{
+	struct tracecmd_input *handle;
+	struct record_handle *records;
+	struct tep_record *record;
+	unsigned long long last_timestamp = 0;
+	int next_cpu;
+	int cpus = 0;
+	int all_cpus = 0;
+	int cpu;
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < nr_handles; i++) {
+		handle = handles[i];
+		cpus += handle->max_cpu;
+	}
+
+	records = calloc(cpus, sizeof(*records));
+	if (!records)
+		return -1;
+
+	for (i = 0; i < nr_handles; i++) {
+		handle = handles[i];
+		handle->start_cpu = all_cpus;
+		for (cpu = 0; cpu < handle->max_cpu; cpu++) {
+			records[all_cpus + cpu].record = tracecmd_peek_data(handle, cpu);
+			records[all_cpus + cpu].handle = handle;
+		}
+		all_cpus += cpu;
+	}
+
+	do {
+		next_cpu = -1;
+		for (cpu = 0; cpu < all_cpus; cpu++) {
+			record = records[cpu].record;
+			if (!record)
+				continue;
+
+			if (next_cpu < 0 || record->ts < last_timestamp) {
+				next_cpu = cpu;
+				last_timestamp = record->ts;
+			}
+		}
+		if (next_cpu >= 0) {
+			record = records[next_cpu].record;
+			handle = records[next_cpu].handle;
+			cpu = next_cpu - handle->start_cpu;
+			/* Need to call read_data to increment to the next record */
+			record = tracecmd_read_data(handle, cpu);
+			records[next_cpu].record = tracecmd_peek_data(handle, cpu);
+
+			ret = callback(handle, record, cpu, callback_data);
+			tracecmd_free_record(record);
+		}
+
+	} while (next_cpu >= 0 && ret >= 0);
+
+	/*
+	 * The records array contains only records that were taken via
+	 * tracecmd_peek_data(), and do not need to be freed.
+	 */
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

