Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4C510948
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E1AC433B9;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKp-00000000EJl-0rdB;
	Thu, 28 Dec 2023 16:54:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 18/22] libtracefs: Add tracefs_instance_set/get_subbuf_size()
Date: Thu, 28 Dec 2023 16:52:13 -0500
Message-ID: <20231228215433.54854-19-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228215433.54854-1-rostedt@goodmis.org>
References: <20231228215433.54854-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add API to retrieve and modify the current sub-buffer size.

  tracefs_instance_set_subbuf_size()
  tracefs_instance_get_subbuf_size()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-subbuf.txt | 152 ++++++++++++++++++
 Documentation/libtracefs.txt                  |   4 +
 include/tracefs.h                             |   2 +
 samples/Makefile                              |   1 +
 src/tracefs-instance.c                        |  37 +++++
 5 files changed, 196 insertions(+)
 create mode 100644 Documentation/libtracefs-instances-subbuf.txt

diff --git a/Documentation/libtracefs-instances-subbuf.txt b/Documentation/libtracefs-instances-subbuf.txt
new file mode 100644
index 000000000000..8d5c3e0ed3bd
--- /dev/null
+++ b/Documentation/libtracefs-instances-subbuf.txt
@@ -0,0 +1,152 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_instance_get_subbuf_size, tracefs_instance_set_subbuf_size - Helper functions for working with ring buffer sub buffers.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+size_t *tracefs_instance_get_subbuf_size*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_instance_set_subbuf_size*(struct tracefs_instance pass:[*]_instance_, size_t _size_);
+--
+
+DESCRIPTION
+-----------
+Helper functions for working with the sub-buffers of the tracing ring buffer.
+The tracing ring buffer is broken up into *sub-buffers*. An event can not be
+bigger than the data section of the sub-buffer (see *tep_get_sub_buffer_data_size*(3)).
+By default, the ring buffer uses the architectures *page_size* as the default
+size of the sub-buffer, but this can be limiting if there is a need for large
+events, for example, the application wants to write large strings into
+the trace_marker file.
+
+The *tracefs_instance_get_subbuf_size()* returns the current size in kilobytes
+fo the ring buffer sub-buffers.
+
+The *tracefs_instance_set_subbuf_size()* will write the size in kilobytes of
+what the new sub-buffer size should be. Note, that this is only a hint to what
+the minimum sub-buffer size should be. It also does not take into account the
+meta-data that is used by the sub-buffer, so the size written should be no less
+than 16 bytes more than the maximum event size that will be used. The kernel
+will likely make the sub-buffer size larger than specified, as it may need to
+align the size for implementation purposes.
+
+RETURN VALUE
+------------
+The *tracefs_instance_get_subbuf_size()* returns the size of the current
+sub-buffer for the given _instance_ ring buffer or -1 on error.
+
+The *tracefs_instance_set_subbuf_size()* will return 0 if it successfully set
+the _instance_ ring buffer sub-buffer size in kilobytes, or -1 on error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <tracefs.h>
+#include <errno.h>
+
+int main(int argc, char **argv)
+{
+	struct tep_handle *tep;
+	ssize_t save_subsize;
+	ssize_t subsize;
+	char *trace;
+	char buf[3000];
+	int meta_size;
+	int ret;
+	int i;
+
+	tep = tep_alloc();
+	ret = tracefs_load_headers(NULL, tep);
+	tep_free(tep);
+
+	if (ret < 0) {
+		perror("reading headers");
+		exit(-1);
+	}
+
+	meta_size = tep_get_sub_buffer_size(tep) - tep_get_sub_buffer_data_size(tep);
+
+	save_subsize = tracefs_instance_get_subbuf_size(NULL);
+	if (save_subsize < 0) {
+		printf("Changing sub-buffer size not available\n");
+		exit(-1);
+	}
+
+	subsize = save_subsize * 1024;
+
+	/* Have at least 4 writes fit on a sub-buffer */
+	if (subsize - meta_size < sizeof(buf) *4 ) {
+		subsize = ((sizeof(buf) * 4 + meta_size) + 1023) / 1024;
+		tracefs_instance_set_subbuf_size(NULL, subsize);
+	}
+
+	for (i = 0; i < sizeof(buf) - 1; i++) {
+		buf[i] = '0' + i % 10;
+	}
+	buf[i] = '\0';
+
+	tracefs_instance_clear(NULL);
+
+	for (i = 0; i < 4; i++) {
+		ret = tracefs_printf(NULL, "%s\n", buf);
+		if (ret < 0)
+			perror("write");
+	}
+
+	trace = tracefs_instance_file_read(NULL, "trace", NULL);
+	printf("%s\n", trace);
+	free(trace);
+
+	printf("Buffer size was: %zd * 1024\n",
+	       tracefs_instance_get_subbuf_size(NULL));
+
+	tracefs_instance_set_subbuf_size(NULL, save_subsize);
+}
+--
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 6752ed3c9b98..1962b3b34622 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -324,6 +324,10 @@ Recording of trace_pipe_raw files:
 	struct kbuffer pass:[*]*tracefs_cpu_buffered_read_buf*(struct tracefs_cpu pass:[*]_tcpu_, bool _nonblock_);
 	struct kbuffer pass:[*]*tracefs_cpu_flush_buf*(struct tracefs_cpu pass:[*]_tcpu_);
 
