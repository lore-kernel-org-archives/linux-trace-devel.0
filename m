Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B50CA46
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA51C43391;
	Wed, 11 Oct 2023 03:25:20 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZTM-2X;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 11/11] libtraceeval task-evals: Free the libtraceevals
Date: Tue, 10 Oct 2023 23:25:27 -0400
Message-ID: <20231011032640.1804571-12-rostedt@goodmis.org>
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

Add code to free the allocated traceveals including the ones that are
daisy chained in the teval_tasks.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 25032293c9a3..382e30514ec3 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -225,6 +225,20 @@ static void assign_task_keys(struct traceeval_data keys[2],
 	TRACEEVAL_SET_NUMBER(keys[1], state);
 }
 
+static void release_data(const struct traceeval_type *type,
+			  struct traceeval_data *data);
+
+static int copy_data(const struct traceeval_type *type,
+		     struct traceeval_data *dst,
+		     const struct traceeval_data *src)
+{
+	if (dst->pointer && dst->pointer != src->pointer)
+		die("Pointers do not match!");
+	/* This prevents releases of data */
+	*dst = *src;
+	return 0;
+}
+
 /*
  * For each state the process is in, record the time delta for
  * that state. Also, only for the RUNNING state, this will
@@ -237,6 +251,8 @@ static struct traceeval_type task_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_POINTER,
 		.name = "data",
+		.release = release_data,
+		.copy = copy_data,
 	},
 	{
 		.type = TRACEEVAL_TYPE_DELTA,
@@ -326,6 +342,21 @@ enum command {
 	STOP
 };
 
+static void release_data(const struct traceeval_type *type,
+			  struct traceeval_data *data)
+{
+	struct process_data *pdata;
+
+	if (!data || !data->pointer)
+		return;
+
+	pdata = data->pointer;
+	traceeval_release(pdata->teval_cpus);
+	traceeval_release(pdata->teval_threads);
+	free(pdata);
+	data->pointer = NULL;
+}
+
 static void init_process_data(struct process_data *pdata)
 {
 	pdata->teval_cpus = traceeval_init(cpu_keys, cpu_vals);
@@ -1043,6 +1074,11 @@ static void display(struct task_data *tdata)
 
 static void free_tdata(struct task_data *tdata)
 {
+	if (!tdata)
+		return;
+
+	traceeval_release(tdata->teval_cpus);
+	traceeval_release(tdata->teval_tasks);
 }
 
 /*
-- 
2.42.0

