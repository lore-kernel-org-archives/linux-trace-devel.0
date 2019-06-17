Return-Path: <SRS0=wRMB=UQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A974C31E57
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 11:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 396922084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 11:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4pZ0Zg7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbfFQLw0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 07:52:26 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55839 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFQLwZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 07:52:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so8924788wmj.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jun 2019 04:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NLRh6SZZzIiU4K+Y/SMj9s3l9zM8a81mLyZ4Wqoj/9g=;
        b=K4pZ0Zg7PBV/I4kGyd0bFIEFb6hEcX5/h/hWw9pToh/QHHifoiaC75Vms2/QW3UNbA
         2FaXgkMwduQuYV9U9wfXyj42A6TRulybTkGx8/HYHC50SjmgH5BIsqhzvquDFz5qFiiJ
         1i/SlQCFj2z0thjc7mrplgMh8adk4o3IJ238R/8YDLVB9lkP+eqNm7jlj5Rcdkm4bfxA
         P7PgaGRu1iig2PkxMPDlFw4+rsij+BTz3ALLuO3sqvKhFqoriawhmMn4Kwa75/H70eWw
         un7PJoy6DQ41DKNkw7Oc2kcbJv8Wjn/bPDCyISJQ7DIR4tiPHcx9j6X3uMI/0x/Qgg1k
         IKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NLRh6SZZzIiU4K+Y/SMj9s3l9zM8a81mLyZ4Wqoj/9g=;
        b=p6xWMHM+efbI14WIrbcacXXH3tI+aaZeJH5SexkOa7PsOvd3TPyRqK5HPCtX1Nbgv/
         ly8TPjc9OHx5fMddpoV5Ebro558y0e+8RkolOo0C/JrYGABOiNX2eBGdLAJvuArafR0u
         JXjiA5mCVPavUWRCppCRi5HX6D/Iam3fiuT8gR4xV7PJyAc2KwW48wUUi0g1hnyKvgyd
         nmHCli00AHr8wBJvuBy8FqgF8uYUczCPGsqU3z5Aav+OhwUzKTf8AoMPL9kzWpfaz/2z
         3mgJV+ixigURoH7CQHQL7cFfO8DfzhBkY7jw/5SbRxHDStg/9kLH9YXAM2d4sGK/SZuE
         nX2w==
X-Gm-Message-State: APjAAAVqgRUroAQYzSr4C0SCKtwyVWhiMUhgeoD/TVRdCIRtREUzR/qF
        jpSXqHYD7rG6+7ZqkAiWjkscJg8O9u4=
X-Google-Smtp-Source: APXvYqxw7y5JVFH0xX8rTrFF9staTi0izjWduwC8SQIINEsg+skh/lPnHBPlBrVweYYRR3S3A646KQ==
X-Received: by 2002:a1c:f70f:: with SMTP id v15mr18328548wmh.102.1560772342466;
        Mon, 17 Jun 2019 04:52:22 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d18sm13332040wrb.90.2019.06.17.04.52.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 04:52:21 -0700 (PDT)
From:   tz.stoyanov@gmail.com
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Save the tracee memory map into the trace.dat file.
Date:   Mon, 17 Jun 2019 14:52:18 +0300
Message-Id: <20190617115218.6279-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617115218.6279-1-tz.stoyanov@gmail.com>
References: <20190617115218.6279-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

