Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C4F1E0B9C;
	Sun, 16 Nov 2025 21:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763327588; cv=none; b=tYvWhMGWMZRCCcgcXD617VGguADA+jCaalE9M9gQtm6KJT9ZUNECPzBAbXu1olL4WSEiG1nHRDcExqtoY9lbLRihkTtQOSA79ruQX8zFPBNkKpZSFkm/yFPwiOA+LLPYquTxwypM7tV4eLQvSf2yD/W0Lqs8P3xJOXYvA/BbcvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763327588; c=relaxed/simple;
	bh=fruUb+yIT8K1tNDPTPjtcTHpDHX6llvYmwp6arpEJhk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pc7TRVJYTNTFIijRjv6OCyifBsVbLpTjcMXWEMq3C4kq8SDRchvjpAyYxCDuhOuliT3mTBQhI4C8hWCyMdBE/IBBLFZLnR9aNoUTa7aniif4c/3yR1Cmf8xNFwiGcjR5C3UHJhM31MB9PNHB41KSctYh/Fp8f2BixMol+AEAisA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=vvWcfMHD; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=UD3IX1x/; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="vvWcfMHD";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="UD3IX1x/"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4d8jyx6g5tz9tjn;
	Sun, 16 Nov 2025 22:03:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1763327018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8LaLvXISIknqjod/3CsBFa6XWWioHDWRs4VCwqkyOE4=;
	b=vvWcfMHDNbJrHIxmWjShI/NqPUI7WOF97/1kKntlH5HXy6132xHqymUQYL9L0acVRumTUr
	1SIpBWZhRW0bFOHy8aZ4hbouoQ0pOw/IbmHVxV5HZ0Z1W2M9gkqhwdWTgWpG9AVd8+0LtX
	Gq2p6NjppwzGzSzX6Ljf7Ai9rnmodACivlsPzX/7fXWsCqztpbiK6qqBDLCo7Wm2rHgLtW
	dK56gQNOWXIl4SBynbEuC7aTSxKC4rEQjYQCkPrkIVBfvGcP20tM33wEl7SgviAKSP6u7N
	PlX8csGRwxGx/V+M8gyu8VQbvrsfCFB8A8bGCYDYfkW+DNUdLd6JUP25vad+Pg==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="UD3IX1x/";
	spf=pass (outgoing_mbo_mout: domain of mhi@mailbox.org designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=mhi@mailbox.org
From: Maurice Hieronymus <mhi@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1763327017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8LaLvXISIknqjod/3CsBFa6XWWioHDWRs4VCwqkyOE4=;
	b=UD3IX1x/dis4d1BM9SoQmgCRROkr7xZeG58tNPznxYECHO5D0ddxzu8hplHBIHvoCSytZI
	MXNCCluE9tQUXDcnwubWCNGgnYHZ3XyQUGlJf+HJ23RkAN/yEqJnar5wdokLrUxIQHTRgG
	ybmeqwNe/7xDAwXv6wzDVTCqdubn4qFkRyz11lXRPwBFJ3B37F4QfPfjc/d6261K1SdHnZ
	7y/u61wcKSExLc2J0UXdOanykjzMYkimUMWbUXcFXwwHYIBd2EUY7b8wDGYpv9rxRbtP7j
	0uF4SBB1DV+rhozuPBaJrHcidw3x7NtUtQl3gaD3XlLGY+bHM4juCNnPUxNTew==
To: rostedt@goodmis.org,
	mingo@redhat.com
Cc: bristot@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-devel@vger.kernel.org,
	mhi@mailbox.org
Subject: [PATCH] tracing: Fix several comment spelling mistakes
Date: Sun, 16 Nov 2025 22:03:02 +0100
Message-ID: <20251116210302.141405-1-mhi@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: bnuu4p8imo1zt6zdwk1gp1i8s7kzxgnm
X-MBO-RS-ID: 95da841af65d2bfab9b
X-Rspamd-Queue-Id: 4d8jyx6g5tz9tjn

Fix several spelling mistakes in comments in the trace subsystem.
No functional changes. These fixes improve readability and correctness
of comments in the tracing subsystem.

Signed-off-by: Maurice Hieronymus <mhi@mailbox.org>
---
 kernel/trace/Kconfig                 |  2 +-
 kernel/trace/ring_buffer.c           |  2 +-
 kernel/trace/ring_buffer_benchmark.c |  2 +-
 kernel/trace/rv/Kconfig              |  2 +-
 kernel/trace/rv/rv.c                 |  2 +-
 kernel/trace/trace.c                 |  2 +-
 kernel/trace/trace_events.c          |  2 +-
 kernel/trace/trace_events_filter.c   |  2 +-
 kernel/trace/trace_events_trigger.c  |  2 +-
 kernel/trace/trace_events_user.c     |  4 ++--
 kernel/trace/trace_osnoise.c         | 16 ++++++++--------
 kernel/trace/trace_seq.c             |  2 +-
 12 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 1052126bdca2..87bc271c0b9d 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -918,7 +918,7 @@ config RING_BUFFER_RECORD_RECURSION
 	default y
 	help
 	  The ring buffer has its own internal recursion. Although when
-	  recursion happens it wont cause harm because of the protection,
+	  recursion happens it won't cause harm because of the protection,
 	  but it does cause an unwanted overhead. Enabling this option will
 	  place where recursion was detected into the ftrace "recursed_functions"
 	  file.
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d59b6a328b7f..74f8143dda8a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5966,7 +5966,7 @@ static __init int test_ringbuffer(void)
 	/*
 	 * Show buffer is enabled before setting rb_test_started.
 	 * Yes there's a small race window where events could be
-	 * dropped and the thread wont catch it. But when a ring
+	 * dropped and the thread won't catch it. But when a ring
 	 * buffer gets enabled, there will always be some kind of
 	 * delay before other CPUs see it. Thus, we don't care about
 	 * those dropped events. We care about events dropped after
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 78e576575b79..62a3d26e591e 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -431,7 +431,7 @@ static int __init ring_buffer_benchmark_init(void)
 {
 	int ret;
 
-	/* make a one meg buffer in overwite mode */
+	/* make a one meg buffer in overwrite mode */
 	buffer = ring_buffer_alloc(1000000, RB_FL_OVERWRITE);
 	if (!buffer)
 		return -ENOMEM;
diff --git a/kernel/trace/rv/Kconfig b/kernel/trace/rv/Kconfig
index 831779607e84..b76ba1aad0a0 100644
--- a/kernel/trace/rv/Kconfig
+++ b/kernel/trace/rv/Kconfig
@@ -45,7 +45,7 @@ config RV_MON_WWNR
 	help
 	  Enable wwnr (wakeup while not running) sample monitor, this is a
 	  sample monitor that illustrates the usage of per-task monitor.
-	  The model is borken on purpose: it serves to test reactors.
+	  The model is broken on purpose: it serves to test reactors.
 
 	  For further information, see:
 	    Documentation/trace/rv/monitor_wwnr.rst
diff --git a/kernel/trace/rv/rv.c b/kernel/trace/rv/rv.c
index 6c97cc2d754a..d523accb1cbd 100644
--- a/kernel/trace/rv/rv.c
+++ b/kernel/trace/rv/rv.c
@@ -41,7 +41,7 @@
  * per-task monitor, and so on), and the helper functions that glue the
  * monitor to the system via trace. Generally, a monitor includes some form
  * of trace output as a reaction for event parsing and exceptions,
