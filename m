Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFC1C15D
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B1BC433D9;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZT2-26;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 06/11] libtraceeval task-eval: Show max, min and count of deltas too
Date: Tue, 10 Oct 2023 23:25:22 -0400
Message-ID: <20231011032640.1804571-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231011032640.1804571-1-rostedt@goodmis.org>
References: <20231011032640.1804571-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of just showing the total numbers of the delta output, also show
the maximum, minimum and count, as well as the timestamps of where the max
and min occurred.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 64 +++++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 061d27374e66..4a500227cf11 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -646,9 +646,15 @@ static void print_microseconds(int idx, unsigned long long nsecs)
 
 	usecs = nsecs / 1000;
 	if (!nsecs || usecs)
-		printf("%*lld\n", idx, usecs);
+		printf("%*lld", idx, usecs);
 	else
-		printf("%*d.%03lld\n", idx, 0, nsecs);
+		printf("%*d.%03lld", idx, 0, nsecs);
+}
+
+static void print_microseconds_nl(int idx, unsigned long long nsecs)
+{
+	print_microseconds(idx, nsecs);
+	printf("\n");
 }
 
 /*
@@ -743,7 +749,7 @@ static void display_cpus(struct traceeval *teval)
 			break;
 		}
 		printf(" time (us):");
-		print_microseconds(12, traceeval_stat_total(stat));
+		print_microseconds_nl(12, traceeval_stat_total(stat));
 
 		last_cpu = cpu;
 	}
@@ -752,24 +758,54 @@ static void display_cpus(struct traceeval *teval)
 		die("No result for CPUs\n");
 }
 
-static void display_state_times(int state, unsigned long long total)
+static void print_stats(int idx, struct traceeval_stat *stat)
+{
+	unsigned long long total, max, min, cnt, max_ts, min_ts;
+
+	if (stat) {
+		total = traceeval_stat_total(stat);
+		max = traceeval_stat_max_timestamp(stat, &max_ts);
+		min = traceeval_stat_min_timestamp(stat, &min_ts);
+		cnt = traceeval_stat_count(stat);
+	} else {
+		total = max = max_ts = min = min_ts = cnt = 0;
+	}
+
+	if (!cnt) {
+		print_microseconds_nl(idx, total);
+	} else if (cnt == 1) {
+		print_microseconds(idx, total);
+		printf("\tat: %lld\n", max_ts);
+	} else {
+		print_microseconds_nl(idx, total);
+		printf("%*s%*lld\n", 40 - idx, "count:", idx, cnt);
+		printf("%*s", 40 - idx, "max:");
+		print_microseconds(idx, max);
+		printf("\tat: %lld\n", max_ts);
+		printf("%*s", 40 - idx, "min:");
+		print_microseconds(idx, min);
+		printf("\tat: %lld\n", min_ts);
+	}
+}
+
+static void display_state_times(int state, struct traceeval_stat *stat)
 {
 	switch (state) {
 	case RUNNING:
 		printf("      Total run time (us):");
-		print_microseconds(14, total);
+		print_stats(14, stat);
 		break;
 	case BLOCKED:
 		printf("      Total blocked time (us):");
-		print_microseconds(10, total);
+		print_stats(10, stat);
 		break;
 	case PREEMPT:
 		printf("      Total preempt time (us):");
-		print_microseconds(10, total);
+		print_stats(10, stat);
 		break;
 	case SLEEP:
 		printf("      Total sleep time (us):");
-		print_microseconds(12, total);
+		print_stats(12, stat);
 	}
 }
 
@@ -809,7 +845,7 @@ static void display_threads(struct traceeval *teval)
 		last_tid = tid;
 		last_prio = prio;
 
-		display_state_times(state, traceeval_stat_total(stat));
+		display_state_times(state, stat);
 	}
 
 	if (last_tid < 0)
@@ -827,7 +863,6 @@ static void display_process_stats(struct traceeval *teval,
 				  struct process_data *pdata, const char *comm)
 {
 	struct traceeval_stat *stat;
-	unsigned long long delta;
 	struct traceeval_data keys[] = {
 		DEFINE_TRACEEVAL_CSTRING(	comm		),
 		DEFINE_TRACEEVAL_NUMBER(	RUNNING		),
@@ -836,11 +871,8 @@ static void display_process_stats(struct traceeval *teval,
 	for (int i = 0; i < OTHER; i++) {
 		TRACEEVAL_SET_NUMBER(keys[1], i);
 
-		delta = 0;
 		stat = traceeval_stat(teval, keys, DELTA_NAME);
-		if (stat)
-			delta = traceeval_stat_total(stat);
-		display_state_times(i, delta);
+		display_state_times(i, stat);
 	}
 }
 
@@ -918,9 +950,9 @@ static void display(struct task_data *tdata)
 	}
 
 	printf("  Total  run time (us):");
-	print_microseconds(16, total_time);
+	print_microseconds_nl(16, total_time);
 	printf("  Total idle time (us):");
-	print_microseconds(16, idle_time);
+	print_microseconds_nl(16, idle_time);
 
 	display_cpus(tdata->teval_cpus);
 
-- 
2.42.0

