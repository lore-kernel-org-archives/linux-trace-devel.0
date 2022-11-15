Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3485DC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 16:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKOQ6i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 11:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiKOQ63 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 11:58:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A46BDC6
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 08:58:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB3AAB81A0D
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 16:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A216C433D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 16:58:20 +0000 (UTC)
Date:   Tue, 15 Nov 2022 11:59:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Use tracefs_cpu for recorder helpers
Message-ID: <20221115115904.63d021d2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Use the API from libtracefs on tracefs_cpu that is used for reading from
the trace_pipe_raw files for the recorder.

Link: https://lore.kernel.org/linux-trace-devel/20221110194915.69da6d3b@rorschach.local.home

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1:

   - Fixed record with -m option (for max kb per CPU)

 Makefile                                      |   2 +-
 .../include/private/trace-cmd-private.h       |   6 +-
 lib/trace-cmd/trace-recorder.c                | 330 ++++--------------
 tracecmd/trace-record.c                       |  34 +-
 4 files changed, 73 insertions(+), 299 deletions(-)

diff --git a/Makefile b/Makefile
index e67cb77eaefc..41d885b88533 100644
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,7 @@ export LIBTRACECMD_VERSION
 VERSION_FILE = ltc_version.h
 
 LIBTRACEEVENT_MIN_VERSION = 1.5
-LIBTRACEFS_MIN_VERSION = 1.4
+LIBTRACEFS_MIN_VERSION = 1.6
 
 MAKEFLAGS += --no-print-directory
 
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ef35c370c34e..271f0541982f 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -371,9 +371,9 @@ struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, un
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags);
 struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags, int trace_fd);
 struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int maxkb);
-struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *buffer);
-struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer);
-struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags, const char *buffer, int maxkb);
+struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, struct tracefs_instance *instance);
+struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, struct tracefs_instance *instance);
+struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags, struct tracefs_instance *instance, int maxkb);
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep);
 void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 25c26def3784..20deb31c0897 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -32,20 +32,17 @@
 #define POLL_TIMEOUT_MS		1000
 
 struct tracecmd_recorder {
+	struct tracefs_cpu *tcpu;
 	int		fd;
 	int		fd1;
 	int		fd2;
-	int		trace_fd;
-	int		brass[2];
-	int		pipe_size;
 	int		page_size;
+	int		subbuf_size;
 	int		cpu;
 	int		stop;
 	int		max;
 	int		pages;
 	int		count;
-	unsigned	fd_flags;
-	unsigned	trace_fd_flags;
 	unsigned	flags;
 };
 
@@ -94,14 +91,7 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 		append_file(recorder->page_size, recorder->fd1, recorder->fd2);
 	}
  close:
-	if (recorder->brass[0] >= 0)
-		close(recorder->brass[0]);
-
-	if (recorder->brass[1] >= 0)
-		close(recorder->brass[1]);
-
-	if (recorder->trace_fd >= 0)
-		close(recorder->trace_fd);
+	tracefs_cpu_close(recorder->tcpu);
 
 	if (recorder->fd1 >= 0)
 		close(recorder->fd1);
@@ -114,44 +104,22 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 
 static void set_nonblock(struct tracecmd_recorder *recorder)
 {
-	long flags;
-
-	/* Do not block on reads */
-	flags = fcntl(recorder->trace_fd, F_GETFL);
-	fcntl(recorder->trace_fd, F_SETFL, flags | O_NONBLOCK);
-
-	/* Do not block on streams */
-	recorder->fd_flags |= SPLICE_F_NONBLOCK;
+	tracefs_cpu_stop(recorder->tcpu);
 }
 
