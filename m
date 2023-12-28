Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8275D101FE
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19847C433A9;
	Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIx7z-00000000DtI-3WDr;
	Thu, 28 Dec 2023 15:37:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 12/23] libtracefs: Add tracefs_instance_get/set_buffer_percent()
Date: Thu, 28 Dec 2023 15:35:34 -0500
Message-ID: <20231228203714.53294-13-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228203714.53294-1-rostedt@goodmis.org>
References: <20231228203714.53294-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add an API that allows modifying the buffer_percent of the tracing ring
buffer. That is the amount that is written into the ring buffer before the
trace is woken up.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-utils.txt | 28 +++++++++++++++++++-
 Documentation/libtracefs.txt                 |  2 ++
 include/tracefs.h                            |  3 +++
 src/tracefs-utils.c                          | 27 +++++++++++++++++++
 4 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
index bc8c9a7bf8e9..d2c4f163902d 100644
--- a/Documentation/libtracefs-instances-utils.txt
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -4,7 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_instance_get_name, tracefs_instance_get_trace_dir, tracefs_instances_walk, tracefs_instance_exists,
-tracefs_instance_get_buffer_size, tracefs_instance_set_buffer_size - Helper functions for working with tracing instances.
+tracefs_instance_get_buffer_size, tracefs_instance_set_buffer_size, tracefs_instance_get_buffer_percent,
+tracefs_instance_set_buffer_percent - Helper functions for working with tracing instances.
 
 SYNOPSIS
 --------
@@ -18,6 +19,8 @@ int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void
 bool *tracefs_instance_exists*(const char pass:[*]_name_);
 size_t *tracefs_instance_get_buffer_size*(struct tracefs_instance pass:[*]_instance_, int _cpu_);
 int *tracefs_instance_set_buffer_size*(struct tracefs_instance pass:[*]_instance_, size_t _size_, int _cpu_);
+int *tracefs_instance_get_buffer_percent*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_instance_set_buffer_percent*(struct tracefs_instance pass:[*]_instance_, int _val_);
 --
 
 DESCRIPTION
@@ -48,6 +51,29 @@ If _cpu_ is negative, then it sets all the per CPU ring buffers to _size_ (note
 the total size is the number of CPUs * _size_). If _cpu_ is specified, then it only
 sets the size of the per CPU ring buffer.
 
+The *tracefs_instance_set_buffer_percent()* sets the buffer percent value of
+the tracing ring buffer for _instance_ or the top level buffer if _instance_ is
+NULL. The buffer percent decides when readers on *tracefs_cpu_read*(3),
+*tracefs_cpu_buffered_read*(3), *tracefs_cpu_write*(3) and *tracefs_cpu_pipe*(3)
+will block when O_NONBLOCK is not set. The value of _val_ must be between 0 and
+100, where:
+
+[verse]
+--
+  0   - block until there's any data in the ring buffer
+  1   - block until 1% of the ring buffer sub-buffers are filled
+  50  - block until 50% of the ring buffer sub-buffers are filled
+  100 - block until the entire ring buffer is filled
+--
+
+Note, any number from 0 to 100 can be used where it is the percentage of the
+ring buffer that must be filled before a blocked reader will be notified that
+there's data to be retrieved.
+
+The *tracefs_instance_get_buffer_percent()* retrieves the current buffer percent
+setting of the tracing ring buffer for _instance_ or the top level buffer
+if _instance_ is NULL.
+
 RETURN VALUE
 ------------
 The *tracefs_instance_get_name()* returns a string or NULL in case of the top
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 8ca19a04fe77..529922580f8d 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -50,6 +50,8 @@ Trace instances:
 	char pass:[*]*tracefs_instance_get_affinity_raw*(struct tracefs_instance pass:[*]_instance_);
 	size_t *tracefs_instance_get_buffer_size*(struct tracefs_instance pass:[*]_instance_, int _cpu_);
 	int *tracefs_instance_set_buffer_size*(struct tracefs_instance pass:[*]_instance_, size_t _size_, int _cpu_);
+	int *tracefs_instance_get_buffer_percent*(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_instance_set_buffer_percent*(struct tracefs_instance pass:[*]_instance_, int _val_);
 
 Trace events:
 	char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 1722cbd60598..4be66b488536 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -64,6 +64,9 @@ ssize_t tracefs_instance_get_buffer_size(struct tracefs_instance *instance, int
 int tracefs_instance_set_buffer_size(struct tracefs_instance *instance, size_t size, int cpu);
 char **tracefs_instances(const char *regex);
 
+int tracefs_instance_get_buffer_percent(struct tracefs_instance *instance);
+int tracefs_instance_set_buffer_percent(struct tracefs_instance *instance, int val);
+
 bool tracefs_instance_exists(const char *name);
 bool tracefs_file_exists(struct tracefs_instance *instance, const char *name);
 bool tracefs_dir_exists(struct tracefs_instance *instance, const char *name);
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index e67b698f5b99..50a7c7474145 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -643,3 +643,30 @@ bool tracefs_tracer_available(const char *tracing_dir, const char *tracer)
 	tracefs_list_free(tracers);
 	return ret;
 }
+
+/**
+ * tracefs_instance_get_buffer_percent - get the instance buffer percent
+ * @instance: The instance to get from (NULL for toplevel)
+ *
+ * Returns the buffer percent setting of the given instance.
+ *  (-1 if not found).
+ */
+int tracefs_instance_get_buffer_percent(struct tracefs_instance *instance)
+{
+	long long val;
+	int ret;
+
+	ret = tracefs_instance_file_read_number(instance, "buffer_percent", &val);
+	return !ret ? (int)val : ret;
+}
+
+/**
+ * tracefs_instance_set_buffer_percent - set the instance buffer percent
+ * @instance: The instance to set (NULL for toplevel)
+ *
+ * Returns zero on success or -1 on error
+ */
+int tracefs_instance_set_buffer_percent(struct tracefs_instance *instance, int val)
+{
+	return tracefs_instance_file_write_number(instance, "buffer_percent", val);
+}
-- 
2.42.0

