Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AD8EB64D7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Jun 2023 20:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344428AbjFPUC6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Jun 2023 16:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345861AbjFPUCw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Jun 2023 16:02:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB583AB8
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Jun 2023 13:02:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C61632A3
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Jun 2023 20:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE37C433C0
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Jun 2023 20:02:31 +0000 (UTC)
Date:   Fri, 16 Jun 2023 16:02:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] trace-cmd library: Add tracecmd_iterate_events_reverse()
 API
Message-ID: <20230616160228.4c9f97d8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add an iterator that starts at the end of a trace.dat file and iterates
the events backward in time. That is, the first event will be the last
event in the file, followed by the previous event, etc. This is useful for
looking into what caused an event.

A flag is also added to continue where it last left off, as the end of the
file is not a normal location, it doesn't make sense to have it start
where it last left off like tracecmd_iterate_events() does.

The use case that inspired this change is to analyze cyclictest latency.
First the print of the failed threshold must be found, which is at the end
of the trace. Then the event of the wake up before the failed trace has to
be found, and so on. Having a way to iterate backward is helpful in this
case.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20230615152345.3ff2be25@gandalf.local.home/T/#u

  - Honor the cpuset if it is passed in (it was ignoring it).

 .../libtracecmd/libtracecmd-iterate.txt       |  29 ++-
 Documentation/libtracecmd/libtracecmd.txt     |   6 +
 include/trace-cmd/trace-cmd.h                 |   6 +
 lib/trace-cmd/trace-input.c                   | 205 ++++++++++++++++++
 4 files changed, 241 insertions(+), 5 deletions(-)

diff --git a/Documentation/libtracecmd/libtracecmd-iterate.txt b/Documentation/libtracecmd/libtracecmd-iterate.txt
index 5c1eece0e463..12c54b2ce1a0 100644
--- a/Documentation/libtracecmd/libtracecmd-iterate.txt
+++ b/Documentation/libtracecmd/libtracecmd-iterate.txt
@@ -24,6 +24,12 @@ int *tracecmd_iterate_events_multi*(struct tracecmd_input pass:[**]_handles_,
 							   struct tep_record pass:[*],
 							   int, void pass:[*]),
 				  void pass:[*]_callback_data_);
+int *tracecmd_iterate_events_reverse*(struct tracecmd_input pass:[*]_handle_,
+			    cpu_set_t pass:[*]_cpus_, int _cpu_size_,
+			    int (pass:[*]_callback_)(struct tracecmd_input pass:[*],
+					    struct tep_record pass:[*],
+					    int, void pass:[*]),
+			    void pass:[*]_callback_data_, bool _cont_);
 int *tracecmd_follow_event*(struct tracecmd_input pass:[*]_handle_,
 			  const char pass:[*]_system_, const char pass:[*]_event_name_,
 			  int (pass:[*]_callback_)(struct tracecmd_input pass:[*],
@@ -71,7 +77,20 @@ as its last parameter.  _callback_ may be NULL, which is useful if *tracecmd_fol
 is used, but note if _callback_ is NULL, then _callback_data_ is ignored and not sent to the
 _callback_ of *tracecmd_follow_event()*.
 
-The _callback()_ for both *tracecmd_iterate_events()* and *tracecmd_iterate_events_multi()* is of the prototype:
+The function *tracecmd_iterate_events_reverse()* works pretty much the same way as
+*tracecmd_iterate_events()* works, but instead of calling the _callback_() function for
+each event in order of the timestamp, it will call the _callback_() function for
+each event in reverse order of the timestamp. If _cont_ is false, it will start by
+calling the event with the oldest timestamp in the trace.dat file. If _cont_ is set
+to true, then it will start whereever the current position of the tracing data is.
+For instance, if the _callback()_ return something other than zero it will exit the
+iteration. If *tracecmd_iterate_events_reverse()* is called again with _cont_ to true
+it will continue where it left off. If _cont_ is false, it will start again at the event
+with the oldest timestamp. The _handle_, _cpus_, _cpu_size_, and _callback_data_ act the
+same as *tracecmd_iterate_events()*.
+
+The _callback()_ for both *tracecmd_iterate_events()*, *tracecmd_iterate_events_reverse()*
+and *tracecmd_iterate_events_multi()* is of the prototype:
 
 int _callback()_(struct tracecmd_input pass:[*]_handle_, struct tep_record pass:[*]_record_,
 		 int _cpu_, void pass:[*]_data_);
@@ -123,10 +142,10 @@ the _callback()_ function in the iterators.
 
 RETURN VALUE
 ------------
-Both *tracecmd_iterate_events()* and *tracecmd_iterate_events_multi()* return zero
-if they successfully iterated all events (handling the follow and filters appropriately).
-Or an error value, which can include returning a non-zero result from the _callback()_
-function.
+Both *tracecmd_iterate_events()*, *tracecmd_iterate_events_reverse()* and
+*tracecmd_iterate_events_multi()* return zero if they successfully iterated all events
+(handling the follow and filters appropriately). Or an error value, which can include
+returning a non-zero result from the _callback()_ function.
 
 EXAMPLE
 -------
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index 6f1494fe57d3..bbe6cc78b575 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -40,6 +40,12 @@ Iterating over events in a trace file:
 								   struct tep_record pass:[*],
 							   int, void pass:[*]),
 					  void pass:[*]_callback_data_);
