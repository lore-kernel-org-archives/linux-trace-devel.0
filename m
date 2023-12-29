Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C7717D8
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5798C433CB;
	Fri, 29 Dec 2023 03:10:48 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rJ3Hf-00000000HmI-0QxC;
	Thu, 28 Dec 2023 22:11:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] trace-cmd library: Add tracecmd_iterate_reset()
Date: Thu, 28 Dec 2023 22:10:15 -0500
Message-ID: <20231229031138.68313-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231229031138.68313-1-rostedt@goodmis.org>
References: <20231229031138.68313-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently there's no easy way to reset iterating over a trace.dat file if a
tracecmd_iterate_events() was called. Add a helper function to do that:

 tracecmd_iterate_reset()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtracecmd/libtracecmd-iterate.txt       | 10 +++++-
 Documentation/libtracecmd/libtracecmd.txt     |  1 +
 include/trace-cmd/trace-cmd.h                 |  2 ++
 lib/trace-cmd/trace-input.c                   | 32 +++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracecmd/libtracecmd-iterate.txt b/Documentation/libtracecmd/libtracecmd-iterate.txt
index 12c54b2ce1a0..dc053ccbbade 100644
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
@@ -45,6 +45,7 @@ int *tracecmd_follow_missed_events*(struct tracecmd_input pass:[*]_handle_,
 				   void pass:[*]_callback_data_);
 struct tracecmd_filter pass:[*]*tracecmd_filter_add*(struct tracecmd_input *_handle_,
 					    const char pass:[*]_filter_str_, bool _neg_);
+int *tracecmd_iterate_reset*(struct tracecmd_input pass:[*]_handle_);
 --
 
 DESCRIPTION
@@ -140,6 +141,10 @@ is defined by *tep_filter_add_filter_str(3)*. If _neg_ is true, then the events
 that match the filter will be skipped, otherwise the events that match will execute
 the _callback()_ function in the iterators.
 
+The *tracecmd_iterate_reset()* sets the _handle_ back to start at the beginning, so that
+the next call to *tracecmd_iterate_events()* starts back at the first event again, instead
+of continuing where it left off.
+
 RETURN VALUE
 ------------
 Both *tracecmd_iterate_events()*, *tracecmd_iterate_events_reverse()* and
@@ -147,6 +152,9 @@ Both *tracecmd_iterate_events()*, *tracecmd_iterate_events_reverse()* and
 (handling the follow and filters appropriately). Or an error value, which can include
 returning a non-zero result from the _callback()_ function.
 
+*tracecmd_iterate_reset()* returns 0 on success and -1 if an error occurred. Note,
+if -1 is returned, a partial reset may have also happened.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index bbe6cc78b575..52d4e5994c14 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -61,6 +61,7 @@ Iterating over events in a trace file:
 					   void pass:[*]_callback_data_);
 	struct tracecmd_filter pass:[*]*tracecmd_filter_add*(struct tracecmd_input *_handle_,
 						    const char pass:[*]_filter_str_, bool _neg_);
+	int *tracecmd_iterate_reset*(struct tracecmd_input pass:[*]_handle_);
 
 Read tracing instances from a trace file:
 	int *tracecmd_buffer_instances*(struct tracecmd_input pass:[*]_handle_);
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index e6527b7116c1..55a0c51845b0 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -72,6 +72,8 @@ int tracecmd_follow_missed_events(struct tracecmd_input *handle,
 						  int, void *),
 				  void *callback_data);
 
+int tracecmd_iterate_reset(struct tracecmd_input *handle);
+
 int tracecmd_iterate_events(struct tracecmd_input *handle,
 			    cpu_set_t *cpus, int cpu_size,
 			    int (*callback)(struct tracecmd_input *handle,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index bf070f057ed0..88bef83f4fe0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2113,6 +2113,38 @@ tracecmd_read_cpu_first(struct tracecmd_input *handle, int cpu)
 	return tracecmd_read_data(handle, cpu);
 }
 
+/**
+ * tracecmd_iterate_reset - Set the handle to iterate from the beginning
+ * @handle: input handle for the trace.dat file
+ *
+ * This causes tracecmd_iterate_events*() to start from the beginning
+ * of the trace.dat file.
+ */
+int tracecmd_iterate_reset(struct tracecmd_input *handle)
+{
+	unsigned long long page_offset;
+	int cpu;
+	int ret = 0;
+	int r;
+
+	for (cpu = 0; cpu < handle->cpus; cpu++) {
+		page_offset = calc_page_offset(handle, handle->cpu_data[cpu].file_offset);
+
+		r = get_page(handle, cpu, page_offset);
+		if (r < 0) {
+			ret = -1;
+			continue; /* ?? */
+		}
+
+		/* If the page was already mapped, we need to reset it */
+		if (r)
+			update_page_info(handle, cpu);
+
+		free_next(handle, cpu);
+	}
+	return ret;
+}
+
 /**
  * tracecmd_read_cpu_last - get the last record in a CPU
  * @handle: input handle for the trace.dat file
-- 
2.42.0

