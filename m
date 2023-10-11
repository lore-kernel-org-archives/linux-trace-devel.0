Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A2ECA5C
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E532C433B9;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZTI-2S;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 10/11] libtraceveal task-eval: Clean up all traceeval_iterators
Date: Tue, 10 Oct 2023 23:25:26 -0400
Message-ID: <20231011032640.1804571-11-rostedt@goodmis.org>
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

When traceeval_iterator_get() is used, it must be accompanied with a
traceeval_iterator_put().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 420d87f498cc..25032293c9a3 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -828,6 +828,8 @@ static void display_cpus(struct traceeval *teval)
 
 	if (last_cpu < 0)
 		die("No result for CPUs\n");
+
+	traceeval_iterator_put(iter);
 }
 
 static void print_stats(int idx, struct traceeval_stat *stat)
@@ -920,6 +922,8 @@ static void display_threads(struct traceeval *teval)
 		display_state_times(state, stat);
 	}
 
+	traceeval_iterator_put(iter);
+
 	if (last_tid < 0)
 		die("No result for threads\n");
 }
@@ -982,12 +986,13 @@ static void display_processes(struct traceeval *teval)
 		if (pdata)
 			display_process(pdata);
 	}
+	traceeval_iterator_put(iter);
 }
 
 static void display(struct task_data *tdata)
 {
 	struct traceeval *teval = tdata->teval_cpus;
-	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	struct traceeval_iterator *iter;
 	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
 	unsigned long long total_time = 0;
@@ -997,6 +1002,8 @@ static void display(struct task_data *tdata)
 		return display_processes(tdata->teval_tasks);
 	}
 
+	iter = traceeval_iterator_get(teval);
+
 	printf("Total:\n");
 
 	if (!iter)
@@ -1021,6 +1028,8 @@ static void display(struct task_data *tdata)
 		}
 	}
 
+	traceeval_iterator_put(iter);
+
 	printf("  Total  run time (us):");
 	print_microseconds_nl(16, total_time);
 	printf("  Total idle time (us):");
-- 
2.42.0

