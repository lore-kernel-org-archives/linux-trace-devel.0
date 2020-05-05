Return-Path: <SRS0=VUZx=6T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D8DC47247
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 May 2020 10:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 777FE20675
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 May 2020 10:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONJSBjCW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgEEKR0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 May 2020 06:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727931AbgEEKRZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 May 2020 06:17:25 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2494BC061A0F
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 May 2020 03:17:25 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id h4so1000367ljg.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 May 2020 03:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/S0UYiAXG7Xl8jW+ptugcN2F1KXkzuO+1I72xZuljWY=;
        b=ONJSBjCWBae9uiTYm22PXOKDxngdJRqn6NOFFKsYYw0sLrjr+MpwiMcsXyFOpMNeBb
         e3LtriVEa7dHjww/K32AN4GcdMD6mnEojMWmNplp9Z/3moAg91fAKiXchEpeUXy7TTOp
         FKINdyOGZf3DdCDEZ9dAVH8+jzLd7FXMFtB2wPvjLiE9EodmO1Hc9zlZqIoUmoylaVww
         YObPBJfVvfSNjQv++mFKx6DjetmKCP1Uq+q5YL2PVALLgmro/ywVruGHsNCgSPPevChD
         FBJpljDb+ODNPbuKG8anIcK3o/AkM56GzeV/zCBaNxHy/mB4L2FnYApi8RuByFztC3jT
         soYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/S0UYiAXG7Xl8jW+ptugcN2F1KXkzuO+1I72xZuljWY=;
        b=q+J63+0cDHEatp8alDwgxf4aDnIhAg4eYH89SZ0Mdf3brhfoG+owNSEDN+aSnqBSP7
         MXO0OL+FimWH5HXT9h19D/LpBgcOkDnn83x7P/IxoAlDhmwfQoSKl2Se801dBIQNuPUE
         PX3UqNWNeUn/KwS8UzsziPSis9QITiviXptrdsgi3s098Hggc0GyyMfrctkSVgaX4V/o
         GwdoSiLwp3dLUJFsc/D1P3pG5zmUVLobNPlnh6iLYyAmaDDGuhzM4ey1e+HKs/cbhoM6
         QLVmouxkOGcb3NG1T65bWbFwkGsKDP7zWiLhBwMmsc4zmAfG6AHO8GzPs96cEq+M8U74
         WAQg==
X-Gm-Message-State: AGi0Pub0MVtFsp1wzF9NVbx2ntiE2KYyhCe3yLAuqV5FiIu+4GXpYL8+
        1Ut9K8m9BUUgg0JcYFiXuCSAYqArjVE=
X-Google-Smtp-Source: APiQypKcoVMPlpJKB4kkygVCgyWL1gsAqlN/ahMutqH7S2XoahaBjwYBK7rOT64goe6QChjrvWuVzA==
X-Received: by 2002:a2e:9a93:: with SMTP id p19mr1270395lji.77.1588673842890;
        Tue, 05 May 2020 03:17:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y21sm1334715ljg.66.2020.05.05.03.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 03:17:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] trace-cmd: Handle filtered PIDs per ftarce instance
Date:   Tue,  5 May 2020 13:17:18 +0300
Message-Id: <20200505101719.1856601-1-tz.stoyanov@gmail.com>
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
their configuration scope is limited to the specified ftrace instance
only. If no instance is specified, the configuration is applied to
the main instance.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v3: Check if event / function fork is supported by the kernel using the top
    frtace instance, as the other instances are not yet created when the
    arguments are parsed.

 tracecmd/include/trace-local.h |  24 +-
 tracecmd/trace-record.c        | 535 ++++++++++++++++++---------------
 2 files changed, 317 insertions(+), 242 deletions(-)

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
index 1e4d38fa..d0619ba6 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -90,8 +90,6 @@ static int max_kb;
 static bool use_tcp;
 
 static int do_ptrace;
-static int do_children;
-static int get_procmap;
 
 static int filter_task;
 static bool no_filter = false;
@@ -114,31 +112,8 @@ static int func_stack;
 
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
@@ -227,7 +202,6 @@ struct common_record_context {
 	int date;
 	int manual;
 	int topt;
-	int do_child;
 	int run_command;
 	int saved_cmdlines_size;
 };
@@ -327,41 +301,47 @@ void add_instance(struct buffer_instance *instance, int cpu_count)
 	buffers++;
 }
 
