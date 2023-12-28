Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6444A10977
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D27AC433AB;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKp-00000000EJJ-05f3;
	Thu, 28 Dec 2023 16:54:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 11/22] libtracefs: Add API to read tracefs_cpu and return a kbuffer
Date: Thu, 28 Dec 2023 16:52:06 -0500
Message-ID: <20231228215433.54854-12-rostedt@goodmis.org>
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

Instead of having the caller have to allocate a buffer and a kbuffer to read
the content of a tracefs_cpu, add an interface to allow the tracefs_cpu to
handle this for the application.

The following three functions are added to the API:

    tracefs_cpu_read_buf()
    tracefs_cpu_buffered_read_buf()
    tracefs_cpu_flush_buf()

That act the same as the corresponding functions with the same name minus the
ending "_buf", but instead of requiring to send a buffer in and then add it to
a kbuffer element to read, just return a kbuffer structure that can be used to
read.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-cpu-buf.txt | 171 +++++++++++++++++++++++++++
 Documentation/libtracefs-cpu.txt     |   3 +
 Documentation/libtracefs.txt         |   3 +
 include/tracefs.h                    |   4 +
 samples/Makefile                     |   1 +
 src/tracefs-record.c                 | 116 ++++++++++++++++++
 6 files changed, 298 insertions(+)
 create mode 100644 Documentation/libtracefs-cpu-buf.txt

