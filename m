Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72F4C3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 11:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 845D72173E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 11:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZVqWp/BA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfH1LZE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 07:25:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36821 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfH1LZE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 07:25:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id p13so2233260wmh.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 04:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NdOzju8h45Z5YBOmkFuoCNJV38KV0/qaAbJ+IxsLHV0=;
        b=ZVqWp/BAUg0O0GdF5f6FtscFO6kM3ZpHL3FPCvsksNBlSOmqbqmaprYYuMmR5nwvSy
         A8B6HQ0lQbjs2nIDxJnql3F60yfmwl4qzS0qW/xBPYNpf4GiSzrA/YrB67Qeuw4N3jOh
         0nCGzcw7XQhU5d/R1jXcoV43n/e7XHzOlrHKrEWV7P5euePbERYErDZGtNrEsNLArpdn
         oTRqvtK6VHL8j6LRXOieBBYS87CZd1tdzlQ7r1vpKBysQorHEuq+byEvsFB5O4PQHTYL
         Nzf6oXkoOaBL+HDQwZTIDwpu9ppt7Q+/e8K1kh5DlmrolXJDYKJJub0nJgbql2CwLv8j
         fHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NdOzju8h45Z5YBOmkFuoCNJV38KV0/qaAbJ+IxsLHV0=;
        b=TT/qMDXX60FgEnxhCYU8Z5wtHNk6mvXha9cM+OG92nl+Ulx/nnPBb6VLJfqWopiPAi
         ffOLaH52JOgca5YldG4zLQQXTifveYwf7/3s/WFm9q77eHAswooX+5wlNyTSkoCQJ+/g
         i2Eikv97NdW7LkGP1h7Qj9pqLE+vOuMTX4XYBRl9t2IoFRrc9D/jIRO1aVagvxO2+UWj
         1Q0OL0zZY+M0jXq0efnpFOXOtCQdewbP+rPaM0mj+/PHi+cQKWTThTm75wBOzZFwnBx7
         TOJcC3q+iCL9hEDZRemHnHBkPuGe1PKQ9Inr7eAMorKW6GHStNpa6EBrfnVecPKQueaa
         7ABg==
X-Gm-Message-State: APjAAAV3X71APXiYtzWjTUQ5wjuSD6StsCJqVnykbDSMJK1GNmqEdlBZ
        zngWRCNL8ffnZtrkn+MNqPU=
X-Google-Smtp-Source: APXvYqwhcy1jRSANU263LkpfrO1CdzjoRTFgYWNikxwny4LRXsPG6P67DqlVxXLKL2t3z86AjPjiqg==
X-Received: by 2002:a1c:4c04:: with SMTP id z4mr4253891wmf.1.1566991501863;
        Wed, 28 Aug 2019 04:25:01 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c132sm2846766wme.27.2019.08.28.04.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 04:25:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 1/3] trace-cmd: Extend ptrace logic to work with multiple filtered pids
Date:   Wed, 28 Aug 2019 14:24:55 +0300
Message-Id: <20190828112457.10533-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828112457.10533-1-tz.stoyanov@gmail.com>
References: <20190828112457.10533-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the trace-record.c file there is a global variable named "filter_pid".
It is not set anywhere in the code, but there is a logic which relies on it.
This variable is a leftover from the past implementation of trace-cmd
record "-P" option, when it was designed to filter only a single PID.
Now "-P" option works with a list of PIDs, stored in filter_pids global
list. The code is modified to work with filter_pids instead of filter_pid.
This logic is used only if there is no ftrace "options/event-fork" on the
system and we have ptrace support. There is one significant change in
the trace-cmd record behavior in this specific use case:
  - filtered pids are specified with the "-P" option.
  - there is no ftrace "options/event-fork" on the system.
  - there is ptrace support.
The trace continues until Ctrl^C is hit or all filtered PIDs exit,
whatever comes first.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 69 +++++++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 13 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5dc6f17..917f52a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -86,7 +86,6 @@ static bool use_tcp;
 static int do_ptrace;
 
 static int filter_task;
-static int filter_pid = -1;
 static bool no_filter = false;
 
 static int local_cpu_count;
@@ -866,6 +865,13 @@ static void add_filter_pid(int pid, int exclude)
 	struct filter_pids *p;
 	char buf[100];
 
+	for (p = filter_pids; p; p = p->next) {
+		if (p->pid == pid) {
+			p->exclude = exclude;
+			return;
+		}
+	}
+
 	p = malloc(sizeof(*p));
 	if (!p)
 		die("Failed to allocate pid filter");
@@ -1223,17 +1229,36 @@ static void enable_ptrace(void)
 	ptrace(PTRACE_TRACEME, 0, NULL, 0);
 }
 