-static void test_set_event_pid(void)
+static void instance_reset_file_save(struct buffer_instance *instance, char *file, int prio)
 {
-	static int tested;
-	struct stat st;
 	char *path;
-	int ret;
 
-	if (tested)
-		return;
-
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
-	}
-	tracefs_put_tracing_file(path);
+static void test_set_event_pid(struct buffer_instance *instance)
+{
+	static int have_set_event_pid;
+	static int have_event_fork;
+	static int have_func_fork;
 
-	path = tracefs_get_tracing_file("options/function-fork");
-	ret = stat(path, &st);
-	if (!ret) {
+	if (!have_set_event_pid &&
+	    tracefs_file_exists(top_instance.tracefs, "set_event_pid"))
+		have_set_event_pid = 1;
+	if (!have_event_fork &&
+	    tracefs_file_exists(top_instance.tracefs, "options/event-fork"))
+		have_event_fork = 1;
+	if (!have_func_fork &&
+	    tracefs_file_exists(top_instance.tracefs, "options/function-fork"))
 		have_func_fork = 1;
-		reset_save_file(path, RESET_DEFAULT_PRIO);
-	}
-	tracefs_put_tracing_file(path);
 
-	tested = 1;
+	if (!instance->have_set_event_pid && have_set_event_pid) {
+		instance->have_set_event_pid = 1;
+		instance_reset_file_save(instance, "set_event_pid",
+					 RESET_DEFAULT_PRIO);
+	}
+	if (!instance->have_event_fork && have_event_fork) {
+		instance->have_event_fork = 1;
+		instance_reset_file_save(instance, "options/event-fork",
+					 RESET_DEFAULT_PRIO);
+	}
+	if (!instance->have_func_fork && have_func_fork) {
+		instance->have_func_fork = 1;
+		instance_reset_file_save(instance, "options/function-fork",
+					 RESET_DEFAULT_PRIO);
+	}
 }
 
 /**
@@ -864,70 +844,74 @@ static void reset_max_latency(struct buffer_instance *instance)
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
+}
+
+static void add_filter_pid_all(int pid, int exclude)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		add_filter_pid(instance, pid, exclude);
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
 
@@ -939,24 +923,35 @@ static void update_ftrace_pid(const char *pid, int reset)
 
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
@@ -1026,7 +1021,8 @@ static void append_filter_pid_range(char **filter, int *curr_len,
  * If @curr_filter is not NULL, it will add this string as:
  *  (@curr_filter) && ((@field == pid) || ...)
  */
