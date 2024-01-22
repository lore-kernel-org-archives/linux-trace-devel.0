Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438C85813E
	for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jan 2024 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705941836; cv=none; b=Wb85Tryoe4SKAqHztfS71ULsMvwgQi7Es2mpB3EAvvXa3kyNWxiSVX7LHu804COuM2SzIJXSqEBDvuO0pWibfJFH8rBTOMpABCBf60e5FuMaL1H6L/Bjkn7sjm4bkkvEJEoVVgo5Cm00sb3wCcCB2zsvkoBnyyg0Y5HE4ypdcaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705941836; c=relaxed/simple;
	bh=qe8xUahKJlJc+jeSd8B02ijlGtLwUsSERzYcM5xwdaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GIPzHxrJd7Iy7OWKMiJGQ8t8fQgX5PksTUNqAudW8pTn1JPO8+imoXr6eZKI9KKs233HKGkEgitwavXq7nAVdKLs5Z1gEdummlM5hnD0pHsvv/RwGsfuhea35RGyJ/LXTALGMLNjt+mHzG9JGCWNzyrdkC+1qGxrzM8C3cs//X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 115171424;
	Mon, 22 Jan 2024 08:44:40 -0800 (PST)
Received: from e126645.nice.arm.com (e126645.nice.arm.com [10.34.100.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 54B723F5A1;
	Mon, 22 Jan 2024 08:43:53 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v2 5/7] trace-cmd split: Handle splitting files with multiple instances
Date: Mon, 22 Jan 2024 17:43:34 +0100
Message-Id: <20240122164336.167256-6-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240122164336.167256-1-pierre.gondois@arm.com>
References: <20240122164336.167256-1-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

trace-cmd can record events in multiple instances:
  $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch

When trying to split a trace.dat file recorded with the above command,
only the events located in the main buffer seems to be split. The
events recorded in the test_instance buffer seem to be discarded:
  $ trace-cmd split -i trace.dat -o trace_2.dat 284443 284444
  $ trace-cmd report trace_2.dat
    cpus=8
           <...>-525991 [004] 284443.173879: sched_wakeup: [...]
           <...>-525991 [004] 284443.173879: sched_wakeup: [...]
           <...>-525990 [007] 284443.173885: sched_wakeup: [...]
           <...>-525990 [007] 284443.173885: sched_wakeup: [...]
(no sign of sched_switch events)

Keep all instances/buffers of a trace when it is split.
Also add a 'get_handle()' function.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 137 ++++++++++++++++++++++++++---------------
 1 file changed, 87 insertions(+), 50 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 5f3ed940..9b37c75e 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -91,6 +91,29 @@ static void free_handles(struct list_head *list)
 	}
 }
 
