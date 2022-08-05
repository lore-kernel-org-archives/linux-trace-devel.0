Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A671C25B08
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbiHEPkw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240782AbiHEPks (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A65725C66
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5973FB82757
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8819C433D6;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRK-008S4o-0C;
        Fri, 05 Aug 2022 11:40:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 8/9] trace-cmd report: Make filter arguments match their files
Date:   Fri,  5 Aug 2022 11:40:39 -0400
Message-Id: <20220805154040.2014381-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154040.2014381-1-rostedt@goodmis.org>
References: <20220805154040.2014381-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently the filter argument "-F" only affects the first file passed in,
and is ignored for the rest of the files passed in via '-i'. Also, buffers
ignore them as well.

Have the -F affect the last '-i file', with the exception that the -F
filter can be called before the first file. That is, the first -i file is
affected by any -F before it and directly after it but before another -i
file is added.

Also, have buffers within a file be affected by the filters given to the
file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 119 ++++++++++++++++++++++++++++++------------
 1 file changed, 85 insertions(+), 34 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 8b3efae63f8e..99f3538646ee 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -51,9 +51,12 @@ struct event_str {
 	const char		*event;
 };
 
+struct input_files;
+
 struct handle_list {
 	struct list_head	list;
 	struct tracecmd_input	*handle;
+	struct input_files	*input_file;
 	const char		*file;
 	int			cpus;
 	struct filter		*event_filters;
@@ -64,6 +67,8 @@ static struct list_head handle_list;
 struct input_files {
 	struct list_head	list;
 	const char		*file;
+	struct filter_str	*filter_str;
+	struct filter_str	**filter_str_next;
 	long long		tsoffset;
 	unsigned long long	ts2secs;
 };
@@ -336,29 +341,42 @@ static void test_save(struct tep_record *record, int cpu)
 }
 #endif
 
-static void add_input(const char *file)
+static void free_filter_strings(struct filter_str *filter_str)
+{
+	struct filter_str *filter;
+
+	while (filter_str) {
+		filter = filter_str;
+		filter_str = filter->next;
+		free(filter->filter);
+		free(filter);
+	}
+}
+
+static struct input_files *add_input(const char *file)
 {
 	struct input_files *item;
 
-	item = malloc(sizeof(*item));
+	item = calloc(1, sizeof(*item));
 	if (!item)
 		die("Failed to allocate for %s", file);
-	memset(item, 0, sizeof(*item));
 	item->file = file;
+	item->filter_str_next = &item->filter_str;
 	list_add_tail(&item->list, &input_files);
 	last_input_file = item;
+	return item;
 }
 
-static void add_handle(struct tracecmd_input *handle, const char *file)
+static void add_handle(struct tracecmd_input *handle, struct input_files *input_files)
 {
 	struct handle_list *item;
+	const char *file = input_files ? input_files->file : input_file;
 
-	item = malloc(sizeof(*item));
+	item = calloc(1, sizeof(*item));
 	if (!item)
 		die("Failed ot allocate for %s", file);
-	memset(item, 0, sizeof(*item));
 	item->handle = handle;
-	if (file) {
+	if (input_files) {
 		item->file = file + strlen(file);
 		/* we want just the base name */
 		while (item->file >= file && *item->file != '/')
@@ -366,6 +384,8 @@ static void add_handle(struct tracecmd_input *handle, const char *file)
 		item->file++;
 		if (strlen(item->file) > max_file_size)
 			max_file_size = strlen(item->file);
+
+		item->input_file = input_files;
 	}
 	list_add_tail(&item->list, &handle_list);
 }
@@ -377,6 +397,7 @@ static void free_inputs(void)
 	while (!list_empty(&input_files)) {
 		item = container_of(input_files.next, struct input_files, list);
 		list_del(&item->list);
+		free_filter_strings(item->filter_str);
 		free(item);
 	}
 }
@@ -392,7 +413,7 @@ static void free_handles(void)
 	}
 }
 
-static void add_filter(const char *filter, int neg)
+static void add_filter(struct input_files *input_file, const char *filter, int neg)
 {
 	struct filter_str *ftr;
 
@@ -406,8 +427,13 @@ static void add_filter(const char *filter, int neg)
 	ftr->neg = neg;
 
 	/* must maintain order of command line */
-	*filter_next = ftr;
-	filter_next = &ftr->next;
+	if (input_file) {
+		*input_file->filter_str_next = ftr;
+		input_file->filter_str_next = &ftr->next;
+	} else {
+		*filter_next = ftr;
+		filter_next = &ftr->next;
+	}
 }
 
 static void __add_filter(struct pid_list **head, const char *arg)
@@ -517,7 +543,8 @@ static void convert_comm_filter(struct tracecmd_input *handle)
 	}
 }
 
-static void make_pid_filter(struct tracecmd_input *handle)
+static void make_pid_filter(struct tracecmd_input *handle,
+			    struct input_files *input_files)
 {
 	struct pid_list *list;
 	char *str = NULL;
@@ -532,7 +559,7 @@ static void make_pid_filter(struct tracecmd_input *handle)
 		str = append_pid_filter(str, list->pid);
 	}
 
