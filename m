Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C199C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Nov 2022 23:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiKIXvp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 18:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiKIXvo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 18:51:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E1715719
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 15:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0290E61BC4
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 23:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336CFC4347C;
        Wed,  9 Nov 2022 23:51:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1osurg-009C6I-0w;
        Wed, 09 Nov 2022 18:52:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 3/8] libtracefs: Add tracefs_cpu_pipe()
Date:   Wed,  9 Nov 2022 18:52:09 -0500
Message-Id: <20221109235214.2191393-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221109235214.2191393-1-rostedt@goodmis.org>
References: <20221109235214.2191393-1-rostedt@goodmis.org>
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
index fd4f0668e7cc..9f0bdc62836a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -609,6 +609,6 @@ int tracefs_cpu_write(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
 int tracefs_cpu_stop(struct tracefs_cpu *tcpu);
 int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer);
 int tracefs_cpu_flush_write(struct tracefs_cpu *tcpu, int wfd);
-
+int tracefs_cpu_pipe(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
 
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 4ef3a259a203..f5a72a08877d 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -547,3 +547,33 @@ int tracefs_cpu_write(struct tracefs_cpu *tcpu, int wfd, bool nonblock)
 
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