-static char *make_pid_filter(char *curr_filter, const char *field)
+static char *make_pid_filter(struct buffer_instance *instance,
+			     char *curr_filter, const char *field)
 {
 	int start_pid = -1, last_pid = -1;
 	int last_exclude = -1;
@@ -1035,13 +1031,13 @@ static char *make_pid_filter(char *curr_filter, const char *field)
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
@@ -1075,9 +1071,8 @@ static char *make_pid_filter(char *curr_filter, const char *field)
 #define _STRINGIFY(x) #x
 #define STRINGIFY(x) _STRINGIFY(x)
 
-static int get_pid_addr_maps(int pid)
+static int get_pid_addr_maps(struct buffer_instance *instance, int pid)
 {
-	struct buffer_instance *instance = &top_instance;
 	struct pid_addr_maps *maps = instance->pid_maps;
 	struct tracecmd_proc_addr_map *map;
 	unsigned long long begin, end;
@@ -1178,12 +1173,17 @@ out_fail:
 
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
 
@@ -1195,32 +1195,19 @@ static void update_task_filter(void)
 	if (no_filter)
 		return;
 
-	if (get_procmap && filter_pids)
-		get_filter_pid_maps();
+	get_filter_pid_maps();
 
 	if (filter_task)
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
-
-	if (!filter_pids)
-		return;
+		add_filter_pid_all(pid, 0);
 
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
@@ -1287,8 +1274,6 @@ static void append_sched_event(struct event_list *event, const char *field, int
 
 static void update_sched_events(struct buffer_instance *instance, int pid)
 {
-	if (have_set_event_pid)
-		return;
 	/*
 	 * Also make sure that the sched_switch to this pid
 	 * and wakeups of this pid are also traced.
@@ -1302,36 +1287,44 @@ static void update_sched_events(struct buffer_instance *instance, int pid)
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
 
@@ -1341,7 +1334,10 @@ static void ptrace_attach(int pid)
 		do_ptrace = 0;
 		return;
 	}
-	add_filter_pid(pid, 0);
+	if (instance)
+		add_filter_pid(instance, pid, 0);
+	else
+		add_filter_pid_all(pid, 0);
 }
 
 static void enable_ptrace(void)
@@ -1352,11 +1348,32 @@ static void enable_ptrace(void)
 	ptrace(PTRACE_TRACEME, 0, NULL, 0);
 }
 
+static struct buffer_instance *get_intance_fpid(int pid)
+{
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
 static void ptrace_wait(enum trace_type type)
 {
+	struct buffer_instance *instance;
 	struct filter_pids *fpid;
 	unsigned long send_sig;
 	unsigned long child;
+	int nr_pids = 0;
 	siginfo_t sig;
 	int main_pids;
 	int cstatus;
@@ -1367,18 +1384,24 @@ static void ptrace_wait(enum trace_type type)
 	int pid;
 	int ret;
 
-	pids = calloc(nr_filter_pids, sizeof(int));
+
+	for_all_instances(instance)
+		nr_pids += instance->nr_filter_pids;
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
+	for_all_instances(instance) {
+		if (!instance->ptrace_child && !instance->get_procmap)
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
 
@@ -1407,13 +1430,14 @@ static void ptrace_wait(enum trace_type type)
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
@@ -1427,13 +1451,12 @@ static void ptrace_wait(enum trace_type type)
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
@@ -1444,15 +1467,15 @@ static void ptrace_wait(enum trace_type type)
 #else
 static inline void ptrace_wait(enum trace_type type) { }
 static inline void enable_ptrace(void) { }
-static inline void ptrace_attach(int pid) { }
+static inline void ptrace_attach(struct buffer_instance *instance, int pid) { }
 
 #endif /* NO_PTRACE */
 
-static void trace_or_sleep(enum trace_type type)
+static void trace_or_sleep(enum trace_type type, bool pwait)
 {
 	struct timeval tv = { 1 , 0 };
 
-	if (do_ptrace && filter_pids)
+	if (pwait)
 		ptrace_wait(type);
 	else if (type & TRACE_TYPE_STREAM)
 		trace_stream_read(pids, recorder_threads, &tv);
@@ -1520,8 +1543,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 		}
 	}
 	if (do_ptrace) {
-		add_filter_pid(pid, 0);
-		ptrace_attach(pid);
+		ptrace_attach(NULL, pid);
 		ptrace_wait(type);
 	} else
 		trace_waitpid(type, pid, &status, 0);
@@ -1590,24 +1612,24 @@ static void set_plugin(const char *name)
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
@@ -1646,7 +1668,7 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	if (memcmp(cond, "function", size - (cond - content)) !=0)
 		goto out;
 
-	set_option("nofunc_stack_trace");
+	set_option(instance, "nofunc_stack_trace");
  out:
 	free(content);
 }
@@ -1659,7 +1681,7 @@ static void disable_func_stack_trace(void)
 		disable_func_stack_trace_instance(instance);
 }
 
-static void add_reset_options(void)
+static void add_reset_options(struct buffer_instance *instance)
 {
 	struct opt_list *opt;
 	const char *option;
@@ -1671,10 +1693,10 @@ static void add_reset_options(void)
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
@@ -1740,18 +1762,21 @@ static void add_reset_options(void)
 
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
 
@@ -2352,6 +2377,8 @@ void tracecmd_disable_tracing(void)
 
 void tracecmd_disable_all_tracing(int disable_tracer)
 {
+	struct buffer_instance *instance;
+
 	tracecmd_disable_tracing();
 
 	if (disable_tracer) {
@@ -2362,19 +2389,20 @@ void tracecmd_disable_all_tracing(int disable_tracer)
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
@@ -2385,15 +2413,15 @@ static void update_event_filters(struct buffer_instance *instance)
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
@@ -2408,7 +2436,7 @@ static void update_event_filters(struct buffer_instance *instance)
 					if (!event_filter)
 						die("Failed to allocate event_filter");
 					sprintf(event_filter, "(%s)&&(%s||%s)",
-						event->filter, common_pid_filter,
+						event->filter, instance->common_pid_filter,
 						event->pid_filter);
 				} else {
 					free_it = 1;
@@ -2418,11 +2446,11 @@ static void update_event_filters(struct buffer_instance *instance)
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
@@ -2433,9 +2461,9 @@ static void update_event_filters(struct buffer_instance *instance)
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
@@ -2462,14 +2490,14 @@ static void update_pid_filters(struct buffer_instance *instance)
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
@@ -2495,16 +2523,16 @@ static void update_pid_filters(struct buffer_instance *instance)
 
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
@@ -2700,7 +2728,7 @@ create_event(struct buffer_instance *instance, char *path, struct event_list *ol
 	*event = *old_event;
 	add_event(instance, event);
 
-	if (event->filter || filter_task || filter_pids) {
+	if (event->filter || filter_task || instance->filter_pids) {
 		event->filter_file = strdup(path);
 		if (!event->filter_file)
 			die("malloc filter file");
@@ -3903,7 +3931,7 @@ void start_threads(enum trace_type type, struct common_record_context *ctx)
 			if (brass)
 				close(brass[1]);
 			if (pid > 0)
-				add_filter_pid(pid, 1);
+				add_filter_pid(instance, pid, 1);
 		}
 	}
 	recorder_threads = i;
@@ -4423,7 +4451,7 @@ static void set_funcs(struct buffer_instance *instance)
 	if (func_stack && is_top_instance(instance)) {
 		if (!functions_filtered(instance))
 			die("Function stack trace set, but functions not filtered");
-		save_option(FUNC_STACK_TRACE);
+		save_option(instance, FUNC_STACK_TRACE);
 	}
 	clear_function_filters = 1;
 }
@@ -4809,7 +4837,10 @@ static void reset_cpu_mask(void)
 
 static void reset_event_pid(void)
 {
-	add_event_pid("");
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		add_event_pid(instance, "");
 }
 
 static void clear_triggers(void)
@@ -4996,7 +5027,7 @@ static void check_function_plugin(void)
 static int __check_doing_something(struct buffer_instance *instance)
 {
 	return is_guest(instance) || (instance->flags & BUFFER_FL_PROFILE) ||
-		instance->plugin || instance->events;
+		instance->plugin || instance->events || instance->get_procmap;
 }
 
 static void check_doing_something(void)
@@ -5328,7 +5359,7 @@ static void enable_profile(struct buffer_instance *instance)
 		 * kernel, then we need to default to the stack trace option.
 		 * This is less efficient but still works.
 		 */
-		save_option("stacktrace");
+		save_option(instance, "stacktrace");
 
 
 	for (i = 0; trigger_events[i]; i++)
@@ -5690,6 +5721,8 @@ static void parse_record_options(int argc,
 	int neg_event = 0;
 	struct buffer_instance *instance;
 	bool guest_sync_set = false;
+	int do_children = 0;
+	int fpids_count = 0;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5817,38 +5850,40 @@ static void parse_record_options(int argc,
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
@@ -5923,10 +5958,10 @@ static void parse_record_options(int argc,
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
@@ -6000,7 +6035,7 @@ static void parse_record_options(int argc,
 				die("Failed to allocate user name");
 			break;
 		case OPT_procmap:
-			get_procmap = 1;
+			ctx->instance->get_procmap = 1;
 			break;
 		case OPT_date:
 			ctx->date = 1;
@@ -6103,10 +6138,8 @@ static void parse_record_options(int argc,
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
 
-	if (do_children && !filter_task && !nr_filter_pids)
+	if (do_children && !filter_task && !fpids_count)
 		die(" -c can only be used with -F (or -P with event-fork support)");
-	if (ctx->do_child && !filter_task && !nr_filter_pids)
-		die(" -c can only be used with -P or -F");
 
 	if ((argc - optind) >= 2) {
 		if (IS_START(ctx))
@@ -6120,11 +6153,25 @@ static void parse_record_options(int argc,
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
+		if (ctx->run_command) {
 			do_ptrace = 1;
+		} else if (!top_instance.nr_filter_pids) {
+			warning("--proc-map is ignored for top instance, "
+				"no command or filtered PIDs are specified.");
+			top_instance.get_procmap = 0;
+		}
+	}
+
+	for_all_instances(instance) {
+		if (instance->get_procmap && !instance->nr_filter_pids) {
+			warning("--proc-map is ignored for instance %s, "
+				"no filtered PIDs are specified.",
+				tracefs_instance_get_name(instance->tracefs));
+			instance->get_procmap = 0;
+		}
 	}
 }
 
@@ -6210,7 +6257,7 @@ static void record_trace(int argc, char **argv,
 	 * If top_instance doesn't have any plugins or events, then
 	 * remove it from being processed.
 	 */
-	if (!__check_doing_something(&top_instance))
+	if (!__check_doing_something(&top_instance) && !filter_task)
 		first_instance = buffer_instances;
 	else
 		ctx->topt = 1;
@@ -6297,19 +6344,25 @@ static void record_trace(int argc, char **argv,
 		tracecmd_enable_tracing();
 		tracecmd_msg_wait_close(ctx->instance->msg_handle);
 	} else {
+		bool pwait = false;
+
 		update_task_filter();
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

