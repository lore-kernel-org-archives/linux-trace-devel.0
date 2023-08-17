Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C02C71134
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355712AbjHQWYa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355710AbjHQWYW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:24:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1C830C5
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FFB866D7D
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34080C433D9;
        Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWlPj-000UsX-2V;
        Thu, 17 Aug 2023 18:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5/9] libtraceeval histogram: Add type to traceeval_data and make it a structure
Date:   Thu, 17 Aug 2023 18:24:18 -0400
Message-Id: <20230817222422.118568-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817222422.118568-1-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Having a straight union for passing in the data that must match the types
is dangerous and prone for buggy code. If some data doesn't match its
type, there's nothing to catch it.

Instead of having a union traceeval_data of each type, have it be a
structure with a "type" field follow by a union, where the type defines
what kind of data it is.

Add helper macros to make it easy to define the data when using it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  88 ++++++++++++++++---------
 samples/task-eval.c      | 137 ++++++++++++++++-----------------------
 src/eval-local.h         |   4 +-
 src/histograms.c         |  68 +++++++++----------
 4 files changed, 150 insertions(+), 147 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 7d67673ce7e5..38d5dc878d3b 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -52,45 +52,75 @@ struct traceeval_dynamic {
  * Trace data entry for a traceeval histogram
  * Constitutes keys and values.
  */
-union traceeval_data {
-	struct traceeval_dynamic	dyn_data;
-	char				*string;
-	const char			*cstring;
-	void				*pointer;
-	unsigned long			number;
-	unsigned long long		number_64;
-	unsigned int			number_32;
-	unsigned short			number_16;
-	unsigned char			number_8;
+struct traceeval_data {
+	enum traceeval_data_type		type;
+	union {
+		struct traceeval_dynamic	dyn_data;
+		char				*string;
+		const char			*cstring;
+		void				*pointer;
+		unsigned long			number;
+		unsigned long long		number_64;
+		unsigned int			number_32;
+		unsigned short			number_16;
+		unsigned char			number_8;
+	};
 };
 
+#define __TRACEEVAL_DATA(data_type, member, data)			\
+	{  .type = TRACEEVAL_TYPE_##data_type, .member = (data) }
+
+#define DEFINE_TRACEEVAL_NUMBER(data)	   __TRACEEVAL_DATA(NUMBER, number, data)
+#define DEFINE_TRACEEVAL_NUMBER_8(data)	   __TRACEEVAL_DATA(NUMBER_8, number_8, data)
+#define DEFINE_TRACEEVAL_NUMBER_16(data)   __TRACEEVAL_DATA(NUMBER_16, number_16, data)
+#define DEFINE_TRACEEVAL_NUMBER_32(data)   __TRACEEVAL_DATA(NUMBER_32, number_32, data)
+#define DEFINE_TRACEEVAL_NUMBER_64(data)   __TRACEEVAL_DATA(NUMBER_64, number_64, data)
+#define DEFINE_TRACEEVAL_STRING(data)	   __TRACEEVAL_DATA(STRING, string, data)
+#define DEFINE_TRACEEVAL_CSTRING(data)	   __TRACEEVAL_DATA(STRING, cstring, data)
+#define DEFINE_TRACEEVAL_POINTER(data)	   __TRACEEVAL_DATA(POINTER, pointer, data)
+
+#define __TRACEEVAL_SET(data, data_type, member, val)		\
+	do {							\
+		(data).type = TRACEEVAL_TYPE_##data_type;	\
+		(data).member = (val);				\
+	} while (0)
+
+#define TRACEEVAL_SET_NUMBER(data, val)	     __TRACEEVAL_SET(data, NUMBER, number, val)
+#define TRACEEVAL_SET_NUMBER_8(data, val)    __TRACEEVAL_SET(data, NUMBER_8, number_8, val)
+#define TRACEEVAL_SET_NUMBER_16(data, val)   __TRACEEVAL_SET(data, NUMBER_16, number_16, val)
+#define TRACEEVAL_SET_NUMBER_32(data, val)   __TRACEEVAL_SET(data, NUMBER_32, number_32, val)
+#define TRACEEVAL_SET_NUMBER_64(data, val)   __TRACEEVAL_SET(data, NUMBER_64, number_64, val)
+#define TRACEEVAL_SET_STRING(data, val)	     __TRACEEVAL_SET(data, STRING, string, val)
+#define TRACEEVAL_SET_CSTRING(data, val)     __TRACEEVAL_SET(data, STRING, cstring, val)
+#define TRACEEVAL_SET_POINTER(data, val)     __TRACEEVAL_SET(data, POINTER, pointer, val)
+
 struct traceeval_type;
 struct traceeval;
 
 /* release function callback on traceeval_data */
 typedef void (*traceeval_data_release_fn)(const struct traceeval_type *type,
-					  union traceeval_data *data);
+					  struct traceeval_data *data);
 
 /* compare function callback to compare traceeval_data */
 typedef int (*traceeval_data_cmp_fn)(struct traceeval *teval,
 				     const struct traceeval_type *type,
-				     const union traceeval_data *A,
-				     const union traceeval_data *B);
+				     const struct traceeval_data *A,
+				     const struct traceeval_data *B);
 
 /* make a unique value */
 typedef int (*traceeval_data_hash_fn)(struct traceeval *teval,
 				      const struct traceeval_type *type,
-				      const union traceeval_data *data);
+				      const struct traceeval_data *data);
 
 typedef int (*traceeval_data_copy_fn)(const struct traceeval_type *type,
-				      union traceeval_data *dst,
-				      const union traceeval_data *src);
+				      struct traceeval_data *dst,
+				      const struct traceeval_data *src);
 
 typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
