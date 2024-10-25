Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EDD1B85CA
	for <linux-trace-devel@vger.kernel.org>; Fri, 25 Oct 2024 07:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729842127; cv=none; b=P0Ip5xH/cyxZxyGOug0dcyWVJsku07/EjStLqhQThauN5mE4f/drroz/9ywghH6HbhKVThLn6SIlqozmwu3ihSRdoNJDZldr0UffCBYUSOx694I+yBb4Ri5kp2a0sfid8RO8Xw9Ag22lFPQajz+bvoapTni4xpSPxUKYXMbul/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729842127; c=relaxed/simple;
	bh=7hJbs6cyNzYdec/zkTGHOgKRvygqUOuj49be/cfq8vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSI9MRSlQzqLt3XSsI3hhaPt8LZvNTp4yQx0BsVBuzIQVCXO78G22gba6x5hUqbjI+ejFYEVPGLKTRMahQF7SuGIinQKXsZICL7z+0ti6b4K5wx9NjCg0jNXpMSNoTdYQ2oZikk2cdRe6uLPmanHOMIrCBljatwFICsqF0mYZNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291AAC4CEE4;
	Fri, 25 Oct 2024 07:42:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1t4Ey9-00000004r2n-0AEr;
	Fri, 25 Oct 2024 03:42:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] libtraceevent: Add DECLARE_TRACEEVAL_<types>
Date: Fri, 25 Oct 2024 03:40:46 -0400
Message-ID: <20241025074247.1157166-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025074247.1157166-1-rostedt@goodmis.org>
References: <20241025074247.1157166-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Using the format of:

  {
	.type = TRACEEVAL_TYPE_NUMBER,
 	.name = "Schedule state"
  },
  {
	.type = TRACEEVAL_TYPE_STRING,
	.name = "COMM",
  },
  {
	.type = TRACEEVAL_TYPE_NUMBER,
	.name = "Prio",
  },

Is cumbersome, instead add macros that make it easier to assign these
values:

	DECLARE_TRACEEVAL_NUMBER("Schedule state"),
	DECLARE_TRACEEVAL_STRING("COMM"),
	DECLARE_TRACEEVAL_NUMBER("Prio"),

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h |  19 +++++++
 samples/task-eval.c | 122 +++++++++-----------------------------------
 2 files changed, 43 insertions(+), 98 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index f02ecdd58ffb..7de59a302445 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -97,6 +97,24 @@ struct traceeval_data {
 	};
 };
 
+#define __TRACEEVAL_DECLARE(data_type, data_name)			\
+	{  .type = TRACEEVAL_TYPE_##data_type, .name = (data_name) }
+
+#define DECLARE_TRACEEVAL_NUMBER(data)	   __TRACEEVAL_DECLARE(NUMBER, data)
+#define DECLARE_TRACEEVAL_NUMBER_8(data)   __TRACEEVAL_DECLARE(NUMBER_8, data)
+#define DECLARE_TRACEEVAL_NUMBER_16(data)  __TRACEEVAL_DECLARE(NUMBER_16, data)
+#define DECLARE_TRACEEVAL_NUMBER_32(data)  __TRACEEVAL_DECLARE(NUMBER_32, data)
+#define DECLARE_TRACEEVAL_NUMBER_64(data)  __TRACEEVAL_DECLARE(NUMBER_64, data)
+#define DECLARE_TRACEEVAL_STRING(data)	   __TRACEEVAL_DECLARE(STRING, data)
+#define DECLARE_TRACEEVAL_CSTRING(data)	   __TRACEEVAL_DECLARE(STRING, data)
+#define DECLARE_TRACEEVAL_DELTA(data)	   __TRACEEVAL_DECLARE(DELTA, data)
+#define DECLARE_TRACEEVAL_POINTER(data_name, data_release, data_copy)	\
+	{								\
+		.type = TRACEEVAL_TYPE_POINTER,				\
+		.name = (data_name),					\
+		.release = data_release, .copy = data_copy,		\
+	}
+
 #define __TRACEEVAL_DATA(data_type, member, data)			\
 	{  .type = TRACEEVAL_TYPE_##data_type, .member = (data) }
 
@@ -362,6 +380,7 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
 			     const struct traceeval_data **results);
 void traceeval_iterator_results_release(struct traceeval_iterator *iter,
 					const struct traceeval_data *results);
+int traceeval_iterator_reset(struct traceeval_iterator *iter);
 struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
 					       const char *val_name);
 int traceeval_iterator_delta_stop(struct traceeval_iterator *iter,
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 47ccce8e4737..26197385c91d 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -104,10 +104,7 @@ enum sched_state {
  * sched_switch event.
  */
 static struct traceeval_type cpu_delta_keys[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "CPU",
-	},
+	DECLARE_TRACEEVAL_NUMBER("CPU"),
 };
 
 /*
@@ -117,10 +114,7 @@ static struct traceeval_type cpu_delta_keys[] = {
  * as RUNNING.
  */
 static struct traceeval_type cpu_delta_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Schedule state",
-	},
+	DECLARE_TRACEEVAL_NUMBER("Schedule state"),
 };
 
 static void start_cpu_data(struct traceeval *teval, int cpu, int state,
@@ -190,14 +184,8 @@ int cpu_last_state(struct traceeval *teval, int cpu, int *state)
  * The output will show all the CPUs and their IDLE vs RUNNING states.
  */
 static struct traceeval_type cpu_keys[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "CPU",
-	},
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Schedule state",
-	},
+	DECLARE_TRACEEVAL_NUMBER("CPU"),
+	DECLARE_TRACEEVAL_NUMBER("Schedule state"),
 };
 
 /*
@@ -205,10 +193,7 @@ static struct traceeval_type cpu_keys[] = {
  * CPU was in that state.
  */
 static struct traceeval_type cpu_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_DELTA,
