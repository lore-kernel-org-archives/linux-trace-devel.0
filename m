Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D1A58106
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C131C433F1
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:12:02 +0000 (UTC)
Date: Thu, 11 Jan 2024 17:13:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Break function graph line if exit is on
 another CPU
Message-ID: <20240111171305.0bb529f0@gandalf.local.home>
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

The function graph tracer has two events. One for the entry of a function,
and one for the exit. The ftrace tracing plugin will check the next event,
and if the exit event of a function follows directly after the entry of the
same function, it will combine them to look like:

	123.456 us | func();

If some other event were to be between the events, then it will break it up:

	           | func() {
	 54.321 us |   other_func();
	123.456 us | }

But this could hide that a function migrated across CPUs.

For example:

  migrate-14353 [001] dN.1. 66420.851920: funcgraph_entry:      + 43.090 us  |  exit_to_user_mode_prepare();

Hides that the migrate program migrated between the entry of
exit_to_user_mode_prepare() and the exit, where looking at each event there is:

  migrate-14353 [001] dN.1. 66420.851920: funcgraph_entry:                   |  exit_to_user_mode_prepare() {
  migrate-14353 [003] d.... 66420.851963: funcgraph_exit:       + 43.090 us  |  }

Where it migrated from CPU 1 to 3.

Worse, it confuses the idle for which CPUs they were run on and for how long:

  <idle>-0     [007] ...2. 66420.073288: funcgraph_entry:      ! 268.817 us |  do_idle();
  <idle>-0     [004] ...2. 66420.073315: funcgraph_entry:      ! 258.832 us |  do_idle();
  <idle>-0     [005] ...2. 66420.073323: funcgraph_entry:      ! 157.311 us |  do_idle();

Instead of:

  <idle>-0     [007] ...2. 66420.073288: funcgraph_entry:                   |  do_idle() {
  <idle>-0     [004] ...1. 66420.073315: funcgraph_exit:       ! 268.817 us |  }
  <idle>-0     [004] ...2. 66420.073315: funcgraph_entry:                   |  do_idle() {
  <idle>-0     [005] ...1. 66420.073322: funcgraph_exit:       ! 258.832 us |  }
  <idle>-0     [005] ...2. 66420.073323: funcgraph_entry:                   |  do_idle() {
  <idle>-0     [000] ...1. 66420.073330: funcgraph_exit:       ! 157.311 us |  }

Where the first one shows 268.817us for CPU 7 when it was really for CPU 4.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-ftrace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index f74f7c2e8b96..89e46c3d1cb4 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -283,6 +283,14 @@ fgraph_ent_handler(struct trace_seq *s, struct tep_record *record,
 		return trace_seq_putc(s, '!');
 
 	rec = tracecmd_peek_next_data(tracecmd_curr_thread_handle, &cpu);
+
+	/*
+	 * If the next event is on another CPU, show it.
+	 * Even if the next event is the return of this function.
+	 */
+	if (cpu != record->cpu)
+		rec = NULL;
+
 	if (rec)
 		rec = get_return_for_leaf(s, cpu, pid, val, rec, finfo);
 
-- 
2.43.0

