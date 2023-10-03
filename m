Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3113CCF5
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 22:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6236C433C7;
	Tue,  3 Oct 2023 22:05:47 +0000 (UTC)
Date: Tue, 3 Oct 2023 18:06:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Change hash.c to use traceeval.h instead of
 traceeval-hist.h
Message-ID: <20231003180639.18e4ea7d@gandalf.local.home>
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

It appears that some of the files was using the system traceeval-hist.h
from a "make install" I had done and did not fail to build when the
traceeval-hist.h was renamed to traceeval.h.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/hash.c b/src/hash.c
index 82962fbba8d8..eceebe29d766 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
  */
 
-#include <traceeval-hist.h>
+#include <traceeval.h>
 
 #include "eval-local.h"
 
-- 
2.40.1

