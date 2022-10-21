Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A987C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Oct 2022 21:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiJUVY2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Oct 2022 17:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJUVYZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Oct 2022 17:24:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A032811837
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Oct 2022 14:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AC8BB82D1B
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Oct 2022 21:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6443DC433C1
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Oct 2022 21:24:20 +0000 (UTC)
Date:   Fri, 21 Oct 2022 17:24:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] libtracefs: Add reading of per cpu files
Message-ID: <20221021172426.0eb34368@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the APIs:

    tracefs_cpu_open()
    tracefs_cpu_close()
    tracefs_cpu_read_size()
    tracefs_cpu_read()
    tracefs_cpu_pipe_read()
    tracefs_cpu_pipe_write()
    tracefs_cpu_stop()
    tracefs_cpu_flush()
    tracefs_cpu_flush_write()

That will attach to a trace_pipe_raw file for a given instance and allow
opening, reading and writing to a file from it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/all/20221021163930.3f94bb1c@gandalf.local.home/

 - Removed unused "flags" variable in tracefs_cpu_flush()

 Documentation/libtracefs-cpu.txt | 239 +++++++++++++++
 Documentation/libtracefs.txt     |  12 +
 include/tracefs.h                |  14 +
 samples/Makefile                 |   1 +
 src/Makefile                     |   1 +
 src/tracefs-record.c             | 511 +++++++++++++++++++++++++++++++
 6 files changed, 778 insertions(+)
 create mode 100644 Documentation/libtracefs-cpu.txt
 create mode 100644 src/tracefs-record.c

