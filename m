Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A1317D1
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFEBC433C8;
	Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rJ3Ou-00000000I4b-2CUL;
	Thu, 28 Dec 2023 22:19:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] trace-cmd show: Re-arrange the enum long option values
Date: Thu, 28 Dec 2023 22:16:44 -0500
Message-ID: <20231229031907.69432-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231229031907.69432-1-rostedt@goodmis.org>
References: <20231229031907.69432-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

To simplify adding enums to trace-cmd show, re-arrange the enum values. They
can be larger than 255 as well.

No functional changes.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-show.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tracecmd/trace-show.c b/tracecmd/trace-show.c
index eb3285277fe1..796c587c0cd0 100644
--- a/tracecmd/trace-show.c
+++ b/tracecmd/trace-show.c
@@ -11,16 +11,16 @@
 #include "trace-local.h"
 
 enum {
-	OPT_tracing_on			= 255,
-	OPT_current_tracer		= 254,
-	OPT_buffer_size_kb		= 253,
-	OPT_buffer_total_size_kb	= 252,
-	OPT_ftrace_filter		= 251,
-	OPT_ftrace_notrace		= 250,
-	OPT_ftrace_pid			= 249,
-	OPT_graph_function		= 248,
-	OPT_graph_notrace		= 247,
-	OPT_cpumask			= 246,
+	OPT_cpumask			= 240,
+	OPT_graph_notrace,
+	OPT_graph_function,
+	OPT_ftrace_pid,
+	OPT_ftrace_notrace,
+	OPT_ftrace_filter,
+	OPT_buffer_total_size_kb,
+	OPT_buffer_size_kb,
+	OPT_current_tracer,
+	OPT_tracing_on,
 };
 
 void trace_show(int argc, char **argv)
-- 
2.42.0

