Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5118634AAEB
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Jan 2026 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768928130; cv=none; b=feknTuks/jy/3q6937b9Q+ZsugVuZQ/EisFYQc/5QGsN8LFTauoRItvedG+UM2d3Fkbj/1h3tmE0PD+k2qUqKWznswk2dRAcnllSJw+wMgsZOkS/TLfxPb6Ly0KBL/vuNLoTW1bKNF/W3HRk01HntWOCg6VvsntjMbUEu74z/JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768928130; c=relaxed/simple;
	bh=CTZBfhsTDiyUGEaUOnF/huGd8vg3sVH7KnXVhyLD71c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=guHkSeKI1aXnwherp58vrXgLbcqcZPeoqMzPRncnRB0wOlUO8AGTnjF//52xlKquE/loDC1yWsbGc/b/h9pGoSH/3BTjQxByn2Bry+ycXgKiyt0s4pL7pL5VWOnUpaD1jKvg6FayrOjykDCFmV8NacaV9GCR2nR4o6e+EnGbgy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1640BD25A7;
	Tue, 20 Jan 2026 16:55:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id A799320028;
	Tue, 20 Jan 2026 16:55:19 +0000 (UTC)
Date: Tue, 20 Jan 2026 11:55:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Donglin Peng <pengdonglin@xiaomi.com>
Subject: [PATCH] libtracecmd: Add support to display parent function in
 function graph
Message-ID: <20260120115540.2f391ad9@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ut5q8n3rrga1chzctjffqbwi9e3dhqf
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: A799320028
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/cQJtQXUYR/24iV3m5vheBskRq1PeK5LE=
X-HE-Tag: 1768928119-74643
X-HE-Meta: U2FsdGVkX194QPg9CPtmBtbfpMMFAY6VdiczKColw75sVWH1m8wOhdP/fnyBPfU5XPSzohI8+uzolfFI9anZeuekPPK9/c/XgObld/eLpGKt0KxYsbG+SRXWhgBpxVHmdvO5bKcGxFhEXePoLJEnixd/KcN8YnaMvw7qOLYiIztJ1x2Dtt/ztDhY7SYkx5w5S23uEK7ejCENkzd8gKOLXo2TOhy1H4qbMlLkQMs8HxUcxjl0V+tq/aYFstYZKhtiddu/ZGTrAXiLWQZFAji+roPORxBiMNan6QzaXQWhmYFhtel6YYBOqoNJh8ZcG6bWKCU3XiakypScdfWSK9Xh3jD5bicJvF8aDE2NPCx+9d1rM5V83w/uhU2JdEAKMo8M

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the trace was recorded with the function graph option: funcgraph-retaddr
The function trace includes the parent function in the address space.
Add support to show the parent function in a /* <-[parent] */ format.

 fgraph_retaddr_entry:              |  irq_enter_rcu() /* <-sysvec_call_function_single */ {
 fgraph_retaddr_entry:   0.748 us   |    preempt_count_add(val=65536); /* <-irq_enter_rcu */ (ret=0x10001)
 fgraph_retaddr_entry:              |    tick_irq_enter() /* <-irq_enter_rcu */ {
 fgraph_retaddr_entry:   0.524 us   |      tick_check_oneshot_broadcast_this_cpu(); /* <-tick_irq_enter */ (ret=0x6)
 fgraph_retaddr_entry:   2.030 us   |      ktime_get(); /* <-tick_irq_enter */ (ret=0x4695e53ad9c)
 fgraph_retaddr_entry:              |      tick_nohz_stop_idle(ts=0xffff90273df22610, now=4850600619420) /* <-tick_irq_enter */ {
 fgraph_retaddr_entry:   0.437 us   |        nr_iowait_cpu(cpu=6); /* <-tick_nohz_stop_idle */ (ret=0x0)
 funcgraph_exit:         2.043 us   |      } (ret=0xb882194c0316dc00)
 funcgraph_exit:         6.764 us   |    } (ret=0x31)
 funcgraph_exit:       + 11.033 us  |  } (ret=0x31)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-ftrace.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index c61dd543..f52b203c 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -253,6 +253,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 	unsigned long long val;
 	unsigned long long retval;
 	bool fgraph_retval_supported = true;
+	const char *retfunc = NULL;
 	const char *func;
 	int ret;
 	int i;
@@ -270,6 +271,10 @@ print_graph_entry_leaf(struct trace_seq *s,
 			return trace_seq_putc(s, '!');
 	}
 
+	/* In case this is a retaddr event */
+	if (!tep_get_field_val(s, event, "retaddr", record, &val, 1))
+		retfunc = tep_find_function(pevent, val);
+
 	duration = rettime - calltime;
 
 	/* Overhead */
@@ -299,6 +304,9 @@ print_graph_entry_leaf(struct trace_seq *s,
 	if (ret && fgraph_depth->set)
 		ret = trace_seq_printf(s, " (%lld)", depth);
 
+	if (retfunc)
+		ret = trace_seq_printf(s, " /* <-%s */", retfunc);
+
 	/* Return Value */
 	if (ret && fgraph_retval_supported && !fgraph_retval_skip->set) {
 		if (fgraph_retval_dec->set) {
@@ -324,6 +332,7 @@ static int print_graph_nested(struct trace_seq *s,
 	struct tep_handle *pevent = event->tep;
 	unsigned long long depth;
 	unsigned long long val;
+	const char *retfunc = NULL;
 	const char *func;
 	int ret;
 	int i;
@@ -337,6 +346,10 @@ static int print_graph_nested(struct trace_seq *s,
 	if (tep_get_field_val(s, event, "depth", record, &depth, 1))
 		return trace_seq_putc(s, '!');
 
+	/* In case this is a retaddr event */
+	if (!tep_get_field_val(s, event, "retaddr", record, &val, 1))
+		retfunc = tep_find_function(pevent, val);
+
 	/* Function */
 	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
 		trace_seq_putc(s, ' ');
@@ -346,12 +359,20 @@ static int print_graph_nested(struct trace_seq *s,
 
 	func = tep_find_function(pevent, val);
 
+
 	if (func) {
 		ret = trace_seq_printf(s, "%s(", func);
 		print_args(s, event, record, func);
-		ret = trace_seq_puts(s, ") {");
-	} else
-		ret = trace_seq_printf(s, "%llx() {", val);
+		if (retfunc)
+			ret = trace_seq_printf(s, ") /* <-%s */ {", retfunc);
+		else
+			ret = trace_seq_puts(s, ") {");
+	} else {
+		if (retfunc)
+			ret = trace_seq_printf(s, "%llx() /* <-%s */ {", val, retfunc);
+		else
+			ret = trace_seq_puts(s, ") {");
+	}
 
 	if (ret && fgraph_depth->set)
 		ret = trace_seq_printf(s, " (%lld)", depth);
@@ -504,6 +525,9 @@ int tracecmd_ftrace_overrides(struct tracecmd_input *handle,
 	tep_register_event_handler(pevent, -1, "ftrace", "funcgraph_entry",
 				      fgraph_ent_handler, finfo);
 
+	tep_register_event_handler(pevent, -1, "ftrace", "fgraph_retaddr_entry",
+				      fgraph_ent_handler, finfo);
+
 	tep_register_event_handler(pevent, -1, "ftrace", "funcgraph_exit",
 				      fgraph_ret_handler, finfo);
 
-- 
2.50.1

