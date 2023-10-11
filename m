Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DA9A41
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 17:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238F7C433C7;
	Wed, 11 Oct 2023 17:37:12 +0000 (UTC)
Date: Wed, 11 Oct 2023 13:38:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Add average and standard deviation to stat
Message-ID: <20231011133834.7b89a784@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the APIs:

 traceeval_stat_average()
 traceeval_stat_stddev()

That return the average mean and standard deviation respectively of all
the values in the stat.

It uses the Welford method of computing the running standard deviation,
which is:

 count = 0;

 calculate(x) {
    if (!count) {
       count = 1;
       M = x;
       M2 = 0.0;
    } else {
        double D;

        count++;
        D = x - M;
        M += D / count;
        M2 = D * (x - M);
    }
 }

 stddev() {
    return sqrt(M2 / (count - 1))
 }

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h |  2 ++
 samples/task-eval.c | 22 ++++++++++++++++++++-
 scripts/utils.mk    |  2 +-
 src/Makefile        |  2 ++
 src/eval-local.h    |  3 ++-
 src/histograms.c    | 47 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index 55d6df67375a..69c7c45a7bea 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -345,6 +345,8 @@ unsigned long long traceeval_stat_max_timestamp(struct traceeval_stat *stat,
 						unsigned long long *ts);
 unsigned long long traceeval_stat_min_timestamp(struct traceeval_stat *stat,
 						unsigned long long *ts);
+unsigned long long traceeval_stat_average(struct traceeval_stat *stat);
+double traceeval_stat_stddev(struct traceeval_stat *stat);
 
 struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval);
 struct traceeval_iterator *traceeval_iterator_delta_start_get(struct traceeval *teval);
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 382e30514ec3..199c3b5dd926 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -814,6 +814,7 @@ static int compare_pdata(struct traceeval *teval,
 static void display_cpus(struct traceeval *teval)
 {
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	unsigned long long max, max_ts, min, min_ts;
 	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
 	int last_cpu = -1;
@@ -834,6 +835,9 @@ static void display_cpus(struct traceeval *teval)
 		if (!stat)
 			continue; // die?
 
+		max = traceeval_stat_max_timestamp(stat, &max_ts);
+		min = traceeval_stat_min_timestamp(stat, &min_ts);
+
 		if (last_cpu != cpu)
 			printf("    CPU [%d]:\n", cpu);
 
@@ -853,6 +857,18 @@ static void display_cpus(struct traceeval *teval)
 		}
 		printf(" time (us):");
 		print_microseconds_nl(12, traceeval_stat_total(stat));
+		printf("              average (us):");
+		print_microseconds_nl(12, traceeval_stat_average(stat));
+		printf("                       max:");
+		print_microseconds(12, max);
+		printf("\tat: %lld\n", max_ts);
+		printf("                       min:");
+		print_microseconds(12, min);
+		printf("\tat: %lld\n", min_ts);
+		printf("                     count: %*lld\n", 11,
+			traceeval_stat_count(stat));
+		printf("                   stddev: %*.3f\n", 16,
+		       traceeval_stat_stddev(stat) / 1000);
 
 		last_cpu = cpu;
 	}
