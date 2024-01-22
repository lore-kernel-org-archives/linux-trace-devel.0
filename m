Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271BE58135
	for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jan 2024 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705941834; cv=none; b=G8Dy9E/6mb7WLq8M8Ol63NuqhXmOpQMH4YK+x6A9rYHJ9mlZRUy2QpdYIWypbIpfK/5hp5KsFjle8JSbyVu1JSDPROQZxH/Ujop+bwCzyCLvSfoJ5r5owNJJEbFS/4utD9KR7WAwzLXZSKFS6Cdg5guqU0ds3lEOmRqhygTlsDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705941834; c=relaxed/simple;
	bh=i1Q+EyUhY8k4F+AYsYU5n2kIa2RdLHDm+9C+LXDefd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u7RrZMjhwHK28uy+05DP8LOebnXw20CYpHh9TqKVfpTwVtqX8VLb6rCwOPj08f0/EKckR57xJG8ifcD9aCPyOkKMji7zEmNP59BRiMroD4mocJ9S78qw7Rebd3+EXqfxmHlgEoMMUojNfSfZwp58GMGi/sI87uZX1RtO2SPeBzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83024106F;
	Mon, 22 Jan 2024 08:44:37 -0800 (PST)
Received: from e126645.nice.arm.com (e126645.nice.arm.com [10.34.100.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C47163F5A1;
	Mon, 22 Jan 2024 08:43:50 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v2 2/7] trace-cmd split: Correctly split with start/end/time-window parameters
Date: Mon, 22 Jan 2024 17:43:31 +0100
Message-Id: <20240122164336.167256-3-pierre.gondois@arm.com>
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

With a trace.dat file having events timestamped between
[284443.0, 284448.0] seconds, the following command:
  trace-cmd split -i trace.dat -o trace2.dat -r -m 100 284444 284445
should produce ten trace2.dat.XXX files between [284444.0, 284445.0],
each one lasting 100ms.

Currently only one trace2.dat.001 file is produced, with events
within the [284444.0, 284445.1] time window.

Don't stop splitting the input file after the first iteration.
Add a end_reached to detect when the end timestamp is reached.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

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
-- 
2.25.1

