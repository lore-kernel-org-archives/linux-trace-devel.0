Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A9BC00140
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbiHEPkt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbiHEPkr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2F21A81F
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BBC5615F4
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04503C43470;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRK-008S4k-08;
        Fri, 05 Aug 2022 11:40:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 7/9] trace-cmd library: Add filtering logic for iterating events
Date:   Fri,  5 Aug 2022 11:40:38 -0400
Message-Id: <20220805154040.2014381-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154040.2014381-1-rostedt@goodmis.org>
References: <20220805154040.2014381-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracecmd_filter_add() and tracecmd_filter_match() for filtering of
events during tracecmd_iterate_events() and
tracecmd_iterate_events_multi().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h           |  13 ++
 lib/trace-cmd/Makefile                  |   1 +
 lib/trace-cmd/include/trace-cmd-local.h |   5 +
 lib/trace-cmd/trace-filter.c            | 197 ++++++++++++++++++++++++
 lib/trace-cmd/trace-input.c             |  28 +++-
 5 files changed, 242 insertions(+), 2 deletions(-)
 create mode 100644 lib/trace-cmd/trace-filter.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index e8d72c76c02a..4963f45dfe12 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -66,4 +66,17 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 
 void tracecmd_set_loglevel(enum tep_loglevel level);
 
+enum tracecmd_filters {
+	TRACECMD_FILTER_NONE		= TEP_ERRNO__NO_FILTER,
+	TRACECMD_FILTER_NOT_FOUND	= TEP_ERRNO__FILTER_NOT_FOUND,
+	TRACECMD_FILTER_MISS		= TEP_ERRNO__FILTER_MISS,
+	TRACECMD_FILTER_MATCH		= TEP_ERRNO__FILTER_MATCH,
+};
+
+struct tracecmd_filter;
+struct tracecmd_filter *tracecmd_filter_add(struct tracecmd_input *handle,
+					    const char *filter_str, bool neg);
+enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
+					    struct tep_record *record);
+
 #endif /* _TRACE_CMD_H */
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index a476e35b3762..81cde3def3a7 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -15,6 +15,7 @@ OBJS += trace-output.o
 OBJS += trace-recorder.o
 OBJS += trace-util.o
 OBJS += trace-filter-hash.o
+OBJS += trace-filter.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
 ifeq ($(PERF_DEFINED), 1)
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index cfa3e97ae445..2a458133204b 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -97,4 +97,9 @@ unsigned int get_meta_strings_size(struct tracecmd_input *handle);
 int trace_append_options(struct tracecmd_output *handle, void *buf, size_t len);
 void *trace_get_options(struct tracecmd_output *handle, size_t *len);
 