- * as depicted bellow:
+ * as depicted below:
  *
  * Linux  +----- RV Monitor ----------------------------------+ Formal
  *  Realm |                                                   |  Realm
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d3005279165d..55b99081ce4e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -124,7 +124,7 @@ cpumask_var_t __read_mostly	tracing_buffer_mask;
  * If there is an oops (or kernel panic) and the ftrace_dump_on_oops
  * is set, then ftrace_dump is called. This will output the contents
  * of the ftrace buffers to the console.  This is very useful for
- * capturing traces that lead to crashes and outputing it to a
+ * capturing traces that lead to crashes and outputting it to a
  * serial console.
  *
  * It is default off, but you can enable it with either specifying
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0356cae0cf74..b7312247eaa6 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -611,7 +611,7 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
 		 *
 		 * When soft_disable is not set but the SOFT_MODE flag is,
 		 * we do nothing. Do not disable the tracepoint, otherwise
-		 * "soft enable"s (clearing the SOFT_DISABLED bit) wont work.
+		 * "soft enable"s (clearing the SOFT_DISABLED bit) won't work.
 		 */
 		if (soft_disable) {
 			if (atomic_dec_return(&file->sm_ref) > 0)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 4b1057ab9d96..cd67ce285fc4 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -92,7 +92,7 @@ static bool is_not(const char *str)
 }
 
 /**
- * prog_entry - a singe entry in the filter program
+ * prog_entry - a single entry in the filter program
  * @target:	     Index to jump to on a branch (actually one minus the index)
  * @when_to_branch:  The value of the result of the predicate to do a branch
  * @pred:	     The predicate to execute.
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 918730d74932..d6abd5fa8c93 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -650,7 +650,7 @@ static void unregister_trigger(char *glob,
  *   param             - text following cmd and ':' and stripped of filter
  *   filter            - the optional filter text following (and including) 'if'
  *
- * To illustrate the use of these componenents, here are some concrete
+ * To illustrate the use of these components, here are some concrete
  * examples. For the following triggers:
  *
  *   echo 'traceon:5 if pid == 0' > trigger
diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index a6621c52ce45..f26f99c0ed21 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -189,7 +189,7 @@ static int user_field_array_size(const char *type)
 
 static int user_field_size(const char *type)
 {
-	/* long is not allowed from a user, since it's ambigious in size */
+	/* long is not allowed from a user, since it's ambiguous in size */
 	if (strcmp(type, "s64") == 0)
 		return sizeof(s64);
 	if (strcmp(type, "u64") == 0)