+	int *tracecmd_iterate_events_reverse*(struct tracecmd_input pass:[*]_handle_,
+				    cpu_set_t pass:[*]_cpus_, int _cpu_size_,
+				    int (pass:[*]_callback_)(struct tracecmd_input pass:[*],
+						    struct tep_record pass:[*],
+						    int, void pass:[*]),
+				    void pass:[*]_callback_data_, bool _cont_);
 	int *tracecmd_follow_event*(struct tracecmd_input pass:[*]_handle_,
 				  const char pass:[*]_system_, const char pass:[*]_event_name_,
 				  int (pass:[*]_callback_)(struct tracecmd_input pass:[*],
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 8b467fe514a9..e6527b7116c1 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -84,6 +84,12 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 						  struct tep_record *,
 						  int, void *),
 				  void *callback_data);
+int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
+				    cpu_set_t *cpus, int cpu_size,
+				    int (*callback)(struct tracecmd_input *handle,
+						    struct tep_record *,
+						    int, void *),
+				    void *callback_data, bool cont);
 
 void tracecmd_set_loglevel(enum tep_loglevel level);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5279f581439d..af51b3d71e1a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2836,6 +2836,211 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 	return ret;
 }
 
+static struct tep_record *
+load_records(struct tracecmd_input *handle, int cpu,
+	     unsigned long long page_offset, unsigned long long start_offset)
+{
+	struct tep_record *last_record = NULL;
+	struct tep_record *record;
+	unsigned long long page_end = page_offset + handle->page_size;
+
+	if (get_page(handle, cpu, page_offset) < 0)
+		return NULL;
+
+	update_page_info(handle, cpu);
+
+	if (start_offset)
+		page_end = start_offset + 1;
+
+	for (;;) {
+		record = tracecmd_read_data(handle, cpu);
+		if (!record || record->offset >= page_end) {
+			/* Make sure the cpu_data page is still valid */
+			get_page(handle, cpu, page_offset);
+			tracecmd_free_record(record);
+			break;
+		}
+		/*
+		 * Hijack the record->priv, as we know that it points
+		 * to handle->cpu_data[cpu].page, and use that as
+		 * a link list of all the records on this page going
+		 * backwards.
+		 */
+		record->priv = last_record;
+		last_record = record;
+	}
+
+	return last_record;
+}
+
+static void free_last_record(struct tracecmd_input *handle, struct tep_record *record,
+			     int cpu)
+{
+	record->priv = handle->cpu_data[cpu].page;
+	tracecmd_free_record(record);
+}
+
+static void free_last_records(struct tracecmd_input *handle, struct tep_record *records,
+			      int cpu)
+{
+	struct tep_record *last_record;
+
+	while (records) {
+		last_record = records;
+		records = last_record->priv;
+		free_last_record(handle, last_record, cpu);
+	}
+}
+
+static void initialize_last_events(struct tracecmd_input *handle,
+				   struct tep_record **last_records,
+				   cpu_set_t *cpu_set, int cpu_size,
+				   int cpus, bool cont)
+{
+	unsigned long long page_offset;
+	unsigned long long start_offset = 0;
+	struct tep_record *record;
+	int cpu;
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		if (cpu_set && !CPU_ISSET_S(cpu, cpu_size, cpu_set))
+			continue;
+
+		if (!handle->cpu_data[cpu].file_size)
+			continue;
+
+		if (cont) {
+			record = tracecmd_read_data(handle, cpu);
+			if (record)
+				page_offset = start_offset = record->offset;
+			tracecmd_free_record(record);
+		}
+
+		if (!start_offset) {
+			/* Find the start of the last page for this CPU */
+			page_offset = handle->cpu_data[cpu].file_offset +
+				handle->cpu_data[cpu].file_size;
+		}
+		page_offset = calc_page_offset(handle, page_offset - 1);
+
+		last_records[cpu] = load_records(handle, cpu, page_offset, start_offset);
+	}
+}
+
+static struct tep_record *peek_last_event(struct tracecmd_input *handle,
+					  struct tep_record **last_records, int cpu)
+{
+	struct tep_record *record = last_records[cpu];
+	struct page *page = handle->cpu_data[cpu].page;
+	unsigned long long page_offset;
+
+	if (record)
+		return record;
+
+	page_offset = page->offset - handle->page_size;
+	if (page_offset < handle->cpu_data[cpu].file_offset)
+		return NULL;
+
+	last_records[cpu] = load_records(handle, cpu, page_offset, 0);
+	return peek_last_event(handle, last_records, cpu);
+}
+
+static struct tep_record *next_last_event(struct tracecmd_input *handle,
+					  struct tep_record **last_records, int cpu)
+{
+	struct tep_record *record = last_records[cpu];
+	struct page *page = handle->cpu_data[cpu].page;
+
+	if (!record)
+		return NULL;
+
+	last_records[cpu] = record->priv;
+	record->priv = page;
+
+	return record;
+}
+
+/**
+ * tracecmd_iterate_events_reverse - iterate events over a given handle backwards
+ * @handle: The handle to iterate over
+ * @cpus: The CPU set to filter on (NULL for all CPUs)
+ * @cpu_size: The size of @cpus (ignored if @cpus is NULL)
+ * @callback: The callback function for each event
+ * @callback_data: The data to pass to the @callback.
+ * @cont: If true, start where it left off, otherwise start at the end.
+ *
+ * Will loop over all events in @handle (filtered by the given @cpus),
+ * and will call @callback for each event in reverse order.
+ *
+ * Returns the -1 on error, or the value of the callbacks.
+ */
+int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
+				    cpu_set_t *cpus, int cpu_size,
+				    int (*callback)(struct tracecmd_input *handle,
+						    struct tep_record *,
+						    int, void *),
+				    void *callback_data, bool cont)
+{
+	unsigned long long last_timestamp = 0;
+	struct tep_record **records;
+	struct tep_record *record;
+	int next_cpu;
+	int max_cpus = handle->max_cpu;
+	int cpu;
+	int ret = 0;
+
+	if (!callback && !handle->nr_followers) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	records = calloc(max_cpus, sizeof(*records));
+	if (!records)
+		return -1;
+
+	initialize_last_events(handle, records, cpus, cpu_size, max_cpus, cont);
+
+	do {
+		next_cpu = -1;
+		for (cpu = 0; cpu < max_cpus; cpu++) {
+			if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
+				continue;
+			record = peek_last_event(handle, records, cpu);
+			if (!record)
+				continue;
+
+			if (next_cpu < 0 || record->ts > last_timestamp) {
+				next_cpu = cpu;
+				last_timestamp = record->ts;
+			}
+		}
+		if (next_cpu >= 0) {
+			record = next_last_event(handle, records, next_cpu);;
+			ret = call_callbacks(handle, record, next_cpu,
+					     callback, callback_data);
+			tracecmd_free_record(record);
+		}
+	} while (next_cpu >= 0 && ret == 0);
+
+	for (cpu = 0; cpu < max_cpus; cpu++) {
+		int offset;
+
+		/* Get the next record to set the index to. */
+		record = peek_last_event(handle, records, cpu);
+		if (!record)
+			continue;
+		/* Reset the buffer to read the cached record again */
+		offset = record->offset & (handle->page_size - 1);
+		free_last_records(handle, records[cpu], cpu);
+		/* Reset the buffer to read the cached record again */
+		kbuffer_read_at_offset(handle->cpu_data[cpu].kbuf, offset, NULL);
+	}
+
+	free(records);
+
+	return ret;
+}
+
 struct record_handle {
 	struct tep_record		*record;
 	struct tracecmd_input		*handle;
-- 
2.39.2

