Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F172179A8
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Oct 2023 16:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BCCC433C8;
	Sat,  7 Oct 2023 16:28:44 +0000 (UTC)
Date: Sat, 7 Oct 2023 12:28:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Add new TRACEEVAL_TYPE_DELTA
Message-ID: <20231007122842.31152c71@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a new traceeval_type called "delta". This type is a tuple of a delta
and a timestamp. It is a common occurrence to record a delta between
timestamps of two events and to record the delta with a stat. Instead of
creating two traceeval_data types (a number_64 timestamp and a number_64
delta), create a type that does that.

The TRACEEVAL_TYPE_DELTA is a structure of:

 struct {
	unsigned long long	delta;
	unsigned long long	timestamp;
 };

It automatically gets set as a STAT to retrieve statistics of the delta.
There's no need to supply another TIMESTAMP value as this will use the
given timestamp for the max and min saving.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h | 17 +++++++++++++++++
 samples/task-eval.c |  9 ++++-----
 samples/wake-lat.c  | 17 +++++------------
 src/histograms.c    | 30 ++++++++++++++++++++++++------
 4 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index 5464a5a55fe4..80d2ee1ee14f 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -50,6 +50,7 @@ enum traceeval_data_type {
 	TRACEEVAL_TYPE_NUMBER,
 	TRACEEVAL_TYPE_POINTER,
 	TRACEEVAL_TYPE_STRING,
+	TRACEEVAL_TYPE_DELTA,
 };
 
 /* Statistics specification flags */
@@ -61,6 +62,11 @@ enum traceeval_flags {
 	TRACEEVAL_FL_STAT		= (1 << 4),
 };
 