+/**
+ * get_handle - Obtain a handle that must be closed once finished.
+ */
+static struct tracecmd_input *get_handle(struct handle_list *item)
+{
+	struct tracecmd_input *top_handle, *handle;
+
+	top_handle = tracecmd_open(input_file, 0);
+	if (!top_handle)
+		die("Error reading %s", input_file);
+
+	if (item->was_top_instance) {
+		return top_handle;
+	} else {
+		handle = tracecmd_buffer_instance_handle(top_handle, item->index);
+		if (!handle)
+			warning("Could not retrieve handle %s", item->name);
+
+		tracecmd_close(top_handle);
+		return handle;
+	}
+}
+
 static int create_type_len(struct tep_handle *pevent, int time, int len)
 {
 	static int bigendian = -1;
@@ -447,6 +470,7 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 				     bool *end_reached)
 {
 	unsigned long long current;
+	struct handle_list *handle_entry;
 	struct tracecmd_output *ohandle;
 	struct cpu_data *cpu_data;
 	struct tep_record *record;
@@ -454,66 +478,79 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 	char *file;
 	int cpus;
 	int cpu;
+	int ret;
 	int fd;
 
 	ohandle = tracecmd_copy(handle, output_file, TRACECMD_FILE_CMD_LINES, 0, NULL);
+	tracecmd_set_out_clock(ohandle, tracecmd_get_trace_clock(handle));
 
-	cpus = tracecmd_cpus(handle);
-	cpu_data = malloc(sizeof(*cpu_data) * cpus);
-	if (!cpu_data)
-		die("Failed to allocate cpu_data for %d cpus", cpus);
-
-	for (cpu = 0; cpu < cpus; cpu++) {
-		file = get_temp_file(output_file, NULL, cpu);
-		touch_file(file);
-
-		fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-		cpu_data[cpu].cpu = cpu;
-		cpu_data[cpu].fd = fd;
-		cpu_data[cpu].file = file;
-		cpu_data[cpu].offset = 0;
-		if (start)
-			tracecmd_set_cpu_to_timestamp(handle, cpu, start);
-	}
+	list_for_each_entry(handle_entry, &handle_list, list) {
+		struct tracecmd_input *curr_handle;
+
+		curr_handle = get_handle(handle_entry);
+		cpus = tracecmd_cpus(curr_handle);
+		cpu_data = malloc(sizeof(*cpu_data) * cpus);
+		if (!cpu_data)
+			die("Failed to allocate cpu_data for %d cpus", cpus);
 
-	if (only_cpu >= 0) {
-		parse_cpu(handle, cpu_data, start, end, count,
-			  1, only_cpu, type, end_reached);
-	} else if (percpu) {
+		for (cpu = 0; cpu < cpus; cpu++) {
+			file = get_temp_file(output_file, handle_entry->name, cpu);
+			touch_file(file);
+
+			fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+			cpu_data[cpu].cpu = cpu;
+			cpu_data[cpu].fd = fd;
+			cpu_data[cpu].file = file;
+			cpu_data[cpu].offset = 0;
+			if (start)
+				tracecmd_set_cpu_to_timestamp(curr_handle, cpu, start);
+		}
+
+		if (only_cpu >= 0) {
+			parse_cpu(curr_handle, cpu_data, start, end, count,
+				  1, only_cpu, type, end_reached);
+		} else if (percpu) {
+			for (cpu = 0; cpu < cpus; cpu++)
+				parse_cpu(curr_handle, cpu_data, start,
+					  end, count, percpu, cpu, type, end_reached);
+		} else {
+			parse_cpu(curr_handle, cpu_data, start,
+				  end, count, percpu, -1, type, end_reached);
+		}
+
+		cpu_list = malloc(sizeof(*cpu_list) * cpus);
+		if (!cpu_list)
+			die("Failed to allocate cpu_list for %d cpus", cpus);
 		for (cpu = 0; cpu < cpus; cpu++)
-			parse_cpu(handle, cpu_data, start,
-				  end, count, percpu, cpu, type, end_reached);
-	} else
-		parse_cpu(handle, cpu_data, start,
-			  end, count, percpu, -1, type, end_reached);
-
-	cpu_list = malloc(sizeof(*cpu_list) * cpus);
-	if (!cpu_list)
-		die("Failed to allocate cpu_list for %d cpus", cpus);
-	for (cpu = 0; cpu < cpus; cpu ++)
-		cpu_list[cpu] = cpu_data[cpu].file;
+			cpu_list[cpu] = cpu_data[cpu].file;
 
-	tracecmd_set_out_clock(ohandle, tracecmd_get_trace_clock(handle));
-	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
-		die("Failed to append tracing data\n");
-
-	for (cpu = 0; cpu < cpus; cpu++) {
-		/* Set the tracecmd cursor to the next set of records */
-		if (cpu_data[cpu].offset) {
-			record = tracecmd_read_at(handle, cpu_data[cpu].offset, NULL);
-			if (record && (!current || record->ts > current))
-				current = record->ts + 1;
-			tracecmd_free_record(record);
+		if (handle_entry->is_top_instance)
+			ret = tracecmd_append_cpu_data(ohandle, cpus, cpu_list);
+		else
+			ret = tracecmd_append_buffer_cpu_data(ohandle, handle_entry->name, cpus,
+							      cpu_list);
+		if (ret < 0)
+			die("Failed to append tracing data\n");
+
+		for (cpu = 0; cpu < cpus; cpu++) {
+			/* Set the tracecmd cursor to the next set of records */
+			if (cpu_data[cpu].offset) {
+				record = tracecmd_read_at(curr_handle, cpu_data[cpu].offset, NULL);
+				if (record && (!current || record->ts > current))
+					current = record->ts + 1;
+				tracecmd_free_record(record);
+			}
 		}
-	}
 
-	for (cpu = 0; cpu < cpus; cpu++) {
-		close(cpu_data[cpu].fd);
-		delete_temp_file(cpu_data[cpu].file);
-		put_temp_file(cpu_data[cpu].file);
+		for (cpu = 0; cpu < cpus; cpu++) {
+			close(cpu_data[cpu].fd);
+			delete_temp_file(cpu_data[cpu].file);
+			put_temp_file(cpu_data[cpu].file);
+		}
+		free(cpu_data);
+		free(cpu_list);
+		tracecmd_close(curr_handle);
 	}
-	free(cpu_data);
-	free(cpu_list);
 
 	tracecmd_output_close(ohandle);
 
-- 
2.25.1

