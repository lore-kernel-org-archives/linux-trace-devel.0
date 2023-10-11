Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9ABC2DF
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C36C43391;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZSy-21;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 05/11] libtraceeval task-eval: Account for ZOMBIE and EXITED states
Date: Tue, 10 Oct 2023 23:25:21 -0400
Message-ID: <20231011032640.1804571-6-rostedt@goodmis.org>
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

Currently, if a sched_switch happens with a task in he ZOMBIE or EXITED
state, task-eval will treat it as being preempted in a running state. This
is incorrect, and should be updated to reflect it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 40e7345a27c4..061d27374e66 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -254,6 +254,8 @@ enum sched_state {
 	PREEMPT,
 	SLEEP,
 	IDLE,
+	ZOMBIE,
+	EXITED,
 	OTHER
 };
 
@@ -474,6 +476,10 @@ static int get_stop_state(unsigned long long val)
 		return SLEEP;
 	if (val & 2)
 		return BLOCKED;
+	if (val & 0x10)
+		return ZOMBIE;
+	if (val & 0x20)
+		return EXITED;
 	return PREEMPT;
 }
 
-- 
2.42.0

