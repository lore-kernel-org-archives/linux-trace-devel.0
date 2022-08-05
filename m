Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3523C00140
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbiHEPkz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240808AbiHEPku (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E7B18E38
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7D2EB82951
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BD3C43145;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRK-008S4s-0G;
        Fri, 05 Aug 2022 11:40:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 9/9] trace-cmd report: Use library tracecmd_filter_*() logic
Date:   Fri,  5 Aug 2022 11:40:40 -0400
Message-Id: <20220805154040.2014381-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154040.2014381-1-rostedt@goodmis.org>
References: <20220805154040.2014381-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Simplify trace-read.c by implementing the use of tracecmd_filter_add(),
tracecmd_filter_match(). And move the processing into the library.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 175 +++---------------------------------------
 1 file changed, 10 insertions(+), 165 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 99f3538646ee..5b4d88b1fca5 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -41,11 +41,6 @@ static struct filter_str {
 } *filter_strings;
 static struct filter_str **filter_next = &filter_strings;
 
-struct filter {
-	struct filter		*next;
-	struct tep_event_filter	*filter;
-};
-
 struct event_str {
 	struct event_str	*next;
 	const char		*event;
@@ -59,8 +54,6 @@ struct handle_list {
 	struct input_files	*input_file;
 	const char		*file;
 	int			cpus;
-	struct filter		*event_filters;
-	struct filter		*event_filter_out;
 };
 static struct list_head handle_list;
 
@@ -100,7 +93,6 @@ static int show_wakeup;
 static int wakeup_id;
 static int wakeup_new_id;
 static int sched_id;
-static int stacktrace_id;
 
 static int profile;
 
@@ -573,16 +565,9 @@ static void make_pid_filter(struct tracecmd_input *handle,
 
 static void process_filters(struct handle_list *handles)
 {
-	struct filter **filter_next = &handles->event_filters;
-	struct filter **filter_out_next = &handles->event_filter_out;
-	struct filter *event_filter;
+	struct tracecmd_filter *trace_filter;
 	struct filter_str *filter;
-	struct tep_handle *pevent;
-	char errstr[200];
 	int filters = 0;
-	int ret;
-
-	pevent = tracecmd_get_tep(handles->handle);
 
 	make_pid_filter(handles->handle, handles->input_file);
 
@@ -592,29 +577,12 @@ static void process_filters(struct handle_list *handles)
 		filter = filter_strings;
 
 	for (; filter; filter = filter->next) {
-		event_filter = malloc(sizeof(*event_filter));
-		if (!event_filter)
-			die("Failed to allocate for event filter");
-		event_filter->next = NULL;
-		event_filter->filter = tep_filter_alloc(pevent);
-		if (!event_filter->filter)
-			die("malloc");
-
-		ret = tep_filter_add_filter_str(event_filter->filter,
-						   filter->filter);
-		if (ret < 0) {
-			tep_strerror(pevent, ret, errstr, sizeof(errstr));
-			die("Error filtering: %s\n%s",
-			    filter->filter, errstr);
-		}
-
-		if (filter->neg) {
-			*filter_out_next = event_filter;
-			filter_out_next = &event_filter->next;
-		} else {
-			*filter_next = event_filter;
-			filter_next = &event_filter->next;
-		}
+		trace_filter = tracecmd_filter_add(handles->handle,
+						   filter->filter,
+						   filter->neg);
+		if (!trace_filter)
+			die("Failed to create event filter: %s", filter->filter);
+		
 		filters++;
 	}
 	if (filters && test_filters_mode)
@@ -993,10 +961,8 @@ static void read_latency(struct tracecmd_input *handle)
 }
 
 static int
-test_filters(struct tep_handle *pevent, struct filter *event_filters,
-	     struct tep_record *record, int neg)
+test_filters(struct tep_handle *pevent, struct tep_record *record)
 {
-	int found = 0;
 	int ret = FILTER_NONE;
 	int flags;
 
@@ -1008,19 +974,6 @@ test_filters(struct tep_handle *pevent, struct filter *event_filters,
 			return FILTER_MISS;
 	}
 
-	while (event_filters) {
-		ret = tep_filter_match(event_filters->filter, record);
-		switch (ret) {
-			case FILTER_NONE:
-			case FILTER_MATCH: 
-				found = 1;
-		}
-		/* We need to test all negative filters */
-		if (!neg && found)
-			break;
-		event_filters = event_filters->next;
-	}
-
 	return ret;
 }
 
@@ -1033,85 +986,9 @@ struct stack_info {
 	struct stack_info	*next;
 	struct handle_list	*handles;
 	struct stack_info_cpu	*cpus;
-	int			stacktrace_id;
 	int			nr_cpus;
 };
 
-static int
-test_stacktrace(struct handle_list *handles, struct tep_record *record,
-		int last_printed)
-{
-	static struct stack_info *infos;
-	struct stack_info *info;
-	struct stack_info_cpu *cpu_info;
-	struct handle_list *h;
-	struct tracecmd_input *handle;
-	struct tep_handle *pevent;
-	struct tep_event *event;
-	static int init;
-	int ret;
-	int id;
-
-	if (!init) {
-		init = 1;
-
-		list_for_each_entry(h, &handle_list, list) {
-			info = malloc(sizeof(*info));
-			if (!info)
-				die("Failed to allocate handle");
-			info->handles = h;
-			info->nr_cpus = tracecmd_cpus(h->handle);
-
-			info->cpus = malloc(sizeof(*info->cpus) * info->nr_cpus);
-			if (!info->cpus)
-				die("Failed to allocate for %d cpus", info->nr_cpus);
-			memset(info->cpus, 0, sizeof(*info->cpus));
-
-			pevent = tracecmd_get_tep(h->handle);
-			event = tep_find_event_by_name(pevent, "ftrace",
-						       "kernel_stack");
-			if (event)
-				info->stacktrace_id = event->id;
-			else
-				info->stacktrace_id = 0;
-
-			info->next = infos;
-			infos = info;
-		}
-
-
-	}
-
-	handle = handles->handle;
-	pevent = tracecmd_get_tep(handle);
-
-	for (info = infos; info; info = info->next)
-		if (info->handles == handles)
-			break;
-
-	if (!info->stacktrace_id)
-		return 0;
-
-	cpu_info = &info->cpus[record->cpu];
-
-	id = tep_data_type(pevent, record);
-
-	/*
-	 * Print the stack trace if the previous event was printed.
-	 * But do not print the stack trace if it is explicitly
-	 * being filtered out.
-	 */
-	if (id == info->stacktrace_id) {
-		ret = test_filters(pevent, handles->event_filter_out, record, 1);
-		if (ret != FILTER_MATCH)
-			return cpu_info->last_printed;
-		return 0;
-	}
-
-	cpu_info->last_printed = last_printed;
-	return 0;
-}
-
 static void print_handle_file(struct handle_list *handles)
 {
 	/* Only print file names if more than one file is read */
@@ -1123,19 +1000,6 @@ static void print_handle_file(struct handle_list *handles)
 		printf("%*s  ", max_file_size, "");
 }
 
-static void free_filters(struct filter *event_filter)
-{
-	struct filter *filter;
-
-	while (event_filter) {
-		filter = event_filter;
-		event_filter = filter->next;
-
-		tep_filter_free(filter->filter);
-		free(filter);
-	}
-}
-
 static bool skip_record(struct handle_list *handles, struct tep_record *record, int cpu)
 {
 	struct tep_handle *tep;
@@ -1159,28 +1023,20 @@ static bool skip_record(struct handle_list *handles, struct tep_record *record,
 		found = false;
 	}
 
-	ret = test_filters(tep, handles->event_filters, record, 0);
+	ret = test_filters(tep, record);
 	switch (ret) {
 	case FILTER_NOEXIST:
-		/* Stack traces may still filter this */
-		if (stacktrace_id &&
-		    test_stacktrace(handles, record, 0))
-			found = true;
 		break;
 	case FILTER_NONE:
 	case FILTER_MATCH:
 		/* Test the negative filters (-v) */
-		ret = test_filters(tep, handles->event_filter_out,
-				   record, 1);
+		ret = test_filters(tep, record);
 		if (ret != FILTER_MATCH) {
 			found = true;
 			break;
 		}
 	}
 
-	if (record && stacktrace_id)
-		test_stacktrace(handles, record, 1);
-
 	return !found;
 }
 
@@ -1218,8 +1074,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	unsigned long long ts, first_ts;
 	struct handle_list *handles;
 	struct tracecmd_input **handle_array;
-	struct tep_handle *pevent;
-	struct tep_event *event;
 	unsigned long long last_timestamp = 0;
 	int nr_handles = 0;
 	int first = 1;
@@ -1277,12 +1131,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 			continue;
 		}
 
-		/* Find the kernel_stacktrace if available */
-		pevent = tracecmd_get_tep(handles->handle);
-		event = tep_find_event_by_name(pevent, "ftrace", "kernel_stack");
-		if (event)
-			stacktrace_id = event->id;
-
 		init_wakeup(handles->handle);
 		if (last_hook)
 			last_hook->next = tracecmd_hooks(handles->handle);
@@ -1353,9 +1201,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		do_trace_profile();
 
 	list_for_each_entry(handles, handle_list, list) {
-		free_filters(handles->event_filters);
-		free_filters(handles->event_filter_out);
-
 		show_test(handles->handle);
 	}
 }
-- 
2.35.1