-static void ptrace_wait(enum trace_type type, int main_pid)
+static void ptrace_wait(enum trace_type type)
 {
+	struct filter_pids *fpid;
 	unsigned long send_sig;
 	unsigned long child;
 	siginfo_t sig;
+	int main_pids;
 	int cstatus;
 	int status;
+	int i = 0;
+	int *pids;
 	int event;
 	int pid;
 	int ret;
 
+	pids = calloc(nr_filter_pids, sizeof(int));
+	if (!pids) {
+		warning("Unable to allocate array for %d PIDs", nr_filter_pids);
+		return;
+	}
+
+	for (fpid = filter_pids; fpid; fpid = fpid->next) {
+		if (fpid->exclude)
+			continue;
+		pids[i++] = fpid->pid;
+		if (i >= nr_filter_pids)
+			break;
+	}
+	main_pids = i;
+
 	do {
 		ret = trace_waitpid(type, -1, &status, WSTOPPED | __WALL);
 		if (ret < 0)
@@ -1275,11 +1300,24 @@ static void ptrace_wait(enum trace_type type, int main_pid)
 			       PTRACE_O_TRACEEXIT);
 			ptrace(PTRACE_CONT, pid, NULL, send_sig);
 		}
-	} while (!finished && ret > 0 &&
-		 (!WIFEXITED(status) || pid != main_pid));
+		if (WIFEXITED(status) ||
+		   (WIFSTOPPED(status) && event == PTRACE_EVENT_EXIT)) {
+			for (i = 0; i < nr_filter_pids; i++) {
+				if (pid == pids[i]) {
+					pids[i] = 0;
+					main_pids--;
+					if (!main_pids)
+						finished = 1;
+					break;
+				}
+			}
+		}
+	} while (!finished && ret > 0);
+
+	free(pids);
 }
 #else
-static inline void ptrace_wait(enum trace_type type, int main_pid) { }
+static inline void ptrace_wait(enum trace_type type) { }
 static inline void enable_ptrace(void) { }
 static inline void ptrace_attach(int pid) { }
 
@@ -1289,8 +1327,8 @@ static void trace_or_sleep(enum trace_type type)
 {
 	struct timeval tv = { 1 , 0 };
 
-	if (do_ptrace && filter_pid >= 0)
-		ptrace_wait(type, filter_pid);
+	if (do_ptrace && filter_pids)
+		ptrace_wait(type);
 	else if (type & TRACE_TYPE_STREAM)
 		trace_stream_read(pids, recorder_threads, &tv);
 	else
@@ -1327,7 +1365,7 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
 	}
 	if (do_ptrace) {
 		add_filter_pid(pid, 0);
-		ptrace_wait(type, pid);
+		ptrace_wait(type);
 	} else
 		trace_waitpid(type, pid, &status, 0);
 }
@@ -2318,7 +2356,7 @@ create_event(struct buffer_instance *instance, char *path, struct event_list *ol
 	*event = *old_event;
 	add_event(instance, event);
 
-	if (event->filter || filter_task || filter_pid) {
+	if (event->filter || filter_task || filter_pids) {
 		event->filter_file = strdup(path);
 		if (!event->filter_file)
 			die("malloc filter file");
@@ -4924,9 +4962,9 @@ static void parse_record_options(int argc,
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
 
-	if (do_ptrace && !filter_task && (filter_pid < 0))
+	if (do_ptrace && !filter_task && !nr_filter_pids)
 		die(" -c can only be used with -F (or -P with event-fork support)");
-	if (ctx->do_child && !filter_task &&! filter_pid)
+	if (ctx->do_child && !filter_task && !nr_filter_pids)
 		die(" -c can only be used with -P or -F");
 
 	if ((argc - optind) >= 2) {
@@ -4997,6 +5035,7 @@ static void record_trace(int argc, char **argv,
 {
 	enum trace_type type = get_trace_cmd_type(ctx->curr_cmd);
 	struct buffer_instance *instance;
+	struct filter_pids *pid;
 
 	/*
 	 * If top_instance doesn't have any plugins or events, then
@@ -5083,8 +5122,12 @@ static void record_trace(int argc, char **argv,
 		update_task_filter();
 		tracecmd_enable_tracing();
 		/* We don't ptrace ourself */
-		if (do_ptrace && filter_pid >= 0)
-			ptrace_attach(filter_pid);
+		if (do_ptrace && filter_pids) {
+			for (pid = filter_pids; pid; pid = pid->next) {
+				if (!pid->exclude)
+					ptrace_attach(pid->pid);
+			}
+		}
 		/* sleep till we are woken with Ctrl^C */
 		printf("Hit Ctrl^C to stop recording\n");
 		while (!finished)
-- 
2.21.0

