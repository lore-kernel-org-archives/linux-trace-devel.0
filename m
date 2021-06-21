Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C0EC4743C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 14:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B72816128A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 14:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFUOEC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 10:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhFUOEB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 10:04:01 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B27C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Jun 2021 07:01:47 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id s6so19063174edu.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Jun 2021 07:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdCYXa6kbMTn6WP8i7IhS9w82h0nWIMpSgA6GHb1uTc=;
        b=fUcePL0CmB4FdnfgSSqsCwMCQEsQcBihtEHaPHxfDHR93asI8+m3mIqsW/cGiFkN/t
         BOE2zQGveqeiPe9+KmJFX/wSuoZ/cjuS6gFpSlzV053Y87ujg1LAuaLGM0RyIGrMhk6F
         z644DjwpN0cAZELcjzgjew+SdvWNYQxAmgGDiZHgidkSPzBiHjonpCU9mJVA5o79E0Bt
         0DIq9ijqf703UY0MwB31rQAy9+C8IfwNeEuI5YM+PbTUUZ6EKxv8mG51sAX09rFjGwNf
         7ObQBSxHur1msJSaxgOjcCmKB6RDumfTImy2mU2iUheOEDOsjM5jHgDaeSHdeyMLhJ2/
         M9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdCYXa6kbMTn6WP8i7IhS9w82h0nWIMpSgA6GHb1uTc=;
        b=OmxKjqxgIl8g+moUGtoZ0CM13Hzq0EmVlivaCMQ9gBGWG8gltHsW0dt+NgnDGuGOBs
         gY8cjYNYNEGAMVQSlA7HHt9fF1F7yEkE16IzB+KUZicycMIcSO9pD2Jzbs8SC6CRLwCW
         tBSIFwThrOlh5psNIA0zH1R0zdf2CQy/+6d8KEa+pP8DTX6cQJ76PkTebaryauuKlm4S
         R3XEm+MFzrnLv1IxrNFuFD0ijuxO4BxKfcpzy6mFfCV4+cOS6Dggs5bZaE9lILlcTIhH
         mSDCJTocsUgm6hY/QsqtEESlVFwwXB2UpViA0Md+pvajUsTuqPzO5X8Ojz4kE63Ncgsn
         DubQ==
X-Gm-Message-State: AOAM531CJf3SU2f1Fabr3rAj2wXQw2198aRqUURF0MEmC32B/9kn3/KL
        OaV9VxgEWDfYLpD3ZfzXBns=
X-Google-Smtp-Source: ABdhPJyx6Doo0wxFbeTXFN5oPtMpVTVppT+yFZnkijx1k/Xl8JgdR/QxGpTMcqkmS/R+a23rFdC7NQ==
X-Received: by 2002:a50:ef12:: with SMTP id m18mr21973324eds.285.1624284105865;
        Mon, 21 Jun 2021 07:01:45 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id e6sm4811637ejm.35.2021.06.21.07.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 07:01:45 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Add APIs for data streaming
Date:   Mon, 21 Jun 2021 17:01:32 +0300
Message-Id: <20210621140132.16185-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new APIs can be used to dump the content of "trace_pipe" into a
file or directly to "stdout". The "splice" system call is used to
moves the data without copying. The new functionality is essentially
identical to what 'trace-cmd show -p' does.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-stream.txt | 93 +++++++++++++++++++++++++++++
 include/tracefs.h                   |  4 ++
 src/tracefs-tools.c                 | 92 ++++++++++++++++++++++++++++
 3 files changed, 189 insertions(+)
 create mode 100644 Documentation/libtracefs-stream.txt

diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
new file mode 100644
index 0000000..715cdfc
--- /dev/null
+++ b/Documentation/libtracefs-stream.txt
@@ -0,0 +1,93 @@
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
+int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
+int tracefs_trace_pipe_print(struct tracefs_instance *instance);
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
+The _tracefs_trace_pipe_stream()_, and _tracefs_trace_pipe_print()_ functions return 0 if the operation is
+successful, or -1 in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+int main(int argc, char **argv)
+{
+	mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
+	const char *filename = "./test.out";
+	int fd = creat(filename, mode);
+
+	return tracefs_trace_pipe_stream(fd, NULL, 0);
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
diff --git a/include/tracefs.h b/include/tracefs.h
index e29b550..f3c69da 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -184,4 +184,8 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
 /* Control library logs */
 void tracefs_set_loglevel(enum tep_loglevel level);
 
+int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
+
+int tracefs_trace_pipe_print(struct tracefs_instance *instance);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 0cbb56d..4874a44 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -15,6 +15,7 @@
 #include <limits.h>
 #include <pthread.h>
 #include <errno.h>
+#include <signal.h>
 
 #include "tracefs.h"
 #include "tracefs-local.h"
@@ -912,3 +913,94 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
 	tracefs_put_tracing_file(filter_path);
 	return ret;
 }
+
+static bool keep_going;
+
+static void finish(int sig)
+{
+	signal(SIGINT,SIG_DFL);
+	keep_going = false;
+}
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
+ * Returns -1 in case of an error or 0 otherwise.
+ */
+int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance,
+			      int flags)
+{
+	const char *file = "trace_pipe";
+	int brass[2], in_fd, ret = -1;
+	off_t data_size;
+
+	in_fd = tracefs_instance_file_open(instance, file, O_RDONLY);
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
+	signal(SIGINT, finish);
+	keep_going = true;
+
+	while (keep_going) {
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
+	}
+
+	/*
+	 * Do not return error in the case when the "splice" system call
+	 * was interrupted by the user (pressing Ctrl-c).
+	 */
+	if (!keep_going)
+		ret = 0;
+
+ close_all:
+	close(brass[0]);
+	close(brass[1]);
+ close_file:
+	close(in_fd);
+
+	return ret;
+}
+
+/**
+ * tracefs_trace_pipe_print - redirect the stream of trace data to "stdout".
+ * The "splice" system call is used to moves the data without copying
+ * between kernel address space and user address space.
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ *
+ * Returns -1 in case of an error or 0 otherwise.
+ */
+
+int tracefs_trace_pipe_print(struct tracefs_instance *instance)
+{
+   return tracefs_trace_pipe_stream(STDOUT_FILENO,
+				    instance,
+				    SPLICE_F_MORE | SPLICE_F_MOVE);
+}
-- 
2.27.0

