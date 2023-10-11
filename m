Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95961C2F0
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC4AC43142;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZTE-2M;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 09/11] libtraceeval task-eval: Do not add pdata to non RUNNING tasks
Date: Tue, 10 Oct 2023 23:25:25 -0400
Message-ID: <20231011032640.1804571-10-rostedt@goodmis.org>
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

The pdata is used to daisy chain all the threads for each task with the
same name. But since the tasks saving is broken up for each of their
scheduling states, the pdata is saved in just the RUNNING state. But since
it also needs to be freed, each pdata only needs to be saved once in the
traceeval for tasks.

Make sure that when updating the tasks, the pdata for the task is only
saved with the RUNNING state, and all other states just have NULL.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 79039580ce78..420d87f498cc 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -496,6 +496,10 @@ static void update_thread(struct task_data *tdata, int pid, const char *comm,
 
 		traceeval_insert(pdata->teval_threads, thread_keys, vals);
 
+		/* Only the RUNNING state keeps pdata */
+		if (state != RUNNING)
+			pdata = NULL;
+
 		/* Also update the process */
 		assign_task_keys(task_keys, comm, state);
 		assign_task_vals(pvals, pdata, delta, ts);
-- 
2.42.0

