Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DABC3DA7A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 18:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjAES4y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 13:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbjAES4w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 13:56:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E57D5F48D
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 10:56:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45E6EB81BBD
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 18:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7A8C433D2;
        Thu,  5 Jan 2023 18:56:48 +0000 (UTC)
Date:   Thu, 5 Jan 2023 13:56:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Charlemagne Lasse <charlemagnelasse@gmail.com>
Subject: [PATCH] trace-cmd stream: Close temp trace file to create options
Message-ID: <20230105135646.701f4138@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The trace_stream_init() function creates a temp file to save the headers
in, and then reads it for processing the information. It does this by
using tmpfile() to create the temp file, grabs the file descriptor from
it, and then calls tracecmd_output_create_fd() on it to save the
information. After it is written, the trace_output is no longer needed,
and the tracecmd_input descriptor is created by reading this temporary
file.

The problem arises with the movement of when the trace option are written.
As some options need to happen after recording, they are finished up at
the end where tracecmd_output_close() is called. But in this case, we only
want the options written, and not to close the descriptor (as it will be
used for reading too).

Create a new tracecmd_output_flush() that writes out the options and use
that.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216577
Reported-by: Charlemagne Lasse <charlemagnelasse@gmail.com>
Fixes: 5d4d7ec30255 ("trace-cmd: Move reading of trace.dat options to tracecmd_read_headers()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Sorry, for not submitting this sooner. I thought I had, but apparently, I
never committed the patch.

 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 10 +++++++-
 tracecmd/trace-stream.c                       | 25 ++++++++-----------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 271f0541982f..2cb6f35cb250 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -341,6 +341,7 @@ int tracecmd_write_options(struct tracecmd_output *handle);
 int tracecmd_write_meta_strings(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
 void tracecmd_output_close(struct tracecmd_output *handle);
+void tracecmd_output_flush(struct tracecmd_output *handle);
 void tracecmd_output_free(struct tracecmd_output *handle);
 struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char *file,
 				      enum tracecmd_file_states state, int file_version,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index bdec75d67bc4..1c0f7b773ddc 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -281,7 +281,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 	free(handle);
 }
 
-void tracecmd_output_close(struct tracecmd_output *handle)
+void tracecmd_output_flush(struct tracecmd_output *handle)
 {
 	if (!handle)
 		return;
@@ -293,6 +293,14 @@ void tracecmd_output_close(struct tracecmd_output *handle)
 		/* write strings section */
 		save_string_section(handle, true);
 	}
+}
+
+void tracecmd_output_close(struct tracecmd_output *handle)
+{
+	if (!handle)
+		return;
+
+	tracecmd_output_flush(handle);
 
 	if (handle->fd >= 0) {
 		close(handle->fd);
diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index ee310f3d0507..d83513f8aa89 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -24,11 +24,10 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 		  struct hook_list *hooks,
 		  tracecmd_handle_init_func handle_init, int global)
 {
-	struct tracecmd_input *trace_input;
 	struct tracecmd_output *trace_output;
+	struct tracecmd_input *trace_input;
 	static FILE *fp = NULL;
 	static int tfd;
-	static int ofd;
 	long flags;
 
 	if (instance->handle) {
@@ -42,23 +41,21 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 			return NULL;
 		tfd = fileno(fp);
 
-		ofd = dup(tfd);
-		trace_output = tracecmd_output_create_fd(ofd);
-		if (!trace_output) {
-			fclose(fp);
-			return NULL;
-		}
+		trace_output = tracecmd_output_create_fd(tfd);
+		if (!trace_output)
+			goto fail;
+
 		tracecmd_output_write_headers(trace_output, NULL);
+		tracecmd_output_flush(trace_output);
+		/* Don't close the descriptor, use it for reading */
 		tracecmd_output_free(trace_output);
 	}
 
-	lseek(ofd, 0, SEEK_SET);
+	lseek(tfd, 0, SEEK_SET);
 
-	trace_input = tracecmd_alloc_fd(ofd, 0);
-	if (!trace_input) {
-		close(ofd);
+	trace_input = tracecmd_alloc_fd(tfd, 0);
+	if (!trace_input)
 		goto fail;
-	}
 
 	if (tracecmd_read_headers(trace_input, TRACECMD_FILE_PRINTK) < 0)
 		goto fail_free_input;
@@ -82,7 +79,7 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 	tracecmd_close(trace_input);
  fail:
 	fclose(fp);
-
+	fp = NULL; /* Try again later? */
 	return NULL;
 }
 
-- 
2.35.1

