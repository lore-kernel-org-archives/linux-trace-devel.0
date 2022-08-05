Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C561C25B07
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiHEPkt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240718AbiHEPks (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A211ADA2
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 072E7615F1
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31B6C43140;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRK-008S4g-04;
        Fri, 05 Aug 2022 11:40:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6/9] trace-cmd report: Use tracecmd_iterate_events_multi()
Date:   Fri,  5 Aug 2022 11:40:37 -0400
Message-Id: <20220805154040.2014381-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154040.2014381-1-rostedt@goodmis.org>
References: <20220805154040.2014381-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Use the new helper library function tracecmd_iterate_events_multi(). This
simplifies the code as well as shows an example of how to use it for other
applications.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 214 +++++++++++++++++-------------------------
 1 file changed, 87 insertions(+), 127 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 691450b05a39..8b3efae63f8e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -56,11 +56,8 @@ struct handle_list {
 	struct tracecmd_input	*handle;
 	const char		*file;
 	int			cpus;
-	int			done;
-	struct tep_record	*record;
 	struct filter		*event_filters;
 	struct filter		*event_filter_out;
-	unsigned long long	*last_timestamp;
 };
 static struct list_head handle_list;
 
@@ -1088,92 +1085,6 @@ test_stacktrace(struct handle_list *handles, struct tep_record *record,
 	return 0;
 }
 
-static struct tep_record *get_next_record(struct handle_list *handles)
-{
-	struct tep_record *record;
-	struct tep_handle *pevent;
-	int found = 0;
-	int cpu;
-	int ret;
-
-	if (handles->record)
-		return handles->record;
-
-	if (handles->done)
-		return NULL;
-
-	pevent = tracecmd_get_tep(handles->handle);
-
-	do {
-		if (filter_cpus) {
-			long long last_stamp = -1;
-			struct tep_record *precord;
-			int first_record = 1;
-			int next_cpu = -1;
-			int i;
-
-			for (i = 0; (cpu = filter_cpus[i]) >= 0; i++) {
-				precord = tracecmd_peek_data(handles->handle, cpu);
-				if (precord &&
-				    (first_record || precord->ts < last_stamp)) {
-					next_cpu = cpu;
-					last_stamp = precord->ts;
-					first_record = 0;
-				}
-			}
-			if (!first_record)
-				record = tracecmd_read_data(handles->handle, next_cpu);
-			else
-				record = NULL;
-		} else
-			record = tracecmd_read_next_data(handles->handle, &cpu);
-
-		if (record) {
-			ret = test_filters(pevent, handles->event_filters, record, 0);
-			switch (ret) {
-			case FILTER_NOEXIST:
-				/* Stack traces may still filter this */
-				if (stacktrace_id &&
-				    test_stacktrace(handles, record, 0))
-					found = 1;
-				else
-					tracecmd_free_record(record);
-				break;
-			case FILTER_NONE:
-			case FILTER_MATCH:
-				/* Test the negative filters (-v) */
-				ret = test_filters(pevent, handles->event_filter_out,
-						   record, 1);
-				if (ret != FILTER_MATCH) {
-					found = 1;
-					break;
-				}
-				/* fall through */
-			default:
-				tracecmd_free_record(record);
-			}
-		}
-	} while (record && !found);
-
-	if (record && stacktrace_id)
-		test_stacktrace(handles, record, 1);
-
-	handles->record = record;
-	if (!record)
-		handles->done = 1;
-
-	return record;
-}
-
-static void free_handle_record(struct handle_list *handles)
-{
-	if (!handles->record)
-		return;
-
-	tracecmd_free_record(handles->record);
-	handles->record = NULL;
-}
-
 static void print_handle_file(struct handle_list *handles)
 {
 	/* Only print file names if more than one file is read */
@@ -1198,6 +1109,75 @@ static void free_filters(struct filter *event_filter)
 	}
 }
 
