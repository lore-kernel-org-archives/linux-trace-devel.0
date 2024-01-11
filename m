Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4C858AA6
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FBBC43394;
	Thu, 11 Jan 2024 22:20:57 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rO3R3-00000000eGl-3RZl;
	Thu, 11 Jan 2024 17:22:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtracecmd: Just save timestamps and not the records in iterators
Date: Thu, 11 Jan 2024 17:15:38 -0500
Message-ID: <20240111222201.154686-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240111222201.154686-1-rostedt@goodmis.org>
References: <20240111222201.154686-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The iterators cache the records via a tracecmd_peek_data() to find the next
CPU record to use. The problem is that the callback() may do a
tracecmd_read_data() (the function graph plugin does) and this may
invalidate the cached record. It would require refreshing every record of
every cached CPU after every callback, which can be expensive.

Since only the timestamps of the records are needed, simply cache the
timestamp of the record to find which is the next CPU record to use. After
finding the CPU that has the earliest timestamp, do a tracecmd_peek_data()
test again to make sure the timestamp still matches the record. If it does,
then simply use that record, if not, refresh the timestamp for that CPU and
try again.

Fixes: 2cb6cc2f4 ("tracecmd library: Add tracecmd_iterate_events()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 60 ++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index bc937b0491d7..dbcbf3613686 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2807,9 +2807,9 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 					    int, void *),
 			    void *callback_data)
 {
-	struct tep_record **records;
 	struct tep_record *record;
-	unsigned long long last_timestamp = 0;
+	unsigned long long *timestamps;
+	unsigned long long ts, last_timestamp = 0;
 	int next_cpu;
 	int cpu;
 	int ret = 0;
@@ -2819,42 +2819,53 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 		return -1;
 	}
 
-	records = calloc(handle->cpus, sizeof(*records));
-	if (!records)
+	timestamps = calloc(handle->cpus, sizeof(*timestamps));
+	if (!timestamps)
 		return -1;
 
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
 		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
 			continue;
 
-		records[cpu] = tracecmd_peek_data(handle, cpu);
+		record = tracecmd_peek_data(handle, cpu);
+		timestamps[cpu] = record ? record->ts : -1ULL;
 	}
 
 	do {
 		next_cpu = -1;
 		for (cpu = 0; cpu < handle->cpus; cpu++) {
-			record = records[cpu];
-			if (!record)
+			ts = timestamps[cpu];
+			if (ts == -1ULL)
 				continue;
 
-			if (next_cpu < 0 || record->ts < last_timestamp) {
+			if (next_cpu < 0 || ts < last_timestamp) {
 				next_cpu = cpu;
-				last_timestamp = record->ts;
+				last_timestamp = ts;
 			}
 		}
 		if (next_cpu >= 0) {
+			record = tracecmd_peek_data(handle, next_cpu);
+
+			/* Make sure the record is still what we expect it to be */
+			if (!record || record->ts != last_timestamp) {
+				timestamps[next_cpu] = record ? record->ts : -1ULL;
+				continue;
+			}
+
 			/* Need to call read_data to increment to the next record */
 			record = tracecmd_read_data(handle, next_cpu);
 
 			ret = call_callbacks(handle, record, next_cpu,
 					     callback, callback_data);
 
-			records[next_cpu] = tracecmd_peek_data(handle, next_cpu);
 			tracecmd_free_record(record);
+
+			record = tracecmd_peek_data(handle, next_cpu);
+			timestamps[next_cpu] = record ? record->ts : -1ULL;
 		}
 	} while (next_cpu >= 0 && ret == 0);
 
-	free(records);
+	free(timestamps);
 
 	return ret;
 }
@@ -3036,7 +3047,7 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 }
 
 struct record_handle {
-	struct tep_record		*record;
+	unsigned long long		ts;
 	struct tracecmd_input		*handle;
 };
 
@@ -3063,7 +3074,7 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 	struct tracecmd_input *handle;
 	struct record_handle *records;
 	struct tep_record *record;
-	unsigned long long last_timestamp = 0;
+	unsigned long long ts, last_timestamp = 0;
 	int next_cpu;
 	int cpus = 0;
 	int all_cpus = 0;
@@ -3084,7 +3095,8 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 		handle = handles[i];
 		handle->start_cpu = all_cpus;
 		for (cpu = 0; cpu < handle->cpus; cpu++) {
-			records[all_cpus + cpu].record = tracecmd_peek_data(handle, cpu);
+			record = tracecmd_peek_data(handle, cpu);
+			records[all_cpus + cpu].ts = record ? record->ts : -1ULL;
 			records[all_cpus + cpu].handle = handle;
 		}
 		all_cpus += cpu;
@@ -3093,19 +3105,28 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 	do {
 		next_cpu = -1;
 		for (cpu = 0; cpu < all_cpus; cpu++) {
-			record = records[cpu].record;
-			if (!record)
+			ts = records[cpu].ts;
+			if (ts == -1ULL)
 				continue;
 
-			if (next_cpu < 0 || record->ts < last_timestamp) {
+			if (next_cpu < 0 || ts < last_timestamp) {
 				next_cpu = cpu;
-				last_timestamp = record->ts;
+				last_timestamp = ts;
 			}
 		}
 		if (next_cpu >= 0) {
-			record = records[next_cpu].record;
 			handle = records[next_cpu].handle;
 			cpu = next_cpu - handle->start_cpu;
+
+			/* Refresh record as callback could have changed */
+			record = tracecmd_peek_data(handle, cpu);
+
+			/* If the record updated, try again */
+			if (!record || record->ts != last_timestamp) {
+				records[next_cpu].ts = record ? record->ts : -1ULL;
+				continue;
+			}
+
 			/* Need to call read_data to increment to the next record */
 			record = tracecmd_read_data(handle, cpu);
 
@@ -3113,7 +3134,6 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 					     callback, callback_data);
 
 			tracecmd_free_record(record);
-			records[next_cpu].record = tracecmd_peek_data(handle, cpu);
 		}
 
 	} while (next_cpu >= 0 && ret == 0);
-- 
2.43.0

