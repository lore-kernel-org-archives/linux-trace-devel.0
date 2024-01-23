Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA24C5F542
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706017362; cv=none; b=KT42KcUuB5AIbwHBuGqi50Pfm4udrEfu+Y5ffsG6W+OT+cNRj/UDSjjNaPMV65oOhiyvDHehPBE+LCJMvh8bstXozLClU9jTwko9wTOvRVXeKGP9KV6n5ucOVFa3SLgJ6m2NvBwSXuH9qyOcwW6S0xIRm8i+U+IzWrg++v2AAj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706017362; c=relaxed/simple;
	bh=bUSyTBXUKVh3bUtzRKDVhB59knV8Rhx9Vrze4Lkq1LE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cNBNvb2bjg72GaD4irf/35TCgCrOb+7h553I86C06wD3/1jWeIy/byPq4QDD0leJ6NiOIevWMyrJfeVsokD4wjuwdAR+0pkF5g1vp4GqIcqTGS8U4lFZ3DRBJzcTvKMshKvl7gP+g5hU0hj/9Fp2i0NGIV4HFfkdBIFq9qqdbtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04A7513D5;
	Tue, 23 Jan 2024 05:43:25 -0800 (PST)
Received: from e126645.home (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 89A743F762;
	Tue, 23 Jan 2024 05:42:38 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v3 4/5] trace-cmd split: Enable support for buffer selection
Date: Tue, 23 Jan 2024 14:42:14 +0100
Message-Id: <20240123134215.385415-5-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240123134215.385415-1-pierre.gondois@arm.com>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'trace-cmd split' command conserves all buffers/instances
of the input .dat file. Add support to select the instances to
keep and to place as the top instance in an output .dat file.

Multiple .dat files can be generated with different combinations
of the instances to keep. The first instance in the command line
is selected as the top instance in an output .dat file.

For example, with a trace recorded with:
  $ trace-cmd record -e sched_wakeup -B switch_instance \
    -e sched_switch -B timer_instance -e timer

Creating a test.dat file containing the top instance and
the switch_instance:
  $ trace-cmd split --top -B switch_instance -o test.dat

Creating a test.dat file containing the switch_instance as
the top instance, and the initial top instance as an instance
named 'old_top':
  $ trace-cmd split -B switch_instance --top=old_top -o test.dat

Splitting all instances in different .dat files:
  $ trace-cmd split --top -o top.dat -B switch_instance \
    -o switch.dat -B timer_instance -o timer.dat

To achieve this, new 'struct name_list', 'struct output_file_list'
structures are created, with associated functions.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 307 +++++++++++++++++++++++++++++++++++------
 1 file changed, 262 insertions(+), 45 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 0820a3bb..73ef6e97 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -51,11 +51,89 @@ struct cpu_data {
 	char				*file;
 };
 