diff --git a/Documentation/libtracefs-cpu-buf.txt b/Documentation/libtracefs-cpu-buf.txt
new file mode 100644
index 000000000000..943cb1f2f437
--- /dev/null
+++ b/Documentation/libtracefs-cpu-buf.txt
@@ -0,0 +1,171 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_cpu_read_buf, tracefs_cpu_buffered_read_buf, tracefs_cpu_flush_buf
+- Reading trace_pipe_raw data returning a kbuffer
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct kbuffer pass:[*]*tracefs_cpu_read_buf*(struct tracefs_cpu pass:[*]_tcpu_, bool _nonblock_);
+struct kbuffer pass:[*]*tracefs_cpu_buffered_read_buf*(struct tracefs_cpu pass:[*]_tcpu_, bool _nonblock_);
+struct kbuffer pass:[*]*tracefs_cpu_flush_buf*(struct tracefs_cpu pass:[*]_tcpu_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to read the raw data from the trace_pipe_raw
+files in the tracefs file system and return a kbuffer structure to read it with.
+
+The *tracefs_cpu_read_buf()* reads the trace_pipe_raw files associated to _tcpu_
+and returns a kbuffer structure that can be used to iterate the events.
+If _nonblock_ is set, and there's no data available, it will return immediately.
+Otherwise depending on how _tcpu_ was opened, it will block. If _tcpu_ was
+opened with nonblock set, then this _nonblock_ will make no difference.
+
+The *tracefs_cpu_buffered_read_buf()* is basically the same as *tracefs_cpu_read_buf()*
+except that it uses a pipe through splice to buffer reads. This will batch
+reads keeping the reading from the ring buffer less intrusive to the system,
+as just reading all the time can cause quite a disturbance. Note, one
+difference between this and *tracefs_cpu_read()* is that it will read only in
+sub buffer pages. If the ring buffer has not filled a page, then it will not
+return anything, even with _nonblock_ set.  Calls to *tracefs_cpu_flush_buf()*
+or *tracefs_cpu_flush()* should be done to read the rest of the file at the
+end of the trace.
+
+The *tracefs_cpu_flush_buf()* reads the trace_pipe_raw file associated by the
+_tcpu_ and puts it into _buffer_, which must be the size of the sub buffer
+which is retrieved.  This should be called at the end of tracing
+to get the rest of the data. This call will convert the file descriptor of
+trace_pipe_raw into non-blocking mode.
+
+RETURN VALUE
+------------
+The functions *tracefs_cpu_read_buf()*, tracefs_cpu_buffered_read_buf()* and
+*tracefs_cpu_flush()* returns a kbuffer descriptor that can be iterated
+over to find the events. Note, this descriptor is part of the tracefs_cpu structure
+and should not be freed. It will be freed. It returns NULL on error or if nonblock
+is set and there are no events available. In the case of no events, errno will be
+set with EAGAIN.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <ctype.h>
+#include <tracefs.h>
+
+static void read_page(struct tep_handle *tep, struct kbuffer *kbuf)
+{
+	static struct trace_seq seq;
+	struct tep_record record;
+
+	if (seq.buffer)
+		trace_seq_reset(&seq);
+	else
+		trace_seq_init(&seq);
+
+	while ((record.data = kbuffer_read_event(kbuf, &record.ts))) {
+		record.size = kbuffer_event_size(kbuf);
+		kbuffer_next_event(kbuf, NULL);
+		tep_print_event(tep, &seq, &record,
+				"%s-%d %9d\t%s: %s\n",
+				TEP_PRINT_COMM,
+				TEP_PRINT_PID,
+				TEP_PRINT_TIME,
+				TEP_PRINT_NAME,
+				TEP_PRINT_INFO);
+		trace_seq_do_printf(&seq);
+		trace_seq_reset(&seq);
+	}
+}
+
+int main (int argc, char **argv)
+{
+	struct tracefs_cpu *tcpu;
+	struct tep_handle *tep;
+	struct kbuffer *kbuf;
+	int cpu;
+
+	if (argc < 2 || !isdigit(argv[1][0])) {
+		printf("usage: %s cpu\n\n", argv[0]);
+		exit(-1);
+	}
+
+	cpu = atoi(argv[1]);
+
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		perror("Reading trace event formats");
+		exit(-1);
+	}
+
+	tcpu = tracefs_cpu_open(NULL, cpu, 0);
+	if (!tcpu) {
+		perror("Open CPU 0 file");
+		exit(-1);
+	}
+
+	while ((kbuf = tracefs_cpu_buffered_read_buf(tcpu, true))) {
+		read_page(tep, kbuf);
+	}
+
+	kbuf = tracefs_cpu_flush_buf(tcpu);
+	if (kbuf)
+		read_page(tep, kbuf);
+
+	tracefs_cpu_close(tcpu);
+	tep_free(tep);
+
+	return 0;
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
+*tracefs_cpu_open*(3)
+*tracefs_cpu_close*(3)
+*tracefs_cpu_read*(3)
+*tracefs_cpu_buffered_read*(3)
+*tracefs_cpu_flush*(3)
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
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
+Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-cpu.txt b/Documentation/libtracefs-cpu.txt
index d6215d9912c0..6fb65248089b 100644
--- a/Documentation/libtracefs-cpu.txt
+++ b/Documentation/libtracefs-cpu.txt
@@ -212,6 +212,9 @@ SEE ALSO
 --------
 *tracefs_cpu_open*(3)
 *tracefs_cpu_close*(3)
+*tracefs_cpu_read_buf*(3)
+*tracefs_cpu_buffered_read_buf*(3)
+*tracefs_cpu_flush_buf*(3)
 *libtracefs*(3),
 *libtraceevent*(3),
 *trace-cmd*(1)
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 11ff576e826c..8ca19a04fe77 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -304,6 +304,9 @@ Recording of trace_pipe_raw files:
 	int *tracefs_cpu_flush*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_);
 	int *tracefs_cpu_flush_write*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_);
 	int *tracefs_cpu_pipe*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_, bool _nonblock_);