+struct traceeval_data_delta {
+	unsigned long long			delta;
+	unsigned long long			timestamp;
+};
+
 /*
  * Trace data entry for a traceeval histogram
  * Constitutes keys and values.
@@ -76,6 +82,7 @@ struct traceeval_data {
 		unsigned int			number_32;
 		unsigned short			number_16;
 		unsigned char			number_8;
+		struct traceeval_data_delta	delta;
 	};
 };
 
@@ -91,6 +98,9 @@ struct traceeval_data {
 #define DEFINE_TRACEEVAL_CSTRING(data)	   __TRACEEVAL_DATA(STRING, cstring, data)
 #define DEFINE_TRACEEVAL_POINTER(data)	   __TRACEEVAL_DATA(POINTER, pointer, data)
 
+#define DEFINE_TRACEEVAL_DELTA(data, ts) \
+	__TRACEEVAL_DATA(DELTA, { .delta = data, .timestamp = ts })
+
 #define __TRACEEVAL_SET(data, data_type, member, val)		\
 	do {							\
 		(data).type = TRACEEVAL_TYPE_##data_type;	\
@@ -120,6 +130,13 @@ struct traceeval_data {
 #define TRACEEVAL_SET_CSTRING(data, val)     __TRACEEVAL_SET_STR(data, STRING, cstring, val)
 #define TRACEEVAL_SET_POINTER(data, val)     __TRACEEVAL_SET(data, POINTER, pointer, val)
 
+#define TRACEEVAL_SET_DELTA(data, val_delta, val_ts)		\
+	do {							\
+		(data).type = TRACEEVAL_TYPE_DELTA;		\
+		(data).delta.delta = (val_delta);		\
+		(data).delta.timestamp = (val_ts);		\
+	} while (0)
+
 struct traceeval_type;
 struct traceeval;
 
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 3808212e2e84..ac00e2aeb813 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -130,9 +130,8 @@ static struct traceeval_type timestamp_vals[] = {
 
 static struct traceeval_type delta_vals[] = {
 	{
-		.type	= TRACEEVAL_TYPE_NUMBER_64,
+		.type	= TRACEEVAL_TYPE_DELTA,
 		.name	= "delta",
-		.flags = TRACEEVAL_FL_STAT,
 	},
 };
 
@@ -199,7 +198,7 @@ static void update_process(struct task_data *tdata, const char *comm,
 		if (!results[0].number_64)
 			break;
 
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
+		TRACEEVAL_SET_DELTA(new_vals[0], ts - results[0].number_64, ts);
 
 		ret = traceeval_insert(tdata->teval_processes.stop, keys, new_vals);
 		if (ret < 0)
@@ -314,7 +313,7 @@ static void update_cpu(struct teval_pair *teval_pair, int cpu,
 		if (!results[0].number_64)
 			break;
 
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
+		TRACEEVAL_SET_DELTA(new_vals[0], ts - results[0].number_64, ts);
 
 		ret = traceeval_insert(teval_pair->stop, keys, new_vals);
 		if (ret < 0)
@@ -373,7 +372,7 @@ static void update_thread(struct process_data *pdata, int tid,
 		if (ret == 0)
 			return;
 
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
+		TRACEEVAL_SET_DELTA(new_vals[0], ts - results[0].number_64, ts);
 
 		ret = traceeval_insert(pdata->teval_threads.stop, keys, new_vals);
 		traceeval_results_release(pdata->teval_threads.start, results);
diff --git a/samples/wake-lat.c b/samples/wake-lat.c
index 163815997793..1436dbda0874 100644
--- a/samples/wake-lat.c
+++ b/samples/wake-lat.c
@@ -35,16 +35,10 @@ struct traceeval_type sched_keys[] = {
 };
 
 struct traceeval_type sched_vals[] = {
-	{
-		.name		= "timestamp",
-		.flags		= TRACEEVAL_FL_TIMESTAMP,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
-	},
 	{
 		.name		= "delta",
-		.flags		= TRACEEVAL_FL_STAT,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
-	}
+		.type		= TRACEEVAL_TYPE_DELTA,
+	},
 };
 
 static int wakeup_callback(struct tracecmd_input *handle, struct tep_event *event,
@@ -82,7 +76,7 @@ static int sched_callback(struct tracecmd_input *handle, struct tep_event *event
 	long pid;
 	struct traceeval_data wakeup_keys[1];
 	struct traceeval_data keys[2];
-	struct traceeval_data vals[2];
+	struct traceeval_data vals[1];
 	const struct traceeval_data *results;
 	const char *comm;
 
@@ -106,8 +100,7 @@ static int sched_callback(struct tracecmd_input *handle, struct tep_event *event
 	TRACEEVAL_SET_CSTRING(keys[0],comm);
 	TRACEEVAL_SET_NUMBER(keys[1], pid);
 
-	TRACEEVAL_SET_NUMBER_64(vals[0], record->ts);
-	TRACEEVAL_SET_NUMBER_64(vals[1], delta);
+	TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
 
 	traceeval_insert(data->teval_sched, keys, vals);
 
@@ -125,7 +118,7 @@ static void show_latency(struct data *data)
 		unsigned long long val;
 		unsigned long long ts;
 
-		stat = traceeval_iterator_stat(iter, sched_vals[1].name);
+		stat = traceeval_iterator_stat(iter, sched_vals[0].name);
 		if (!stat)
 			continue;
 
diff --git a/src/histograms.c b/src/histograms.c
index 0cf52225a03a..ea938cee9254 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -74,6 +74,9 @@ static int compare_traceeval_data(struct traceeval *teval,
 	case TRACEEVAL_TYPE_NUMBER_8:
 		compare_numbers_return(orig->number_8, copy->number_8);
 
+	case TRACEEVAL_TYPE_DELTA:
+		compare_numbers_return(orig->delta.delta, copy->delta.delta);
+
 	default:
 		print_err("%d is an invalid enum traceeval_data_type member",
 				type->type);
@@ -244,6 +247,8 @@ static int check_vals(struct traceeval *teval, struct traceeval_type *vals, int
 			ts_found = true;
 			teval->timestamp_idx = i;
 		}
+		if (vals[i].type == TRACEEVAL_TYPE_DELTA)
+			vals[i].flags |= TRACEEVAL_FL_STAT;
 		vals[i].index = i;
 	}
 	if (!ts_found)
@@ -473,6 +478,9 @@ static unsigned make_hash(struct traceeval *teval, const struct traceeval_data *
 		case TRACEEVAL_TYPE_NUMBER:
 			val = keys[i].number_64;
 			break;
+		case TRACEEVAL_TYPE_DELTA:
+			val = keys[i].delta.delta;
+			break;
 		case TRACEEVAL_TYPE_STRING:
 			val = hash_string(keys[i].cstring);
 			break;
@@ -532,12 +540,11 @@ static bool is_stat_type(struct traceeval_type *type)
 	    !(type->flags & TRACEEVAL_FL_STAT))
 		return false;
 
+	if (type->type && type->type <= TRACEEVAL_TYPE_NUMBER)
+		return true;
+
 	switch (type->type) {
-	case TRACEEVAL_TYPE_NUMBER:
-	case TRACEEVAL_TYPE_NUMBER_64:
-	case TRACEEVAL_TYPE_NUMBER_32:
-	case TRACEEVAL_TYPE_NUMBER_16:
-	case TRACEEVAL_TYPE_NUMBER_8:
+	case TRACEEVAL_TYPE_DELTA:
 		return true;
 	default:
 		return false;
@@ -607,10 +614,21 @@ static int copy_traceeval_data(struct traceeval_type *type,
 		if (!dst->string)
 			return -1;
 		return 0;
+
+	case TRACEEVAL_TYPE_DELTA:
+		if (ts == (unsigned long long)-1)
+			return 0;
+
+		val = dst->delta.delta;
+		ts = dst->delta.timestamp;
+		break;
 	default:
 		return 0;
 	}
 
+	if (ts == (unsigned long long)-1)
+		return 0;
+
 	if (!stat || !is_stat_type(type))
 		return 0;
 
@@ -817,7 +835,7 @@ static int create_entry(struct traceeval *teval,
 
 	/* copy keys */
 	if (dup_traceeval_data_set(teval->nr_key_types, teval->key_types,
-				   NULL, keys, &new_keys, 0) == -1)
+				   NULL, keys, &new_keys, -1) == -1)
 		goto fail_stats;
 
 	/* copy vals */
-- 
2.40.1

