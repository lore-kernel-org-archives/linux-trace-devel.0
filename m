Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879BBC49EA5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 14:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F62613C3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 14:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhFXOxe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Jun 2021 10:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhFXOxe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Jun 2021 10:53:34 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3B8C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Jun 2021 07:51:14 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id w13so4179240wmc.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Jun 2021 07:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uYulqRV2CCTrpxi6MiZGdoym9XJxwJ6uN5yIKJhU7oE=;
        b=uyCrqiKm9vSw7AliwK59TXq07PzBYaLS6EFN4UUQHXDgu33i4rndQC0toZRhYmj1B+
         8Xf3VqdLXWw1oP/ggq9xnJ35+XcY2NX/KrWRO36OfU1UmktaZmPeC5PW1kstlDKu7LYe
         uIKkj7UlvQq62ay31QLsAdEXVenttn98Hz8xl7NJ7W/pjjaX/cMQ0BAiG9Pc7XeeqXMk
         trPjFBXtLwt8wxs+h1cK3wU4rlR5RthlEMsJXp6wro2uElVfPIGuAY+tp6lwByCj9Kd3
         g2+lyDiqRDOQcl0NCIXUP+73wC8kp9wxxu+AvzH05HgM8q3s8+rmjlD5yQBK2GXuZhFZ
         bSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uYulqRV2CCTrpxi6MiZGdoym9XJxwJ6uN5yIKJhU7oE=;
        b=oAslopabMekDTZnZuAgwqDJHO8agk7qqIOvXomNhZc5Yenyie3H7fLDMp0fsljyB+F
         OpzqTQ/zGhN5+tttz2OB/JqZeVtigw3Cegf0s9UQicgMVxaubWdlVS9cgczXfJ7TfpZM
         /GrcXBfrOGG1Vzhv+yxhd0y+hX+R/P1B0a2AjF3EjFct/Rvk0HqRmdplKUtWmYuUsgqG
         rHWt01B0DuCkVQ7500wKRYkug5LMCFkqJeTLymBKzQkVF5QiDqoHd0/wCBWlLleU94uB
         PZKjQMGdvuikya8t5daP1fG2jQG5wt9OCh0/rwBh4Pdp2g8xG7eJOnZBqTU6+0KrCNcZ
         6YTA==
X-Gm-Message-State: AOAM533QIiW2ufkNMpnCCYDwk7bmYKNOBLKnIgibmRDmLksJRihyVTWV
        RKSy9BIMpJca3DH0nifl2lU=
X-Google-Smtp-Source: ABdhPJztlIHtuCWBCiP7bk0cIY3rcWJ7jhJpYyqB0cD8oa7DXtAqJlMiIezWQa6RRHN4bRE5MpXL7g==
X-Received: by 2002:a1c:7f96:: with SMTP id a144mr4838411wmd.22.1624546273471;
        Thu, 24 Jun 2021 07:51:13 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id 2sm8826708wmk.24.2021.06.24.07.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:51:12 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3] libtracefs: Add APIs for data streaming
Date:   Thu, 24 Jun 2021 17:51:01 +0300
Message-Id: <20210624145101.87233-1-y.karadz@gmail.com>
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
 Documentation/libtracefs-stream.txt | 106 ++++++++++++++++++++++++++++
 include/tracefs-local.h             |   1 +
 include/tracefs.h                   |   5 ++
 src/tracefs-tools.c                 |  99 ++++++++++++++++++++++++++
 4 files changed, 211 insertions(+)
 create mode 100644 Documentation/libtracefs-stream.txt

diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
new file mode 100644
index 0000000..24c2e47
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
+	ret = tracefs_trace_pipe_stream(fd, NULL, 0);
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
index e29b550..3c6741b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -184,4 +184,9 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
 /* Control library logs */
 void tracefs_set_loglevel(enum tep_loglevel level);
 
+int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
+int tracefs_trace_pipe_print(struct tracefs_instance *instance);
+void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
+
+
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 0cbb56d..a4fc36d 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -912,3 +912,102 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
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
+ * Returns -1 in case of an error or 0 otherwise.
+ */
+int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance,
+			      int flags)
+{
+	bool *keep_going = instance ? &instance->pipe_keep_going :
+				      &top_pipe_keep_going;
+	const char *file = "trace_pipe";
+	int brass[2], in_fd, ret = -1;
+	off_t data_size;
+
+	(*(volatile bool *)keep_going) = true;
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
2.27.0

