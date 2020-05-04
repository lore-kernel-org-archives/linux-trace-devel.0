Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2CBC3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6700D20661
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNm1ay8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgEDG2e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 02:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgEDG2d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 02:28:33 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0661AC061A0E
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 May 2020 23:28:33 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id l11so8708303lfc.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 May 2020 23:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zeqr9M+Wa7iK3OnA0ac5KIbYMsOjYHmZV+S/sZU6aU4=;
        b=nNm1ay8exKrdoRbqA2xIFoe/9QkWgk37v+K5i9rsaVZEnRGYSwYkiDtztsnogTatV9
         dV42zDT2JsgAd5Tl70iyEbOXly7JM83mw4D6FzmdDq0AbVlkEalN5GIW9SNRU8O/b0hE
         5PTMEhDRfBbqiSJ1P73g/Ej/R2ZRTNwJQlwVrQEMwF8LXJgDUQacoAFRAir+Apb3CxaW
         Sc4Zt87JrJu2xnnwcHNyC6cIuCfaRaPRbxLtC9ixwNPskN0lc6hlDy/H1kG2M89JtHOX
         VQ8rn2/aiROcwHYJjlnHpTGeahWZUaFk5++zviprWC3KaFo+FZTw9KwVWg2YfX6fz/QS
         y8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zeqr9M+Wa7iK3OnA0ac5KIbYMsOjYHmZV+S/sZU6aU4=;
        b=oTj57MRCLiQVfQoYiRfIWdvpN92ZTQNzepeQMgUW22ZS2df1/WVSzIGUtI6cdsfAgP
         7moXdFrsXvh2TGAMob9o32v3zVhplDa34eNVBwwj+2QXGggYm+IZD6f++Ak3OjYdik5X
         oZ6eM2czqzt39iQ163bqsh83RWMilxajpcNsXbHamInB08fLytbT7oCdUgNykbDe18UZ
         arcFL0x9oOOAifsif/zc6Fb16Zwe4784MsWViHveg1YgBrTL/kCzcbmsz6cu02GTe1Uq
         VRNJQFI+iKh6GEZfgp9/zPVi8qd+BFuo42ECJlrD1iN88gBUdcLdaOrJ1wNYLhAZi4gh
         ynGA==
X-Gm-Message-State: AGi0Pua0pzV5g+b0Q27ACRxUWyeApyZJ0p37je2BWdLvQgihNqAiD9Cy
        DW3KNlrRUJJlcBki9P/vem8=
X-Google-Smtp-Source: APiQypL6dh/YeDMn7E/2D5Sk1FXWMgk2YKFci9j+8jQAeWMv0CIAopAcACbboVnG4TWvuFKVdnt9Nw==
X-Received: by 2002:ac2:5dd5:: with SMTP id x21mr840810lfq.107.1588573710559;
        Sun, 03 May 2020 23:28:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 78sm7389576ljf.76.2020.05.03.23.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 23:28:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Handle filtered PIDs per ftarce instance
Date:   Mon,  4 May 2020 09:28:28 +0300
Message-Id: <20200504062828.108080-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace supports PID filtering per instance. Currently
trace-cmd does not use this functionality, all PIDs specified
with "-P" option are propagated to all configured tracing instances.
The patch affects these trace-cmd options:
  -P, -O, -T, --proc-map
their configuration scope is limited to the specified ftrace instance only.
If no instance is specified, the configuration is applied to the main instance

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h |  24 +-
 tracecmd/trace-record.c        | 522 ++++++++++++++++++---------------
 2 files changed, 303 insertions(+), 243 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 0f58c772..4c6a63d0 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -184,6 +184,17 @@ struct pid_addr_maps {
 	int				pid;
 };
 
