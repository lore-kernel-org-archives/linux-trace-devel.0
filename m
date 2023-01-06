Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EC2C63707
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbjAFSjk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbjAFSjf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC00F7CDD1
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68847B81E44
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F68CC433EF;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrcp-0003Ks-04;
        Fri, 06 Jan 2023 13:39:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 03/10] trace-cmd stream: Add a flush signal to kick the output
Date:   Fri,  6 Jan 2023 13:39:23 -0500
Message-Id: <20230106183930.12565-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230106183930.12565-1-rostedt@goodmis.org>
References: <20230106183930.12565-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Have trace-cmd stream periodically signal the recorder tasks to flush some
output, otherwise it will look empty for a long time (especially with the
default setting of a 50 percent buffering, where the ring buffers will not
return read until they are half full).

Add a "finish" flag to tracecmd_flush_recording() that will keep the old
behavior when set, but when not set, it will only do a single
tracefs_cpu_flush() that will output some data, but not all of it.

Use the SIGUSR2 to signal the recorder tasks to do the flush.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  2 +-
 lib/trace-cmd/trace-recorder.c                | 10 ++++-
 tracecmd/trace-record.c                       | 41 +++++++++++++++----
 3 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 2cb6f35cb250..e8b0989ac67e 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -378,7 +378,7 @@ struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep);
 void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
-long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
+long tracecmd_flush_recording(struct tracecmd_recorder *recorder, bool finish);
 
 enum tracecmd_msg_flags {
 	TRACECMD_MSG_FL_USE_TCP		= 1 << 0,
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index bb02f7b8ee11..79b95ce1193d 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -366,13 +366,19 @@ static long move_data(struct tracecmd_recorder *recorder)
 	return ret;
 }
 
-long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
+long tracecmd_flush_recording(struct tracecmd_recorder *recorder, bool finish)
 {
 	char buf[recorder->subbuf_size];
 	long total = 0;
 	long wrote = 0;
 	long ret;
 
+	if (!recorder)
+		return 0;
+
+	if (!finish)
+		return tracefs_cpu_flush_write(recorder->tcpu, recorder->fd);
+
 	set_nonblock(recorder);
 
 	do {
@@ -421,7 +427,7 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 	} while (!recorder->stop);
 
 	/* Flush out the rest */
-	ret = tracecmd_flush_recording(recorder);
+	ret = tracecmd_flush_recording(recorder, true);
 
 	if (ret < 0)
 		return ret;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index cc6f27bf22e8..a03d334a65d5 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1641,12 +1641,21 @@ static inline void ptrace_attach(struct buffer_instance *instance, int pid) { }
 static void trace_or_sleep(enum trace_type type, bool pwait)
 {
 	struct timeval tv = { 1 , 0 };
+	int i;
 
 	if (pwait)
 		ptrace_wait(type);
-	else if (type & TRACE_TYPE_STREAM)
-		trace_stream_read(pids, recorder_threads, &tv);
-	else
+	else if (type & TRACE_TYPE_STREAM) {
+		/* Returns zero if it did not read anything (and did a sleep) */
+		if (trace_stream_read(pids, recorder_threads, &tv) > 0)
+			return;
+		/* Force a flush if nothing was read (including on errors) */
+		for (i = 0; i < recorder_threads; i++) {
+			if (pids[i].pid > 0) {
+				kill(pids[i].pid, SIGUSR2);
+			}
+		}
+	} else
 		sleep(10);
 }
 
@@ -3156,7 +3165,7 @@ static void expand_event_list(void)
 		expand_event_instance(instance);
 }
 
-static void finish(int sig)
+static void finish(void)
 {
 	/* all done */
 	if (recorder)
@@ -3164,6 +3173,23 @@ static void finish(int sig)
 	finished = 1;
 }
 
+static void flush(void)
+{
+	if (recorder)
+		tracecmd_flush_recording(recorder, false);
+}
+
+static void do_sig(int sig)
+{
+	switch (sig) {
+	case SIGUSR1:
+	case SIGINT:
+		return finish();
+	case SIGUSR2:
+		return flush();
+	}
+}
+
 static struct addrinfo *do_getaddrinfo(const char *host, unsigned int port,
 				       enum port_type type)
 {
@@ -3405,7 +3431,8 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 			return pid;
 
 		signal(SIGINT, SIG_IGN);
-		signal(SIGUSR1, finish);
+		signal(SIGUSR1, do_sig);
+		signal(SIGUSR2, do_sig);
 
 		if (rt_prio)
 			set_prio(rt_prio);
@@ -3451,7 +3478,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		die ("can't create recorder");
 
 	if (type == TRACE_TYPE_EXTRACT) {
-		ret = tracecmd_flush_recording(recorder);
+		ret = tracecmd_flush_recording(recorder, true);
 		tracecmd_free_recorder(recorder);
 		recorder = NULL;
 		return ret;
@@ -6945,7 +6972,7 @@ static void record_trace(int argc, char **argv,
 	allocate_seq();
 
 	if (type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM)) {
-		signal(SIGINT, finish);
+		signal(SIGINT, do_sig);
 		if (!latency)
 			start_threads(type, ctx);
 	}
-- 
2.35.1

