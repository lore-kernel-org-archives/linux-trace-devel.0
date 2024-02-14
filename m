Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47AB84A37
	for <linux-trace-devel@vger.kernel.org>; Wed, 14 Feb 2024 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707932444; cv=none; b=abZYpeWtzuJsuySzVMEb5PbzOHjVJF5Wdkciv/p+ceT6I1pr2QIQ0IaZ5waWqrdQjgzXdAAVObNKmVqfDF+5FYQVA7iWWISO/e+vh28Bol5ARewyUok7ln6IVmHCbnuVPkgjsbiljnic9cmpyElvyh8p1zXaMECYIAhNBg9d3qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707932444; c=relaxed/simple;
	bh=ScCjgiOWCHvOEgcq5B9LT4w3btc+9Z1GhTPF/YHtFMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PscxzoS24PhVUtSJGB9IO/W741/Ir9TdTBvnTBAS2EtghCUNYoUjn5+y5HQu/tGK/jO+auonIiPOlIxcISqhyjZcQG+bsxAYWOzXF/J26oID4psVzB1K6YJ83Zb/16J+u1zWdoXFNtbSw7lYfXXwpRnUrzDHtlCNTP6T0Et1+2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB3BC1FB;
	Wed, 14 Feb 2024 09:41:22 -0800 (PST)
Received: from e126645.home (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CED5A3F766;
	Wed, 14 Feb 2024 09:40:40 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v4] trace-cmd split: Enable support for buffer selection
Date: Wed, 14 Feb 2024 18:40:13 +0100
Message-Id: <20240214174013.68568-1-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'trace-cmd split' command conserves all buffers/instances
of the input .dat file. Add support to select the instances to
keep:
- '--top' to keep the top instance
- '-b' top rename the top instance. Must follow '--top'.
- '-B buffer' to keep a buffer/instance
- t top promote a buffer to the top instance.
  Must follow '-B'.

For example, with a trace recorded with:
  $ trace-cmd record -e sched_wakeup -B switch_instance \
    -e sched_switch

Creating a test.dat file containing the top instance and
the switch_instance:
  $ trace-cmd split --top -B switch_instance -o test.dat

Creating a test.dat file containing the switch_instance as
the top instance, and the initial top instance as an instance
named 'old_top':
  $ trace-cmd split --top -b old_top -B switch_instance -t \
    -o test.dat

Also update the trace-usage.c and the relevant documentation
for the new options.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---

Notes:
    v4:
    - Update the options as discussed at:
    https://lore.kernel.org/all/20240212162800.3fe15000@gandalf.local.home/

 Documentation/trace-cmd/trace-cmd-split.1.txt |  25 +++
 tracecmd/trace-split.c                        | 182 ++++++++++++++++--
 tracecmd/trace-usage.c                        |   7 +
 3 files changed, 203 insertions(+), 11 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-split.1.txt b/Documentation/trace-cmd/trace-cmd-split.1.txt
index 25385796..d2fea252 100644
--- a/Documentation/trace-cmd/trace-cmd-split.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-split.1.txt
@@ -86,6 +86,31 @@ OPTIONS
 
     This will split out all the events for cpu 1 in the file.
 
+*--top*::
+    This allows to keep the top buffer.
+    The top buffer can be renamed using the '-b' option.
+
+    trace-cmd split --top
+
+    This will keep only the top buffer.
+
+    trace-cmd split --top -b old_top
+
+    This will keep only the top buffer and rename it 'old_top'.
+
+*-B* 'buffer'::
+    This allows to keep the selected buffer.
+    A buffer can be promoted to the top buffer using the '-t' option.
+
+    trace-cmd split -B timer -B sched
+
+    This will keep the 'timer' and 'sched' buffers.
+
+    trace-cmd split -B timer -t -B sched
+
+    This will keep the 'timer' and 'sched' buffers, with the events
+    from the 'timer' buffer promoted to the top instance.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 2c311b3d..f7c455c6 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -55,13 +55,10 @@ struct handle_list {
 	struct list_head		list;
 	const char			*name;
 	int				index;
-	struct tracecmd_input 		*handle;
+	struct tracecmd_input		*handle;
 
 	/* Identify the top instance in the input trace. */
 	bool				was_top_instance;
-
-	/* Identify the top instance in each output trace. */
-	bool				is_top_instance;
 };
 
 static struct list_head handle_list;
@@ -120,6 +117,51 @@ static void free_handles(struct list_head *list)
 	}
 }
 
