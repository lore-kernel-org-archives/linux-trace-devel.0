Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADAE154B0
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Sep 2023 09:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83264C433C9;
	Fri, 29 Sep 2023 09:59:32 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qmAIO-004Gu5-1W;
	Fri, 29 Sep 2023 06:00:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtraceeval samples: Remove adding TRACEEVAL_TYPE_NONE to keys and vals
Date: Fri, 29 Sep 2023 06:00:25 -0400
Message-Id: <20230929100025.1018258-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230929100025.1018258-1-rostedt@goodmis.org>
References: <20230929100025.1018258-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Remove the TRACEEVAL_TYPE_NONE in the initialization of keys and vals in
the sample code as it is no longer needed.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 6b01b8d076f2..361c4a835f06 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -89,9 +89,6 @@ static struct traceeval_type cpu_keys[] = {
 		.type = TRACEEVAL_TYPE_NUMBER,
 		.name = "Schedule state",
 	},
-	{
-		.type = TRACEEVAL_TYPE_NONE
-	}
 };
 
 static struct traceeval_type process_keys[] = {
@@ -103,9 +100,6 @@ static struct traceeval_type process_keys[] = {
 		.type = TRACEEVAL_TYPE_NUMBER,
 		.name = "Schedule state"
 	},
-	{
-		.type	= TRACEEVAL_TYPE_NONE,
-	}
 };
 
 static struct traceeval_type process_data_vals[] = {
@@ -113,9 +107,6 @@ static struct traceeval_type process_data_vals[] = {
 		.type = TRACEEVAL_TYPE_POINTER,
 		.name = "data",
 	},
-	{
-		.type = TRACEEVAL_TYPE_NONE
-	}
 };
 
 static struct traceeval_type thread_keys[] = {
@@ -127,9 +118,6 @@ static struct traceeval_type thread_keys[] = {
 		.type = TRACEEVAL_TYPE_NUMBER,
 		.name = "Schedule state",
 	},
-	{
-		.type = TRACEEVAL_TYPE_NONE,
-	}
 };
 
 static struct traceeval_type timestamp_vals[] = {
@@ -138,9 +126,6 @@ static struct traceeval_type timestamp_vals[] = {
 		.name = "Timestamp",
 		.flags = TRACEEVAL_FL_TIMESTAMP,
 	},
-	{
-		.type = TRACEEVAL_TYPE_NONE
-	}
 };
 
 static struct traceeval_type delta_vals[] = {
@@ -149,9 +134,6 @@ static struct traceeval_type delta_vals[] = {
 		.name	= "delta",
 		.flags = TRACEEVAL_FL_STAT,
 	},
-	{
-		.type	= TRACEEVAL_TYPE_NONE,
-	},
 };
 
 enum sched_state {
-- 
2.40.1