@@ -883,13 +899,17 @@ static void print_stats(int idx, struct traceeval_stat *stat)
 		printf("\tat: %lld\n", max_ts);
 	} else {
 		print_microseconds_nl(idx, total);
-		printf("%*s%*lld\n", 40 - idx, "count:", idx, cnt);
+		printf("%*s", 40 - idx, "average:");
+		print_microseconds_nl(idx, traceeval_stat_average(stat));
 		printf("%*s", 40 - idx, "max:");
 		print_microseconds(idx, max);
 		printf("\tat: %lld\n", max_ts);
 		printf("%*s", 40 - idx, "min:");
 		print_microseconds(idx, min);
 		printf("\tat: %lld\n", min_ts);
+		printf("%*s%*lld\n", 40 - idx, "count:", idx, cnt);
+		printf("%*s%*.3f\n", 40 - idx, "stddev:", idx + 4,
+		       traceeval_stat_stddev(stat) / 1000);
 	}
 }
 
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 2ffc349ab412..2a9ef3450772 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -101,7 +101,7 @@ extract_example =				\
 
 do_sample_build =							\
 	$(Q)($(print_sample_build)					\
-	$(CC) -o $1 $2 $(CFLAGS) $(LIBRARY_STATIC) $(LIBRARY_LIBS))
+	$(CC) -o $1 $2 $(CFLAGS) $(LIBRARY_STATIC) $(LIBRARY_LIBS) -lm)
 
 do_sample_obj =									\
 	$(Q)($(print_sample_obj)						\
diff --git a/src/Makefile b/src/Makefile
index 6f790b21bae4..a5a36261d662 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -9,6 +9,8 @@ OBJS += hash.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 
+LIBS = -lm
+
 $(LIBRARY_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
diff --git a/src/eval-local.h b/src/eval-local.h
index ca8195a2f4cb..5ae63841f39f 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -56,7 +56,8 @@ struct traceeval_stat {
 	unsigned long long	min;
 	unsigned long long	min_ts;
 	unsigned long long	total;
-	unsigned long long	std;
+	double	M;
+	double	M2;
 	size_t			count;
 };
 
diff --git a/src/histograms.c b/src/histograms.c
index e16f0e9e903e..3323fcacae4a 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <stdarg.h>
 #include <stdio.h>
+#include <math.h>
 
 #include <traceeval.h>
 #include "eval-local.h"
@@ -623,6 +624,8 @@ __hidden void _teval_update_stat(struct traceeval_type *type,
 				 unsigned long long val,
 				 unsigned long long ts)
 {
+	double D;
+
 	/* If both the delta and the timestamp are zero, ignore this */
 	if (!val && !ts)
 		return;
@@ -633,6 +636,8 @@ __hidden void _teval_update_stat(struct traceeval_type *type,
 		stat->max_ts = ts;
 		stat->min_ts = ts;
 		stat->total = val;
+		stat->M = (double)val;
+		stat->M2 = 0.0;
 		return;
 	}
 
@@ -657,6 +662,14 @@ __hidden void _teval_update_stat(struct traceeval_type *type,
 		}
 		stat->total += val;
 	}
+	/*
+	 * Welford's method for standard deviation:
+	 *   s^2 = 1 / (n - 1) * \Sum ((x - M_k-1) * (x - M_k))
+	 *   Where M_k is the mean of the current samples of k.
+	 */
+	D = val - stat->M;
+	stat->M += D / stat->count;
+	stat->M2 += D * (val - stat->M);
 }
 
 static bool is_stat_type(struct traceeval_type *type)
@@ -1126,6 +1139,40 @@ unsigned long long traceeval_stat_total(struct traceeval_stat *stat)
 	return stat->total;
 }
 
+/**
+ * traceeval_stat_average - return the average value of stat
+ * @stat: The stat structure that holds the stats
+ *
+ * Returns the calculated average within @stat.
+ */
+unsigned long long traceeval_stat_average(struct traceeval_stat *stat)
+{
+	return stat->total / stat->count;
+}
+
+/**
+ * traceeval_stat_stddev - return the standard deviation of stat
+ * @stat: The stat structure that holds the stats
+ *
+ * Returns the calculated standard deviation within @stat.
+ */
+double traceeval_stat_stddev(struct traceeval_stat *stat)
+{
+	double stddev;
+
+	if (stat->count < 2)
+		return 0.0;
+	/*
+	 * Welford's method for standard deviation:
+	 *   s^2 = 1 / (n - 1) * \Sum ((x - M_k-1) * (x - M_k))
+	 *   Where M_k is the mean of the current samples of k.
+	 */
+
+	stddev = stat->M2 / (stat->count - 1);
+
+	return sqrt(stddev);
+}
+
 /**
  * traceeval_stat_count - return count value of stat
  * @stat: The stat structure that holds the stats
-- 
2.42.0