+static bool skip_record(struct handle_list *handles, struct tep_record *record, int cpu)
+{
+	struct tep_handle *tep;
+	bool found = false;
+	int ret;
+
+	tep = tracecmd_get_tep(handles->handle);
+
+	if (filter_cpus) {
+		int i;
+
+		for (i = 0; filter_cpus[i] >= 0; i++) {
+			if (filter_cpus[i] == cpu) {
+				found = true;
+				break;
+			}
+		}
+
+		if (!found)
+			return true;
+		found = false;
+	}
+
+	ret = test_filters(tep, handles->event_filters, record, 0);
+	switch (ret) {
+	case FILTER_NOEXIST:
+		/* Stack traces may still filter this */
+		if (stacktrace_id &&
+		    test_stacktrace(handles, record, 0))
+			found = true;
+		break;
+	case FILTER_NONE:
+	case FILTER_MATCH:
+		/* Test the negative filters (-v) */
+		ret = test_filters(tep, handles->event_filter_out,
+				   record, 1);
+		if (ret != FILTER_MATCH) {
+			found = true;
+			break;
+		}
+	}
+
+	if (record && stacktrace_id)
+		test_stacktrace(handles, record, 1);
+
+	return !found;
+}
+
+static int process_record(struct tracecmd_input *handle, struct tep_record *record,
+			  int cpu, void *data)
+{
+	struct handle_list *handles = tracecmd_get_private(handle);
+	unsigned long long *last_timestamp = data;
+
+	if (skip_record(handles, record, cpu))
+		return 0;
+
+	if (tscheck && *last_timestamp > record->ts) {
+		errno = 0;
+		warning("WARNING: Record on cpu %d went backwards: %lld to %lld delta: -%lld\n",
+			cpu, *last_timestamp, record->ts, *last_timestamp - record->ts);
+	}
+	*last_timestamp = record->ts;
+
+	print_handle_file(handles);
+	trace_show_data(handle, record);
+	return 0;
+}
+
 enum output_type {
 	OUTPUT_NORMAL,
 	OUTPUT_STAT_ONLY,
@@ -1210,17 +1190,19 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 {
 	unsigned long long ts, first_ts;
 	struct handle_list *handles;
-	struct handle_list *last_handle;
-	struct tep_record *record;
-	struct tep_record *last_record;
+	struct tracecmd_input **handle_array;
 	struct tep_handle *pevent;
 	struct tep_event *event;
+	unsigned long long last_timestamp = 0;
+	int nr_handles = 0;
 	int first = 1;
 	int ret;
 
 	list_for_each_entry(handles, handle_list, list) {
 		int cpus;
 
+		nr_handles++;
+
 		if (!tracecmd_is_buffer_instance(handles->handle)) {
 			ret = tracecmd_init_data(handles->handle);
 			if (ret < 0)
@@ -1228,9 +1210,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		}
 		cpus = tracecmd_cpus(handles->handle);
 		handles->cpus = cpus;
-		handles->last_timestamp = calloc(cpus, sizeof(*handles->last_timestamp));
-		if (!handles->last_timestamp)
-			die("allocating timestamps");
 
 		/* Don't process instances that we added here */
 		if (tracecmd_is_buffer_instance(handles->handle))
@@ -1315,38 +1294,20 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		}
 	}
 
-	do {
-		last_handle = NULL;
-		last_record = NULL;
+	handle_array = calloc(nr_handles, sizeof(*handle_array));
+	if (!handle_array)
+		die("Could not allocate memory for handle list");
 
-		list_for_each_entry(handles, handle_list, list) {
-			record = get_next_record(handles);
-			if (!record)
-				continue;
-			if (!last_record ||
-			    (record && record->ts < last_record->ts)) {
-				last_record = record;
-				last_handle = handles;
-			}
-		}
-		if (last_record) {
-			int cpu = last_record->cpu;
-			if (cpu >= last_handle->cpus)
-				die("cpu %d greater than %d\n", cpu, last_handle->cpus);
-			if (tscheck &&
-			    last_handle->last_timestamp[cpu] > last_record->ts) {
-				errno = 0;
-				warning("WARNING: Record on cpu %d went backwards: %lld to %lld delta: -%lld\n",
-					cpu, last_handle->last_timestamp[cpu],
-					last_record->ts,
-					last_handle->last_timestamp[cpu] - last_record->ts);
-			}
-			last_handle->last_timestamp[cpu] = last_record->ts;
-			print_handle_file(last_handle);
-			trace_show_data(last_handle->handle, last_record);
-			free_handle_record(last_handle);
-		}
-	} while (last_record);
+	nr_handles = 0;
+	list_for_each_entry(handles, handle_list, list) {
+		tracecmd_set_private(handles->handle, handles);
+		handle_array[nr_handles++] = handles->handle;
+	}
+
+	tracecmd_iterate_events_multi(handle_array, nr_handles,
+				      process_record, &last_timestamp);
+
+	free(handle_array);
 
 	if (profile)
 		do_trace_profile();
@@ -1354,7 +1315,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	list_for_each_entry(handles, handle_list, list) {
 		free_filters(handles->event_filters);
 		free_filters(handles->event_filter_out);
-		free(handles->last_timestamp);
 
 		show_test(handles->handle);
 	}
-- 
2.35.1