+/* filters */
+struct tracecmd_filter *tracecmd_filter_get(struct tracecmd_input *handle);
+void tracecmd_filter_set(struct tracecmd_input *handle, struct tracecmd_filter *filter);
+void tracecmd_filter_free(struct tracecmd_filter *filter);
+
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-filter.c b/lib/trace-cmd/trace-filter.c
new file mode 100644
index 000000000000..f7eb46c762d6
--- /dev/null
+++ b/lib/trace-cmd/trace-filter.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022, Google Inc, Steven Rostedt <rostedt@goodmis.org>
+*/
+#include <stdlib.h>
+#include <trace-cmd.h>
+#include <trace-cmd-local.h>
+
+struct filter {
+	struct tep_event_filter		*filter;
+};
+
+struct tracecmd_filter {
+	struct tep_handle	*tep;
+	struct filter		**event_filters;
+	struct filter		**event_notrace;
+	bool			*last_printed;
+	int			nr_cpus;
+	int			nr_filters;
+	int			nr_notrace;
+	int			kernel_stacktrace_id;
+	int			user_stacktrace_id;
+};
+
+static bool test_stacktrace(struct tracecmd_filter *filter, struct tep_record *record,
+			    int stacktrace_id)
+{
+	struct tep_handle *tep = filter->tep;
+	int id;
+
+	if (stacktrace_id < 0)
+		return false;
+
+	id = tep_data_type(tep, record);
+	if (id != stacktrace_id)
+		return false;
+
+	return filter->last_printed[record->cpu];
+}
+
+static bool test_stacktraces(struct tracecmd_filter *filter, struct tep_record *record)
+{
+	return test_stacktrace(filter, record, filter->kernel_stacktrace_id) ||
+		test_stacktrace(filter, record, filter->user_stacktrace_id);
+}
+
+enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
+					    struct tep_record *record)
+{
+	bool found = false;
+	int ret;
+	int i;
+
+	if (!filter)
+		return TRACECMD_FILTER_NONE;
+
+	/* Setup stack traces. If a event is shown, still show stack traces */
+	if (!filter->kernel_stacktrace_id) {
+		struct tep_handle *tep = filter->tep;
+		struct tep_event *event;
+
+		/* In case the below logic fails, do not do this again */
+		filter->kernel_stacktrace_id = -1;
+
+		event = tep_find_event_by_name(tep, "ftrace", "kernel_stack");
+		if (event)
+			filter->kernel_stacktrace_id = event->id;
+
+		event = tep_find_event_by_name(tep, "ftrace", "user_stack");
+		if (event)
+			filter->user_stacktrace_id = event->id;
+
+		filter->nr_cpus = tep_get_cpus(tep);
+		filter->last_printed = calloc(filter->nr_cpus, sizeof(*filter->last_printed));
+		if (!filter->last_printed) {
+			tracecmd_warning("Could not allocate last_printed array for stack trace filtering");
+			filter->kernel_stacktrace_id = -1;
+			filter->user_stacktrace_id = -1;
+		}
+	}
+
+	for (i = 0; i < filter->nr_filters; i++) {
+		ret = tep_filter_match(filter->event_filters[i]->filter, record);
+		switch (ret) {
+		case TRACECMD_FILTER_NONE:
+		case TRACECMD_FILTER_MATCH:
+			found = true;
+		}
+		if (found)
+			break;
+	}
+
+	if (!found && filter->nr_filters) {
+		/* If this is a stack trace and the last event was printed continue */
+		if (!test_stacktraces(filter, record))
+			return TRACECMD_FILTER_MISS;
+	}
+
+	found = false;
+	/* We need to test all negative filters */
+	for (i = 0; i < filter->nr_notrace; i++) {
+		ret = tep_filter_match(filter->event_notrace[i]->filter, record);
+		switch (ret) {
+		case TRACECMD_FILTER_NONE:
+		case TRACECMD_FILTER_MATCH:
+			found = true;
+		}
+		if (found)
+			break;
+	}
+
+	if (filter->last_printed)
+		filter->last_printed[record->cpu] = !found;
+
+	return found ? TRACECMD_FILTER_MISS : TRACECMD_FILTER_MATCH;
+}
+
+struct tracecmd_filter *tracecmd_filter_add(struct tracecmd_input *handle,
+					    const char *filter_str, bool neg)
+{
+	struct tracecmd_filter *trace_filter;
+	struct tep_handle *tep;
+	struct filter ***filter_ptr;
+	struct filter **filters;
+	struct filter *filter;
+	int *nr;
+	int ret;
+
+	filter = calloc(1, sizeof(*filter));
+	if (!filter)
+		return NULL;
+
+	tep = tracecmd_get_tep(handle);
+
+	trace_filter = tracecmd_filter_get(handle);
+	if (!trace_filter) {
+		trace_filter = calloc(1, sizeof(*trace_filter));
+		if (!trace_filter)
+			goto fail;
+		tracecmd_filter_set(handle, trace_filter);
+		trace_filter->tep = tep;
+	}
+
+	filter->filter = tep_filter_alloc(tep);
+	if (!filter->filter)
+		goto fail;
+
+	ret = tep_filter_add_filter_str(filter->filter, filter_str);
+	if (ret < 0)
+		goto fail;
+
+	if (neg) {
+		filter_ptr = &trace_filter->event_notrace;
+		nr = &trace_filter->nr_notrace;
+	} else {
+		filter_ptr = &trace_filter->event_filters;
+		nr = &trace_filter->nr_filters;
+	}
+
+	filters = realloc(*filter_ptr, sizeof(*filters) * (*nr + 1));
+	if (!filters)
+		goto fail;
+
+	*filter_ptr = filters;
+	filters[*nr] = filter;
+	(*nr)++;
+	return trace_filter;
+ fail:
+	if (filter) {
+		tep_filter_free(filter->filter);
+		free(filter);
+	}
+	return NULL;
+}
+
+static void free_filters (struct filter **filter, int nr)
+{
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		tep_filter_free(filter[i]->filter);
+		free(filter[i]);
+	}
+
+	free(filter);
+}
+
+__hidden void tracecmd_filter_free(struct tracecmd_filter *trace_filter)
+{
+	if (!trace_filter)
+		return;
+
+	free_filters(trace_filter->event_filters, trace_filter->nr_filters);
+	free_filters(trace_filter->event_notrace, trace_filter->nr_notrace);
+
+	free(trace_filter);
+}
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a3f17070c269..cdaa17bd69f9 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -160,6 +160,7 @@ struct tracecmd_input {
 	struct tep_handle	*pevent;
 	struct tep_plugin_list	*plugin_list;
 	struct tracecmd_input	*parent;
+	struct tracecmd_filter	*filter;
 	unsigned long		file_state;
 	unsigned long long	trace_id;
 	unsigned long long	next_offset;
@@ -2580,7 +2581,10 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 			record = tracecmd_read_data(handle, next_cpu);
 			records[next_cpu] = tracecmd_peek_data(handle, next_cpu);
 
-			ret = callback(handle, record, next_cpu, callback_data);
+			if (!handle->filter ||
+			    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH)
+				ret = callback(handle, record, next_cpu, callback_data);
+
 			tracecmd_free_record(record);
 		}
 
@@ -2669,7 +2673,9 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 			record = tracecmd_read_data(handle, cpu);
 			records[next_cpu].record = tracecmd_peek_data(handle, cpu);
 
-			ret = callback(handle, record, cpu, callback_data);
+			if (!handle->filter ||
+			    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH)
+				ret = callback(handle, record, next_cpu, callback_data);
 			tracecmd_free_record(record);
 		}
 
@@ -4716,6 +4722,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 	trace_tsync_offset_free(&handle->host);
 	trace_guests_free(handle);
 
+	tracecmd_filter_free(handle->filter);
+
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
 	else {
@@ -6058,3 +6066,19 @@ int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
 	return 0;
 }
 
+__hidden struct tracecmd_filter *tracecmd_filter_get(struct tracecmd_input *handle)
+{
+	return handle->filter;
+}
+
+__hidden void tracecmd_filter_set(struct tracecmd_input *handle,
+				  struct tracecmd_filter *filter)
+{
+	/* This can be used to set filter to NULL though. */
+	if (handle->filter && filter) {
+		tracecmd_warning("Filter exists and setting a new one");
+		return;
+	}
+
+	handle->filter = filter;
+}
-- 
2.35.1