+struct name_list {
+	struct list_head		list;
+	const char			*name;
+
+	/* Identify the top instance in the input trace. */
+	bool				was_top_instance;
+
+	/* Identify the top instance in each output trace. */
+	bool				is_top_instance;
+};
+
+static void free_names(struct list_head *list) {
+	struct name_list *item;
+
+	while (!list_empty(list)) {
+		item = container_of(list->next, struct name_list, list);
+		list_del(&item->list);
+		free((char *)item->name);
+		free(item);
+	}
+}
+
+struct output_file_list {
+	struct list_head list;
+	const char *output;
+	char *output_file;
+	struct list_head instance_list;
+	struct list_head handle_list;
+};
+
+static struct list_head output_file_list;
+
+static struct output_file_list *add_output_file(void) {
+	struct output_file_list *item;
+
+	item = calloc(1, sizeof(*item));
+	if (!item)
+		die("Failed to allocate output_file item");
+
+	list_head_init(&item->instance_list);
+	list_head_init(&item->handle_list);
+	list_add_tail(&item->list, &output_file_list);
+	return item;
+}
+
+static void add_output_file_instance(struct output_file_list *output_file, const char *instance,
+				     bool was_top_instance, bool is_top_instance) {
+	struct name_list *item;
+
+	item = calloc(1, sizeof(*item));
+	if (!item)
+		die("Failed to allocate output_file item");
+
+	item->name = strdup(instance);
+	if (!item->name)
+		die("Failed to duplicate %s", instance);
+
+	item->was_top_instance = was_top_instance;
+	item->is_top_instance = is_top_instance;
+	list_add_tail(&item->list, &output_file->instance_list);
+}
+
+static void free_handles(struct list_head *list);
+
+static void free_output_files(struct list_head *list) {
+	struct output_file_list *item;
+
+	while (!list_empty(list)) {
+		item = container_of(list->next, struct output_file_list, list);
+		list_del(&item->list);
+		free_names(&item->instance_list);
+		free_handles(&item->handle_list);
+		free((char *)item->output);
+		free((char *)item->output_file);
+		free(item);
+	}
+}
+
 struct handle_list {
 	struct list_head		list;
 	const char			*name;
 	int				index;
-	struct tracecmd_input 		*handle;
+	struct tracecmd_input		*handle;
 
 	/* Identify the top instance in the input trace. */
 	bool				was_top_instance;
@@ -103,10 +181,28 @@ static void add_handle(const char *name, int index, bool was_top_instance)
 
 	item->index = index;
 	item->was_top_instance = was_top_instance;
-	item->handle = get_handle(item);
+
+	/* Don't need to request a real handle for handle_list nodes. */
+	item->handle = NULL;
 	list_add_tail(&item->list, &handle_list);
 }
 
+static void add_handle_copy(struct handle_list *item, struct name_list *name_entry,
+			    struct list_head *list) {
+	struct handle_list *copied_item;
+
+	copied_item = calloc(1, sizeof(*copied_item));
+	copied_item->name = strdup(name_entry->name);
+	if (!copied_item->name)
+		die("Failed to duplicate %s", name_entry->name);
+
+	copied_item->index = item->index;
+	copied_item->was_top_instance = item->was_top_instance;
+	copied_item->is_top_instance = name_entry->is_top_instance;
+	copied_item->handle = get_handle(copied_item);
+	list_add_tail(&copied_item->list, list);
+}
+
 static void free_handles(struct list_head *list)
 {
 	struct handle_list *item;
@@ -115,7 +211,8 @@ static void free_handles(struct list_head *list)
 		item = container_of(list->next, struct handle_list, list);
 		list_del(&item->list);
 		free((char *)item->name);
-		tracecmd_close(item->handle);
+		if (item->handle)
+			tracecmd_close(item->handle);
 		free(item);
 	}
 }