+static struct list_head inst_list;
+
+struct inst_list {
+	struct list_head		list;
+	const char			*name;
+	struct handle_list		*handle;
+
+	/* Identify the top instance in the input trace. */
+	bool				was_top_instance;
+
+	/* Identify the top instance in the output trace. */
+	bool				is_top_instance;
+};
+
+static void free_inst(struct list_head *list)
+{
+	struct inst_list *item;
+
+	while (!list_empty(list)) {
+		item = container_of(list->next, struct inst_list, list);
+		list_del(&item->list);
+		free((char *)item->name);
+		free(item);
+	}
+}
+
+static struct inst_list *add_inst(const char *name, bool was_top_instance,
+				  bool is_top_instance)
+{
+	struct inst_list *item;
+
+	item = calloc(1, sizeof(*item));
+	if (!item)
+		die("Failed to allocate output_file item");
+
+	item->name = strdup(name);
+	if (!item->name)
+		die("Failed to duplicate %s", name);
+
+	item->was_top_instance = was_top_instance;
+	item->is_top_instance = is_top_instance;
+	list_add_tail(&item->list, &inst_list);
+	return item;
+}
+
 static int create_type_len(struct tep_handle *pevent, int time, int len)
 {
 	static int bigendian = -1;
@@ -481,8 +523,8 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 				     bool *end_reached)
 {
 	unsigned long long current = 0;
-	struct handle_list *handle_entry;
 	struct tracecmd_output *ohandle;
+	struct inst_list *inst_entry;
 	struct cpu_data *cpu_data;
 	struct tep_record *record;
 	bool all_end_reached = true;
@@ -496,18 +538,18 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 	ohandle = tracecmd_copy(handle, output_file, TRACECMD_FILE_CMD_LINES, 0, NULL);
 	tracecmd_set_out_clock(ohandle, tracecmd_get_trace_clock(handle));
 
-	list_for_each_entry(handle_entry, &handle_list, list) {
+	list_for_each_entry(inst_entry, &inst_list, list) {
 		struct tracecmd_input *curr_handle;
 		bool curr_end_reached = false;
 
-		curr_handle = handle_entry->handle;
+		curr_handle = inst_entry->handle->handle;
 		cpus = tracecmd_cpus(curr_handle);
 		cpu_data = malloc(sizeof(*cpu_data) * cpus);
 		if (!cpu_data)
 			die("Failed to allocate cpu_data for %d cpus", cpus);
 
 		for (cpu = 0; cpu < cpus; cpu++) {
-			file = get_temp_file(output_file, handle_entry->name, cpu);
+			file = get_temp_file(output_file, inst_entry->name, cpu);
 			touch_file(file);
 
 			fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
@@ -540,10 +582,10 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 		for (cpu = 0; cpu < cpus; cpu++)
 			cpu_list[cpu] = cpu_data[cpu].file;
 
-		if (handle_entry->was_top_instance)
+		if (inst_entry->is_top_instance)
 			ret = tracecmd_append_cpu_data(ohandle, cpus, cpu_list);
 		else
-			ret = tracecmd_append_buffer_cpu_data(ohandle, handle_entry->name, cpus,
+			ret = tracecmd_append_buffer_cpu_data(ohandle, inst_entry->name, cpus,
 							      cpu_list);
 		if (ret < 0)
 			die("Failed to append tracing data\n");
@@ -573,11 +615,80 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 	return current;
 }
 
+/* Map the instance names to their handle. */
+static void map_inst_handle(void)
+{
+	struct handle_list *handle_entry;
+	struct inst_list *inst_entry;
+
+	/*
+	 * No specific instance was given for this output file.
+	 * Add all the available instances.
+	 */
+	if (list_empty(&inst_list)) {
+		list_for_each_entry(handle_entry, &handle_list, list) {
+			add_inst(handle_entry->name, handle_entry->was_top_instance,
+				 handle_entry->was_top_instance);
+		}
+	}
+
+	list_for_each_entry(inst_entry, &inst_list, list) {
+		list_for_each_entry(handle_entry, &handle_list, list) {
+			if ((inst_entry->was_top_instance &&
+			     handle_entry->was_top_instance) ||
+			    (!inst_entry->was_top_instance &&
+			     !strcmp(handle_entry->name, inst_entry->name))) {
+				inst_entry->handle = handle_entry;
+				goto found;
+			}
+		}
+
+		warning("Requested instance %s was not found in trace.", inst_entry->name);
+		break;
+found:
+		continue;
+	}
+}
+
+static bool is_top_instance_unique(void)
+{
+	struct inst_list *inst_entry;
+	bool has_top_buffer = false;
+
+	/* Check there is at most one top buffer. */
+	list_for_each_entry(inst_entry, &inst_list, list) {
+		if (inst_entry->is_top_instance) {
+			if (has_top_buffer)
+				return false;
+			has_top_buffer = true;
+		}
+	}
+
+	return true;
+}
+
+enum {
+	OPT_top = 237,
+};
+
+/*
+ * Used to identify the arg. previously parsed.
+ * E.g. '-b' can only follow '--top'.
+ */
+enum prev_arg_type {
+	PREV_IS_NONE,
+	PREV_IS_TOP,
+	PREV_IS_BUFFER,
+};
+
 void trace_split (int argc, char **argv)
 {
 	struct tracecmd_input *handle;
 	unsigned long long start_ns = 0, end_ns = 0;
 	unsigned long long current;
+	enum prev_arg_type prev_arg_type;
+	struct inst_list *prev_inst = NULL;
+	int prev_arg_idx;
 	bool end_reached = false;
 	double start, end;
 	char *endptr;
@@ -593,12 +704,22 @@ void trace_split (int argc, char **argv)
 	int ac;
 	int c;
 
+	static struct option long_options[] = {
+		{"top", optional_argument, NULL, OPT_top},
+		{NULL, 0, NULL, 0},
+	};
+	int option_index = 0;
+
+	prev_arg_type = PREV_IS_NONE;
+
 	list_head_init(&handle_list);
+	list_head_init(&inst_list);
 
 	if (strcmp(argv[1], "split") != 0)
 		usage(argv);
 
-	while ((c = getopt(argc-1, argv+1, "+ho:i:s:m:u:e:p:rcC:")) >= 0) {
+	while ((c = getopt_long(argc - 1, argv + 1, "+ho:i:s:m:u:e:p:rcC:B:b:t",
+				long_options, &option_index)) >= 0) {
 		switch (c) {
 		case 'h':
 			usage(argv);
@@ -641,11 +762,47 @@ void trace_split (int argc, char **argv)
 		case 'i':
 			input_file = optarg;
 			break;
+		case OPT_top:
+			prev_arg_type = PREV_IS_TOP;
+			prev_arg_idx = optind;
+			prev_inst = add_inst(default_top_instance_name, true, true);
+			break;
+		case 'b':
+			/* 1 as --top takes no argument. */
+			if (prev_arg_type != PREV_IS_TOP &&
+			    (prev_arg_idx != optind - 1))
+				usage(argv);
+			prev_arg_type = PREV_IS_NONE;
+
+			prev_inst->is_top_instance = false;
+
+			free((char *)prev_inst->name);
+			prev_inst->name = strdup(optarg);
+			if (!prev_inst->name)
+				die("Failed to duplicate %s", optarg);
+			break;
+		case 'B':
+			prev_arg_type = PREV_IS_BUFFER;
+			prev_arg_idx = optind;
+			prev_inst = add_inst(optarg, false, false);
+			break;
+		case 't':
+			/* 2 as -B takes an argument. */
+			if (prev_arg_type != PREV_IS_BUFFER &&
+			    (prev_arg_idx != optind - 2))
+				usage(argv);
+			prev_arg_type = PREV_IS_NONE;
+
+			prev_inst->is_top_instance = true;
+			break;
 		default:
 			usage(argv);
 		}
 	}
 
+	if (!is_top_instance_unique())
+		die("Can only have one top instance.");
+
 	ac = (argc - optind);
 
 	if (ac >= 2) {
@@ -713,6 +870,8 @@ void trace_split (int argc, char **argv)
 		}
 	}
 
+	map_inst_handle();
+
 	do {
 		if (repeat)
 			sprintf(output_file, "%s.%04d", output, c++);
@@ -732,6 +891,7 @@ void trace_split (int argc, char **argv)
 
 	tracecmd_close(handle);
 	free_handles(&handle_list);
+	free_inst(&inst_list);
 
 	return;
 }
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 6944a2c7..8bbf2e3e 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -311,6 +311,13 @@ static struct usage_help usage_help[] = {
 		"          -u n  split file up by n microseconds\n"
 		"          -e n  split file up by n events\n"
 		"          -p n  split file up by n pages\n"
+		"          -C n  select CPU n\n"
+		"          -B buffer  keep buffer in resulting .dat file\n"
+		"                     Use -t to promote the buffer to the top instance.\n"
+		"          -t    promote preceding buffer to the top instance.\n"
+		"                Must follow -B.\n"
+		"          --top keep top buffer in resulting .dat file.\n"
+		"          -b    new name of the top instance. Must follow --top.\n"
 		"          -r    repeat from start to end\n"
 		"          -c    per cpu, that is -p 2 will be 2 pages for each CPU\n"
 		"          if option is specified, it will split the file\n"
-- 
2.25.1

