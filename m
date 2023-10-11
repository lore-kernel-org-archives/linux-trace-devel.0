Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2526CA57
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5044DC4167D;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZTA-2H;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 08/11] libtraceeval task-eval: Only release results if found
Date: Tue, 10 Oct 2023 23:25:24 -0400
Message-ID: <20231011032640.1804571-9-rostedt@goodmis.org>
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

In set_process_data(), the results are release even if they were not
found. But when they are not found, results is undefined.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index aa61ec38244f..79039580ce78 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -348,8 +348,10 @@ void set_process_data(struct task_data *tdata, const char *comm, void *data)
 	int ret;
 
 	ret = traceeval_query(tdata->teval_tasks, keys, &results);
-	if (ret > 0)
-		goto out; /* It already exists ? */
+	if (ret > 0) {
+		traceeval_results_release(tdata->teval_tasks, results);
+		return; /* It already exists ? */
+	}
 	if (ret < 0)
 		pdie("Could not query process data");
 
@@ -358,9 +360,6 @@ void set_process_data(struct task_data *tdata, const char *comm, void *data)
 	ret = traceeval_insert(tdata->teval_tasks, keys, new_vals);
 	if (ret < 0)
 		pdie("Failed to set process data");
-
- out:
-	traceeval_results_release(tdata->teval_tasks, results);
 }
 
 static struct process_data *alloc_pdata(struct task_data *tdata, const char *comm)
-- 
2.42.0

