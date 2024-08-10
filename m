Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5181EB35
	for <linux-trace-devel@vger.kernel.org>; Sat, 10 Aug 2024 01:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723252915; cv=none; b=cLKwATu+s94JQcJCiVTXmOi7m42WqDNaKpjFsVKWmalZDAxQuI6GG8fgS3UlgbpcgonDgIf5AOmRGOB+/7MBzf1moDrNy5injwoqPPhQhGih2PyrQA3oL+a6HVp6JSipQdQ8HflEjH9WtEkDTip8fa2CROa23+m12g0uRCKogNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723252915; c=relaxed/simple;
	bh=YD6oOXQmmAYBIH8WLBDRYXl4WQsToSCZDbcNtHh9L1s=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=CoX86rMF2k+OXKal4pIdUWuzdWKNuJemglmwfo4iAY3PxztGAGKGqs7sHk1Pfwv/qTkeH7XHdziRMvJrkHkC9VqUjgIxM1ocjWjSLW6XgCT1Kmc553Bq0PES5XzOYgL8vw+FB+OGZlyzkpGewfPh8NbJwY3zp/YUEmnbNMM+0Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527DBC32782
	for <linux-trace-devel@vger.kernel.org>; Sat, 10 Aug 2024 01:21:54 +0000 (UTC)
Date: Fri, 9 Aug 2024 21:21:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Always disable func_stack_trace in
 tracecmd_disable_all_tracing()
Message-ID: <20240809212152.6486337d@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function tracecmd_disable_all_tracing() is passed a boolean parameter
to decide to disable the tracers or not. If the tracers are not to be
disabled (as it resets the trace file) it also does not disable the
func_stack_trace. Unfortunately, that means the set_ftrace_filter gets
reset when the function stack tracing is still enabled, causing the end of
the trace to take a long time.

Always disable func_stack_trace option in tracecmd_disable_all_tracing().

Fixes: 935d5c5a033a5 ("trace-cmd reset: Remove functions in function tracing filters")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3c705270f1c5..6b88646a2b7f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2742,10 +2742,10 @@ void tracecmd_disable_all_tracing(int disable_tracer)
 
 	tracecmd_disable_tracing();
 
-	if (disable_tracer) {
-		disable_func_stack_trace();
+	disable_func_stack_trace();
+
+	if (disable_tracer)
 		set_plugin("nop");
-	}
 
 	reset_events();
 
-- 
2.43.0