diff --git a/Documentation/libtracefs-cpu.txt b/Documentation/libtracefs-cpu.txt
new file mode 100644
index 000000000000..1aaae97c7774
--- /dev/null
+++ b/Documentation/libtracefs-cpu.txt
@@ -0,0 +1,239 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_cpu_open, tracefs_cpu_close, tracefs_cpu_read_size, tracefs_cpu_read,
+tracefs_cpu_pipe_read, tracefs_cpu_pipe_write, tracefs_cpu_stop, tracefs_cpu_flush,
+tracefs_cpu_flush_write - Reading trace_pipe_raw data
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_cpu pass:[*]*tracefs_cpu_open*(struct tracefs_instance pass:[*]_instance_,
+				     int _cpu_, bool _nonblock_);
+void *tracefs_cpu_close*(struct tracefs_cpu pass:[*]_tcpu_);
+int *tracefs_cpu_read_size*(struct tracefs_cpu pass:[*]_tcpu_);
+int *tracefs_cpu_read*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_, bool _nonblock_);
+int *tracefs_cpu_pipe_read*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_, bool _nonblock_);
+int *tracefs_cpu_pipe_write*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_, bool _nonblock_);
+int *tracefs_cpu_stop*(struct tracefs_cpu pass:[*]_tcpu_);
+int *tracefs_cpu_flush*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_);
+int *tracefs_cpu_flush_write*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to read the raw data from the trace_pipe_raw
+files in the tracefs file system.
+
+The *tracefs_cpu_open()* creates a descriptor that can read the tracefs
+trace_pipe_raw file for a given _cpu_ in a given _instance_. If _instance_ is
+NULL than the toplevel trace_pipe_raw file is used.
+
+The *tracefs_cpu_close()* closes all the file descriptors associated to the trace_pipe_raw
+opened by *tracefs_cpu_open()*.
+
+The *tracefs_cpu_read_size()* returns the subbuffer size of the trace_pipe_raw. This
+returns the minimum size of the buffer that is passed to the below functions.
+
+The *tracefs_cpu_read()* reads the trace_pipe_raw files associated to _tcpu_ into _buffer_.
+_buffer_ must be at least the size of the sub buffer of the ring buffer,
+which is returned by *tracefs_cpu_read_size()*. If _nonblock_ is set, and
+there's no data available, it will return immediately. Otherwise depending
+on how _tcpu_ was opened, it will block. If _tcpu_ was opened with nonblock
+set, then this _nonblock_ will make no difference.
+
+The *tracefs_cpu_pipe_read()* is basically the same as *tracefs_cpu_read()*
+except that it uses a pipe through splice to buffer reads. This will batch
+reads keeping the reading from the ring buffer less intrusive to the system,
+as just reading all the time can cause quite a disturbance. Note, one
+difference between this and *tracefs_cpu_read()* is that it will read only in
+sub buffer pages. If the ring buffer has not filled a page, then it will not
+return anything, even with _nonblock_ set.  Calls to *tracefs_cpu_flush()*
+should be done to read the rest of the file at the end of the trace.
+
+The *tracefs_cpu_pipe_write()* will pipe the data from the trace_pipe_raw
+file associated with _tcpu_ into the _wfd_ file descriptor. If _nonblock_ is set,
+then it will not block on if there's nothing to write. Note, it will only write
+sub buffer size data to _wfd_. Calls to tracefs_cpu_flush_write() are needed to
+write out the rest.
+
+The *tracefs_cpu_stop()* will attempt to unblock a task blocked on _tcpu_ reading it.
+On older kernels, it may not do anything for the pipe reads, as older kernels do not
+wake up tasks waiting on the ring buffer. Returns 0 if it definitely woke up any possible
+waiters, but returns 1 if it is not sure it worked and waiters may need to have a signal
+sent to them.
+
+The *tracefs_cpu_flush()* reads the trace_pipe_raw file associated by the _tcpu_ and puts it
+into _buffer_, which must be the size of the sub buffer which is retrieved.
+by *tracefs_cpu_read_size()*. This should be called at the end of tracing
+to get the rest of the data. This call will convert the file descriptor of
+trace_pipe_raw into non-blocking mode.
+
+The *tracefs_cpu_flush_write()* same as *trace_cpu_flush()* except it takes a file
+descriptor _wfd_ to flush the data into.
+
+RETURN VALUE
+------------
+The *tracefs_cpu_open()* returns a struct tracefs_cpu descriptor that can be
+used by the other functions or NULL on error.
+
+The *tracefs_cpu_read_size()* returns the minimum size of the buffers to be
+used with *tracefs_cpu_read()*, *tracefs_cpu_pipe_read()* and *tracefs_cpu_flush()*.
+Returns negative on error.
+
+The *tracefs_cpu_read()* returns the number of bytes read, or negative on error.
+
+The *tracefs_cpu_pipe_read()* returns the number of bytes read or negative on error.
+
+The *tracefs_cpu_pipe_write()* returns the number of bytes written to the file
+or negative on error.
+
+The *tracefs_cpu_stop()* returns zero if any waiters were guaranteed to be
+woken up from waiting on input, or returns one if this is an older kernel
+that does not supply that guarantee, and a signal may need to be sent to
+any waiters. Returns negative on error.
+
+The *tracefs_cpu_flush()* returns the number of bytes read or negative on error.
+
+The *tracefs_cpu_flush_write()* returns the number of bytes written to the
+file  or negative on error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#define _LARGEFILE64_SOURCE
+#include <stdlib.h>
+#include <ctype.h>
+#include <pthread.h>
+#include <unistd.h>
+#include <tracefs.h>
+
+struct thread_data {
+	struct tracefs_cpu	*tcpu;
+	int			done;
+	int			fd;
+};
+
+static void *thread_run(void *arg)
+{
+	struct thread_data *data = arg;
+	struct tracefs_cpu *tcpu = data->tcpu;
+	int fd = data->fd;
+	int ret;
+
+	while (!data->done) {
+		ret = tracefs_cpu_pipe_write(tcpu, fd, false);
+		printf("wrote %d\n", ret);
+	}
+	return NULL;
+}
+
+int main (int argc, char **argv)
+{
+	struct tracefs_instance *instance;
+	struct thread_data data;
+	pthread_t thread;
+	char *file;
+	int secs = 10;
+	int cpu;
+	int ret;
+
+	if (argc < 3 || !isdigit(argv[1][0])) {
+		printf("usage: %s cpu file_destination [sleep secs]\n\n", argv[0]);
+		exit(-1);
+	}
+
+	cpu = atoi(argv[1]);
+	file = argv[2];
+
+	if (argc > 3)
+		secs = atoi(argv[3]);
+
+	instance = tracefs_instance_create("cpu_write");
+	if (!instance) {
+		perror("create instance");
+		exit(-1);
+	}
+
+	memset(&data, 0, sizeof(data));
+
+	data.tcpu = tracefs_cpu_open(instance, cpu, 0);
+	if (!data.tcpu) {
+		perror("Open instance");
+		exit(-1);
+	}
+
+	data.fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (data.fd < 0) {
+		perror(file);
+		exit(-1);
+	}
+
+	pthread_create(&thread, NULL, thread_run, &data);
+
+	sleep(secs);
+
+	data.done = 1;
+	printf("stopping\n");
+	ret = tracefs_cpu_stop(data.tcpu);
+
+	printf("joining %d\n", ret);
+	pthread_join(thread, NULL);
+
+	tracefs_trace_off(instance);
+	do {
+		ret = tracefs_cpu_flush_write(data.tcpu, data.fd);
+		printf("flushed %d\n", ret);
+	} while (ret > 0);
+	tracefs_trace_on(instance);
+
+	tracefs_cpu_close(data.tcpu);
+	close(data.fd);
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
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index b81c0301c27a..efe65811089c 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -267,6 +267,18 @@ Histograms:
 	int *tracefs_hist_continue*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
 	int *tracefs_hist_reset*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
 
+Recording of trace_pipe_raw files:
+	struct tracefs_cpu pass:[*]*tracefs_cpu_open*(struct tracefs_instance pass:[*]_instance_,
+					     int _cpu_, bool _nonblock_);
+	void *tracefs_cpu_close*(struct tracefs_cpu pass:[*]_tcpu_);
+	int *tracefs_cpu_read_size*(struct tracefs_cpu pass:[*]_tcpu_);
+	int *tracefs_cpu_read*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_, bool _nonblock_);
+	int *tracefs_cpu_pipe_read*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_, bool _nonblock_);
+	int *tracefs_cpu_pipe_write*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_, bool _nonblock_);
+	int *tracefs_cpu_stop*(struct tracefs_cpu pass:[*]_tcpu_);
+	int *tracefs_cpu_flush*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_);
+	int *tracefs_cpu_flush_write*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_);
+
 --
 
 DESCRIPTION
