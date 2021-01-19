Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6346AC282D4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Jan 2021 18:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3674F22CAD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Jan 2021 18:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbhASRxQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Jan 2021 12:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbhASPAY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Jan 2021 10:00:24 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89615207C4;
        Tue, 19 Jan 2021 14:59:41 +0000 (UTC)
Date:   Tue, 19 Jan 2021 09:59:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Move "load_plugins" out of the opening code
Message-ID: <20210119095939.6f307c4d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Tzvetomir,

From bugzilla:

  https://bugzilla.kernel.org/show_bug.cgi?id=211255

It was reported that:

$ trace-cmd report -N -r funcgraph_exit trace.dat 2>/dev/null | grep funcgraph_exit | wc -l
11645

$ trace-cmd report -N -F funcgraph_exit -r funcgraph_exit trace.dat 2>/dev/null | grep funcgraph_exit | wc -l
24826

Where the first should have been as big as the second. The problem with the
above is really that "-N" does not stop the ftrace function event plugins
from being loaded.

Looking at this further, I think it's a mistake to have the plugins loaded
at opening time.

We should have a new function for the library:

int tracecmd_load_plugins(struct tracecmd_handle *handle, int flags);

And this should be called after read_trace_header() in trace-read.c.

We can still have tracecmd_open_head() call this, as the "open_head" is
basically a "do everything" function.

This will allow us to remove the global "tracecmd_disable_plugins" and
"tracecmd_disable_sys_plugins" variables and use the flags input instead.
With the '-N' option, we should probably just skip calling it regardless.

The below patch was just a POC, to see if there was any side-effects for
this. But it didn't have a return value or flags, which should be added for
the final version.

-- Steve

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3e67dd61..11bf8e5d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3247,11 +3247,6 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 	if (!handle->pevent)
 		goto failed_read;
 
-	/* register default ftrace functions first */
-	tracecmd_ftrace_overrides(handle, &handle->finfo);
-
-	handle->plugin_list = trace_load_plugins(handle->pevent);
-
 	tep_set_file_bigendian(handle->pevent, buf[0]);
 	tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
 
@@ -3344,6 +3339,13 @@ struct tracecmd_input *tracecmd_open(const char *file)
 	return tracecmd_open_fd(fd);
 }
 
+void tracecmd_load_plugins(struct tracecmd_input *handle)
+{
+	/* register default ftrace functions first */
+	tracecmd_ftrace_overrides(handle, &handle->finfo);
+	handle->plugin_list = trace_load_plugins(handle->pevent);
+}
+
 /**
  * tracecmd_open_head - create a tracecmd_handle from a given file, read
  *			and parse only the trace headers from the file
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d07f4efe..a79bf0aa 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1768,10 +1768,14 @@ void trace_report (int argc, char **argv)
 		die("Wakeup tracing can only be done on a single input file");
 
 	list_for_each_entry(inputs, &input_files, list) {
+		void tracecmd_load_plugins(struct tracecmd_input *handle);
 		handle = read_trace_header(inputs->file);
 		if (!handle)
 			die("error reading header for %s", inputs->file);
 
+		if (!tracecmd_disable_plugins)
+			tracecmd_load_plugins(handle);
+
 		/* If used with instances, top instance will have no tag */
 		add_handle(handle, multi_inputs ? inputs->file : NULL);
 
