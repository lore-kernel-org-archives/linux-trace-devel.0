Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13734C38A2D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Oct 2022 23:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiJZX7u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiJZX7t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Oct 2022 19:59:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF4212763
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Oct 2022 16:59:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D9FBB821D0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Oct 2022 23:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E90C433C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Oct 2022 23:59:42 +0000 (UTC)
Date:   Wed, 26 Oct 2022 19:59:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add tracefs_cpu_alloc_fd() and
 tracefs_cpu_free_fd()
Message-ID: <20221026195955.1a4cb2e0@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracefs_cpu_alloc_fd() to attach a tracefs_cpu descriptor to an
already opened file descriptor, and tracefs_cpu_free_fd() to clean up the
descriptor that tracefs_cpu_alloc_fd() created.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20221025183212.1775523-3-rostedt@goodmis.org

 - Renamed tracefs_cpu_create_fd() to tracefs_cpu_alloc_fd()

 - Added tracefs_cpu_free_fd() to clean up the descriptor created.

 include/tracefs.h    |   2 +
 src/tracefs-record.c | 118 +++++++++++++++++++++++++++++--------------
 2 files changed, 83 insertions(+), 37 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index f500cb47c372..fd4f0668e7cc 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -597,9 +597,11 @@ tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth);
 
 struct tracefs_cpu;
 
+struct tracefs_cpu *tracefs_cpu_alloc_fd(int fd, int subbuf_size, bool nonblock);
 struct tracefs_cpu *tracefs_cpu_open(struct tracefs_instance *instance,
 				     int cpu, bool nonblock);
 void tracefs_cpu_close(struct tracefs_cpu *tcpu);
+void tracefs_cpu_free_fd(struct tracefs_cpu *tcpu);
 int tracefs_cpu_read_size(struct tracefs_cpu *tcpu);
 int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock);
 int tracefs_cpu_buffered_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock);
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index a59614de05ab..4ef3a259a203 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -24,7 +24,6 @@ enum {
 };
 
 struct tracefs_cpu {
-	int		cpu;
 	int		fd;
 	int		flags;
 	int		nfds;
@@ -37,25 +36,21 @@ struct tracefs_cpu {
 };
 
 /**
- * tracefs_cpu_open - open an instance raw trace file
- * @instance: the instance (NULL for toplevel) of the cpu raw file to open
- * @cpu: The CPU that the raw trace file is associated with
+ * tracefs_cpu_alloc_fd - create a tracefs_cpu instance for an existing fd
+ * @fd: The file descriptor to attach the tracefs_cpu to
+ * @subbuf_size: The expected size to read the subbuffer with
  * @nonblock: If true, the file will be opened in O_NONBLOCK mode
  *
  * Return a descriptor that can read the tracefs trace_pipe_raw file
- * for a give @cpu in a given @instance.
+ * that is associated with the given @fd and must be read in @subbuf_size.
  *
  * Returns NULL on error.
  */
 struct tracefs_cpu *
-tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
+tracefs_cpu_alloc_fd(int fd, int subbuf_size, bool nonblock)
 {
 	struct tracefs_cpu *tcpu;
-	struct tep_handle *tep;
 	int mode = O_RDONLY;
-	char path[128];
-	char *buf;
-	int len;
 	int ret;
 
 	tcpu = calloc(1, sizeof(*tcpu));
@@ -70,14 +65,62 @@ tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
 	tcpu->splice_pipe[0] = -1;
 	tcpu->splice_pipe[1] = -1;
 
+	tcpu->fd = fd;
+
+	tcpu->subbuf_size = subbuf_size;
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
+	free(tcpu);
+	return NULL;
+}
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
+	char path[128];
+	char *buf;
+	int mode = O_RDONLY;
+	int subbuf_size;
+	int len;
+	int ret;
+	int fd;
+
+	if (nonblock)
+		mode |= O_NONBLOCK;
+
 	sprintf(path, "per_cpu/cpu%d/trace_pipe_raw", cpu);
 
-	tcpu->cpu = cpu;
-	tcpu->fd = tracefs_instance_file_open(instance, path, mode);
-	if (tcpu->fd < 0) {
-		free(tcpu);
+	fd = tracefs_instance_file_open(instance, path, mode);
+	if (fd < 0)
 		return NULL;
-	}
 
 	tep = tep_alloc();
 	if (!tep)
@@ -93,29 +136,18 @@ tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
 	if (ret < 0)
 		goto fail;
 
-	tcpu->subbuf_size = tep_get_sub_buffer_size(tep);
+	subbuf_size = tep_get_sub_buffer_size(tep);
 	tep_free(tep);
 	tep = NULL;
 
-	if (tcpu->flags & TC_NONBLOCK) {
-		tcpu->ctrl_pipe[0] = -1;
-		tcpu->ctrl_pipe[1] = -1;
-	} else {
-		/* ctrl_pipe is used to break out of blocked reads */
-		ret = pipe(tcpu->ctrl_pipe);
-		if (ret < 0)
-			goto fail;
-		if (tcpu->ctrl_pipe[0] > tcpu->fd)
-			tcpu->nfds = tcpu->ctrl_pipe[0] + 1;
-		else
-			tcpu->nfds = tcpu->fd + 1;
-	}
+	tcpu = tracefs_cpu_alloc_fd(fd, subbuf_size, nonblock);
+	if (!tcpu)
+		goto fail;
 
 	return tcpu;
  fail:
 	tep_free(tep);
-	close(tcpu->fd);
-	free(tcpu);
+	close(fd);
 	return NULL;
 }
 
@@ -126,6 +158,23 @@ static void close_fd(int fd)
 	close(fd);
 }
 
+/**
+ * tracefs_cpu_free_fd - clean up the tracefs_cpu descriptor
+ * @tcpu: The descriptor created with tracefs_cpu_alloc_fd()
+ *
+ * Closes all the internal file descriptors that were opened by
+ * tracefs_cpu_alloc_fd(), and frees the descriptor.
+ */
+void tracefs_cpu_free_fd(struct tracefs_cpu *tcpu)
+{
+	close_fd(tcpu->ctrl_pipe[0]);
+	close_fd(tcpu->ctrl_pipe[1]);
+	close_fd(tcpu->splice_pipe[0]);
+	close_fd(tcpu->splice_pipe[1]);
+
+	free(tcpu);
+}
+
 /**
  * tracefs_cpu_close - clean up and close a raw trace descriptor
  * @tcpu: The descriptor created with tracefs_cpu_open()
@@ -139,12 +188,7 @@ void tracefs_cpu_close(struct tracefs_cpu *tcpu)
 		return;
 
 	close(tcpu->fd);
-	close_fd(tcpu->ctrl_pipe[0]);
-	close_fd(tcpu->ctrl_pipe[1]);
-	close_fd(tcpu->splice_pipe[0]);
-	close_fd(tcpu->splice_pipe[1]);
-
-	free(tcpu);
+	tracefs_cpu_free_fd(tcpu);
 }
 
 /**
-- 
2.35.1