-	add_filter(str, 0);
+	add_filter(input_files, str, 0);
 	free(str);
 
 	while (pid_list) {
@@ -557,12 +584,14 @@ static void process_filters(struct handle_list *handles)
 
 	pevent = tracecmd_get_tep(handles->handle);
 
-	make_pid_filter(handles->handle);
+	make_pid_filter(handles->handle, handles->input_file);
 
-	while (filter_strings) {
+	if (handles->input_file)
+		filter = handles->input_file->filter_str;
+	else
 		filter = filter_strings;
-		filter_strings = filter->next;
 
+	for (; filter; filter = filter->next) {
 		event_filter = malloc(sizeof(*event_filter));
 		if (!event_filter)
 			die("Failed to allocate for event filter");
@@ -587,8 +616,6 @@ static void process_filters(struct handle_list *handles)
 			filter_next = &event_filter->next;
 		}
 		filters++;
-		free(filter->filter);
-		free(filter);
 	}
 	if (filters && test_filters_mode)
 		exit(0);
@@ -1211,6 +1238,8 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		cpus = tracecmd_cpus(handles->handle);
 		handles->cpus = cpus;
 
+		process_filters(handles);
+
 		/* Don't process instances that we added here */
 		if (tracecmd_is_buffer_instance(handles->handle))
 			continue;
@@ -1262,15 +1291,17 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (profile)
 			trace_init_profile(handles->handle, hooks, global);
 
-		process_filters(handles);
-
 		/* If this file has buffer instances, get the handles for them */
 		instances = tracecmd_buffer_instances(handles->handle);
 		if (instances) {
 			struct tracecmd_input *new_handle;
+			struct input_files *file_input;
+			const char *save_name;
 			const char *name;
 			int i;
 
+			file_input = handles->input_file;
+
 			for (i = 0; i < instances; i++) {
 				name = tracecmd_buffer_instance_name(handles->handle, i);
 				if (!name)
@@ -1280,7 +1311,16 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 					warning("could not retrieve handle %s", name);
 					continue;
 				}
-				add_handle(new_handle, name);
+				if (file_input) {
+					save_name = file_input->file;
+					file_input->file = name;
+				} else {
+					save_name = NULL;
+					file_input = add_input(name);
+				}
+				add_handle(new_handle, file_input);
+				if (save_name)
+					file_input->file = save_name;
 			}
 		}
 	}
@@ -1493,6 +1533,21 @@ static void add_hook(const char *arg)
 		last_hook = hook;
 }
 
+static void add_first_input(const char *input_file, long long tsoffset)
+{
+	struct input_files *item;
+
+	/* Copy filter strings to this input file */
+	item = add_input(input_file);
+	item->filter_str = filter_strings;
+	if (filter_strings)
+		item->filter_str_next = filter_next;
+	else
+		item->filter_str_next = &item->filter_str;
+	/* Copy the tsoffset to this input file */
+	item->tsoffset = tsoffset;
+}
+
 enum {
 	OPT_verbose	= 234,
 	OPT_align_ts	= 235,
@@ -1615,18 +1670,15 @@ void trace_report (int argc, char **argv)
 			break;
 		case 'i':
 			if (input_file) {
-				if (!multi_inputs) {
-					add_input(input_file);
-					if (tsoffset)
-						last_input_file->tsoffset = tsoffset;
-				}
 				multi_inputs++;
 				add_input(optarg);
-			} else
+			} else {
 				input_file = optarg;
+				add_first_input(input_file, tsoffset);
+			}
 			break;
 		case 'F':
-			add_filter(optarg, neg);
+			add_filter(last_input_file, optarg, neg);
 			break;
 		case 'H':
 			add_hook(optarg);
@@ -1803,15 +1855,14 @@ void trace_report (int argc, char **argv)
 		if (input_file)
 			usage(argv);
 		input_file = argv[optind + 1];
+		add_first_input(input_file, tsoffset);
 	}
 
-	if (!input_file)
-		input_file = default_input_file;
-
 	if (!multi_inputs) {
-		add_input(input_file);
-		if (tsoffset)
-			last_input_file->tsoffset = tsoffset;
+		if (!input_file) {
+			input_file = default_input_file;
+			add_first_input(input_file, tsoffset);
+		}
 	} else if (show_wakeup)
 		die("Wakeup tracing can only be done on a single input file");
 
@@ -1821,7 +1872,7 @@ void trace_report (int argc, char **argv)
 			die("error reading header for %s", inputs->file);
 
 		/* If used with instances, top instance will have no tag */
-		add_handle(handle, multi_inputs ? inputs->file : NULL);
+		add_handle(handle, multi_inputs ? inputs : NULL);
 
 		if (no_date)
 			tracecmd_set_flag(handle, TRACECMD_FL_IGNORE_DATE);
-- 
2.35.1

