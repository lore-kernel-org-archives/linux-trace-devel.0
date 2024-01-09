Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D279191
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 00:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890F3C433C7
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 00:17:02 +0000 (UTC)
Date: Mon, 8 Jan 2024 19:17:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd report: Add interrupt info in output
Message-ID: <20240108191759.5fc4ecda@gandalf.local.home>
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

In the Linux kernel version 3.3 the default output showed the irq information
that is typically only for the latency format. That is, it shows:

               <idle>-0     [000] d..2    49.309305: cpuidle_get_driver <-cpuidle_idle_call
               <idle>-0     [000] d..2    49.309307: mwait_idle <-cpu_idle
               <idle>-0     [000] d..2    49.309309: need_resched <-mwait_idle

Instead of:

               <idle>-0     [000]     49.309305: cpuidle_get_driver <-cpuidle_idle_call
               <idle>-0     [000]     49.309307: mwait_idle <-cpu_idle
               <idle>-0     [000]     49.309309: need_resched <-mwait_idle

After 12 years, it's about time that the default trace-cmd report output did
the same!

This does change the output format and possibly can break anything that
tries to parse it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index f645c053..1dea54c4 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -870,14 +870,13 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 			TEP_PRINT_PID,
 			TEP_PRINT_CPU);
 
-	if (latency_format) {
-		if (raw_format)
-			trace_seq_printf(&s, "-0x%x",
-					 tep_data_flags(pevent, record));
-		else
-			tep_print_event(pevent, &s, record, "%s",
-					TEP_PRINT_LATENCY);
-	}
+	if (raw_format)
+		trace_seq_printf(&s, "-0x%x",
+				 tep_data_flags(pevent, record));
+	else
+		tep_print_event(pevent, &s, record,
+				latency_format ? "%s" : " %s",
+				TEP_PRINT_LATENCY);
 
 	tep_print_event(pevent, &s, record, tfmt, TEP_PRINT_TIME);
 
-- 
2.42.0

