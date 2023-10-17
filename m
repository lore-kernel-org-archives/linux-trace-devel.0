Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD99450E2
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 15:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AE7C433C8
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 15:48:26 +0000 (UTC)
Date: Tue, 17 Oct 2023 11:50:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Add tracecmd_iterate_reset() API
Message-ID: <20231017115003.21559343@gandalf.local.home>
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

As tracecmd_iterate_events_reverse() takes a flag to state if it should
continue where it left off the last time it was called, or to start back
at the end of the file, I realized there was no equivalent flag for
tracecmd_iterate_events() itself. Currently it always starts where it left
off.

Add tracecmd_iterate_reset() that will make cause
tracecmd_iterate_events() to start at the beginning of the file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtracecmd/libtracecmd-iterate.txt       |  9 +++++-
 Documentation/libtracecmd/libtracecmd.txt     |  1 +
 include/trace-cmd/trace-cmd.h                 |  2 ++
 lib/trace-cmd/trace-input.c                   | 28 +++++++++++++++++++
 4 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracecmd/libtracecmd-iterate.txt b/Documentation/libtracecmd/libtracecmd-iterate.txt
index 12c54b2ce1a0..4d66a9708717 100644
--- a/Documentation/libtracecmd/libtracecmd-iterate.txt
+++ b/Documentation/libtracecmd/libtracecmd-iterate.txt
@@ -4,7 +4,7 @@ libtracecmd(3)
 NAME
 ----
 tracecmd_iterate_events, tracecmd_iterate_events_multi, tracecmd_follow_event,
-tracecmd_follow_missed_events, tracecmd_filter_add - Read events from a trace file
+tracecmd_follow_missed_events, tracecmd_filter_add, tracecmd_iterate_reset - Read events from a trace file
 
 SYNOPSIS
 --------
@@ -30,6 +30,7 @@ int *tracecmd_iterate_events_reverse*(struct tracecmd_input pass:[*]_handle_,
 					    struct tep_record pass:[*],
 					    int, void pass:[*]),
 			    void pass:[*]_callback_data_, bool _cont_);
+void *tracecmd_iterate_reset*(struct tracecmd_input pass:[*]_handle_);
 int *tracecmd_follow_event*(struct tracecmd_input pass:[*]_handle_,
 			  const char pass:[*]_system_, const char pass:[*]_event_name_,
 			  int (pass:[*]_callback_)(struct tracecmd_input pass:[*],
@@ -102,6 +103,10 @@ The _record_ is the current event record. The _cpu_ is the current CPU being pro
 CPU of all the _handles_ put together. Use _record_->cpu to get the actual CPU that the
 event is on.
 
+The *tracecmd_iterate_reset()* function resets the cursor back to the start of the
+trace file. That is, the next call to *tracecmd_iterate_events()* on _handle_ will start at the
+first event of _handle_.
+
 The *tracecmd_follow_event()* function will attach to a trace file descriptor _handle_
 and call the _callback_ when the event described by _system_ and _name_ matches an event
 in the iteration of *tracecmd_iterate_events()* or *tracecmd_iterate_events_multi()*.
@@ -147,6 +152,8 @@ Both *tracecmd_iterate_events()*, *tracecmd_iterate_events_reverse()* and
 (handling the follow and filters appropriately). Or an error value, which can include
 returning a non-zero result from the _callback()_ function.
 
+The *tracecmd_iterate_reset()* returns 0 on success and -1 on error.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index bbe6cc78b575..4db901ec9b72 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -46,6 +46,7 @@ Iterating over events in a trace file:
 						    struct tep_record pass:[*],
 						    int, void pass:[*]),
 				    void pass:[*]_callback_data_, bool _cont_);
+	void *tracecmd_iterate_reset*(struct tracecmd_input pass:[*]_handle_);
 	int *tracecmd_follow_event*(struct tracecmd_input pass:[*]_handle_,
 				  const char pass:[*]_system_, const char pass:[*]_event_name_,
 				  int (pass:[*]_callback_)(struct tracecmd_input pass:[*],
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index e6527b7116c1..d8c313b0c472 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -72,6 +72,8 @@ int tracecmd_follow_missed_events(struct tracecmd_input *handle,
 						  int, void *),
 				  void *callback_data);
 
+void tracecmd_iterate_reset(struct tracecmd_input *handle);
+
 int tracecmd_iterate_events(struct tracecmd_input *handle,
 			    cpu_set_t *cpus, int cpu_size,
 			    int (*callback)(struct tracecmd_input *handle,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index af51b3d71e1a..3ea706a86a54 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2108,6 +2108,34 @@ tracecmd_read_cpu_first(struct tracecmd_input *handle, int cpu)
 	return tracecmd_read_data(handle, cpu);
 }
 
+/**
+ * tracecmd_iterate_reset - Set the handle to iterate from the beginning
+ * @handle: input handle for the trace.dat file
+ *
+ * This causes tracecmd_iterate_events*() to start from the beginning
+ * of the trace.dat file.
+ */
+void tracecmd_iterate_reset(struct tracecmd_input *handle)
+{
+	unsigned long long page_offset;
+	int cpu;
+	int ret;
+
+	for (cpu = 0; cpu < handle->cpus; cpu++) {
+		page_offset = calc_page_offset(handle, handle->cpu_data[cpu].file_offset);
+
+		ret = get_page(handle, cpu, page_offset);
+		if (ret < 0)
+			continue; /* ?? */
+
+		/* If the page was already mapped, we need to reset it */
+		if (ret)
+			update_page_info(handle, cpu);
+
+		free_next(handle, cpu);
+	}
+}
+
 /**
  * tracecmd_read_cpu_last - get the last record in a CPU
  * @handle: input handle for the trace.dat file
-- 
2.42.0

