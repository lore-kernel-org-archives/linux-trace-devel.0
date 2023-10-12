Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C58249F0
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Oct 2023 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBBBC433C8;
	Thu, 12 Oct 2023 14:56:37 +0000 (UTC)
Date: Thu, 12 Oct 2023 10:58:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez  
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceeval: Remove TIMESTAMP and STAT flags from API
Message-ID: <20231012105801.3ca2c789@gandalf.local.home>
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

The TRACEEVAL_TYPE_DELTA can be used to keep track of numbers that require
maximum, minimum, count, total, average and stand deviation. This is
easier to use than to create a separate TRACEEVAL_FL_TIMESTAMP to keep
track of the time associated with a value that has a STAT flag.

Note, the logic is only removed from the API, that is, the traceeval_flags
no longer have them. They are now replied with:

  TRACEEVAL_FL_RESERVE_3
  TRACEEVAL_FL_RESERVE_4

The logic in the code still keeps it around in case we discover that
there's use cases where the TRACEEVAL_TYPE_DELTA does not suffice. But we
also have the option of simply removing it too.

The man pages have been updated to remove any mention of these flags, and
to use TRACEEVAL_TYPE_DELTA.

Also, added man pages for:

  traceeval_stat_average()
  traceeval_stat_stddev()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceeval-init.txt |  2 -
 Documentation/libtraceeval-stat.txt | 73 ++++++++++++++++++++++-------
 Documentation/libtraceeval.txt      |  2 +
 include/traceeval.h                 |  4 +-
 src/eval-local.h                    |  4 ++
 5 files changed, 64 insertions(+), 21 deletions(-)

diff --git a/Documentation/libtraceeval-init.txt b/Documentation/libtraceeval-init.txt
index 71251f2cc8ff..1c09cee319c8 100644
--- a/Documentation/libtraceeval-init.txt
+++ b/Documentation/libtraceeval-init.txt
@@ -128,8 +128,6 @@ enum traceeval_flags {
 	TRACEEVAL_FL_KEY		= (1 << 0),
 	TRACEEVAL_FL_VALUE		= (1 << 1),
 	TRACEEVAL_FL_SIGNED		= (1 << 2),
-	TRACEEVAL_FL_TIMESTAMP		= (1 << 3),
-	TRACEEVAL_FL_STAT		= (1 << 4),
 };
 --
 
diff --git a/Documentation/libtraceeval-stat.txt b/Documentation/libtraceeval-stat.txt
index 98861fe0273d..5544dae0c73a 100644
--- a/Documentation/libtraceeval-stat.txt
+++ b/Documentation/libtraceeval-stat.txt
@@ -4,7 +4,8 @@ libtraceeval(3)
 NAME
 ----
 traceeval_stat, traceeval_stat_size, traceeval_stat_max, traceeval_stat_min, traceeval_stat_max_timestamp,
-traceeval_stat_min_timestamp, traceeval_stat_total, traceeval_stat_count - Get statistics of an elements value/key in a traceeval.
+traceeval_stat_min_timestamp, traceeval_stat_total, traceeval_stat_count,
+traceeval_stat_average, traceeval_stat_stddev - Get statistics of an elements value/key in a traceeval.
 
 SYNOPSIS
 --------