+struct opt_list {
+	struct opt_list *next;
+	const char	*option;
+};
+
+struct filter_pids {
+	struct filter_pids *next;
+	int pid;
+	int exclude;
+};
+
 struct buffer_instance {
 	struct buffer_instance	*next;
 	struct tracefs_instance	*tracefs;
@@ -202,6 +213,18 @@ struct buffer_instance {
 	struct func_list	*filter_funcs;
 	struct func_list	*notrace_funcs;
 
+	struct opt_list		*options;
+	struct filter_pids	*filter_pids;
+	char			*common_pid_filter;
+	int			nr_filter_pids;
+	int			len_filter_pids;
+	bool			ptrace_child;
+
+	int			have_set_event_pid;
+	int			have_event_fork;
+	int			have_func_fork;
+	int			get_procmap;
+
 	const char		*clock;
 	unsigned int		*client_ports;
 
@@ -260,7 +283,6 @@ int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
 /* moved from trace-cmd.h */
 void tracecmd_create_top_instance(char *name);
 void tracecmd_remove_instances(void);
-void tracecmd_filter_pid(int pid, int exclude);
 int tracecmd_add_event(const char *event_str, int stack);
 void tracecmd_enable_events(void);
 void tracecmd_disable_all_tracing(int disable_tracer);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ae8a5745..fc4a5127 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -91,8 +91,6 @@ static int max_kb;
 static bool use_tcp;
 
 static int do_ptrace;
-static int do_children;
-static int get_procmap;
 
 static int filter_task;
 static bool no_filter = false;
@@ -115,31 +113,8 @@ static int func_stack;
 
 static int save_stdout = -1;
 
-struct filter_pids {
-	struct filter_pids *next;
-	int pid;
-	int exclude;
-};
-
-static struct filter_pids *filter_pids;
-static int nr_filter_pids;
-static int len_filter_pids;
-
-static int have_set_event_pid;
-static int have_event_fork;
-static int have_func_fork;
-
-struct opt_list {
-	struct opt_list *next;
-	const char	*option;
-};
-
-static struct opt_list *options;
-
 static struct hook_list *hooks;
 
-static char *common_pid_filter;
-
 struct event_list {
 	struct event_list *next;
 	const char *event;
@@ -228,7 +203,6 @@ struct common_record_context {
 	int date;
 	int manual;
 	int topt;
-	int do_child;
 	int run_command;
 	int saved_cmdlines_size;
 };
@@ -328,41 +302,38 @@ void add_instance(struct buffer_instance *instance, int cpu_count)
 	buffers++;
 }
 
-static void test_set_event_pid(void)
+static void instance_reset_file_save(struct buffer_instance *instance, char *file, int prio)
 {
-	static int tested;
-	struct stat st;
 	char *path;
-	int ret;
-
-	if (tested)
-		return;
 
-	path = tracefs_get_tracing_file("set_event_pid");
-	ret = stat(path, &st);
-	if (!ret) {
-		have_set_event_pid = 1;
-		reset_save_file(path, RESET_DEFAULT_PRIO);
-	}
+	path = tracefs_instance_get_file(instance->tracefs, file);
+	if (path)
+		reset_save_file(path, prio);
 	tracefs_put_tracing_file(path);
+}
 
-	path = tracefs_get_tracing_file("options/event-fork");
-	ret = stat(path, &st);
-	if (!ret) {
-		have_event_fork = 1;
-		reset_save_file(path, RESET_DEFAULT_PRIO);
+static void test_set_event_pid(struct buffer_instance *instance)
+{
+	if (!instance->have_set_event_pid &&
+	    tracefs_file_exists(instance->tracefs, "set_event_pid")) {
+		instance->have_set_event_pid = 1;
+		instance_reset_file_save(instance, "set_event_pid",
+					 RESET_DEFAULT_PRIO);
 	}
-	tracefs_put_tracing_file(path);
 
-	path = tracefs_get_tracing_file("options/function-fork");
-	ret = stat(path, &st);
-	if (!ret) {
-		have_func_fork = 1;
-		reset_save_file(path, RESET_DEFAULT_PRIO);
+	if (!instance->have_event_fork &&
+	    tracefs_file_exists(instance->tracefs, "options/event-fork")) {
+		instance->have_event_fork = 1;
+		instance_reset_file_save(instance, "options/event-fork",
+					 RESET_DEFAULT_PRIO);
 	}
-	tracefs_put_tracing_file(path);
 
-	tested = 1;
+	if (!instance->have_func_fork &&
+	    tracefs_file_exists(instance->tracefs, "options/function-fork")) {
+		instance->have_func_fork = 1;
+		instance_reset_file_save(instance, "options/function-fork",
+					 RESET_DEFAULT_PRIO);
+	}
 }
 
 /**
@@ -865,70 +836,66 @@ static void reset_max_latency(struct buffer_instance *instance)
 				    "tracing_max_latency", "0");
 }
 
-static void add_filter_pid(int pid, int exclude)
+static int add_filter_pid(struct buffer_instance *instance, int pid, int exclude)
 {
 	struct filter_pids *p;
 	char buf[100];
 
-	for (p = filter_pids; p; p = p->next) {
+	for (p = instance->filter_pids; p; p = p->next) {
 		if (p->pid == pid) {
 			p->exclude = exclude;
-			return;
+			return 0;
 		}
 	}
 
 	p = malloc(sizeof(*p));
 	if (!p)
 		die("Failed to allocate pid filter");
-	p->next = filter_pids;
+	p->next = instance->filter_pids;
 	p->exclude = exclude;
 	p->pid = pid;
-	filter_pids = p;
-	nr_filter_pids++;
+	instance->filter_pids = p;
+	instance->nr_filter_pids++;
+
+	instance->len_filter_pids += sprintf(buf, "%d", pid);
 
-	len_filter_pids += sprintf(buf, "%d", pid);
+	return 1;
 }
 
-static void update_ftrace_pid(const char *pid, int reset)
+static void reset_save_ftrace_pid(struct buffer_instance *instance)
 {
 	static char *path;
+
+	if (!tracefs_file_exists(instance->tracefs, "set_ftrace_pid"))
+		return;
+
+	path = tracefs_instance_get_file(instance->tracefs, "set_ftrace_pid");
+	if (!path)
+		return;
+
+	reset_save_file_cond(path, RESET_DEFAULT_PRIO, "no pid", "");
+
+	tracefs_put_tracing_file(path);
+}
+
+static void update_ftrace_pid(struct buffer_instance *instance,
+			      const char *pid, int reset)
+{
+	int fd = -1;
+	char *path;
 	int ret;
-	static int fd = -1;
-	static int first = 1;
-	struct stat st;
 
-	if (!pid) {
-		if (fd >= 0)
-			close(fd);
-		if (path)
-			tracefs_put_tracing_file(path);
-		fd = -1;
-		path = NULL;
+	if (!tracefs_file_exists(instance->tracefs, "set_ftrace_pid"))
 		return;
-	}
 
-	/* Force reopen on reset */
-	if (reset && fd >= 0) {
-		close(fd);
-		fd = -1;
-	}
+	path = tracefs_instance_get_file(instance->tracefs, "set_ftrace_pid");
+	if (!path)
+		return;
 
-	if (fd < 0) {
-		if (!path)
-			path = tracefs_get_tracing_file("set_ftrace_pid");
-		if (!path)
-			return;
-		ret = stat(path, &st);
-		if (ret < 0)
-			return;
-		if (first) {
-			first = 0;
-			reset_save_file_cond(path, RESET_DEFAULT_PRIO, "no pid", "");
-		}
-		fd = open(path, O_WRONLY | O_CLOEXEC | (reset ? O_TRUNC : 0));
-		if (fd < 0)
-			return;
-	}
+	fd = open(path, O_WRONLY | O_CLOEXEC | (reset ? O_TRUNC : 0));
+	tracefs_put_tracing_file(path);
+	if (fd < 0)
+		return;
 
 	ret = write(fd, pid, strlen(pid));
 
@@ -940,24 +907,35 @@ static void update_ftrace_pid(const char *pid, int reset)
 
 	if (ret < 0)
 		die("error writing to %s", path);
-
 	/* add whitespace in case another pid is written */
 	write(fd, " ", 1);
+	close(fd);
 }
 
 static void update_ftrace_pids(int reset)
 {
-	char buf[100];
+	struct buffer_instance *instance;
 	struct filter_pids *pid;
+	static int first = 1;
+	char buf[100];
+	int rst;
 
-	for (pid = filter_pids; pid; pid = pid->next) {
-		if (pid->exclude)
-			continue;
-		snprintf(buf, 100, "%d ", pid->pid);
-		update_ftrace_pid(buf, reset);
-		/* Only reset the first entry */
-		reset = 0;
+	for_all_instances(instance) {
+		if (first)
+			reset_save_ftrace_pid(instance);
+		rst = reset;
+		for (pid = instance->filter_pids; pid; pid = pid->next) {
+			if (pid->exclude)
+				continue;
+			snprintf(buf, 100, "%d ", pid->pid);
+			update_ftrace_pid(instance, buf, rst);
+			/* Only reset the first entry */
+			rst = 0;
+		}
 	}
+
+	if (first)
+		first = 0;
 }
 
 static void update_event_filters(struct buffer_instance *instance);
@@ -1027,7 +1005,8 @@ static void append_filter_pid_range(char **filter, int *curr_len,
  * If @curr_filter is not NULL, it will add this string as:
  *  (@curr_filter) && ((@field == pid) || ...)
  */
-static char *make_pid_filter(char *curr_filter, const char *field)
+static char *make_pid_filter(struct buffer_instance *instance,
+			     char *curr_filter, const char *field)
 {
 	int start_pid = -1, last_pid = -1;
 	int last_exclude = -1;
@@ -1036,13 +1015,13 @@ static char *make_pid_filter(char *curr_filter, const char *field)
 	int curr_len = 0;
 
 	/* Use the new method if possible */
-	if (have_set_event_pid)
+	if (instance->have_set_event_pid)
 		return NULL;
 
-	if (!filter_pids)
+	if (!instance->filter_pids)
 		return curr_filter;
 
-	for (p = filter_pids; p; p = p->next) {
+	for (p = instance->filter_pids; p; p = p->next) {
 		/*
 		 * PIDs are inserted in `filter_pids` from the front and that's
 		 * why we expect them in descending order here.
@@ -1076,9 +1055,8 @@ static char *make_pid_filter(char *curr_filter, const char *field)
 #define _STRINGIFY(x) #x
 #define STRINGIFY(x) _STRINGIFY(x)
 
-static int get_pid_addr_maps(int pid)
+static int get_pid_addr_maps(struct buffer_instance *instance, int pid)
 {
-	struct buffer_instance *instance = &top_instance;
 	struct pid_addr_maps *maps = instance->pid_maps;
 	struct tracecmd_proc_addr_map *map;
 	unsigned long long begin, end;
@@ -1179,12 +1157,17 @@ out_fail:
 
 static void get_filter_pid_maps(void)
 {
+	struct buffer_instance *instance;
 	struct filter_pids *p;
 
-	for (p = filter_pids; p; p = p->next) {
-		if (p->exclude)
+	for_all_instances(instance) {
+		if (!instance->get_procmap)
 			continue;
-		get_pid_addr_maps(p->pid);
+		for (p = instance->filter_pids; p; p = p->next) {
+			if (p->exclude)
+				continue;
+			get_pid_addr_maps(instance, p->pid);
+		}
 	}
 }
 
@@ -1198,32 +1181,21 @@ static void update_task_filter(int pid)
 	if (no_filter)
 		return;
 
-	if (get_procmap && filter_pids)
-		get_filter_pid_maps();
-
-	if (filter_task)
-		add_filter_pid(pid, 0);
-
-	if (!filter_pids)
-		return;
-
-	common_pid_filter = make_pid_filter(NULL, "common_pid");
-
-	update_ftrace_pids(1);
-	for_all_instances(instance)
-		update_pid_event_filters(instance);
-}
-
-void tracecmd_filter_pid(int pid, int exclude)
-{
-	struct buffer_instance *instance;
-
-	add_filter_pid(pid, exclude);
-	common_pid_filter = make_pid_filter(NULL, "common_pid");
+	get_filter_pid_maps();
 
-	if (!filter_pids)
-		return;
+	if (filter_task) {
+		for_all_instances(instance)
+				add_filter_pid(instance, pid, 0);
+	}
 
+	for_all_instances(instance) {
+		if (!instance->filter_pids)
+			continue;
+		if (instance->common_pid_filter)
+			free(instance->common_pid_filter);
+		instance->common_pid_filter = make_pid_filter(instance, NULL,
+							      "common_pid");
+	}
 	update_ftrace_pids(1);
 	for_all_instances(instance)
 		update_pid_event_filters(instance);
@@ -1290,8 +1262,6 @@ static void append_sched_event(struct event_list *event, const char *field, int
 
 static void update_sched_events(struct buffer_instance *instance, int pid)
 {
-	if (have_set_event_pid)
-		return;
 	/*
 	 * Also make sure that the sched_switch to this pid
 	 * and wakeups of this pid are also traced.
@@ -1305,36 +1275,44 @@ static void update_sched_events(struct buffer_instance *instance, int pid)
 static int open_instance_fd(struct buffer_instance *instance,
 			    const char *file, int flags);
 
-static void add_event_pid(const char *buf)
+static void add_event_pid(struct buffer_instance *instance, const char *buf)
 {
-	struct buffer_instance *instance;
-
-	for_all_instances(instance)
-		tracefs_instance_file_write(instance->tracefs,
-					    "set_event_pid", buf);
+	tracefs_instance_file_write(instance->tracefs, "set_event_pid", buf);
 }
 
-static void add_new_filter_pid(int pid)
+static void add_new_filter_child_pid(int pid, int child)
 {
 	struct buffer_instance *instance;
+	struct filter_pids *fpid;
 	char buf[100];
 
-	add_filter_pid(pid, 0);
-	sprintf(buf, "%d", pid);
-	update_ftrace_pid(buf, 0);
-
-	if (have_set_event_pid)
-		return add_event_pid(buf);
+	for_all_instances(instance) {
+		if (!instance->ptrace_child || !instance->filter_pids)
+			continue;
+		for (fpid = instance->filter_pids; fpid; fpid = fpid->next) {
+			if (fpid->pid == pid)
+				break;
+		}
+		if (!fpid)
+			continue;
 
-	common_pid_filter = append_pid_filter(common_pid_filter, "common_pid", pid);
+		add_filter_pid(instance, child, 0);
+		sprintf(buf, "%d", child);
+		update_ftrace_pid(instance, buf, 0);
 
-	for_all_instances(instance) {
-		update_sched_events(instance, pid);
-		update_event_filters(instance);
+		instance->common_pid_filter = append_pid_filter(instance->common_pid_filter,
+								"common_pid", pid);
+		if (instance->have_set_event_pid) {
+			add_event_pid(instance, buf);
+		} else {
+			update_sched_events(instance, pid);
+			update_event_filters(instance);
+		}
 	}
+
 }
 
-static void ptrace_attach(int pid)
+static void ptrace_attach(struct buffer_instance *instance, int pid)
 {
 	int ret;
 
@@ -1344,7 +1322,7 @@ static void ptrace_attach(int pid)
 		do_ptrace = 0;
 		return;
 	}
-	add_filter_pid(pid, 0);
+	add_filter_pid(instance, pid, 0);
 }
 
 static void enable_ptrace(void)
@@ -1355,11 +1333,32 @@ static void enable_ptrace(void)
 	ptrace(PTRACE_TRACEME, 0, NULL, 0);
 }
 
-static void ptrace_wait(enum trace_type type)
+static struct buffer_instance *get_intance_fpid(int pid)
 {
+	struct buffer_instance *instance;
+	struct filter_pids *fpid;
+
+	for_all_instances(instance) {
+		for (fpid = instance->filter_pids; fpid; fpid = fpid->next) {
+			if (fpid->exclude)
+				continue;
+			if (fpid->pid == pid)
+				break;
+		}
+		if (fpid)
+			return instance;
+	}
+
+	return NULL;
+}
+
+static void ptrace_wait(enum trace_type type, int wait_pid)
+{
+	struct buffer_instance *instance;
 	struct filter_pids *fpid;
 	unsigned long send_sig;
 	unsigned long child;
+	int nr_pids = 0;
 	siginfo_t sig;
 	int main_pids;
 	int cstatus;
@@ -1370,18 +1369,29 @@ static void ptrace_wait(enum trace_type type)
 	int pid;
 	int ret;
 
-	pids = calloc(nr_filter_pids, sizeof(int));
+
+	for_all_instances(instance)
+		nr_pids += instance->nr_filter_pids;
+
+	if (wait_pid >= 0)
+		nr_pids++;
+
+	pids = calloc(nr_pids, sizeof(int));
 	if (!pids) {
-		warning("Unable to allocate array for %d PIDs", nr_filter_pids);
+		warning("Unable to allocate array for %d PIDs", nr_pids);
 		return;
 	}
-
-	for (fpid = filter_pids; fpid; fpid = fpid->next) {
-		if (fpid->exclude)
+	if (wait_pid >= 0)
+		pids[i++] = wait_pid;
+	for_all_instances(instance) {
+		if (!instance->ptrace_child)
 			continue;
-		pids[i++] = fpid->pid;
-		if (i >= nr_filter_pids)
-			break;
+
+		for (fpid = instance->filter_pids; fpid && i < nr_pids; fpid = fpid->next) {
+			if (fpid->exclude)
+				continue;
+			pids[i++] = fpid->pid;
+		}
 	}
 	main_pids = i;
 
@@ -1410,13 +1420,14 @@ static void ptrace_wait(enum trace_type type)
 				       PTRACE_O_TRACEVFORK |
 				       PTRACE_O_TRACECLONE |
 				       PTRACE_O_TRACEEXIT);
-				add_new_filter_pid(child);
+				add_new_filter_child_pid(pid, child);
 				ptrace(PTRACE_CONT, child, NULL, 0);
 				break;
 
 			case PTRACE_EVENT_EXIT:
-				if (get_procmap)
-					get_pid_addr_maps(pid);
+				instance = get_intance_fpid(pid);
+				if (instance && instance->get_procmap)
+					get_pid_addr_maps(instance, pid);
 				ptrace(PTRACE_GETEVENTMSG, pid, NULL, &cstatus);
 				ptrace(PTRACE_DETACH, pid, NULL, NULL);
 				break;
@@ -1430,13 +1441,12 @@ static void ptrace_wait(enum trace_type type)
 		}
 		if (WIFEXITED(status) ||
 		   (WIFSTOPPED(status) && event == PTRACE_EVENT_EXIT)) {
-			for (i = 0; i < nr_filter_pids; i++) {
+			for (i = 0; i < nr_pids; i++) {
 				if (pid == pids[i]) {
 					pids[i] = 0;
 					main_pids--;
 					if (!main_pids)
 						finished = 1;
-					break;
 				}
 			}
 		}
@@ -1445,18 +1455,18 @@ static void ptrace_wait(enum trace_type type)
 	free(pids);
 }
 #else
-static inline void ptrace_wait(enum trace_type type) { }
+static inline void ptrace_wait(enum trace_type type, int wait_pid) { }
 static inline void enable_ptrace(void) { }
-static inline void ptrace_attach(int pid) { }
+static inline void ptrace_attach(struct buffer_instance *instance, int pid) { }
 
 #endif /* NO_PTRACE */
 
-static void trace_or_sleep(enum trace_type type)
+static void trace_or_sleep(enum trace_type type, bool pwait)
 {
 	struct timeval tv = { 1 , 0 };
 
-	if (do_ptrace && filter_pids)
-		ptrace_wait(type);
+	if (pwait)
+		ptrace_wait(type, -1);
 	else if (type & TRACE_TYPE_STREAM)
 		trace_stream_read(pids, recorder_threads, &tv);
 	else
@@ -1549,7 +1559,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 	sem_wait(sem_run);
 
 	if (do_ptrace)
-		ptrace_wait(type);
+		ptrace_wait(type, pid);
 	else
 		trace_waitpid(type, pid, &status, 0);
 
@@ -1630,24 +1640,24 @@ static void set_plugin(const char *name)
 		set_plugin_instance(instance, name);
 }
 
-static void save_option(const char *option)
+static void save_option(struct buffer_instance *instance, const char *option)
 {
 	struct opt_list *opt;
 
 	opt = malloc(sizeof(*opt));
 	if (!opt)
 		die("Failed to allocate option");
-	opt->next = options;
-	options = opt;
+	opt->next = instance->options;
+	instance->options = opt;
 	opt->option = option;
 }
 
-static int set_option(const char *option)
+static int set_option(struct buffer_instance *instance, const char *option)
 {
 	FILE *fp;
 	char *path;
 
-	path = tracefs_get_tracing_file("trace_options");
+	path = tracefs_instance_get_file(instance->tracefs, "trace_options");
 	fp = fopen(path, "w");
 	if (!fp)
 		warning("writing to '%s'", path);
@@ -1686,7 +1696,7 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	if (memcmp(cond, "function", size - (cond - content)) !=0)
 		goto out;
 
-	set_option("nofunc_stack_trace");
+	set_option(instance, "nofunc_stack_trace");
  out:
 	free(content);
 }
@@ -1699,7 +1709,7 @@ static void disable_func_stack_trace(void)
 		disable_func_stack_trace_instance(instance);
 }
 
-static void add_reset_options(void)
+static void add_reset_options(struct buffer_instance *instance)
 {
 	struct opt_list *opt;
 	const char *option;
@@ -1711,10 +1721,10 @@ static void add_reset_options(void)
 	if (keep)
 		return;
 
-	path = tracefs_get_tracing_file("trace_options");
+	path = tracefs_instance_get_file(instance->tracefs, "trace_options");
 	content = get_file_content(path);
 
-	for (opt = options; opt; opt = opt->next) {
+	for (opt = instance->options; opt; opt = opt->next) {
 		option = opt->option;
 		len = strlen(option);
 		ptr = content;
@@ -1780,18 +1790,21 @@ static void add_reset_options(void)
 
 static void set_options(void)
 {
+	struct buffer_instance *instance;
 	struct opt_list *opt;
 	int ret;
 
-	add_reset_options();
-
-	while (options) {
-		opt = options;
-		options = opt->next;
-		ret = set_option(opt->option);
-		if (ret < 0)
-			exit(-1);
-		free(opt);
+	for_all_instances(instance) {
+		add_reset_options(instance);
+		while (instance->options) {
+			opt = instance->options;
+			instance->options = opt->next;
+			ret = set_option(instance, opt->option);
+			if (ret < 0)
+				die("Failed to  set ftrace option %s",
+				    opt->option);
+			free(opt);
+		}
 	}
 }
 
@@ -2392,6 +2405,8 @@ void tracecmd_disable_tracing(void)
 
 void tracecmd_disable_all_tracing(int disable_tracer)
 {
+	struct buffer_instance *instance;
+
 	tracecmd_disable_tracing();
 
 	if (disable_tracer) {
@@ -2402,19 +2417,20 @@ void tracecmd_disable_all_tracing(int disable_tracer)
 	reset_events();
 
 	/* Force close and reset of ftrace pid file */
-	update_ftrace_pid("", 1);
-	update_ftrace_pid(NULL, 0);
+	for_all_instances(instance)
+		update_ftrace_pid(instance, "", 1);
 
 	clear_trace_instances();
 }
 
 static void
-update_sched_event(struct event_list *event, const char *field)
+update_sched_event(struct buffer_instance *instance,
+		   struct event_list *event, const char *field)
 {
 	if (!event)
 		return;
 
-	event->pid_filter = make_pid_filter(event->pid_filter, field);
+	event->pid_filter = make_pid_filter(instance, event->pid_filter, field);
 }
 
 static void update_event_filters(struct buffer_instance *instance)
@@ -2425,15 +2441,15 @@ static void update_event_filters(struct buffer_instance *instance)
 	int len;
 	int common_len = 0;
 
-	if (common_pid_filter)
-		common_len = strlen(common_pid_filter);
+	if (instance->common_pid_filter)
+		common_len = strlen(instance->common_pid_filter);
 
 	for (event = instance->events; event; event = event->next) {
 		if (!event->neg) {
 
 			free_it = 0;
 			if (event->filter) {
-				if (!common_pid_filter)
+				if (!instance->common_pid_filter)
 					/*
 					 * event->pid_filter is only created if
 					 * common_pid_filter is. No need to check that.
@@ -2448,7 +2464,7 @@ static void update_event_filters(struct buffer_instance *instance)
 					if (!event_filter)
 						die("Failed to allocate event_filter");
 					sprintf(event_filter, "(%s)&&(%s||%s)",
-						event->filter, common_pid_filter,
+						event->filter, instance->common_pid_filter,
 						event->pid_filter);
 				} else {
 					free_it = 1;
@@ -2458,11 +2474,11 @@ static void update_event_filters(struct buffer_instance *instance)
 					if (!event_filter)
 						die("Failed to allocate event_filter");
 					sprintf(event_filter, "(%s)&&(%s)",
-						event->filter, common_pid_filter);
+						event->filter, instance->common_pid_filter);
 				}
 			} else {
 				/* event->pid_filter only exists when common_pid_filter does */
-				if (!common_pid_filter)
+				if (!instance->common_pid_filter)
 					continue;
 
 				if (event->pid_filter) {
@@ -2473,9 +2489,9 @@ static void update_event_filters(struct buffer_instance *instance)
 					if (!event_filter)
 						die("Failed to allocate event_filter");
 					sprintf(event_filter, "%s||%s",
-						common_pid_filter, event->pid_filter);
+							instance->common_pid_filter, event->pid_filter);
 				} else
-					event_filter = common_pid_filter;
+					event_filter = instance->common_pid_filter;
 			}
 
 			update_event(event, event_filter, 1, '1');
@@ -2502,14 +2518,14 @@ static void update_pid_filters(struct buffer_instance *instance)
 	if (fd < 0)
 		die("Failed to access set_event_pid");
 
-	len = len_filter_pids + nr_filter_pids;
+	len = instance->len_filter_pids + instance->nr_filter_pids;
 	filter = malloc(len);
 	if (!filter)
 		die("Failed to allocate pid filter");
 
 	str = filter;
 
-	for (p = filter_pids; p; p = p->next) {
+	for (p = instance->filter_pids; p; p = p->next) {
 		if (p->exclude)
 			continue;
 		len = sprintf(str, "%d ", p->pid);
@@ -2535,16 +2551,16 @@ static void update_pid_filters(struct buffer_instance *instance)
 
 static void update_pid_event_filters(struct buffer_instance *instance)
 {
-	if (have_set_event_pid)
+	if (instance->have_set_event_pid)
 		return update_pid_filters(instance);
 	/*
 	 * Also make sure that the sched_switch to this pid
 	 * and wakeups of this pid are also traced.
 	 * Only need to do this if the events are active.
 	 */
-	update_sched_event(instance->sched_switch_event, "next_pid");
-	update_sched_event(instance->sched_wakeup_event, "pid");
-	update_sched_event(instance->sched_wakeup_new_event, "pid");
+	update_sched_event(instance, instance->sched_switch_event, "next_pid");
+	update_sched_event(instance, instance->sched_wakeup_event, "pid");
+	update_sched_event(instance, instance->sched_wakeup_new_event, "pid");
 
 	update_event_filters(instance);
 }
@@ -2740,7 +2756,7 @@ create_event(struct buffer_instance *instance, char *path, struct event_list *ol
 	*event = *old_event;
 	add_event(instance, event);
 
-	if (event->filter || filter_task || filter_pids) {
+	if (event->filter || filter_task || instance->filter_pids) {
 		event->filter_file = strdup(path);
 		if (!event->filter_file)
 			die("malloc filter file");
@@ -3943,7 +3959,7 @@ void start_threads(enum trace_type type, struct common_record_context *ctx)
 			if (brass)
 				close(brass[1]);
 			if (pid > 0)
-				add_filter_pid(pid, 1);
+				add_filter_pid(instance, pid, 1);
 		}
 	}
 	recorder_threads = i;
@@ -4463,7 +4479,7 @@ static void set_funcs(struct buffer_instance *instance)
 	if (func_stack && is_top_instance(instance)) {
 		if (!functions_filtered(instance))
 			die("Function stack trace set, but functions not filtered");
-		save_option(FUNC_STACK_TRACE);
+		save_option(instance, FUNC_STACK_TRACE);
 	}
 	clear_function_filters = 1;
 }
@@ -4849,7 +4865,10 @@ static void reset_cpu_mask(void)
 
 static void reset_event_pid(void)
 {
-	add_event_pid("");
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		add_event_pid(instance, "");
 }
 
 static void clear_triggers(void)
@@ -5368,7 +5387,7 @@ static void enable_profile(struct buffer_instance *instance)
 		 * kernel, then we need to default to the stack trace option.
 		 * This is less efficient but still works.
 		 */
-		save_option("stacktrace");
+		save_option(instance, "stacktrace");
 
 
 	for (i = 0; trigger_events[i]; i++)
@@ -5730,6 +5749,8 @@ static void parse_record_options(int argc,
 	int neg_event = 0;
 	struct buffer_instance *instance;
 	bool guest_sync_set = false;
+	int do_children = 0;
+	int fpids_count = 0;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5857,38 +5878,40 @@ static void parse_record_options(int argc,
 			break;
 		}
 		case 'F':
-			test_set_event_pid();
+			test_set_event_pid(ctx->instance);
 			filter_task = 1;
 			break;
 		case 'G':
 			ctx->global = 1;
 			break;
 		case 'P':
-			test_set_event_pid();
+			test_set_event_pid(ctx->instance);
 			pids = strdup(optarg);
 			if (!pids)
 				die("strdup");
 			pid = strtok_r(pids, ",", &sav);
 			while (pid) {
-				add_filter_pid(atoi(pid), 0);
+				fpids_count += add_filter_pid(ctx->instance,
+							      atoi(pid), 0);
 				pid = strtok_r(NULL, ",", &sav);
 			}
 			free(pids);
 			break;
 		case 'c':
-			test_set_event_pid();
-			if (!have_event_fork) {
+			test_set_event_pid(ctx->instance);
+			do_children = 1;
+			if (!ctx->instance->have_event_fork) {
 #ifdef NO_PTRACE
 				die("-c invalid: ptrace not supported");
 #endif
 				do_ptrace = 1;
-				do_children = 1;
+				ctx->instance->ptrace_child = 1;
+
 			} else {
-				save_option("event-fork");
-				ctx->do_child = 1;
+				save_option(ctx->instance, "event-fork");
 			}
-			if (have_func_fork)
-				save_option("function-fork");
+			if (ctx->instance->have_func_fork)
+				save_option(ctx->instance, "function-fork");
 			break;
 		case 'C':
 			ctx->instance->clock = optarg;
@@ -5963,10 +5986,10 @@ static void parse_record_options(int argc,
 			break;
 		case 'O':
 			option = optarg;
-			save_option(option);
+			save_option(ctx->instance, option);
 			break;
 		case 'T':
-			save_option("stacktrace");
+			save_option(ctx->instance, "stacktrace");
 			break;
 		case 'H':
 			add_hook(ctx->instance, optarg);
@@ -6040,7 +6063,7 @@ static void parse_record_options(int argc,
 				die("Failed to allocate user name");
 			break;
 		case OPT_procmap:
-			get_procmap = 1;
+			ctx->instance->get_procmap = 1;
 			break;
 		case OPT_date:
 			ctx->date = 1;
@@ -6143,10 +6166,8 @@ static void parse_record_options(int argc,
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
 
-	if (do_children && !filter_task && !nr_filter_pids)
+	if (do_children && !filter_task && !fpids_count)
 		die(" -c can only be used with -F (or -P with event-fork support)");
-	if (ctx->do_child && !filter_task && !nr_filter_pids)
-		die(" -c can only be used with -P or -F");
 
 	if ((argc - optind) >= 2) {
 		if (IS_START(ctx))
@@ -6160,11 +6181,22 @@ static void parse_record_options(int argc,
 	if (ctx->user && !ctx->run_command)
 		warning("--user %s is ignored, no command is specified",
 			ctx->user);
-	if (get_procmap) {
-		if (!ctx->run_command && !nr_filter_pids)
-			warning("--proc-map is ignored, no command or filtered PIDs are specified.");
-		else
+
+	if (top_instance.get_procmap) {
+		 /* use ptrace to get procmap on the command exit */
+		if (ctx->run_command)
 			do_ptrace = 1;
+		else if (!top_instance.nr_filter_pids)
+			warning("--proc-map is ignored for top instance, "
+				"no command or filtered PIDs are specified.");
+	}
+
+	for_all_instances(instance) {
+		if (instance->get_procmap && !instance->nr_filter_pids) {
+			warning("--proc-map is ignored for instance %s, "
+				"no filtered PIDs are specified.",
+				tracefs_instance_get_name(instance->tracefs));
+		}
 	}
 }
 
@@ -6250,7 +6282,7 @@ static void record_trace(int argc, char **argv,
 	 * If top_instance doesn't have any plugins or events, then
 	 * remove it from being processed.
 	 */
-	if (!__check_doing_something(&top_instance))
+	if (!__check_doing_something(&top_instance) && !filter_task)
 		first_instance = buffer_instances;
 	else
 		ctx->topt = 1;
@@ -6337,19 +6369,25 @@ static void record_trace(int argc, char **argv,
 		tracecmd_enable_tracing();
 		tracecmd_msg_wait_close(ctx->instance->msg_handle);
 	} else {
+		bool pwait = false;
+
 		update_task_filter(-1);
 		tracecmd_enable_tracing();
 		/* We don't ptrace ourself */
-		if (do_ptrace && filter_pids) {
-			for (pid = filter_pids; pid; pid = pid->next) {
-				if (!pid->exclude)
-					ptrace_attach(pid->pid);
+		if (do_ptrace) {
+			for_all_instances(instance) {
+				for (pid = instance->filter_pids; pid; pid = pid->next) {
+					if (!pid->exclude && instance->ptrace_child) {
+						ptrace_attach(instance, pid->pid);
+						pwait = true;
+					}
+				}
 			}
 		}
 		/* sleep till we are woken with Ctrl^C */
 		printf("Hit Ctrl^C to stop recording\n");
 		while (!finished)
-			trace_or_sleep(type);
+			trace_or_sleep(type, pwait);
 	}
 
 	tell_guests_to_stop();
-- 
2.26.2

