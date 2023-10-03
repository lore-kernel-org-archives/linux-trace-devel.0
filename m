Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EA3D2EB
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 17:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C0BC433C7;
	Tue,  3 Oct 2023 17:45:02 +0000 (UTC)
Date: Tue, 3 Oct 2023 13:46:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval samples: Have samples use traceeval.h and not
 traceeval-hist.h
Message-ID: <20231003134607.0cad0947@gandalf.local.home>
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

After renaming traceeval-hist.h over to traceeval.h, the sample code still
referenced the traceeval-hist.h. Fix that.

Fixes: 1a6052f926ad ("libtraceeval: Move traceeval-hist.h to traceeval.h")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 361c4a835f06..4421bd90ad3c 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -5,7 +5,7 @@
 #include <getopt.h>
 #include <errno.h>
 #include <trace-cmd.h>
-#include <traceeval-hist.h>
+#include <traceeval.h>
 
 static char *argv0;
 
-- 
2.40.1