diff --git a/include/tracefs.h b/include/tracefs.h
index 539548f30a74..b855bcc2c7d4 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -595,4 +595,18 @@ struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 struct tep_event *
 tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth);
 
+struct tracefs_cpu;
+
+struct tracefs_cpu *tracefs_cpu_open(struct tracefs_instance *instance,
+				     int cpu, bool nonblock);
+void tracefs_cpu_close(struct tracefs_cpu *tcpu);
+int tracefs_cpu_read_size(struct tracefs_cpu *tcpu);
+int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock);
+int tracefs_cpu_pipe_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock);
+int tracefs_cpu_pipe_write(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
+int tracefs_cpu_stop(struct tracefs_cpu *tcpu);
+int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer);
+int tracefs_cpu_flush_write(struct tracefs_cpu *tcpu, int wfd);
+
+
 #endif /* _TRACE_FS_H */
diff --git a/samples/Makefile b/samples/Makefile
index 7bc7ff4f00e1..743bddb67c2d 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -21,6 +21,7 @@ EXAMPLES += hist-cont
 EXAMPLES += tracer
 EXAMPLES += stream
 EXAMPLES += instances-affinity
+EXAMPLES += cpu
 
 TARGETS :=
 TARGETS += sqlhist
diff --git a/src/Makefile b/src/Makefile
index d28b8f419016..e2965bc5e1e9 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -14,6 +14,7 @@ OBJS += tracefs-filter.o
 OBJS += tracefs-dynevents.o
 OBJS += tracefs-eprobes.o
 OBJS += tracefs-uprobes.o