-				const union traceeval_data *Akeys,
-				const union traceeval_data *Avals,
-				const union traceeval_data *Bkeys,
-				const union traceeval_data *Bvals,
+				const struct traceeval_data *Akeys,
+				const struct traceeval_data *Avals,
+				const struct traceeval_data *Bkeys,
+				const struct traceeval_data *Bvals,
 				void *data);
 
 /*
@@ -157,20 +187,20 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
 void traceeval_release(struct traceeval *teval);
 
 int traceeval_insert(struct traceeval *teval,
-		     const union traceeval_data *keys,
-		     const union traceeval_data *vals);
+		     const struct traceeval_data *keys,
+		     const struct traceeval_data *vals);
 
 int traceeval_remove(struct traceeval *teval,
-		     const union traceeval_data *keys);
+		     const struct traceeval_data *keys);
 
-int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
-		    const union traceeval_data **results);
+int traceeval_query(struct traceeval *teval, const struct traceeval_data *keys,
+		    const struct traceeval_data **results);
 
 void traceeval_results_release(struct traceeval *teval,
-			       const union traceeval_data *results);
+			       const struct traceeval_data *results);
 
 struct traceeval_stat *traceeval_stat(struct traceeval *teval,
-				      const union traceeval_data *keys,
+				      const struct traceeval_data *keys,
 				      struct traceeval_type *type);
 
 unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
@@ -185,9 +215,9 @@ int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_fi
 int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
 				   traceeval_cmp_fn sort_fn, void *data);
 int traceeval_iterator_next(struct traceeval_iterator *iter,
-			    const union traceeval_data **keys);
+			    const struct traceeval_data **keys);
 int traceeval_iterator_query(struct traceeval_iterator *iter,
-			     const union traceeval_data **results);
+			     const struct traceeval_data **results);
 struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
 					       struct traceeval_type *type);
 int traceeval_iterator_remove(struct traceeval_iterator *iter);
diff --git a/samples/task-eval.c b/samples/task-eval.c
index bde167d1219b..ed3a1a95f097 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -190,21 +190,15 @@ static void update_process(struct task_data *tdata, const char *comm,
 			   enum sched_state state, enum command cmd,
 			   unsigned long long ts)
 {
-	union traceeval_data keys[] = {
-		{
-			.cstring	= comm,
-		},
-		{
-			.number		= state,
-		},
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_CSTRING(	comm	),
+		DEFINE_TRACEEVAL_NUMBER(	state	),
 	};
-	union traceeval_data vals[] = {
-		{
-			.number_64	= ts,
-		},
+	struct traceeval_data vals[] = {
+		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
 	};
-	union traceeval_data new_vals[1] = { };
-	const union traceeval_data *results;
+	struct traceeval_data new_vals[1] = { };
+	const struct traceeval_data *results;
 	int ret;
 
 	switch (cmd) {
@@ -222,14 +216,15 @@ static void update_process(struct task_data *tdata, const char *comm,
 		if (!results[0].number_64)
 			break;
 
-		new_vals[0].number_64 = ts - results[0].number_64;
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
 
 		ret = traceeval_insert(tdata->teval_processes.stop, keys, new_vals);
 		if (ret < 0)
 			pdie("Could not stop process");
 
 		/* Reset the start */
