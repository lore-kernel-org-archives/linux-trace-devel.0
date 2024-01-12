Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E788482F7
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 08:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69A221570;
	Fri, 12 Jan 2024 00:40:49 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.77.163])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 231F23F64C;
	Fri, 12 Jan 2024 00:40:02 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH 5/5] trace-cmd: split: Handle splitting files with multiple instances
Date: Fri, 12 Jan 2024 09:39:45 +0100
Message-Id: <20240112083945.1361293-6-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240112083945.1361293-1-pierre.gondois@arm.com>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
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

Make use of the previous patches to split all the instances of
a trace.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 109 ++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 50 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 6ab138a2..37ce4176 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -426,6 +426,7 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 				     bool *end_reached)
 {
 	unsigned long long current;
+	struct handle_list *handle_entry;
 	struct tracecmd_output *ohandle;
 	struct cpu_data *cpu_data;
 	struct tep_record *record;
@@ -437,63 +438,71 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
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
+		cpus = tracecmd_cpus(handle_entry->handle);
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
+				tracecmd_set_cpu_to_timestamp(handle_entry->handle, cpu, start);
+		}
+
+		if (only_cpu >= 0) {
+			parse_cpu(handle_entry->handle, cpu_data, start, end, count,
+				  1, only_cpu, type, end_reached);
+		} else if (percpu) {
+			for (cpu = 0; cpu < cpus; cpu++)
+				parse_cpu(handle_entry->handle, cpu_data, start,
+					  end, count, percpu, cpu, type, end_reached);
+		} else {
+			parse_cpu(handle_entry->handle, cpu_data, start,
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
+		if (!handle_entry->name)
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
+				record = tracecmd_read_at(handle, cpu_data[cpu].offset, NULL);
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
 	}
-	free(cpu_data);
-	free(cpu_list);
 
 	tracecmd_output_close(ohandle);
 
-- 
2.25.1

