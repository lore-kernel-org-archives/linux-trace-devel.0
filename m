Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666BFFA373E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Oct 2022 18:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiJYScD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 14:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJYScD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 14:32:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CC5BD674
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 11:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE37A61ACA
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 18:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213ACC4347C;
        Tue, 25 Oct 2022 18:32:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1onOij-007Rz6-1B;
        Tue, 25 Oct 2022 14:32:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/5] libtracefs: Add tracefs_cpu_create_fd()
Date:   Tue, 25 Oct 2022 14:32:09 -0400
Message-Id: <20221025183212.1775523-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221025183212.1775523-1-rostedt@goodmis.org>
References: <20221025183212.1775523-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracefs_cpu_create_fd() to attach a tracefs_cpu descriptor to an
already opened file descriptor.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/tracefs.h    |  1 +
 src/tracefs-record.c | 94 +++++++++++++++++++++++++++++---------------
 2 files changed, 64 insertions(+), 31 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index f500cb47c372..449bfd04a395 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -597,6 +597,7 @@ tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth);
 
 struct tracefs_cpu;
 
+struct tracefs_cpu *tracefs_cpu_create_fd(int fd, int subbuf_size, bool nonblock);
 struct tracefs_cpu *tracefs_cpu_open(struct tracefs_instance *instance,
 				     int cpu, bool nonblock);
 void tracefs_cpu_close(struct tracefs_cpu *tcpu);
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index a59614de05ab..fdc470d71f1e 100644
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
+ * tracefs_cpu_create_fd - create a tracefs_cpu instance for an existing fd
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
+tracefs_cpu_create_fd(int fd, int subbuf_size, bool nonblock)
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
+	tcpu = tracefs_cpu_create_fd(fd, subbuf_size, nonblock);
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
 
-- 
2.35.1