+Helper functions for modifying the ring buffer sub-buffers:
+	size_t *tracefs_instance_get_subbuf_size*(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_instance_set_subbuf_size*(struct tracefs_instance pass:[*]_instance_, size_t _size_);
+
 Helper functions for guest tracing:
 	char pass:[*]*tracefs_find_cid_pid*(int _cid_);
 	char pass:[*]*tracefs_instance_find_cid_pid*(struct tracefs_instance pass:[*]_instance_, int _cid_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 3ae78d4f3af7..c66bfd2edf0b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -63,6 +63,8 @@ int tracefs_instance_get_affinity_set(struct tracefs_instance *instance,
 				      cpu_set_t *set, size_t set_size);
 ssize_t tracefs_instance_get_buffer_size(struct tracefs_instance *instance, int cpu);
 int tracefs_instance_set_buffer_size(struct tracefs_instance *instance, size_t size, int cpu);
+ssize_t tracefs_instance_get_subbuf_size(struct tracefs_instance *instance);
+int tracefs_instance_set_subbuf_size(struct tracefs_instance *instance, size_t size);
 char **tracefs_instances(const char *regex);
 
 int tracefs_instance_get_buffer_percent(struct tracefs_instance *instance);
diff --git a/samples/Makefile b/samples/Makefile
index 787d28769051..77739c8b0aa7 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -25,6 +25,7 @@ EXAMPLES += cpu
 EXAMPLES += guest
 EXAMPLES += cpu-buf
 EXAMPLES += instances-stat
+EXAMPLES += instances-subbuf
 
 TARGETS :=
 TARGETS += sqlhist
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 2162424ad3a7..8d9dd0e21498 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -441,6 +441,43 @@ int tracefs_instance_set_buffer_size(struct tracefs_instance *instance, size_t s
 	return ret < 0 ? -1 : 0;
 }
 
+/**
+ * tracefs_instance_get_subbuf_size - return the sub-buffer size of the ring buffer
+ * @instance: The instance to get the buffer size from
+ *
+ * Returns the sub-buffer size in kilobytes.
+ * Returns -1 on error.
+ */
+ssize_t tracefs_instance_get_subbuf_size(struct tracefs_instance *instance)
+{
+	long long size;
+	int ret;
+
+	ret = tracefs_instance_file_read_number(instance, "buffer_subbuf_size_kb", &size);
+	if (ret < 0)
+		return ret;
+
+	return size;
+}
+
+/**
+ * tracefs_instance_set_buffer_size - modify the ring buffer sub-buffer size
+ * @instance: The instance to modify (NULL for the top level)
+ * @size: The size in kilobytes to to set the sub-buffer size to
+ *
+ * Sets the sub-buffer size in kilobytes for the given ring buffer.
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int tracefs_instance_set_subbuf_size(struct tracefs_instance *instance, size_t size)
+{
+	int ret;
+
+	ret = tracefs_instance_file_write_number(instance, "buffer_subbuf_size_kb", size);
+
+	return ret < 0 ? -1 : 0;
+}
+
 /**
  * tracefs_instance_get_trace_dir - return the top trace directory, where the instance is confuigred
  * @instance: ftrace instance
-- 
2.42.0

