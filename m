Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD96B53E14
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 08:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 517CB12FC;
	Fri, 12 Jan 2024 00:40:45 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.77.163])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2DFEF3F64C;
	Fri, 12 Jan 2024 00:39:58 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH 2/5] trace-cmd: usage: Update usage for trace-cmd split
Date: Fri, 12 Jan 2024 09:39:42 +0100
Message-Id: <20240112083945.1361293-3-pierre.gondois@arm.com>
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

Update usage for 'trace-cmd split' command.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 21 +++++++++++++--------
 tracecmd/trace-usage.c |  3 ++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 6ccda2fc..b6c056b5 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -198,7 +198,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 		     unsigned long long start,
 		     unsigned long long end,
 		     int count_limit, int percpu, int cpu,
-		     enum split_types type)
+		     enum split_types type, bool *end_reached)
 {
 	struct tep_record *record;
 	struct tep_handle *pevent;
@@ -325,6 +325,9 @@ static int parse_cpu(struct tracecmd_input *handle,
 		}
 	}
 
+	if (record && (record->ts > end))
+		*end_reached = true;
+
 	if (record)
 		tracecmd_free_record(record);
 
@@ -352,7 +355,8 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 				     unsigned long long start,
 				     unsigned long long end, int percpu,
 				     int only_cpu, int count,
-				     enum split_types type)
+				     enum split_types type,
+				     bool *end_reached)
 {
 	unsigned long long current;
 	struct tracecmd_output *ohandle;
@@ -396,14 +400,14 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 
 	if (only_cpu >= 0) {
 		parse_cpu(handle, cpu_data, start, end, count,
-			  1, only_cpu, type);
+			  1, only_cpu, type, end_reached);
 	} else if (percpu) {
 		for (cpu = 0; cpu < cpus; cpu++)
 			parse_cpu(handle, cpu_data, start,
-				  end, count, percpu, cpu, type);
+				  end, count, percpu, cpu, type, end_reached);
 	} else
 		parse_cpu(handle, cpu_data, start,
-			  end, count, percpu, -1, type);
+			  end, count, percpu, -1, type, end_reached);
 
 	cpu_list = malloc(sizeof(*cpu_list) * cpus);
 	if (!cpu_list)
@@ -415,7 +419,6 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
 		die("Failed to append tracing data\n");
 
-	current = end;
 	for (cpu = 0; cpu < cpus; cpu++) {
 		/* Set the tracecmd cursor to the next set of records */
 		if (cpu_data[cpu].offset) {
@@ -440,6 +443,7 @@ void trace_split (int argc, char **argv)
 	struct tracecmd_input *handle;
 	unsigned long long start_ns = 0, end_ns = 0;
 	unsigned long long current;
+	bool end_reached = false;
 	double start, end;
 	char *endptr;
 	char *output = NULL;
@@ -564,11 +568,12 @@ void trace_split (int argc, char **argv)
 			strcpy(output_file, output);
 			
 		current = parse_file(handle, output_file, start_ns, end_ns,
-				     percpu, cpu, count, type);
+				     percpu, cpu, count, type, &end_reached);
+
 		if (!repeat)
 			break;
 		start_ns = 0;
-	} while (current && (!end_ns || current < end_ns));
+	} while (!end_reached && (current && (!end_ns || current < end_ns)));
 
 	free(output);
 	free(output_file);
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 61acce5f..433928d3 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -303,13 +303,14 @@ static struct usage_help usage_help[] = {
 	{
 		"split",
 		"parse a trace.dat file into smaller file(s)",
-		" %s split [options] -o file [start [end]]\n"
+		" %s split [-i file] [options] -o file [start [end]]\n"
 		"          -o output file to write to (file.1, file.2, etc)\n"
 		"          -s n  split file up by n seconds\n"
 		"          -m n  split file up by n milliseconds\n"
 		"          -u n  split file up by n microseconds\n"
 		"          -e n  split file up by n events\n"
 		"          -p n  split file up by n pages\n"
+		"          -C n  select CPU n\n"
 		"          -r    repeat from start to end\n"
 		"          -c    per cpu, that is -p 2 will be 2 pages for each CPU\n"
 		"          if option is specified, it will split the file\n"
-- 
2.25.1