-		new_vals[0].number_64 = 0;
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
+
 		ret = traceeval_insert(tdata->teval_processes.start, keys, new_vals);
 		if (ret < 0)
 			pdie("Could not start CPU");
@@ -253,15 +248,11 @@ static void stop_process(struct task_data *tdata, const char *comm,
 static struct process_data *
 get_process_data(struct task_data *tdata, const char *comm)
 {
-	union traceeval_data keys[] = {
-		{
-			.cstring = comm,
-		},
-		{
-			.number = RUNNING,
-		}
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_CSTRING(	comm	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
 	};
-	const union traceeval_data *results;
+	const struct traceeval_data *results;
 	void *data;
 	int ret;
 
@@ -278,16 +269,12 @@ get_process_data(struct task_data *tdata, const char *comm)
 
 void set_process_data(struct task_data *tdata, const char *comm, void *data)
 {
-	union traceeval_data keys[] = {
-		{
-			.cstring = comm,
-		},
-		{
-			.number = RUNNING,
-		}
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_CSTRING(	comm	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
 	};
-	union traceeval_data new_vals[1] = { };
-	const union traceeval_data *results;
+	struct traceeval_data new_vals[1] = { };
+	const struct traceeval_data *results;
 	int ret;
 
 	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
@@ -296,7 +283,7 @@ void set_process_data(struct task_data *tdata, const char *comm, void *data)
 	if (ret < 0)
 		pdie("Could not query process data");
 
-	new_vals[0].pointer = data;
+	TRACEEVAL_SET_POINTER(new_vals[0], data);
 	ret = traceeval_insert(tdata->teval_processes_data, keys, new_vals);
 	if (ret < 0)
 		pdie("Failed to set process data");
@@ -309,21 +296,15 @@ static void update_cpu(struct teval_pair *teval_pair, int cpu,
 		       enum sched_state state, enum command cmd,
 		       unsigned long long ts)
 {
-	const union traceeval_data *results;
-	union traceeval_data keys[] = {
-		{
-			.number = cpu,
-		},
-		{
-			.number = state,
-		}
+	const struct traceeval_data *results;
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_NUMBER(	cpu	),
+		DEFINE_TRACEEVAL_NUMBER(	state	),
 	};
-	union traceeval_data vals[] = {
-		{
-			.number_64	= ts,
-		},
+	struct traceeval_data vals[] = {
+		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
 	};
-	union traceeval_data new_vals[1] = { };
+	struct traceeval_data new_vals[1] = { };
 	int ret;
 
 	switch (cmd) {
@@ -350,14 +331,14 @@ static void update_cpu(struct teval_pair *teval_pair, int cpu,
 		if (!results[0].number_64)
 			break;
 
-		new_vals[0].number_64 = ts - results[0].number_64;
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
 
 		ret = traceeval_insert(teval_pair->stop, keys, new_vals);
 		if (ret < 0)
 			pdie("Could not stop CPU");
 
 		/* Reset the start */
-		new_vals[0].number_64 = 0;
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
 		ret = traceeval_insert(teval_pair->start, keys, new_vals);
 		if (ret < 0)
 			pdie("Could not start CPU");
@@ -385,21 +366,15 @@ static void update_thread(struct process_data *pdata, int tid,
 			  enum sched_state state, enum command cmd,
 			  unsigned long long ts)
 {
-	const union traceeval_data *results;
-	union traceeval_data keys[] = {
-		{
-			.number = tid,
-		},
-		{
-			.number = state,
-		}
+	const struct traceeval_data *results;
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_NUMBER(	tid	),
+		DEFINE_TRACEEVAL_NUMBER(	state	),
 	};
-	union traceeval_data vals[] = {
-		{
-			.number_64	= ts,
-		},
+	struct traceeval_data vals[] = {
+		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
 	};
-	union traceeval_data new_vals[1] = { };
+	struct traceeval_data new_vals[1] = { };
 	int ret;
 
 	switch (cmd) {
@@ -415,7 +390,7 @@ static void update_thread(struct process_data *pdata, int tid,
 		if (ret == 0)
 			return;
 
-		new_vals[0].number_64 = ts - results[0].number_64;
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
 
 		ret = traceeval_insert(pdata->teval_threads.stop, keys, new_vals);
 		traceeval_results_release(pdata->teval_threads.start, results);
@@ -646,17 +621,19 @@ static void print_microseconds(int idx, unsigned long long nsecs)
  *  If RUNNING is equal, then sort by COMM.
  */
 static int compare_pdata(struct traceeval *teval_data,
-				const union traceeval_data *Akeys,
-				const union traceeval_data *Avals,
-				const union traceeval_data *Bkeys,
-				const union traceeval_data *Bvals,
+				const struct traceeval_data *Akeys,
+				const struct traceeval_data *Avals,
+				const struct traceeval_data *Bkeys,
+				const struct traceeval_data *Bvals,
 				void *data)
 {
 	struct traceeval *teval = data; /* The deltas are here */
-	union traceeval_data keysA[] = {
-		{ .cstring = Akeys[0].cstring }, { .number = RUNNING } };
-	union traceeval_data keysB[] = {
-		{ .cstring = Bkeys[0].cstring }, { .number = RUNNING } };
+	struct traceeval_data keysA[] = {
+		DEFINE_TRACEEVAL_CSTRING(	Akeys[0].cstring	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
+	struct traceeval_data keysB[] = {
+		DEFINE_TRACEEVAL_CSTRING(	Bkeys[0].cstring	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
 	struct traceeval_stat *statA;
 	struct traceeval_stat *statB;
 	unsigned long long totalA = -1;
@@ -690,7 +667,7 @@ static int compare_pdata(struct traceeval *teval_data,
 static void display_cpus(struct traceeval *teval)
 {
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
-	const union traceeval_data *keys;
+	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
 	int last_cpu = -1;
 
@@ -762,7 +739,7 @@ static void display_state_times(int state, unsigned long long total)
 static void display_threads(struct traceeval *teval)
 {
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
-	const union traceeval_data *keys;
+	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
 	int last_tid = -1;
 
@@ -802,13 +779,9 @@ static void display_process_stats(struct traceeval *teval,
 {
 	struct traceeval_stat *stat;
 	unsigned long long delta;
-	union traceeval_data keys[] = {
-		{
-			.cstring = comm,
-		},
-		{
-			.number = RUNNING,
-		}
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_CSTRING(	comm		),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING		),
 	};
 
 	for (int i = 0; i < OTHER; i++) {
@@ -826,13 +799,13 @@ static void display_processes(struct traceeval *teval,
 			      struct traceeval *teval_data)
 {
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval_data);
-	const union traceeval_data *keys;
+	const struct traceeval_data *keys;
 	int ret;
 
 	traceeval_iterator_sort_custom(iter, compare_pdata, teval);
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
-		const union traceeval_data *results;
+		const struct traceeval_data *results;
 		struct process_data *pdata = NULL;
 		const char *comm = keys[0].cstring;
 
@@ -857,7 +830,7 @@ static void display(struct task_data *tdata)
 {
 	struct traceeval *teval = tdata->teval_cpus.stop;
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
-	const union traceeval_data *keys;
+	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
 	unsigned long long total_time = 0;
 	unsigned long long idle_time = 0;
diff --git a/src/eval-local.h b/src/eval-local.h
index 73f52efdf0da..26b3c9b29929 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -56,8 +56,8 @@ struct traceeval_stat {
 /* A key-value pair */
 struct entry {
 	struct hash_item	hash;
-	union traceeval_data	*keys;
-	union traceeval_data	*vals;
+	struct traceeval_data	*keys;
+	struct traceeval_data	*vals;
 	struct traceeval_stat	*val_stats;
 };
 
diff --git a/src/histograms.c b/src/histograms.c
index 0fbd9e0a353e..7c0eef6cf421 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -37,8 +37,8 @@ static void print_err(const char *fmt, ...)
  */
 static int compare_traceeval_data(struct traceeval *teval,
 				  struct traceeval_type *type,
-				  const union traceeval_data *orig,
-				  const union traceeval_data *copy)
+				  const struct traceeval_data *orig,
+				  const struct traceeval_data *copy)
 {
 	int i;
 
@@ -86,14 +86,14 @@ static int compare_traceeval_data(struct traceeval *teval,
 }
 
 /*
- * Compare arrays of union traceeval_data's with respect to @def.
+ * Compare arrays of struct traceeval_data's with respect to @def.
  *
  * Return 1 if @orig and @copy are the same, 0 if not, and -1 on error.
  */
 static int compare_traceeval_data_set(struct traceeval *teval,
 				      struct traceeval_type *defs,
-				      union traceeval_data *orig,
-				      const union traceeval_data *copy, size_t size)
+				      struct traceeval_data *orig,
+				      const struct traceeval_data *copy, size_t size)
 {
 	int check;
 	size_t i;
@@ -335,7 +335,7 @@ fail:
 /*
  * Frees dynamic data in @data if @type specifies a dynamic data type.
  */
-static void clean_data(union traceeval_data *data, struct traceeval_type *type)
+static void clean_data(struct traceeval_data *data, struct traceeval_type *type)
 {
 		if (type->release)
 			type->release(type, data);
@@ -352,7 +352,7 @@ static void clean_data(union traceeval_data *data, struct traceeval_type *type)
 /*
  * Free any specified dynamic data in @data.
  */
-static void clean_data_set(union traceeval_data *data, struct traceeval_type *defs,
+static void clean_data_set(struct traceeval_data *data, struct traceeval_type *defs,
 		       size_t size)
 {
 	size_t i;
@@ -431,7 +431,7 @@ void traceeval_release(struct traceeval *teval)
 	free(teval);
 }
 
-static unsigned make_hash(struct traceeval *teval, const union traceeval_data *keys,
+static unsigned make_hash(struct traceeval *teval, const struct traceeval_data *keys,
 			  int bits)
 {
 	const struct traceeval_type *types = teval->key_types;
@@ -470,7 +470,7 @@ static unsigned make_hash(struct traceeval *teval, const union traceeval_data *k
  *
  * Returns 1 on success, 0 if no match found, -1 on error.
  */
-static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
+static int get_entry(struct traceeval *teval, const struct traceeval_data *keys,
 		     struct entry **result)
 {
 	struct hash_table *hist = teval->hist;
@@ -506,8 +506,8 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
  */
 static int copy_traceeval_data(struct traceeval_type *type,
 			       struct traceeval_stat *stat,
-			       union traceeval_data *dst,
-			       const union traceeval_data *src)
+			       struct traceeval_data *dst,
+			       const struct traceeval_data *src)
 {
 	unsigned long long val;
 
@@ -597,7 +597,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
  *
  * Does not call the release() callback if a copy() exists.
  */
-static void data_release(size_t size, union traceeval_data *data,
+static void data_release(size_t size, struct traceeval_data *data,
 			 struct traceeval_type *type)
 {
 	for (size_t i = 0; i < size; i++) {
@@ -610,7 +610,7 @@ static void data_release(size_t size, union traceeval_data *data,
 	}
 }
 
-static void data_release_and_free(size_t size, union traceeval_data **data,
+static void data_release_and_free(size_t size, struct traceeval_data **data,
 				struct traceeval_type *type)
 {
 	data_release(size, *data, type);
@@ -625,8 +625,8 @@ static void data_release_and_free(size_t size, union traceeval_data **data,
  */
 static int dup_traceeval_data_set(size_t size, struct traceeval_type *type,
 				  struct traceeval_stat *stats,
-				  const union traceeval_data *orig,
-				  union traceeval_data **copy)
+				  const struct traceeval_data *orig,
+				  struct traceeval_data **copy)
 {
 	size_t i;
 
@@ -669,8 +669,8 @@ fail:
  *
  * Returns 1 if found, 0 if not found, and -1 on error.
  */
-int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
-		    const union traceeval_data **results)
+int traceeval_query(struct traceeval *teval, const struct traceeval_data *keys,
+		    const struct traceeval_data **results)
 {
 	struct entry *entry;
 	int check;
@@ -698,7 +698,7 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
  * allow traceeval to clean up its references.
  */
 void traceeval_results_release(struct traceeval *teval,
-			       const union traceeval_data *results)
+			       const struct traceeval_data *results)
 {
 	if (!teval || !results) {
 		if (!teval)
@@ -708,7 +708,7 @@ void traceeval_results_release(struct traceeval *teval,
 }
 
 static struct entry *create_hist_entry(struct traceeval *teval,
-				       const union traceeval_data *keys)
+				       const struct traceeval_data *keys)
 {
 	struct hash_table *hist = teval->hist;
 	unsigned key = make_hash(teval, keys, hist->bits);
@@ -729,11 +729,11 @@ static struct entry *create_hist_entry(struct traceeval *teval,
  * Returns 0 on success, -1 on error.
  */
 static int create_entry(struct traceeval *teval,
-			const union traceeval_data *keys,
-			const union traceeval_data *vals)
+			const struct traceeval_data *keys,
+			const struct traceeval_data *vals)
 {
-	union traceeval_data *new_keys;
-	union traceeval_data *new_vals;
+	struct traceeval_data *new_keys;
+	struct traceeval_data *new_vals;
 	struct entry *entry;
 
 	entry = create_hist_entry(teval, keys);
@@ -780,12 +780,12 @@ fail_entry:
  * Return 0 on success, -1 on error.
  */
 static int update_entry(struct traceeval *teval, struct entry *entry,
-			const union traceeval_data *vals)
+			const struct traceeval_data *vals)
 {
 	struct traceeval_stat *stats = entry->val_stats;
 	struct traceeval_type *types = teval->val_types;
-	union traceeval_data *copy = entry->vals;
-	union traceeval_data old[teval->nr_val_types];
+	struct traceeval_data *copy = entry->vals;
+	struct traceeval_data old[teval->nr_val_types];
 	size_t size = teval->nr_val_types;
 	size_t i;
 
@@ -831,7 +831,7 @@ static bool is_stat_type(struct traceeval_type *type)
 }
 
 struct traceeval_stat *traceeval_stat(struct traceeval *teval,
-				      const union traceeval_data *keys,
+				      const struct traceeval_data *keys,
 				      struct traceeval_type *type)
 {
 	struct entry *entry;
@@ -923,8 +923,8 @@ unsigned long long traceeval_stat_count(struct traceeval_stat *stat)
  * Returns 0 on success, and -1 on error.
  */
 int traceeval_insert(struct traceeval *teval,
-		     const union traceeval_data *keys,
-		     const union traceeval_data *vals)
+		     const struct traceeval_data *keys,
+		     const struct traceeval_data *vals)
 {
 	struct entry *entry;
 	int check;
@@ -955,7 +955,7 @@ int traceeval_insert(struct traceeval *teval,
  *        -1 if there was an error.
  */
 int traceeval_remove(struct traceeval *teval,
-		     const union traceeval_data *keys)
+		     const struct traceeval_data *keys)
 {
 	struct hash_table *hist = teval->hist;
 	struct entry *entry;
@@ -1174,8 +1174,8 @@ static int iter_cmp(const void *A, const void *B, void *data)
 
 	for (int i = 0; i < iter->nr_sort; i++) {
 		struct traceeval_type *type;
-		union traceeval_data *dataA;
-		union traceeval_data *dataB;
+		struct traceeval_data *dataA;
+		struct traceeval_data *dataB;
 
 		type = iter->sort[i];
 
@@ -1293,7 +1293,7 @@ int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
  * Returns 1 if another entry is returned, or 0 if not (or negative on error)
  */
 int traceeval_iterator_next(struct traceeval_iterator *iter,
-			    const union traceeval_data **keys)
+			    const struct traceeval_data **keys)
 {
 	struct entry *entry;
 	int ret;
@@ -1333,7 +1333,7 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
  * Returns 1 if another entry is returned, or 0 if not (or negative on error)
  */
 int traceeval_iterator_query(struct traceeval_iterator *iter,
-			     const union traceeval_data **results)
+			     const struct traceeval_data **results)
 {
 	struct entry *entry;
 
-- 
2.40.1

