Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C813C11F64
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 22:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6783A61CF9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 22:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhF1WRp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Jun 2021 18:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232806AbhF1WRo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 18:17:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F05E61CA2;
        Mon, 28 Jun 2021 22:14:48 +0000 (UTC)
Date:   Mon, 28 Jun 2021 18:14:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v6] libtracefs: Add APIs for data streaming
Message-ID: <20210628181446.4d4bb075@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>

The new APIs can be used to dump the content of "trace_pipe" into a
file or directly to "stdout". The "splice" system call is used to
moves the data without copying. The new functionality is essentially
identical to what 'trace-cmd show -p' does.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
[ Updated to fix writing to STDOUT ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v5: https://lore.kernel.org/linux-trace-devel/20210625142737.6c028a93@oasis.local.home/

 - Fix hard coded STDOUT_FILENO to use out_fd.
 - Reworked loop from do { } while to while() { }
 - Jump to close_all label after read_trace_pipe()
 - Made flags use POSIX O_ flags instead of SPLICE_F_ flags
 - Updated documentation to explain stop better.


 Documentation/libtracefs-stream.txt | 113 ++++++++++++++++++++
 include/tracefs-local.h             |   1 +
 include/tracefs.h                   |   4 +
 src/tracefs-tools.c                 | 156 ++++++++++++++++++++++++++++
 4 files changed, 274 insertions(+)
 create mode 100644 Documentation/libtracefs-stream.txt

diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
new file mode 100644
index 0000000..48fc8fa
--- /dev/null
+++ b/Documentation/libtracefs-stream.txt
@@ -0,0 +1,113 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_trace_pipe_stream, tracefs_trace_pipe_print, tracefs_trace_pipe_stop -
+redirect the stream of trace data to an output or stdout.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
+ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
+void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
+
+
+--
+
+DESCRIPTION
+-----------
+If NULL is passed as _instance_, the top trace instance is used.
+
+The reading of the trace_pipe file can be stopped by calling tracefs_trace_pipe_stop()
+which could be placed in a signal handler in case the application wants to stop the
+reading, for example, with the user pressing Ctrl-C.
+
+The _tracefs_trace_pipe_stream()_ function redirects the stream of trace data to an output
+file. The "splice" system call is used to moves the data without copying between kernel
+address space and user address space. The _fd_ is the file descriptor of the output file
+and _flags_ is a bit mask of flags to be passed to the open system call of the trace_pipe
+file (see ). If flags contain O_NONBLOCK, then that is also passed to the splice calls
+that may read the file to the output stream file descriptor.
+
+The _tracefs_trace_pipe_print()_ function is similar to _tracefs_trace_pipe_stream()_, but
+the stream of trace data is redirected to stdout.
+
+
+RETURN VALUE
+------------
+The _tracefs_trace_pipe_stream()_, and _tracefs_trace_pipe_print()_ functions return the
+number of bytes transfered if the operation is successful, or -1 in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <unistd.h>
+#include <signal.h>
+
+#include <tracefs.h>
+
+void stop(int sig)
+{
+	tracefs_trace_pipe_stop(NULL);
+}
+
+int main()
+{
+	mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
+	const char *filename = "trace.txt";
+	int fd = creat(filename, mode);
+	int ret;
+
+	signal(SIGINT, stop);
+	ret = tracefs_trace_pipe_stream(fd, NULL, SPLICE_F_NONBLOCK);
+	close(fd);
+
+	return ret;
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
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_,
+Documentation/trace/ftrace.rst from the Linux kernel tree
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
+Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 9e3aa18..73698e8 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -30,6 +30,7 @@ struct tracefs_instance {
 	int				ftrace_notrace_fd;
 	int				ftrace_marker_fd;
 	int				ftrace_marker_raw_fd;
+	bool				pipe_keep_going;
 };
 
 extern pthread_mutex_t toplevel_lock;
diff --git a/include/tracefs.h b/include/tracefs.h
index 75905ec..bd81cab 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -204,4 +204,8 @@ enum tracefs_tracers {
 int tracefs_tracer_set(struct tracefs_instance *instance, enum tracefs_tracers tracer, ...);
 
 int tracefs_tracer_clear(struct tracefs_instance *instance);
+
+ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
+ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
+void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 0e689aa..ffe033a 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -1025,3 +1025,159 @@ int  tracefs_tracer_clear(struct tracefs_instance *instance)
 {
 	return tracefs_tracer_set(instance, TRACEFS_TRACER_NOP);
 }
+
+static bool splice_safe(int fd, int pfd)
+{
+	int ret;
+
+	errno = 0;
+	ret = splice(pfd, NULL, fd, NULL,
+		     10, SPLICE_F_NONBLOCK | SPLICE_F_MOVE);
+
+	return !ret || (ret < 0 && errno == EAGAIN);
+}
+
+static ssize_t read_trace_pipe(bool *keep_going, int in_fd, int out_fd)
+{
+	char buf[BUFSIZ];
+	ssize_t bread = 0;
+	int ret;
+
+	while (*(volatile bool *)keep_going) {
+		int r;
+		ret = read(in_fd, buf, BUFSIZ);
+		if (ret <= 0)
+			break;
+		r = ret;
+		ret = write(out_fd, buf, r);
+		if (ret < 0)
+			break;
+		bread += ret;
+		/*
+		 * If the write does a partial write, then
+		 * the iteration should stop. This can happen if
+		 * the destination file system ran out of disk space.
+		 * Sure, it probably lost a little from the read
+		 * but there's not much more that can be
+		 * done. Just return what was transferred.
+		 */
+		if (ret < r)
+			break;
+	}
+
+	if (ret < 0 && (errno == EAGAIN || errno == EINTR))
+		ret = 0;
+
+	return ret < 0 ? ret : bread;
+}
+
+static bool top_pipe_keep_going;
+
+/**
+ * tracefs_trace_pipe_stream - redirect the stream of trace data to an output
+ * file. The "splice" system call is used to moves the data without copying
+ * between kernel address space and user address space. The user can interrupt
+ * the streaming of the data by pressing Ctrl-c.
+ * @fd: The file descriptor of the output file.
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ * @flags: flags for opening the trace_pipe file.
+ *
+ * Returns -1 in case of an error or number of bytes transferred otherwise.
+ */
+ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance,
+				 int flags)
+{
+	bool *keep_going = instance ? &instance->pipe_keep_going :
+				      &top_pipe_keep_going;
+	const char *file = "trace_pipe";
+	int brass[2], in_fd, ret = -1;
+	int sflags = flags & O_NONBLOCK ? SPLICE_F_NONBLOCK : 0;
+	off_t data_size;
+	ssize_t bread = 0;
+
+	(*(volatile bool *)keep_going) = true;
+
+	in_fd = tracefs_instance_file_open(instance, file, O_RDONLY | flags);
+	if (in_fd < 0) {
+		tracefs_warning("Failed to open 'trace_pipe'.");
+		return ret;
+	}
+
+	if(pipe(brass) < 0) {
+		tracefs_warning("Failed to open pipe.");
+		goto close_file;
+	}
+
+	data_size = fcntl(brass[0], F_GETPIPE_SZ);
+	if (data_size <= 0) {
+		tracefs_warning("Failed to open pipe (size=0).");
+		goto close_all;
+	}
+
+	/* Test if the output is splice safe */
+	if (!splice_safe(fd, brass[0])) {
+		bread = read_trace_pipe(keep_going, in_fd, fd);
+		ret = 0; /* Force return of bread */
+		goto close_all;
+	}
+
+	errno = 0;
+
+	while (*(volatile bool *)keep_going) {
+		ret = splice(in_fd, NULL,
+			     brass[1], NULL,
+			     data_size, sflags);
+		if (ret < 0)
+			break;
+
+		ret = splice(brass[0], NULL,
+			     fd, NULL,
+			     data_size, sflags);
+		if (ret < 0)
+			break;
+		bread += ret;
+	}
+
+	/*
+	 * Do not return error in the case when the "splice" system call
+	 * was interrupted by the user (pressing Ctrl-c).
+	 * Or if NONBLOCK was specified.
+	 */
+	if (!keep_going || errno == EAGAIN || errno == EINTR)
+		ret = 0;
+
+ close_all:
+	close(brass[0]);
+	close(brass[1]);
+ close_file:
+	close(in_fd);
+
+	return ret ? ret : bread;
+}
+
+/**
+ * tracefs_trace_pipe_print - redirect the stream of trace data to "stdout".
+ * The "splice" system call is used to moves the data without copying
+ * between kernel address space and user address space.
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ * @flags: flags for opening the trace_pipe file.
+ *
+ * Returns -1 in case of an error or number of bytes transferred otherwise.
+ */
+
+ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags)
+{
+	return tracefs_trace_pipe_stream(STDOUT_FILENO, instance, flags);
+}
+
+/**
+ * tracefs_trace_pipe_stop - stop the streaming of trace data.
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ */
+void tracefs_trace_pipe_stop(struct tracefs_instance *instance)
+{
+	if (instance)
+		instance->pipe_keep_going = false;
+	else
+		top_pipe_keep_going = false;
+}
-- 
2.29.2

