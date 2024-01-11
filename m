Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC5758217
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F572C433C7
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:14:01 +0000 (UTC)
Date: Thu, 11 Jan 2024 17:15:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Fix comment for tracecmd_cpus()
Message-ID: <20240111171504.20d585ae@gandalf.local.home>
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

The kerneldoc header of tracecmd_cpus() is tracecmd_page_size() and not
tracecmd_cpus(). Fix it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a10d74cf6cf4..6297e34bde38 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -6342,7 +6342,7 @@ int tracecmd_page_size(struct tracecmd_input *handle)
 }
 
 /**
- * tracecmd_page_size - return the number of CPUs recorded
+ * tracecmd_cpus - return the number of CPUs recorded
  * @handle: input handle for the trace.dat file
  */
 int tracecmd_cpus(struct tracecmd_input *handle)
-- 
2.43.0