@@ -26,24 +27,19 @@ unsigned long long *traceeval_stat_max_timestamp*(struct traceeval_stat pass:[*]
 unsigned long long *traceeval_stat_min_timestamp*(struct traceeval_stat pass:[*]_stat_, unsigned long long pass:[*]ts);
 unsigned long long *traceeval_stat_total*(struct traceeval_stat pass:[*]_stat_);
 unsigned long long *traceeval_stat_count*(struct traceeval_stat pass:[*]_stat_);
+unsigned long long *traceeval_stat_average*(struct traceeval_stat pass:[*]_stat_);
+double *traceeval_stat_stddev*(struct traceeval_stat pass:[*]_stat_);
 --
 
 DESCRIPTION
 -----------
-If a type of a value is numeric (*TRACEEVAL_TYPE_NUMBERpass:[*]*) and has the
-*TRACEEVAL_FL_STAT* flag set, then every instance added will save the maximum,
-minimum, count and total for that value. These functions are used to retrieve
-that information.
-
-If one of the values has *TRACEEVAL_FL_TIMESTAMP* set, that value will also be used
-to record that value for when a maximum or minimum stat value is hit. Note that
-a value can not have both the *TRACEEVAL_FL_TIMESTAMP* and *TRACEEVAL_FL_STAT* flags set.
-That will cause an error when creating the traceeval via *traceeval_init*(3).
-Note that fields marked with *TRACEEVAL_FL_TIMESTAMP* must also be of the
-*TRACEEVAL_TYPE_NUMBERpass:[*]* types.
+If a type of a value is *TRACEEVAL_TYPE_DELTA* then every instance added will save the maximum,
+minimum, count, total and standard deviation for that value. The maximum and minimum values will also
+record the timestamp that is passed in with the delta and keep track of timestamp where
+the maximum or minimum delto occurred.
 
 The *traceeval_stat()* will return a struct traceeval_stat descriptor for the
-given field that is numeric and is marked as a stat type. The _teval_ is the
+given field that is a *TRACEEVAL_TYPE_DELTA* type. The _teval_ is the
 traceeval descriptor that contains the elements, the _keys_ are the keys to find
 the element to get the stats of the vals, and _val_name_ is the name of the value
 field to retrieve the stats from (this is the same name for the field passed to
@@ -63,11 +59,9 @@ the _stat_ descriptor passed in.
 
 The *traceeval_stat_max_timestamp()* and *traceeval_stat_min_timestamp()* functions
 return the same result as the *traceeval_stat_max()* and *traceeval_stat_min()* functions
-respectively, but they take another parameter. The _ts_ is a pointer to a unsigend long long that
+respectively, but they take another parameter. The _ts_ is a pointer to a unsigned long long that
 if not NULL, will be used to return the timestamp of when the maximum or minimum values
-respectively were retrieved. This only works if another field of the traceeval descriptor
-values was marked as *TRACEEVAL_FL_TIMESTAMP*. That field is saved when a new maximum or
-minimum is found.
+respectively were retrieved.
 
 The *traceeval_stat_total()* returns the sum of all the values of the field that the _stat_
 represents.
@@ -80,6 +74,51 @@ of elements does not affect the count of the traceeval_stat, and the same goes f
 the total count. The number returned from this function can safely be used against the number
 returned by *traceeval_stat_total()* to calculate the average.
 
+The *traceeval_stat_average()* returns the average mean of all the entries represented by _stat_.
+Note, this is just a helper function as the same could be calculated by:
+
+[verse]
+--
+  unsigned long long traceeval_stat_average(struct traceeval_stat *stat)
+  {
+          unsigned long long count = traceeval_stat_count(stat);
+
+          if (!count)
+                  return 0;
+          return traceeval_stat_total(stat) / count;
+  }
+--
+
+The *traceeval_stat_stddev()* returns the calculated standard deviation. The standard deviation
+is calculated via the Welford's method. That is, for every instance added, the following is
+performed:
+
+[verse]
+--
+  void add_value(unsigned long long delta, unsigned long long *count, double *M, double *M2)
+  {
+          double D;
+
+          (*count)++;
+          if (*count == 1) {
+                  *M = delta;
+                  *M2 = 0.0;
+                  return;
+          }
+          D = delta - *M;
+          (*M) += D / *count;
+          (*M2) += D * (val - *M);
+  }
+
+  double traceeval_stat_stddev(stat)
+  {
+          if (count < 2)
+                  return 0.0;
+
+          return sqrt(M2 / (count - 1));
+  }
+--
+
 RETURN VALUE
 ------------
 The *traceeval_stat()* and *traceeval_stat_size()* both return a descriptor to a traceeval_stat
diff --git a/Documentation/libtraceeval.txt b/Documentation/libtraceeval.txt
index 173b1ddb3df8..e65ebd270445 100644
--- a/Documentation/libtraceeval.txt
+++ b/Documentation/libtraceeval.txt
@@ -74,6 +74,8 @@ Functions to manage statistics of values of a traceeval:
 	unsigned long long *traceeval_stat_min_timestamp*(struct traceeval_stat pass:[*]_stat_, unsigned long long pass:[*]ts);
 	unsigned long long *traceeval_stat_total*(struct traceeval_stat pass:[*]_stat_);
 	unsigned long long *traceeval_stat_count*(struct traceeval_stat pass:[*]_stat_);
+	unsigned long long *traceeval_stat_average*(struct traceeval_stat pass:[*]_stat_);
+	double *traceeval_stat_stddev*(struct traceeval_stat pass:[*]_stat_);
 --
 
 DESCRIPTION
diff --git a/include/traceeval.h b/include/traceeval.h
index 58c220c0f81c..99b3f7b86915 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -59,8 +59,8 @@ enum traceeval_flags {
 	TRACEEVAL_FL_KEY		= (1 << 0),
 	TRACEEVAL_FL_VALUE		= (1 << 1),
 	TRACEEVAL_FL_SIGNED		= (1 << 2),
-	TRACEEVAL_FL_TIMESTAMP		= (1 << 3),
-	TRACEEVAL_FL_STAT		= (1 << 4),
+	TRACEEVAL_FL_RESERVE_3		= (1 << 3),
+	TRACEEVAL_FL_RESERVE_4		= (1 << 4),
 };
 
 enum traceeval_log_level {
diff --git a/src/eval-local.h b/src/eval-local.h
index 9f387e500efa..4f5f702434f1 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -4,6 +4,10 @@
 
 #include <string.h>
 
+/* For possible future use */
+#define TRACEEVAL_FL_TIMESTAMP	TRACEEVAL_FL_RESERVE_3
+#define TRACEEVAL_FL_STAT	TRACEEVAL_FL_RESERVE_4
+
 #define __hidden __attribute__((visibility ("hidden")))
 #define __weak __attribute__((weak))
 
-- 
2.42.0

