Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91288C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A7864E01
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhCAOjn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Mar 2021 09:39:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233264AbhCAOjk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 09:39:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13F2464E07;
        Mon,  1 Mar 2021 14:38:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lGjhJ-001PsK-2O; Mon, 01 Mar 2021 09:38:57 -0500
Message-ID: <20210301143856.948525416@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 01 Mar 2021 09:37:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 2/8] trace-cmd: Create API tracecmd_read_pre_headers()
References: <20210301143724.540985351@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The trace-cmd restore operation can create a partial header to read the
trace event formats and kallsyms and other data into a stand alone header
before it has access to the cpu data. Then it will also read this header to
put together a broken trace, and it reads the header that does not have the
cpu data attached to it.

In order to handle this case, it needs a way to read the headers but stop
short of reading the CPU information. That requires breaking up
tracecmd_read_headers() with just stopping short of adding the cpu data.

A new API is added called tracecmd_read_pre_headers() that does exactly that.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-input.c                   | 25 ++++++++++++++++---
 tracecmd/trace-restore.c                      |  2 +-
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index fc968cc9efe1..c7ef3af7c8f7 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -153,6 +153,7 @@ typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
 struct tracecmd_input *tracecmd_alloc(const char *file, int flags);
 struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags);
 void tracecmd_ref(struct tracecmd_input *handle);
+int tracecmd_read_pre_headers(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle);
 int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
 int tracecmd_long_size(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9ef7b9f16951..9e1a44540201 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -772,14 +772,17 @@ static int read_cpus(struct tracecmd_input *handle)
 }
 
 /**
- * tracecmd_read_headers - read the header information from trace.dat
+ * tracecmd_read_pre_headers - read the header information from trace.dat
  * @handle: input handle for the trace.dat file
  *
  * This reads the trace.dat file for various information. Like the
  * format of the ring buffer, event formats, ftrace formats, kallsyms
- * and printk.
+ * and printk, but stops before reading cpu and options.
+ *
+ * This is needed by the restore operation where the header does not
+ * have the CPU information yet.
  */
-int tracecmd_read_headers(struct tracecmd_input *handle)
+int tracecmd_read_pre_headers(struct tracecmd_input *handle)
 {
 	int ret;
 
@@ -815,6 +818,22 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 		return -1;
 	handle->file_state = TRACECMD_FILE_CMD_LINES;
 
+	return 0;
+}
+
+/**
+ * tracecmd_read_headers - read the header information from trace.dat
+ * @handle: input handle for the trace.dat file
+ *
+ * This reads the trace.dat file for various information. Like the
+ * format of the ring buffer, event formats, ftrace formats, kallsyms
+ * and printk.
+ */
+int tracecmd_read_headers(struct tracecmd_input *handle)
+{
+	if (tracecmd_read_pre_headers(handle))
+		return -1;
+
 	if (read_cpus(handle) < 0)
 		return -1;
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 13f803053582..bf6940991178 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -122,7 +122,7 @@ void trace_restore (int argc, char **argv)
 		if (!ihandle)
 			die("error reading file %s", input);
 		/* make sure headers are ok */
-		if (tracecmd_read_headers(ihandle) < 0)
+		if (tracecmd_read_pre_headers(ihandle) < 0)
 			die("error reading file %s headers", input);
 
 		handle = tracecmd_copy(ihandle, output);
-- 
2.30.0