+OBJS += tracefs-record.o
 
 # Order matters for the the three below
 OBJS += sqlhist-lex.o
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
new file mode 100644
index 000000000000..31a57114554b
--- /dev/null
+++ b/src/tracefs-record.c
@@ -0,0 +1,511 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <dirent.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/select.h>
+
+#include <kbuffer.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+enum {
+	TC_STOP		= 1 << 0,	/* Stop reading */
+	TC_NONBLOCK	= 1 << 1,	/* read is non blocking */
+};
+
+struct tracefs_cpu {
+	int		cpu;
+	int		fd;
+	int		flags;
+	int		nfds;
+	int		ctrl_pipe[2];
+	int		splice_pipe[2];
+	int		pipe_size;
+	int		subbuf_size;
+	int		buffered;
+	int		splice_read_flags;
+};
+
+/**
+ * tracefs_cpu_open - open an instance raw trace file
+ * @instance: the instance (NULL for toplevel) of the cpu raw file to open
+ * @cpu: The CPU that the raw trace file is associated with
+ * @nonblock: If true, the file will be opened in O_NONBLOCK mode
+ *
+ * Return a descriptor that can read the tracefs trace_pipe_raw file
+ * for a give @cpu in a given @instance.
+ *
+ * Returns NULL on error.
+ */
+struct tracefs_cpu *
+tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
+{
+	struct tracefs_cpu *tcpu;
+	struct tep_handle *tep;
+	int mode = O_RDONLY;
+	char path[128];
+	char *buf;
+	int len;
+	int ret;
+
+	tcpu = calloc(1, sizeof(*tcpu));
+	if (!tcpu)
+		return NULL;
+
+	if (nonblock) {
+		mode |= O_NONBLOCK;
+		tcpu->flags |= TC_NONBLOCK;
+	}
+
+	tcpu->splice_pipe[0] = -1;
+	tcpu->splice_pipe[1] = -1;
+
+	sprintf(path, "per_cpu/cpu%d/trace_pipe_raw", cpu);
+
+	tcpu->cpu = cpu;
+	tcpu->fd = tracefs_instance_file_open(instance, path, mode);
+	if (tcpu->fd < 0) {
+		free(tcpu);
+		return NULL;
+	}
+
+	tep = tep_alloc();
+	if (!tep)
+		goto fail;
+
+	/* Get the size of the page */
+	buf = tracefs_instance_file_read(NULL, "events/header_page", &len);
+	if (!buf)
+		goto fail;
+
+	ret = tep_parse_header_page(tep, buf, len, sizeof(long));
+	free(buf);
+	if (ret < 0)
+		goto fail;
+
+	tcpu->subbuf_size = tep_get_sub_buffer_size(tep);
+	tep_free(tep);
+	tep = NULL;
+
+	if (tcpu->flags & TC_NONBLOCK) {
+		tcpu->ctrl_pipe[0] = -1;
+		tcpu->ctrl_pipe[1] = -1;
+	} else {
+		/* ctrl_pipe is used to break out of blocked reads */
+		ret = pipe(tcpu->ctrl_pipe);
+		if (ret < 0)
+			goto fail;
+		if (tcpu->ctrl_pipe[0] > tcpu->fd)
+			tcpu->nfds = tcpu->ctrl_pipe[0] + 1;
+		else
+			tcpu->nfds = tcpu->fd + 1;
+	}
+
+	return tcpu;
+ fail:
+	tep_free(tep);
+	close(tcpu->fd);
+	free(tcpu);
+	return NULL;
+}
+
+static void close_fd(int fd)
+{
+	if (fd < 0)
+		return;
+	close(fd);
+}
+
+/**
+ * tracefs_cpu_close - clean up and close a raw trace descriptor
+ * @tcpu: The descriptor created with tracefs_cpu_open()
+ *
+ * Closes all the file descriptors associated to the trace_pipe_raw
+ * opened by tracefs_cpu_open().
+ */
+void tracefs_cpu_close(struct tracefs_cpu *tcpu)
+{
+	if (!tcpu)
+		return;
+
+	close(tcpu->fd);
+	close_fd(tcpu->ctrl_pipe[0]);
+	close_fd(tcpu->ctrl_pipe[1]);
+	close_fd(tcpu->splice_pipe[0]);
+	close_fd(tcpu->splice_pipe[1]);
+
+	free(tcpu);
+}
+
+/**
+ * tracefs_cpu_read_size - Return the size of the sub buffer
+ * @tcpu: The descriptor that holds the size of the sub buffer
+ *
+ * A lot of the functions that read the data from the trace_pipe_raw
+ * expect the caller to have allocated enough space to store a full
+ * subbuffer. Calling this function is a requirement to do so.
+ */
+int tracefs_cpu_read_size(struct tracefs_cpu *tcpu)
+{
+	if (!tcpu)
+		return -1;
+	return tcpu->subbuf_size;
+}
+
+/*
+ * If set to blocking mode, block until the watermark has been
+ * reached, or the control has said to stop. If the contol is
+ * set, then nonblock will be set to true on the way out.
+ */
+static int wait_on_input(struct tracefs_cpu *tcpu, bool *nonblock)
+{
+	struct timeval tv, *ptv = NULL;
+	fd_set rfds;
+	int ret;
+
+	if (tcpu->flags & TC_NONBLOCK)
+		return 1;
+
+	if (*nonblock) {
+		tv.tv_sec = 0;
+		tv.tv_usec = 0;
+		ptv = &tv;
+	}
+
+	FD_ZERO(&rfds);
+	FD_SET(tcpu->fd, &rfds);
+	FD_SET(tcpu->ctrl_pipe[0], &rfds);
+
+	ret = select(tcpu->nfds, &rfds, NULL, NULL, ptv);
+
+	/* Let the application decide what to do with signals and such */
+	if (ret < 0)
+		return ret;
+
+	if (FD_ISSET(tcpu->ctrl_pipe[0], &rfds)) {
+		/* Flush the ctrl pipe */
+		read(tcpu->ctrl_pipe[0], &ret, 1);
+		*nonblock = true;
+	}
+
+	return FD_ISSET(tcpu->fd, &rfds);
+}
+
+static long set_nonblock(struct tracefs_cpu *tcpu)
+{
+	long flags;
+
+	flags = fcntl(tcpu->fd, F_GETFL);
+	fcntl(tcpu->fd, F_SETFL, flags | O_NONBLOCK);
+	return flags;
+}
+
+
+/**
+ * tracefs_cpu_read - read from the raw trace file
+ * @tcpu: The descriptor representing the raw trace file
+ * @buffer: Where to read into (must be at least the size of the subbuffer)
+ * @nonblock: Hint to not block on the read if there's no data.
+ *
+ * Reads the trace_pipe_raw files associated to @tcpu into @buffer.
+ * @buffer must be at least the size of the sub buffer of the ring buffer,
+ * which is returned by tracefs_cpu_read_size().
+ *
+ * If @nonblock is set, and there's no data available, it will return
+ * immediately. Otherwise depending on how @tcpu was opened, it will
+ * block. If @tcpu was opened with nonblock set, then this @nonblock
+ * will make no difference.
+ *
+ * Returns the amount read or -1 on error.
+ */
+int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
+{
+	bool orig_nonblock = nonblock;
+	long flags = 0;
+	int ret;
+
+	/*
+	 * If nonblock is set, then the wait_on_input() will return
+	 * immediately, if there's nothing in the buffer, with
+	 * ret == 0.
+	 */
+	ret = wait_on_input(tcpu, &nonblock);
+	if (ret <= 0)
+		return ret;
+
+	/* Temporarily make this nonblock if control woke this up */
+	if (nonblock != orig_nonblock && !(tcpu->flags & TC_NONBLOCK))
+		flags = set_nonblock(tcpu);
+
+	ret = read(tcpu->fd, buffer, tcpu->subbuf_size);
+
+	if (nonblock != orig_nonblock && !(tcpu->flags & TC_NONBLOCK))
+		fcntl(tcpu->fd, F_SETFL, flags);
+
+	return ret;
+}
+
+static int init_splice(struct tracefs_cpu *tcpu)
+{
+	int ret;
+
+	if (tcpu->splice_pipe[0] >= 0)
+		return 0;
+
+	ret = pipe(tcpu->splice_pipe);
+	if (ret < 0)
+		return ret;
+
+	ret = fcntl(tcpu->splice_pipe[0], F_GETPIPE_SZ, &tcpu->pipe_size);
+	/*
+	 * F_GETPIPE_SZ was introduced in 2.6.35, ftrace was introduced
+	 * in 2.6.31. If we are running on an older kernel, just fall
+	 * back to using subbuf_size for splice(). It could also return
+	 * the size of the pipe and not set pipe_size.
+	 */
+	if (ret > 0 && !tcpu->pipe_size)
+		tcpu->pipe_size = ret;
+	else if (ret < 0)
+		tcpu->pipe_size = tcpu->subbuf_size;
+
+	tcpu->splice_read_flags = SPLICE_F_MOVE;
+	if (tcpu->flags & TC_NONBLOCK)
+		tcpu->splice_read_flags |= SPLICE_F_NONBLOCK;
+
+	return 0;
+}
+
+/**
+ * tracefs_cpu_pipe_read - Read the raw trace data buffering through a pipe
+ * @tcpu: The descriptor representing the raw trace file
+ * @buffer: Where to read into (must be at least the size of the subbuffer)
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
+ * Returns the amount read or -1 on error.
+ */
+int tracefs_cpu_pipe_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
+{
+	int mode = SPLICE_F_MOVE;
+	int ret;
+
+	if (tcpu->buffered < 0)
+		tcpu->buffered = 0;
+
+	if (tcpu->buffered)
+		goto do_read;
+
+	ret = wait_on_input(tcpu, &nonblock);
+	if (ret <= 0)
+		return ret;
+
+	if (nonblock || tcpu->flags & TC_NONBLOCK)
+		mode |= SPLICE_F_NONBLOCK;
+
+	ret = init_splice(tcpu);
+	if (ret < 0)
+		return ret;
+
+	ret = splice(tcpu->fd, NULL, tcpu->splice_pipe[1], NULL,
+		     tcpu->pipe_size, mode);
+	if (ret <= 0)
+		return ret;
+
+	tcpu->buffered = ret;
+
+ do_read:
+	ret = read(tcpu->splice_pipe[0], buffer, tcpu->subbuf_size);
+	if (ret > 0)
+		tcpu->buffered -= ret;
+	return ret;
+}
+
+/**
+ * tracefs_cpu_stop - Stop a blocked read of the raw tracing file
+ * @tcpu: The descriptor representing the raw trace file
+ *
+ * This will attempt to unblock a task blocked on @tcpu reading it.
+ * On older kernels, it may not do anything for the pipe reads, as
+ * older kernels do not wake up tasks waiting on the ring buffer.
+ *
+ * Returns 0 if the tasks reading the raw tracing file does not
+ * need a nudge.
+ *
+ * Returns 1 if that tasks may need a nudge (send a signal).
+ *
+ * Returns negative on error.
+ */
+int tracefs_cpu_stop(struct tracefs_cpu *tcpu)
+{
+	int ret = 1;
+
+	if (tcpu->flags & TC_NONBLOCK)
+		return 0;
+
+	ret = write(tcpu->ctrl_pipe[1], &ret, 1);
+	if (ret < 0)
+		return ret;
+
+	/* Calling ioctl() on recent kernels will wake up the waiters */
+	ret = ioctl(tcpu->fd, 0);
+	if (ret < 0)
+		ret = 1;
+	else
+		ret = 0;
+
+	return ret;
+}
+
+/**
+ * tracefs_cpu_flush - Finish out and read the rest of the raw tracing file
+ * @tcpu: The descriptor representing the raw trace file
+ * @buffer: Where to read into (must be at least the size of the subbuffer)
+ *
+ * Reads the trace_pipe_raw file associated by the @tcpu and puts it
+ * into @buffer, which must be the size of the sub buffer which is retrieved.
+ * by tracefs_cpu_read_size(). This should be called at the end of tracing
+ * to get the rest of the data.
+ *
+ * This will set the file descriptor for reading to non-blocking mode.
+ *
+ * Returns the number of bytes read, or negative on error.
+ */
+int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer)
+{
+	int ret;
+
+	/* Make sure that reading is now non blocking */
+	if (!(tcpu->flags & TC_NONBLOCK)) {
+		set_nonblock(tcpu);
+		/* And keep it that way */
+		tcpu->flags |= TC_NONBLOCK;
+	}
+
+	if (tcpu->buffered < 0)
+		tcpu->buffered = 0;
+
+	if (tcpu->buffered)
+		goto do_read;
+
+ do_read:
+	ret = read(tcpu->fd, buffer, tcpu->subbuf_size);
+	if (ret > 0 && tcpu->buffered)
+		tcpu->buffered -= ret;
+
+	/* It's OK if there's no data to read */
+	if (ret < 0 && errno == EAGAIN)
+		ret = 0;
+
+	return ret;
+}
+
+/**
+ * tracefs_cpu_flush_write - Finish out and read the rest of the raw tracing file
+ * @tcpu: The descriptor representing the raw trace file
+ * @wfd: The write file descriptor to write the data to
+ *
+ * Reads the trace_pipe_raw file associated by the @tcpu and writes it to
+ * @wfd. This should be called at the end of tracing to get the rest of the data.
+ *
+ * Returns the number of bytes written, or negative on error.
+ */
+int tracefs_cpu_flush_write(struct tracefs_cpu *tcpu, int wfd)
+{
+	char buffer[tcpu->subbuf_size];
+	int ret;
+
+	ret = tracefs_cpu_flush(tcpu, buffer);
+	if (ret > 0)
+		ret = write(wfd, buffer, ret);
+
+	return ret;
+}
+
+/**
+ * tracefs_cpu_pipe_write - Write the raw trace file into a file descriptor
+ * @tcpu: The descriptor representing the raw trace file
+ * @wfd: The write file descriptor to write the data to
+ * @nonblock: Hint to not block on the read if there's no data.
+ *
+ * This will pipe the data from the trace_pipe_raw file associated with @tcpu
+ * into the @wfd file descriptor. If @nonblock is set, then it will not
+ * block on if there's nothing to write. Note, it will only write sub buffer
+ * size data to @wfd. Calls to tracefs_cpu_flush_write() are needed to
+ * write out the rest.
+ *
+ * Returns the number of bytes read or negative on error.
+ */
+int tracefs_cpu_pipe_write(struct tracefs_cpu *tcpu, int wfd, bool nonblock)
+{
+	char buffer[tcpu->subbuf_size];
+	int mode = SPLICE_F_MOVE;
+	int tot_write = 0;
+	int tot;
+	int ret;
+
+	ret = wait_on_input(tcpu, &nonblock);
+	if (ret <= 0)
+		return ret;
+
+	if (nonblock || tcpu->flags & TC_NONBLOCK)
+		mode |= SPLICE_F_NONBLOCK;
+
+	ret = init_splice(tcpu);
+	if (ret < 0)
+		return ret;
+
+	tot = splice(tcpu->fd, NULL, tcpu->splice_pipe[1], NULL,
+		     tcpu->pipe_size, mode);
+	if (tot < 0)
+		return tot;
+
+	if (tot == 0)
+		return 0;
+
+	ret = splice(tcpu->splice_pipe[0], NULL, wfd, NULL,
+		     tot, SPLICE_F_MOVE | SPLICE_F_NONBLOCK);
+
+	if (ret >= 0)
+		return ret;
+
+	/* Some file systems do not allow splicing, try writing instead */
+	do {
+		int r = tcpu->subbuf_size;
+
+		if (r > tot)
+			r = tot;
+
+		ret = read(tcpu->splice_pipe[0], buffer, r);
+		if (ret > 0) {
+			tot -= ret;
+			ret = write(wfd, buffer, ret);
+		}
+		if (ret > 0)
+			tot_write += ret;
+	} while (ret > 0);
+
+	if (ret < 0)
+		return ret;
+
+	return tot_write;
+}
-- 
2.35.1