+	struct kbuffer pass:[*]*tracefs_cpu_read_buf*(struct tracefs_cpu pass:[*]_tcpu_, bool _nonblock_);
+	struct kbuffer pass:[*]*tracefs_cpu_buffered_read_buf*(struct tracefs_cpu pass:[*]_tcpu_, bool _nonblock_);
+	struct kbuffer pass:[*]*tracefs_cpu_flush_buf*(struct tracefs_cpu pass:[*]_tcpu_);
 
 Helper functions for guest tracing:
 	char pass:[*]*tracefs_find_cid_pid*(int _cid_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 0971d54dd7c7..1722cbd60598 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -9,6 +9,7 @@
 #include <fcntl.h>
 #include <sched.h>
 #include <event-parse.h>
+#include <kbuffer.h>
 
 char *tracefs_get_tracing_file(const char *name);
 void tracefs_put_tracing_file(char *name);
@@ -641,10 +642,13 @@ void tracefs_cpu_close(struct tracefs_cpu *tcpu);
 void tracefs_cpu_free_fd(struct tracefs_cpu *tcpu);
 int tracefs_cpu_read_size(struct tracefs_cpu *tcpu);
 int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock);
+struct kbuffer *tracefs_cpu_read_buf(struct tracefs_cpu *tcpu, bool nonblock);
 int tracefs_cpu_buffered_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock);
+struct kbuffer *tracefs_cpu_buffered_read_buf(struct tracefs_cpu *tcpu, bool nonblock);
 int tracefs_cpu_write(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
 int tracefs_cpu_stop(struct tracefs_cpu *tcpu);
 int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer);
