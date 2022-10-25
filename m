Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91951C38A2D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Oct 2022 18:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiJYScF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 14:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiJYScE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 14:32:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A553BD674
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 11:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80FA8B81DAC
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 18:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C90C43470;
        Tue, 25 Oct 2022 18:32:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1onOij-007Rz9-1F;
        Tue, 25 Oct 2022 14:32:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 3/5] libtracefs: Add tracefs_cpu_pipe()
Date:   Tue, 25 Oct 2022 14:32:10 -0400
Message-Id: <20221025183212.1775523-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221025183212.1775523-1-rostedt@goodmis.org>
References: <20221025183212.1775523-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the interface to call splice directly from the tracefs_cpu descriptor.
The requirement is that either the passed in file descriptor is a pipe, or
that the tcpu was created with tracefs_cpu_create_fd() and the fd used
there was a pipe.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/tracefs.h    |  2 +-
 src/tracefs-record.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 449bfd04a395..aaa77045625e 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -608,6 +608,6 @@ int tracefs_cpu_write(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
 int tracefs_cpu_stop(struct tracefs_cpu *tcpu);
 int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer);
 int tracefs_cpu_flush_write(struct tracefs_cpu *tcpu, int wfd);
-
+int tracefs_cpu_pipe(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
 
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index fdc470d71f1e..4a15d19d5073 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -535,3 +535,33 @@ int tracefs_cpu_write(struct tracefs_cpu *tcpu, int wfd, bool nonblock)
 
 	return tot_write;
 }
+
+/**
+ * tracefs_cpu_pipe - Write the raw trace file into a pipe descriptor
+ * @tcpu: The descriptor representing the raw trace file
+ * @wfd: The write file descriptor to write the data to (must be a pipe)
+ * @nonblock: Hint to not block on the read if there's no data.
+ *
+ * This will splice directly the file descriptor of the trace_pipe_raw
+ * file to the given @wfd, which must be a pipe. This can also be used
+ * if @tcpu was created with tracefs_cpu_create_fd() where the passed
+ * in @fd there was a pipe, then @wfd does not need to be a pipe.
+ *
+ * Returns the number of bytes read or negative on error.
+ */
+int tracefs_cpu_pipe(struct tracefs_cpu *tcpu, int wfd, bool nonblock)
+{
+	int mode = SPLICE_F_MOVE;
+	int ret;
+
+	ret = wait_on_input(tcpu, nonblock);
+	if (ret <= 0)
+		return ret;
+
+	if (nonblock || tcpu->flags & TC_NONBLOCK)
+		mode |= SPLICE_F_NONBLOCK;
+
+	ret = splice(tcpu->fd, NULL, wfd, NULL,
+		     tcpu->pipe_size, mode);
+	return ret;
+}
-- 
2.35.1

