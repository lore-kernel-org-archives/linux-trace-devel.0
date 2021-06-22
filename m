Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5DCC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 21:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EE6661003
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 21:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFVVP5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 17:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhFVVP5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 17:15:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 812E66100B;
        Tue, 22 Jun 2021 21:13:40 +0000 (UTC)
Date:   Tue, 22 Jun 2021 17:13:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH] trace-cmd split: Copy trace_clock from input handler to
 output handler
Message-ID: <20210622171338.6447f199@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When splitting a trace file, the clock is needed to create a output file
from the input file. But the output descriptor clock is never set, and the
clock returned from retrieving the descriptor is NULL (unless you are
root, in which case the code will read the machine trace clock instead,
and continue as if nothing was wrong). This caused a failure, and once
again, trace-cmd split, errored out without failure, but just did not
append all the data.

Although this fixes the commit listed below, the problem was there before,
as the code before that commit tried to read the clock from the file
system, but just wouldn't error out if it couldn't read it.

Add a new function to retrieve the trace_clock from the input handle, to
be used to pass it to the output handle before appending the CPU data.

Reported-by: Julia Lawall <julia.lawall@inria.fr>
Fixes: 72670886 ("trace-cmd: Save only the selected clock in the trace.dat file")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  3 ++-
 lib/trace-cmd/trace-input.c                       | 13 +++++++++++++
 lib/trace-cmd/trace-output.c                      |  2 +-
 tracecmd/trace-split.c                            |  1 +
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 7194cb30..6440084d 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -87,7 +87,8 @@ tracecmd_plugin_context_output(struct trace_plugin_context *trace_context);
 
 void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet);
 bool tracecmd_get_quiet(struct tracecmd_output *handle);
-void tracecmd_set_out_clock(struct tracecmd_output *handle, char *clock);
+void tracecmd_set_out_clock(struct tracecmd_output *handle, const char *clock);
+const char *tracecmd_get_trace_clock(struct tracecmd_input *handle);
 
 static inline int tracecmd_host_bigendian(void)
 {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 655bd654..ac57bc4f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4075,6 +4075,19 @@ size_t tracecmd_get_options_offset(struct tracecmd_input *handle)
 	return handle->options_start;
 }
 
+/**
+ * tracecmd_get_trace_clock - return the saved trace clock
+ * @handle: input handle for the trace.dat file
+ *
+ * Returns a string of the clock that was saved in the trace.dat file.
+ * The string should not be freed, as it points to the internal
+ * structure data.
+ */
+const char *tracecmd_get_trace_clock(struct tracecmd_input *handle)
+{
+	return handle->trace_clock;
+}
+
 /**
  * tracecmd_get_show_data_func - return the show data func
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 78a25350..a8de107c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -122,7 +122,7 @@ void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet)
 		handle->quiet = set_quiet;
 }
 
-void tracecmd_set_out_clock(struct tracecmd_output *handle, char *clock)
+void tracecmd_set_out_clock(struct tracecmd_output *handle, const char *clock)
 {
 	if (handle && clock)
 		handle->trace_clock = strdup(clock);
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 8366d128..10d0943d 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -384,6 +384,7 @@ static double parse_file(struct tracecmd_input *handle,
 	for (cpu = 0; cpu < cpus; cpu ++)
 		cpu_list[cpu] = cpu_data[cpu].file;
 
+	tracecmd_set_out_clock(ohandle, tracecmd_get_trace_clock(handle));
 	tracecmd_append_cpu_data(ohandle, cpus, cpu_list);
 
 	current = end;
-- 
2.29.2