+struct kbuffer *tracefs_cpu_flush_buf(struct tracefs_cpu *tcpu);
 int tracefs_cpu_flush_write(struct tracefs_cpu *tcpu, int wfd);
 int tracefs_cpu_pipe(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
 
diff --git a/samples/Makefile b/samples/Makefile
index d782e8f79424..13ad99579ea3 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -23,6 +23,7 @@ EXAMPLES += stream
 EXAMPLES += instances-affinity
 EXAMPLES += cpu
 EXAMPLES += guest
+EXAMPLES += cpu-buf
 
 TARGETS :=
 TARGETS += sqlhist
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 8750fe7e0e29..bfeae18fd77f 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -34,6 +34,8 @@ struct tracefs_cpu {
 	int		subbuf_size;
 	int		buffered;
 	int		splice_read_flags;
+	struct kbuffer	*kbuf;
+	void		*buffer;
 };
 
 /**
@@ -106,6 +108,7 @@ tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
 {
 	struct tracefs_cpu *tcpu;
 	struct tep_handle *tep;
+	struct kbuffer *kbuf;
 	char path[128];
 	char *buf;
 	int mode = O_RDONLY;
@@ -138,6 +141,11 @@ tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
 		goto fail;
 
 	subbuf_size = tep_get_sub_buffer_size(tep);
+
+	kbuf = tep_kbuffer(tep);
+	if (!kbuf)
+		goto fail;
+
 	tep_free(tep);
 	tep = NULL;
 
@@ -145,6 +153,8 @@ tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
 	if (!tcpu)
 		goto fail;
 
+	tcpu->kbuf = kbuf;
+
 	return tcpu;
  fail:
 	tep_free(tep);
@@ -173,6 +183,7 @@ void tracefs_cpu_free_fd(struct tracefs_cpu *tcpu)
 	close_fd(tcpu->splice_pipe[0]);
 	close_fd(tcpu->splice_pipe[1]);
 
+	kbuffer_free(tcpu->kbuf);
 	free(tcpu);
 }
 
@@ -317,6 +328,49 @@ int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
 	return ret;
 }
 
+static bool get_buffer(struct tracefs_cpu *tcpu)
+{
+	if (!tcpu->buffer) {
+		tcpu->buffer = malloc(tcpu->subbuf_size);
+		if (!tcpu->buffer)
+			return false;
+	}
+	return true;
+}
+
+/**
+ * tracefs_cpu_read_buf - read from the raw trace file and return kbuffer
+ * @tcpu: The descriptor representing the raw trace file
+ * @nonblock: Hint to not block on the read if there's no data.
+ *
+ * Reads the trace_pipe_raw files associated to @tcpu and returns a kbuffer
+ * associated with the read that can be used to parse events.
+ *
+ * If @nonblock is set, and there's no data available, it will return
+ * immediately. Otherwise depending on how @tcpu was opened, it will
+ * block. If @tcpu was opened with nonblock set, then this @nonblock
+ * will make no difference.
+ *
+ * Returns a kbuffer associated to the next sub-buffer or NULL on error
+ * or no data to read with nonblock set (EAGAIN will be set).
+ *
+ * The kbuffer returned should not be freed!
+ */
+struct kbuffer *tracefs_cpu_read_buf(struct tracefs_cpu *tcpu, bool nonblock)
+{
+	int ret;
+
+	if (!get_buffer(tcpu))
+		return NULL;
+
+	ret = tracefs_cpu_read(tcpu, tcpu->buffer, nonblock);
+	if (ret <= 0)
+		return NULL;
+
+	kbuffer_load_subbuffer(tcpu->kbuf, tcpu->buffer);
+	return tcpu->kbuf;
+}
+
 static int init_splice(struct tracefs_cpu *tcpu)
 {
 	char *buf;
@@ -409,6 +463,42 @@ int tracefs_cpu_buffered_read(struct tracefs_cpu *tcpu, void *buffer, bool nonbl
 	return ret;
 }
 
+/**
+ * tracefs_cpu_buffered_read_buf - Read the raw trace data buffering through a pipe
+ * @tcpu: The descriptor representing the raw trace file
+ * @nonblock: Hint to not block on the read if there's no data.
+ *
+ * This is basically the same as tracefs_cpu_read() except that it uses
+ * a pipe through splice to buffer reads. This will batch reads keeping
+ * the reading from the ring buffer less intrusive to the system, as
+ * just reading all the time can cause quite a disturbance.
+ *
+ * Note, one difference between this and tracefs_cpu_read() is that it
+ * will read only in sub buffer pages. If the ring buffer has not filled
+ * a page, then it will not return anything, even with @nonblock set.
+ * Calls to tracefs_cpu_flush() should be done to read the rest of
+ * the file at the end of the trace.
+ *
+ * Returns a kbuffer associated to the next sub-buffer or NULL on error
+ * or no data to read with nonblock set (EAGAIN will be set).
+ *
+ * The kbuffer returned should not be freed!
+ */
+struct kbuffer *tracefs_cpu_buffered_read_buf(struct tracefs_cpu *tcpu, bool nonblock)
+{
+	int ret;
+
+	if (!get_buffer(tcpu))
+		return NULL;
+
+	ret = tracefs_cpu_buffered_read(tcpu, tcpu->buffer, nonblock);
+	if (ret <= 0)
+		return NULL;
+
+	kbuffer_load_subbuffer(tcpu->kbuf, tcpu->buffer);
+	return tcpu->kbuf;
+}
+
 /**
  * tracefs_cpu_stop - Stop a blocked read of the raw tracing file
  * @tcpu: The descriptor representing the raw trace file
@@ -492,6 +582,32 @@ int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer)
 	return ret;
 }
 
+/**
+ * tracefs_cpu_flush_buf - Finish out and read the rest of the raw tracing file
+ * @tcpu: The descriptor representing the raw trace file
+ *
+ * Reads the trace_pipe_raw file associated by the @tcpu and puts it
+ * into @buffer, which must be the size of the sub buffer which is retrieved.
+ * by tracefs_cpu_read_size(). This should be called at the end of tracing
+ * to get the rest of the data.
+ *
+ * This will set the file descriptor for reading to non-blocking mode.
+ */
+struct kbuffer *tracefs_cpu_flush_buf(struct tracefs_cpu *tcpu)
+{
+	int ret;
+
+	if (!get_buffer(tcpu))
+		return NULL;
+
+	ret = tracefs_cpu_flush(tcpu, tcpu->buffer);
+	if (ret <= 0)
+		return NULL;
+
+	kbuffer_load_subbuffer(tcpu->kbuf, tcpu->buffer);
+	return tcpu->kbuf;
+}
+
 /**
  * tracefs_cpu_flush_write - Finish out and read the rest of the raw tracing file
  * @tcpu: The descriptor representing the raw trace file
-- 
2.42.0