-		.name = DELTA_NAME,
-	},
+	DECLARE_TRACEEVAL_DELTA(DELTA_NAME),
 };
 
 static void insert_cpu_data(struct traceeval *teval, int cpu, int state,
@@ -229,24 +214,15 @@ static void insert_cpu_data(struct traceeval *teval, int cpu, int state,
  * When tracking tasks and threads wake up timings.
  */
 static struct traceeval_type wakeup_delta_keys[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "PID",
-	},
+	DECLARE_TRACEEVAL_NUMBER("PID"),
 };
 
 /*
  * When finishing the timings of the task being woken up.
  */
 static struct traceeval_type wakeup_delta_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_STRING,
-		.name = "COMM",
-	},
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Prio",
-	},
+	DECLARE_TRACEEVAL_STRING("COMM"),
+	DECLARE_TRACEEVAL_NUMBER("Prio"),
 };
 
 static void start_wakeup_data(struct traceeval *teval, int pid,
@@ -292,10 +268,7 @@ static int stop_wakeup_data(struct traceeval *teval, int pid,
  * when scheduling out (for sleep state) or in (for running state).
  */
 static struct traceeval_type task_delta_keys[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "PID",
-	},
+	DECLARE_TRACEEVAL_NUMBER("PID"),
 };
 
 /*
@@ -304,18 +277,9 @@ static struct traceeval_type task_delta_keys[] = {
  * and the priority it had. This will be saved for the output.
  */
 static struct traceeval_type task_delta_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Schedule state"
-	},
-	{
-		.type = TRACEEVAL_TYPE_STRING,
-		.name = "COMM",
-	},
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Prio",
-	},
+	DECLARE_TRACEEVAL_NUMBER("Schedule state"),
+	DECLARE_TRACEEVAL_STRING("COMM"),
+	DECLARE_TRACEEVAL_NUMBER("Prio"),
 };
 
 static void start_task_data(struct traceeval *teval, int pid, int state,
@@ -367,14 +331,8 @@ static int stop_task_data(struct traceeval *teval, int pid, int *state,
  * they were in: RUNNING, BLOCKED, PREEMPTED, SLEEPING.
  */
 static struct traceeval_type task_keys[] = {
-	{
-		.type = TRACEEVAL_TYPE_STRING,
-		.name = "COMM"
-	},
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Schedule state"
-	},
+	DECLARE_TRACEEVAL_STRING("COMM"),
+	DECLARE_TRACEEVAL_NUMBER("Schedule state"),
 };
 
 static void release_data(const struct traceeval_type *type,
@@ -400,16 +358,8 @@ static int copy_data(const struct traceeval_type *type,
  * that will be saved in the "data" field.
  */
 static struct traceeval_type task_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_POINTER,
-		.name = "data",
-		.release = release_data,
-		.copy = copy_data,
-	},
-	{
-		.type = TRACEEVAL_TYPE_DELTA,
-		.name = DELTA_NAME,
-	},
+	DECLARE_TRACEEVAL_POINTER("data", release_data, copy_data),
+	DECLARE_TRACEEVAL_DELTA(DELTA_NAME),
 };
 
 static int insert_task_data(struct traceeval *teval, const char *comm,
@@ -464,28 +414,16 @@ static bool task_data_exists(struct traceeval *teval, const char *comm, void **d
  * and their priority.
  */
 static struct traceeval_type thread_keys[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "TID",
-	},
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Prio",
-	},
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Schedule state",
-	},
+	DECLARE_TRACEEVAL_NUMBER("TID"),
+	DECLARE_TRACEEVAL_NUMBER("Prio"),
+	DECLARE_TRACEEVAL_NUMBER("Schedule state"),
 };
 
 /*
  * Save the timings of the thread/state/prio keys.
  */
 static struct traceeval_type thread_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_DELTA,
-		.name = DELTA_NAME,
-	},
+	DECLARE_TRACEEVAL_DELTA(DELTA_NAME),
 };
 
 static void insert_thread_data(struct traceeval *teval,
@@ -506,28 +444,16 @@ static void insert_thread_data(struct traceeval *teval,
 }
 
 static struct traceeval_type wakeup_task_keys[] = {
-	{
-		.type = TRACEEVAL_TYPE_STRING,
-		.name = "COMM"
-	},
+	DECLARE_TRACEEVAL_STRING("COMM"),
 };
 
 static struct traceeval_type wakeup_thread_keys[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "PID"
-	},
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Prio"
-	},
+	DECLARE_TRACEEVAL_NUMBER("PID"),
+	DECLARE_TRACEEVAL_NUMBER("Prio"),
 };
 
 static struct traceeval_type wakeup_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_DELTA,
-		.name = DELTA_NAME,
-	},
+	DECLARE_TRACEEVAL_DELTA(DELTA_NAME),
 };
 
 static void insert_wakeup_task_data(struct traceeval *teval,
-- 
2.45.2