-struct tracecmd_recorder *
-tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
-				    const char *buffer, int maxkb)
+static struct tracecmd_recorder *
+create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
+			   struct tracefs_instance *instance, int maxkb, int tfd)
 {
 	struct tracecmd_recorder *recorder;
-	char *path = NULL;
-	int pipe_size = 0;
-	int ret;
+	bool nonblock = false;
 
 	recorder = malloc(sizeof(*recorder));
 	if (!recorder)
 		return NULL;
 
-	recorder->cpu = cpu;
 	recorder->flags = flags;
 
-	recorder->fd_flags = SPLICE_F_MOVE;
-
-	if (!(recorder->flags & TRACECMD_RECORD_BLOCK_SPLICE))
-		recorder->fd_flags |= SPLICE_F_NONBLOCK;
-
-	recorder->trace_fd_flags = SPLICE_F_MOVE;
-
-	/* Init to know what to free and release */
-	recorder->trace_fd = -1;
-	recorder->brass[0] = -1;
-	recorder->brass[1] = -1;
-
 	recorder->page_size = getpagesize();
 	if (maxkb) {
 		int kb_per_page = recorder->page_size >> 10;
@@ -174,47 +142,18 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	recorder->fd1 = fd;
 	recorder->fd2 = fd2;
 
-	if (buffer) {
-		if (flags & TRACECMD_RECORD_SNAPSHOT)
-			ret = asprintf(&path, "%s/per_cpu/cpu%d/snapshot_raw",
-				       buffer, cpu);
-		else
-			ret = asprintf(&path, "%s/per_cpu/cpu%d/trace_pipe_raw",
-				       buffer, cpu);
-		if (ret < 0)
-			goto out_free;
-
-		recorder->trace_fd = open(path, O_RDONLY);
-		free(path);
-
-		if (recorder->trace_fd < 0)
-			goto out_free;
-	}
+	if (recorder->flags & TRACECMD_RECORD_POLL)
+		nonblock = true;
 
-	if (!(recorder->flags & (TRACECMD_RECORD_NOSPLICE |
-				 TRACECMD_RECORD_NOBRASS))) {
-		ret = pipe(recorder->brass);
-		if (ret < 0)
-			goto out_free;
-
-		ret = fcntl(recorder->brass[0], F_GETPIPE_SZ, &pipe_size);
-		/*
-		 * F_GETPIPE_SZ was introduced in 2.6.35, ftrace was introduced
-		 * in 2.6.31. If we are running on an older kernel, just fall
-		 * back to using page_size for splice(). It could also return
-		 * success, but not modify pipe_size.
-		 */
-		if (ret > 0 && !pipe_size)
-			pipe_size = ret;
-		else if (ret < 0)
-			pipe_size = recorder->page_size;
-
-		recorder->pipe_size = pipe_size;
-	}
+	if (tfd >= 0)
+		recorder->tcpu = tracefs_cpu_alloc_fd(tfd, recorder->page_size, nonblock);
+	else
+		recorder->tcpu = tracefs_cpu_open(instance, cpu, nonblock);
 
-	if (recorder->flags & TRACECMD_RECORD_POLL)
-		set_nonblock(recorder);
+	if (!recorder->tcpu)
+		goto out_free;
 
+	recorder->subbuf_size = tracefs_cpu_read_size(recorder->tcpu);
 	return recorder;
 
  out_free:
@@ -222,62 +161,31 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	return NULL;
 }
 
-static void verify_splice(const char *file, unsigned *flags)
+struct tracecmd_recorder *
+tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
+				    struct tracefs_instance *instance, int maxkb)
 {
-	int brass[2];
-	int ret;
-	int fd;
-
-	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
-		return; /* Will fail by the caller too */
-
-	if (pipe(brass) < 0)
-		goto fail_pipe;
-
-	ret = splice(brass[0], NULL, fd, NULL, 0, SPLICE_F_NONBLOCK);
-	if (ret < 0)
-		goto fail_splice;
-
- out_pipe:
-	close(brass[0]);
-	close(brass[1]);
- out:
-	close(fd);
-	return;
-
- fail_pipe:
-	tracecmd_warning("Failed opening pipe, trying read/write");
-	*flags |= TRACECMD_RECORD_NOSPLICE;
-	goto out;
-
- fail_splice:
-	tracecmd_warning("Failed splice to file, trying read/write");
-	*flags |= TRACECMD_RECORD_NOSPLICE;
-	goto out_pipe;
+	return create_buffer_recorder_fd2(fd, fd2, cpu, flags, instance, maxkb, -1);
 }
 
 struct tracecmd_recorder *
-tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *buffer)
+tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, struct tracefs_instance *instance)
 {
-	return tracecmd_create_buffer_recorder_fd2(fd, -1, cpu, flags, buffer, 0);
+	return tracecmd_create_buffer_recorder_fd2(fd, -1, cpu, flags, instance, 0);
 }
 
 static struct tracecmd_recorder *
 __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
-				  const char *buffer)
+				  struct tracefs_instance *instance, int tfd)
 {
 	struct tracecmd_recorder *recorder;
 	int fd;
 
-	if (!(flags & TRACECMD_RECORD_NOSPLICE))
-		verify_splice(file, &flags);
-
 	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
 	if (fd < 0)
 		return NULL;
 
-	recorder = tracecmd_create_buffer_recorder_fd(fd, cpu, flags, buffer);
+	recorder = create_buffer_recorder_fd2(fd, -1, cpu, flags, instance, 0, tfd);
 	if (!recorder) {
 		close(fd);
 		unlink(file);
@@ -288,7 +196,7 @@ __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
 
 struct tracecmd_recorder *
 tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
-				      const char *buffer, int maxkb)
+				      struct tracefs_instance *instance, int maxkb)
 {
 	struct tracecmd_recorder *recorder = NULL;
 	char *file2;
@@ -297,7 +205,7 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
 	int fd2;
 
 	if (!maxkb)
-		return tracecmd_create_buffer_recorder(file, cpu, flags, buffer);
+		return tracecmd_create_buffer_recorder(file, cpu, flags, instance);
 
 	len = strlen(file);
 	file2 = malloc(len + 3);
@@ -314,7 +222,7 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
 	if (fd2 < 0)
 		goto err;
 
-	recorder = tracecmd_create_buffer_recorder_fd2(fd, fd2, cpu, flags, buffer, maxkb);
+	recorder = tracecmd_create_buffer_recorder_fd2(fd, fd2, cpu, flags, instance, maxkb);
 	if (!recorder)
 		goto err2;
  out:
@@ -333,9 +241,9 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
 
 struct tracecmd_recorder *
 tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
-				const char *buffer)
+				struct tracefs_instance *instance)
 {
-	return __tracecmd_create_buffer_recorder(file, cpu, flags, buffer);
+	return __tracecmd_create_buffer_recorder(file, cpu, flags, instance, -1);
 }
 
 /**
@@ -350,53 +258,23 @@ struct tracecmd_recorder *
 tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags,
 			      int trace_fd)
 {
-	struct tracecmd_recorder *recorder;
-
-	recorder = __tracecmd_create_buffer_recorder(file, cpu, flags, NULL);
-	if (recorder)
-		recorder->trace_fd = trace_fd;
-
-	return recorder;
+	return __tracecmd_create_buffer_recorder(file, cpu, flags, NULL, trace_fd);
 }
 
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags)
 {
-	const char *tracing;
-
-	tracing = tracefs_tracing_dir();
-	if (!tracing) {
-		errno = ENODEV;
-		return NULL;
-	}
-
-	return tracecmd_create_buffer_recorder_fd(fd, cpu, flags, tracing);
+	return tracecmd_create_buffer_recorder_fd(fd, cpu, flags, NULL);
 }
 
 struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, unsigned flags)
 {
-	const char *tracing;
-
-	tracing = tracefs_tracing_dir();
-	if (!tracing) {
-		errno = ENODEV;
-		return NULL;
-	}
-
-	return tracecmd_create_buffer_recorder(file, cpu, flags, tracing);
+	return tracecmd_create_buffer_recorder(file, cpu, flags, NULL);
 }
 
 struct tracecmd_recorder *
 tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int maxkb)
 {
-	const char *tracing;
-
-	tracing = tracefs_tracing_dir();
-	if (!tracing) {
-		errno = ENODEV;
-		return NULL;
-	}
-
-	return tracecmd_create_buffer_recorder_maxkb(file, cpu, flags, tracing, maxkb);
+	return tracecmd_create_buffer_recorder_maxkb(file, cpu, flags, NULL, maxkb);
 }
 
 static inline void update_fd(struct tracecmd_recorder *recorder, int size)
@@ -433,105 +311,17 @@ static inline void update_fd(struct tracecmd_recorder *recorder, int size)
 	recorder->fd = fd;
 }
 
-/*
- * Returns -1 on error.
- *          or bytes of data read.
- */
-static long splice_data(struct tracecmd_recorder *recorder)
-{
-	long total_read = 0;
-	long read;
-	long ret;
-
-	read = splice(recorder->trace_fd, NULL, recorder->brass[1], NULL,
-		      recorder->pipe_size, recorder->trace_fd_flags);
-	if (read < 0) {
-		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
-			return 0;
-
-		tracecmd_warning("recorder error in splice input");
-		return -1;
-	} else if (read == 0)
-		return 0;
-
- again:
-	ret = splice(recorder->brass[0], NULL, recorder->fd, NULL,
-		     read, recorder->fd_flags);
-	if (ret < 0) {
-		if (errno != EAGAIN && errno != EINTR) {
-			tracecmd_warning("recorder error in splice output");
-			return -1;
-		}
-		return total_read;
-	} else
-		update_fd(recorder, ret);
-	total_read = ret;
-	read -= ret;
-	if (read)
-		goto again;
-
-	return total_read;
-}
-
-/*
- * Returns -1 on error.
- *          or bytes of data read.
- */
-static long direct_splice_data(struct tracecmd_recorder *recorder)
-{
-	struct pollfd pfd = {
-		.fd = recorder->trace_fd,
-		.events = POLLIN,
-	};
-	long read;
-	int ret;
-
-	/*
-	 * splice(2) in Linux used to not check O_NONBLOCK flag of pipe file
-	 * descriptors before [1]. To avoid getting blocked in the splice(2)
-	 * call below after the user had requested to stop tracing, we poll(2)
-	 * here. This poll() is not necessary on newer kernels.
-	 *
-	 * [1] https://github.com/torvalds/linux/commit/ee5e001196d1345b8fee25925ff5f1d67936081e
-	 */
-	ret = poll(&pfd, 1, POLL_TIMEOUT_MS);
-	if (ret < 0)
-		return -1;
-
-	if (!(pfd.revents | POLLIN))
-		return 0;
-
-	read = splice(recorder->trace_fd, NULL, recorder->fd, NULL,
-		      recorder->pipe_size, recorder->fd_flags);
-	if (read < 0) {
-		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
-			return 0;
-
-		tracecmd_warning("recorder error in splice input");
-		return -1;
-	}
-
-	return read;
-}
-
 /*
  * Returns -1 on error.
  *          or bytes of data read.
  */
 static long read_data(struct tracecmd_recorder *recorder)
 {
-	char buf[recorder->page_size];
+	char buf[recorder->subbuf_size];
 	long left;
 	long r, w;
 
-	r = read(recorder->trace_fd, buf, recorder->page_size);
-	if (r < 0) {
-		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
-			return 0;
-
-		tracecmd_warning("recorder error in read input");
-		return -1;
-	}
+	r = tracefs_cpu_read(recorder->tcpu, buf, false);
 
 	left = r;
 	do {
@@ -548,20 +338,34 @@ static long read_data(struct tracecmd_recorder *recorder)
 	return r;
 }
 
+/*
+ * Returns -1 on error.
+ *          or bytes of data read.
+ */
+static long direct_splice_data(struct tracecmd_recorder *recorder)
+{
+	return tracefs_cpu_pipe(recorder->tcpu, recorder->fd, false);
+}
+
 static long move_data(struct tracecmd_recorder *recorder)
 {
+	long ret;
+
 	if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
 		return read_data(recorder);
 
 	if (recorder->flags & TRACECMD_RECORD_NOBRASS)
 		return direct_splice_data(recorder);
 
-	return splice_data(recorder);
+	ret = tracefs_cpu_write(recorder->tcpu, recorder->fd, false);
+	if (ret > 0)
+		update_fd(recorder, ret);
+	return ret;
 }
 
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
 {
-	char buf[recorder->page_size];
+	char buf[recorder->subbuf_size];
 	long total = 0;
 	long wrote = 0;
 	long ret;
@@ -569,28 +373,17 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
 	set_nonblock(recorder);
 
 	do {
-		ret = move_data(recorder);
-		if (ret < 0)
-			return ret;
-		total += ret;
-	} while (ret);
-
-	/* splice only reads full pages */
-	do {
-		ret = read(recorder->trace_fd, buf, recorder->page_size);
-		if (ret > 0) {
-			write(recorder->fd, buf, ret);
+		ret = tracefs_cpu_flush_write(recorder->tcpu, recorder->fd);
+		if (ret > 0)
 			wrote += ret;
-		}
-
 	} while (ret > 0);
 
 	/* Make sure we finish off with a page size boundary */
-	wrote &= recorder->page_size - 1;
+	wrote &= recorder->subbuf_size - 1;
 	if (wrote) {
-		memset(buf, 0, recorder->page_size);
-		write(recorder->fd, buf, recorder->page_size - wrote);
-		total += recorder->page_size;
+		memset(buf, 0, recorder->subbuf_size);
+		write(recorder->fd, buf, recorder->subbuf_size - wrote);
+		total += recorder->subbuf_size;
 	}
 
 	return total;
@@ -615,10 +408,13 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 		read = 0;
 		do {
 			ret = move_data(recorder);
-			if (ret < 0)
+			if (ret < 0) {
+				if (errno == EINTR)
+					continue;
 				return ret;
+			}
 			read += ret;
-		} while (ret);
+		} while (ret > 0 && !recorder->stop);
 	} while (!recorder->stop);
 
 	/* Flush out the rest */
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 72f306228e77..361524b58772 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3326,19 +3326,11 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 {
 	struct tracecmd_recorder *recorder;
 	unsigned flags = recorder_flags | TRACECMD_RECORD_BLOCK_SPLICE;
-	char *path;
-
-	path = tracefs_instance_get_dir(instance->tracefs);
-
-	if (!path)
-		die("malloc");
 
 	/* This is already the child */
 	close(brass[0]);
 
-	recorder = tracecmd_create_buffer_recorder_fd(brass[1], cpu, flags, path);
-
-	tracefs_put_tracing_file(path);
+	recorder = tracecmd_create_buffer_recorder_fd(brass[1], cpu, flags, instance->tracefs);
 
 	return recorder;
 }