@@ -473,13 +570,10 @@ static void touch_file(const char *file)
 }
 
 static unsigned long long parse_file(struct tracecmd_input *handle,
-				     const char *output_file,
-				     unsigned long long start,
-				     unsigned long long end, int percpu,
-				     int only_cpu, int count,
-				     enum split_types type,
-				     bool *end_reached)
-{
+				     struct output_file_list *output_file_entry,
+				     unsigned long long start, unsigned long long end, int percpu,
+				     int only_cpu, int count, enum split_types type,
+				     bool *end_reached) {
 	unsigned long long current;
 	struct handle_list *handle_entry;
 	struct tracecmd_output *ohandle;
@@ -493,10 +587,11 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 	int ret;
 	int fd;
 
-	ohandle = tracecmd_copy(handle, output_file, TRACECMD_FILE_CMD_LINES, 0, NULL);
+	ohandle = tracecmd_copy(handle, output_file_entry->output_file,
+				TRACECMD_FILE_CMD_LINES, 0, NULL);
 	tracecmd_set_out_clock(ohandle, tracecmd_get_trace_clock(handle));
 
-	list_for_each_entry(handle_entry, &handle_list, list) {
+	list_for_each_entry(handle_entry, &output_file_entry->handle_list, list) {
 		struct tracecmd_input *curr_handle;
 		bool curr_end_reached = false;
 
@@ -507,7 +602,8 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 			die("Failed to allocate cpu_data for %d cpus", cpus);
 
 		for (cpu = 0; cpu < cpus; cpu++) {
-			file = get_temp_file(output_file, handle_entry->name, cpu);
+			file = get_temp_file(output_file_entry->output_file,
+					     handle_entry->name, cpu);
 			touch_file(file);
 
 			fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
@@ -540,7 +636,7 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 		for (cpu = 0; cpu < cpus; cpu++)
 			cpu_list[cpu] = cpu_data[cpu].file;
 
-		if (handle_entry->was_top_instance)
+		if (handle_entry->is_top_instance)
 			ret = tracecmd_append_cpu_data(ohandle, cpus, cpu_list);
 		else
 			ret = tracecmd_append_buffer_cpu_data(ohandle, handle_entry->name, cpus,
@@ -573,16 +669,76 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 	return current;
 }
 
+/**
+ * map_handle_output - Map the buffer/instances to the output_files.
+ *
+ * The trace-cmd split command can create multiple .dat files, each containing
+ * various combinations of the buffers available in the input .dat file.
+ * Associate the list of buffers/instances to keep to each output file. A
+ * buffer/instance can be present in multiple output files.
+ */
+static void map_handle_output(void) {
+	struct output_file_list *output_file_entry;
+	struct handle_list *handle_entry;
+	struct name_list *name_entry;
+	bool found_match = false;
+
+	list_for_each_entry(output_file_entry, &output_file_list, list) {
+		/*
+		 * No specific instance were given for this output file.
+		 * Select all the instances.
+		 */
+		if (list_empty(&output_file_entry->instance_list)) {
+			list_for_each_entry(handle_entry, &handle_list, list) {
+				/* Keep the old top instance as the top instance. */
+				add_output_file_instance(output_file_entry, handle_entry->name,
+							 handle_entry->was_top_instance,
+							 handle_entry->was_top_instance);
+			}
+		}
+
+		list_for_each_entry(name_entry, &output_file_entry->instance_list, list) {
+			list_for_each_entry(handle_entry, &handle_list, list) {
+				if ((name_entry->was_top_instance &&
+				     handle_entry->was_top_instance) ||
+				    !strcmp(handle_entry->name, name_entry->name)) {
+					found_match = true;
+					goto found;
+				}
+			}
+
+		found:
+			if (!found_match) {
+				warning("Buffer %s requested, but not found.", name_entry->name);
+				continue;
+			}
+
+			/*
+			 * As a handle can be requested in multiple output files,
+			 * the name_entry must be copied (and not de/en-queued).
+			 */
+			add_handle_copy(handle_entry, name_entry, &output_file_entry->handle_list);
+			found_match = false;
+		}
+	}
+}
+
+enum { OPT_top = 237,
+};
+
 void trace_split (int argc, char **argv)
 {
 	struct tracecmd_input *handle;
+	struct output_file_list *output_file_param = NULL;
+	struct output_file_list *output_file_entry;
 	unsigned long long start_ns = 0, end_ns = 0;
 	unsigned long long current;
+	bool was_top_instance;
+	bool is_top_instance;
 	bool end_reached = false;
 	double start, end;
 	char *endptr;
 	char *output = NULL;
-	char *output_file;
 	enum split_types split_type = SPLIT_NONE;
 	enum split_types type = SPLIT_NONE;
 	int instances;
@@ -593,12 +749,26 @@ void trace_split (int argc, char **argv)
 	int ac;
 	int c;
 
+	static struct option long_options[] = {
+		{"top", optional_argument, NULL, OPT_top},
+		{NULL, 0, NULL, 0},
+	};
+	int option_index = 0;
+
+	/* The first instance is the new top buffer of the output file. */
+	is_top_instance = true;
+	was_top_instance = false;
+
 	list_head_init(&handle_list);
+	list_head_init(&output_file_list);
+
+	output_file_param = add_output_file();
 
 	if (strcmp(argv[1], "split") != 0)
 		usage(argv);
 
-	while ((c = getopt(argc-1, argv+1, "+ho:i:s:m:u:e:p:rcC:")) >= 0) {
+	while ((c = getopt_long(argc - 1, argv + 1, "+ho:i:s:m:u:e:p:rcC:B:",
+				long_options, &option_index)) >= 0) {
 		switch (c) {
 		case 'h':
 			usage(argv);
@@ -634,13 +804,48 @@ void trace_split (int argc, char **argv)
 			cpu = atoi(optarg);
 			break;
 		case 'o':
-			if (output)
+			if (!output_file_param) {
+				/* The first name is the main instance. */
+				is_top_instance = true;
+				output_file_param = add_output_file();
+			}
+
+			if (output_file_param->output)
 				die("only one output file allowed");
-			output = strdup(optarg);
+
+			output_file_param->output = strdup(optarg);
+			if (!output_file_param->output)
+				die("Failed to duplicate %s", optarg);
+
+			/* New output file. */
+			output_file_param = NULL;
 			break;
 		case 'i':
 			input_file = optarg;
 			break;
+		case OPT_top:
+			was_top_instance = true;
+			if (!optarg)
+				output = (char *)default_top_instance_name;
+			else
+				output = optarg;
+			/* Fall through */
+		case 'B':
+			if (!output_file_param) {
+				/* The first name is the main instance. */
+				is_top_instance = true;
+				output_file_param = add_output_file();
+			}
+			if (!output)
+				output = optarg;
+
+			add_output_file_instance(output_file_param, output,
+						 was_top_instance, is_top_instance);
+
+			output = NULL;
+			was_top_instance = false;
+			is_top_instance = false;
+			break;
 		default:
 			usage(argv);
 		}
@@ -686,19 +891,6 @@ void trace_split (int argc, char **argv)
 
 	page_size = tracecmd_page_size(handle);
 
-	if (!output)
-		output = strdup(input_file);
-
-	if (!repeat && strcmp(output, input_file) == 0) {
-		output = realloc(output, strlen(output) + 3);
-		strcat(output, ".1");
-	}
-
-	output_file = malloc(strlen(output) + 50);
-	if (!output_file)
-		die("Failed to allocate for %s", output);
-	c = 1;
-
 	add_handle(default_top_instance_name, -1, true);
 	instances = tracecmd_buffer_instances(handle);
 	if (instances) {
@@ -713,25 +905,50 @@ void trace_split (int argc, char **argv)
 		}
 	}
 
-	do {
-		if (repeat)
-			sprintf(output_file, "%s.%04d", output, c++);
-		else
-			strcpy(output_file, output);
-			
-		current = parse_file(handle, output_file, start_ns, end_ns,
-				     percpu, cpu, count, type, &end_reached);
+	if (output_file_param && !output_file_param->output) {
+		output_file_param->output = strdup(input_file);
+		if (!output_file_param->output)
+			die("Failed to duplicate %s", input_file);
+	}
 
-		if (!repeat)
-			break;
-		start_ns = 0;
-	} while (!end_reached && (current && (!end_ns || current < end_ns)));
+	map_handle_output();
 
-	free(output);
-	free(output_file);
+	list_for_each_entry(output_file_entry, &output_file_list, list) {
+		output = (char *)output_file_entry->output;
+
+		if (!repeat && strcmp(output, input_file) == 0) {
+			output = realloc(output, strlen(output) + 3);
+			strcat(output, ".1");
+		}
+
+		output_file_entry->output_file = malloc(strlen(output) + 50);
+		if (!output_file_entry->output_file)
+			die("Failed to allocate for %s", output);
+
+		output_file_entry->output = output;
+	}
+
+	list_for_each_entry(output_file_entry, &output_file_list, list) {
+		c = 1;
+		do {
+			if (repeat)
+				sprintf(output_file_entry->output_file, "%s.%04d",
+					output_file_entry->output, c++);
+			else
+				strcpy(output_file_entry->output_file, output_file_entry->output);
+
+			current = parse_file(handle, output_file_entry, start_ns, end_ns, percpu,
+					     cpu, count, type, &end_reached);
+
+			if (!repeat)
+				break;
+			start_ns = 0;
+		} while (!end_reached && (current && (!end_ns || current < end_ns)));
+	}
 
 	tracecmd_close(handle);
 	free_handles(&handle_list);
+	free_output_files(&output_file_list);
 
 	return;
 }
-- 
2.25.1