@@ -227,7 +227,7 @@ static int user_field_size(const char *type)
 	if (str_has_prefix(type, "__rel_loc "))
 		return sizeof(u32);
 
-	/* Uknown basic type, error */
+	/* Unknown basic type, error */
 	return -EINVAL;
 }
 
diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 313439920a8c..d66862ac2567 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -326,7 +326,7 @@ static struct osnoise_data {
 	u64	print_stack;		/* print IRQ stack if total > */
 	int	timerlat_tracer;	/* timerlat tracer */
 #endif
-	bool	tainted;		/* infor users and developers about a problem */
+	bool	tainted;		/* info users and developers about a problem */
 } osnoise_data = {
 	.sample_period			= DEFAULT_SAMPLE_PERIOD,
 	.sample_runtime			= DEFAULT_SAMPLE_RUNTIME,
@@ -737,7 +737,7 @@ cond_move_thread_delta_start(struct osnoise_variables *osn_var, u64 duration)
 /*
  * get_int_safe_duration - Get the duration of a window
  *
- * The irq, softirq and thread varaibles need to have its duration without
+ * The irq, softirq and thread variables need to have its duration without
  * the interference from higher priority interrupts. Instead of keeping a
  * variable to discount the interrupt interference from these variables, the
  * starting time of these variables are pushed forward with the interrupt's
@@ -1182,7 +1182,7 @@ trace_sched_switch_callback(void *data, bool preempt,
 }
 
 /*
- * hook_thread_events - Hook the insturmentation for thread noise
+ * hook_thread_events - Hook the instrumentation for thread noise
  *
  * Hook the osnoise tracer callbacks to handle the noise from other
  * threads on the necessary kernel events.
@@ -1199,9 +1199,9 @@ static int hook_thread_events(void)
 }
 
 /*
- * unhook_thread_events - *nhook the insturmentation for thread noise
+ * unhook_thread_events - Unhook the instrumentation for thread noise
  *
- * Unook the osnoise tracer callbacks to handle the noise from other
+ * Unhook the osnoise tracer callbacks to handle the noise from other
  * threads on the necessary kernel events.
  */
 static void unhook_thread_events(void)
@@ -1330,7 +1330,7 @@ static int run_osnoise(void)
 	stop_in = osnoise_data.stop_tracing * NSEC_PER_USEC;
 
 	/*
-	 * Start timestemp
+	 * Start timestamp
 	 */
 	start = time_get();
 
@@ -1664,7 +1664,7 @@ static int timerlat_main(void *data)
 	tlat->kthread = current;
 	osn_var->pid = current->pid;
 	/*
-	 * Anotate the arrival time.
+	 * Annotate the arrival time.
 	 */
 	tlat->abs_period = hrtimer_cb_get_time(&tlat->timer);
 
@@ -1734,7 +1734,7 @@ static void stop_per_cpu_kthreads(void)
 }
 
 /*
- * start_kthread - Start a workload tread
+ * start_kthread - Start a workload thread
  */
 static int start_kthread(unsigned int cpu)
 {
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 9c90b3a7dce2..ec63d0ae6a22 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -18,7 +18,7 @@
  *
  * A write to the buffer will either succeed or fail. That is, unlike
  * sprintf() there will not be a partial write (well it may write into
- * the buffer but it wont update the pointers). This allows users to
+ * the buffer but it won't update the pointers). This allows users to
  * try to write something into the trace_seq buffer and if it fails
  * they can flush it and try again.
  *

base-commit: 70575e77839f4c5337ce2653b39b86bb365a870e
-- 
2.50.1