@@ -3349,7 +3341,6 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 {
 	struct tracecmd_recorder *record;
 	struct addrinfo *result;
-	char *path;
 
 	if (is_guest(instance)) {
 		int fd;
@@ -3386,12 +3377,8 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 	if (!tracefs_instance_get_name(instance->tracefs))
 		return tracecmd_create_recorder_maxkb(file, cpu, recorder_flags, max_kb);
 
-	path = tracefs_instance_get_dir(instance->tracefs);
-
 	record = tracecmd_create_buffer_recorder_maxkb(file, cpu, recorder_flags,
-						       path, max_kb);
-	tracefs_put_tracing_file(path);
-
+						       instance->tracefs, max_kb);
 	return record;
 }
 
@@ -3402,6 +3389,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 static int create_recorder(struct buffer_instance *instance, int cpu,
 			   enum trace_type type, int *brass)
 {
+	struct tracefs_instance *recorder_instance = NULL;
 	long ret;
 	char *file;
 	pid_t pid;
@@ -3427,7 +3415,6 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 
 	if ((instance->client_ports && !is_guest(instance)) || is_agent(instance)) {
 		unsigned int flags = recorder_flags;
-		char *path = NULL;
 		int fd;
 
 		if (is_agent(instance)) {
@@ -3449,19 +3436,10 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		}
 		if (fd < 0)
 			die("Failed connecting to client");
-		if (tracefs_instance_get_name(instance->tracefs) && !is_agent(instance)) {
-			path = tracefs_instance_get_dir(instance->tracefs);
-		} else {
-			const char *dir = tracefs_tracing_dir();
+		if (tracefs_instance_get_name(instance->tracefs) && !is_agent(instance))
+			recorder_instance = instance->tracefs;
 
-			if (dir)
-				path = strdup(dir);
-		}
-		if (!path)
-			die("can't get the tracing directory");
-
-		recorder = tracecmd_create_buffer_recorder_fd(fd, cpu, flags, path);
-		tracefs_put_tracing_file(path);
+		recorder = tracecmd_create_buffer_recorder_fd(fd, cpu, flags, recorder_instance);
 	} else {
 		file = get_temp_file(instance, cpu);
 		recorder = create_recorder_instance(instance, file, cpu, brass);
-- 
2.35.1

