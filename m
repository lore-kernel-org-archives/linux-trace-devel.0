Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A21C49EA5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 16:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16584613D8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 16:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhFXQnJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Jun 2021 12:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhFXQnJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Jun 2021 12:43:09 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B8F613CC;
        Thu, 24 Jun 2021 16:40:49 +0000 (UTC)
Date:   Thu, 24 Jun 2021 12:40:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v4] libtracefs: Add APIs for data streaming
Message-ID: <20210624124048.70a3b12f@oasis.local.home>
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
 Documentation/libtracefs-stream.txt | 106 +++++++++++++++++++++
 include/tracefs-local.h             |   1 +
 include/tracefs.h                   |   5 +
 src/tracefs-tools.c                 | 140 ++++++++++++++++++++++++++++
 4 files changed, 252 insertions(+)
 create mode 100644 Documentation/libtracefs-stream.txt

diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
new file mode 100644
index 0000000..b9692e3
--- /dev/null
+++ b/Documentation/libtracefs-stream.txt
@@ -0,0 +1,106 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_trace_pipe_stream, tracefs_trace_pipe_print -
+redirect the stream of trace data to an output or stdout.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
+ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance);
+
+--
+
+DESCRIPTION
+-----------
+If NULL is passed as _instance_, the top trace instance is used.
+The user can interrupt the streaming of the data by pressing Ctrl-c.
+
+The _tracefs_trace_pipe_stream()_ function redirects the stream of trace data to an output
+file. The "splice" system call is used to moves the data without copying between kernel
+address space and user address space. The _fd_ is the file descriptor of the output file
+and _flags_ is a bit mask of flags to be passed to the "splice" system call.
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
index e29b550..23a3c7d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -184,4 +184,9 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
 /* Control library logs */
 void tracefs_set_loglevel(enum tep_loglevel level);
 
+ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
+ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance);
+void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
+
+
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 0cbb56d..1df3732 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -912,3 +912,143 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
 	tracefs_put_tracing_file(filter_path);
 	return ret;
 }
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
+ * @flags: flags to be passed to the "splice" system call.
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
+	int oflags = flags & SPLICE_F_NONBLOCK ? O_NONBLOCK: 0;
+	off_t data_size;
+	ssize_t bread = 0;
+
+	(*(volatile bool *)keep_going) = true;
+
+	in_fd = tracefs_instance_file_open(instance, file, O_RDONLY | oflags);
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
+	errno = 0;
+
+	while (*(volatile bool *)keep_going) {
+		ret = splice(in_fd, NULL,
+			     brass[1], NULL,
+			     data_size, flags);
+		if (ret < 0)
+			break;
+
+		ret = splice(brass[0], NULL,
+			     fd, NULL,
+			     data_size, flags);
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
+ *
+ * Returns -1 in case of an error or number of bytes transferred otherwise.
+ */
+
+ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance)
+{
+	bool *keep_going = instance ? &instance->pipe_keep_going :
+				      &top_pipe_keep_going;
+	char buf[BUFSIZ];
+	ssize_t bread = 0;
+	int brass[2];
+	int ret;
+
+	if(pipe(brass) < 0) {
+		tracefs_warning("Failed to open pipe.");
+		return -1;
+	}
+
+	errno = 0;
+	do {
+		ret = tracefs_trace_pipe_stream(brass[1],
+						instance,
+						SPLICE_F_MORE | SPLICE_F_MOVE |
+						SPLICE_F_NONBLOCK);
+		if (ret < 0 && errno != EAGAIN && errno != EINTR)
+			break;
+
+		if (!ret)
+			break;
+
+		ret = read(brass[0], buf, BUFSIZ);
+		if (ret < 0 && errno == EAGAIN)
+			ret = 0;
+		if (ret > 0) {
+			ret = write(STDOUT_FILENO, buf, ret);
+			if (ret > 0)
+				bread += ret;
+		}
+	} while (ret > 0 && *(volatile bool *)keep_going);
+
+	close(brass[0]);
+	close(brass[1]);
+
+	return ret < 0 ? ret : bread;
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
2.30.2