A new trace-cmd record option is added: "--mmap". When it is set with
combination of -F or -P options, the memory map of the traced applications
is stored in the trace.dat file. A new API tracecmd_search_tracee_mmap()
can be used to look up into stored memory maps. The map is retrieved from
/proc/<pid>/maps file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h  |   4 ++
 lib/trace-cmd/trace-input.c    |  81 ++++++++++++++++++++++
 tracecmd/include/trace-local.h |  16 +++++
 tracecmd/trace-record.c        | 123 +++++++++++++++++++++++++++++++++
 4 files changed, 224 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 3919673..868e571 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -81,6 +81,7 @@ enum {
 	TRACECMD_OPTION_HOOK,
 	TRACECMD_OPTION_OFFSET,
 	TRACECMD_OPTION_CPUCOUNT,
+	TRACECMD_OPTION_PIDMMAPS,
 };
 
 enum {
@@ -206,6 +207,9 @@ unsigned long long tracecmd_page_ts(struct tracecmd_input *handle,
 unsigned int tracecmd_record_ts_delta(struct tracecmd_input *handle,
 				      struct tep_record *record);
 
+char *tracecmd_get_tracee_lib(struct tracecmd_input *handle,
+			      int pid, unsigned long addr);
+
 #ifndef SWIG
 /* hack for function graph work around */
 extern __thread struct tracecmd_input *tracecmd_curr_thread_handle;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 264e3c3..aaf3c56 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -100,6 +100,7 @@ struct tracecmd_input {
 	struct tracecmd_ftrace	finfo;
 
 	struct hook_list	*hooks;
+	struct pid_mem_maps	*pid_mmaps;
 	/* file information */
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
@@ -2133,6 +2134,83 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
 	handle->use_trace_clock = false;
 }
 
+static void trace_pid_mmap_load(struct tracecmd_input *handle, char *buf)
+{
+	struct pid_mem_maps *maps;
+	char mapname[PATH_MAX+1];
+	char *line;
+	int ret;
+	int i;
+
+	maps = calloc(1, sizeof(*maps));
+	if (!maps)
+		return;
+
+	maps->nr_lib_maps = tep_read_number(handle->pevent, buf, 4);
+	maps->lib_maps = calloc(maps->nr_lib_maps, sizeof(struct lib_mem_map));
+	if (!maps->lib_maps) {
+		free(maps);
+		return;
+	}
+	maps->next = handle->pid_mmaps;
+	handle->pid_mmaps = maps;
+
+	ret = sscanf(buf+4, "%d %s", &maps->pid, mapname);
+	if (ret == 2)
+		maps->proc_name = strdup(mapname);
+	line = strchr(buf+4, '\n');
+	for (i = 0; i < maps->nr_lib_maps; i++) {
+		if (!line)
+			break;
+		ret = sscanf(line+1, "%llx %llx %s", &maps->lib_maps[i].start,
+			     &maps->lib_maps[i].end, mapname);
+		if (ret == 3)
+			maps->lib_maps[i].lib_name = strdup(mapname);
+		line = strchr(line+1, '\n');
+	}
+}
+
+/**
+ * tracecmd_search_tracee_mmap - Search tracee memory address map
+ * @handle: input handle to the trace.dat file
+ * @pid: pid of the tracee
+ * @addr: address from the tracee memory space.
+ *
+ * Map of the tracee memory can be saved in the trace.dat file, using the option
+ * "--mmap". If there is such information, this API can be used to look up into
+ * this memory map to find library is loaded at the given @addr.
+ *
+ * The name of the library at given tracee @addr is returned.
+ */
+char *tracecmd_search_tracee_mmap(struct tracecmd_input *handle,
+				  int pid, unsigned long long addr)
+{
+	struct pid_mem_maps *maps;
+	int i;
+
+	if (!handle || !handle->pid_mmaps)
+		return NULL;
+
+	maps = handle->pid_mmaps;
+	while (maps) {
+		if (maps->pid == pid)
+			break;
+		maps = maps->next;
+	}
+	if (!maps || !maps->nr_lib_maps || !maps->lib_maps)
+		return NULL;
+
+	for (i = 0; i < maps->nr_lib_maps; i++)
+		if (maps->lib_maps[i].start <= addr &&
+		    maps->lib_maps[i].end > addr)
+			break;
+
+	if (i < maps->nr_lib_maps)
+		return maps->lib_maps[i].lib_name;
+
+	return NULL;
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	unsigned long long offset;
@@ -2229,6 +2307,9 @@ static int handle_options(struct tracecmd_input *handle)
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
 			break;
+		case TRACECMD_OPTION_PIDMMAPS:
+			trace_pid_mmap_load(handle, buf);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a1a06e9..5c623ec 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -157,6 +157,20 @@ struct func_list {
 	const char *mod;
 };
 
+struct lib_mem_map {
+	unsigned long long start;
+	unsigned long long end;
+	char		*lib_name;
+};
+
+struct pid_mem_maps {
+	struct pid_mem_maps	*next;
+	struct lib_mem_map	*lib_maps;
+	unsigned int		nr_lib_maps;
+	char			*proc_name;
+	int			pid;
+};
+
 struct buffer_instance {
 	struct buffer_instance	*next;
 	const char		*name;
@@ -183,6 +197,8 @@ struct buffer_instance {
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
 
+	struct pid_mem_maps	*mem_maps;
+
 	int			flags;
 	int			tracing_on_init_val;
 	int			tracing_on_fd;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2f5fbd9..2147554 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -83,6 +83,7 @@ static int max_kb;
 static bool use_tcp;
 
 static int do_ptrace;
+static int get_mmap;
 
 static int filter_task;
 static int filter_pid = -1;
@@ -1060,6 +1061,82 @@ static char *make_pid_filter(char *curr_filter, const char *field)
 	return filter;
 }
 
+static void get_pid_mmaps(int pid)
+{
+	char buf[PATH_MAX+100], perm[5], dev[6], mapname[PATH_MAX+1];
+	struct buffer_instance *instance = &top_instance;
+	struct pid_mem_maps *maps = instance->mem_maps;
+	unsigned long long begin, end, inode, foo;
+	struct lib_mem_map *map;
+	char fname[PATH_MAX+1];
+	FILE *f;
+	int ret;
+	int i;
+
+	while (maps) {
+		if (pid == maps->pid)
+			break;
+		maps = maps->next;
+	}
+
+	sprintf(fname, "/proc/%d/exe", pid);
+	ret = readlink(fname, mapname, PATH_MAX);
+	if (ret >= PATH_MAX || ret < 0)
+		return;
+
+	sprintf(fname, "/proc/%d/maps", pid);
+	f = fopen(fname, "r");
+	if (!f)
+		return;
+
+	if (!maps) {
+		maps = calloc(1, sizeof(*maps));
+		if (!maps)
+			return;
+		maps->pid = pid;
+		maps->next = instance->mem_maps;
+		instance->mem_maps = maps;
+	} else {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		free(maps->lib_maps);
+		maps->lib_maps = NULL;
+		maps->nr_lib_maps = 0;
+		free(maps->proc_name);
+	}
+
+	maps->proc_name = strdup(mapname);
+
+	while (fgets(buf, sizeof(buf), f)) {
+		mapname[0] = '\0';
+		ret = sscanf(buf, "%llx-%llx %4s %llx %5s %lld %s",
+			     &begin, &end, perm, &foo, dev, &inode, mapname);
+		if (ret == 7 && mapname[0] != '\0') {
+			map = realloc(maps->lib_maps,
+				      (maps->nr_lib_maps+1)*sizeof(*map));
+			if (!map)
+				break;
+			map[maps->nr_lib_maps].end = end;
+			map[maps->nr_lib_maps].start = begin;
+			map[maps->nr_lib_maps].lib_name = strdup(mapname);
+			maps->lib_maps = map;
+			maps->nr_lib_maps++;
+		}
+	}
+	fclose(f);
+}
+
+static void get_filter_pid_mmaps(void)
+{
+	struct filter_pids *p;
+
+	for (p = filter_pids; p; p = p->next) {
+		if (p->exclude)
+			continue;
+		get_pid_mmaps(p->pid);
+	}
+}
+
 static void update_task_filter(void)
 {
 	struct buffer_instance *instance;
@@ -1068,6 +1145,9 @@ static void update_task_filter(void)
 	if (no_filter)
 		return;
 
+	if (get_mmap && filter_pids)
+		get_filter_pid_mmaps();
+
 	if (filter_task)
 		add_filter_pid(pid, 0);
 
@@ -1262,6 +1342,8 @@ static void ptrace_wait(enum trace_type type, int main_pid)
 				break;
 
 			case PTRACE_EVENT_EXIT:
+				if (get_mmap)
+					get_pid_mmaps(main_pid);
 				ptrace(PTRACE_GETEVENTMSG, pid, NULL, &cstatus);
 				ptrace(PTRACE_DETACH, pid, NULL, NULL);
 				break;
@@ -3092,6 +3174,35 @@ static void append_buffer(struct tracecmd_output *handle,
 	}
 }
 
+static void
+add_pid_mem_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
+{
+	struct pid_mem_maps *maps = instance->mem_maps;
+	struct iovec vector[2];
+	struct trace_seq s;
+	int i;
+
+	trace_seq_init(&s);
+	while (maps) {
+		if (!maps->nr_lib_maps)
+			continue;
+		trace_seq_reset(&s);
+		trace_seq_printf(&s, "%d %s\n", maps->pid, maps->proc_name);
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			trace_seq_printf(&s, "%llx %llx %s\n",
+					maps->lib_maps[i].start,
+					maps->lib_maps[i].end,
+					maps->lib_maps[i].lib_name);
+		vector[0].iov_len = 4;
+		vector[0].iov_base = &maps->nr_lib_maps;
+		vector[1].iov_len = s.len+1;
+		vector[1].iov_base = s.buffer;
+		tracecmd_add_option_v(handle, TRACECMD_OPTION_PIDMMAPS, vector, 2);
+		maps = maps->next;
+	}
+	trace_seq_destroy(&s);
+}
+
 static void
 add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
@@ -3272,6 +3383,10 @@ static void record_data(struct common_record_context *ctx)
 		if (!no_top_instance() && !top_instance.msg_handle)
 			print_stat(&top_instance);
 
+		for_all_instances(instance) {
+			add_pid_mem_maps(handle, instance);
+		}
+
 		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
 
 		for (i = 0; i < max_cpu_count; i++)
@@ -4382,6 +4497,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 }
 
 enum {
+	OPT_mmap		= 244,
 	OPT_quiet		= 245,
 	OPT_debug		= 246,
 	OPT_no_filter		= 247,
@@ -4612,6 +4728,7 @@ static void parse_record_options(int argc,
 			{"debug", no_argument, NULL, OPT_debug},
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
+			{"mmap", no_argument, NULL, OPT_mmap},
 			{"module", required_argument, NULL, OPT_module},
 			{NULL, 0, NULL, 0}
 		};
@@ -4843,6 +4960,9 @@ static void parse_record_options(int argc,
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
+		case OPT_mmap:
+			get_mmap = 1;
+			break;
 		case OPT_date:
 			ctx->date = 1;
 			if (ctx->data_flags & DATA_FL_OFFSET)
@@ -4909,6 +5029,9 @@ static void parse_record_options(int argc,
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
 
+	if (filter_task && get_mmap)
+		do_ptrace = 1;
+
 	if (do_ptrace && !filter_task && (filter_pid < 0))
 		die(" -c can only be used with -F (or -P with event-fork support)");
 	if (ctx->do_child && !filter_task &&! filter_pid)
-- 
2.21.0

