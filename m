Return-Path: <SRS0=4yZ8=US=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDA8C31E49
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 08:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DC8D20B1F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 08:39:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uOwMPdCh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbfFSIjX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 04:39:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54831 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730418AbfFSIjW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 04:39:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so790495wme.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jun 2019 01:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OkEYVU3Cm/LM5ebOcVtGXk6iAJp6lU2LvbNEOfzsFMI=;
        b=uOwMPdChPtD8CvFnm4tK/6aVa/wk1UCO3Mt9k81VDdqgDZqy5FrjLMTkxtYpf3RxPm
         7m2gY09ZxtvblczpN193xhVsbPAEZmoOUUIlr60I5PTxgKGLHSaloeZJ7dQ+aZJaOBhI
         0Pt144gv4MEfKefl3l8nGoVT97jeXb9SNxBEkSYENPL86lGpTsOMoV3C+VNIqD3mYova
         UUXDsum7drVPYPClX68OgcQk30+byX71gjfa6aX/dXimn/NGlRypUIOztl1EvBz43Ild
         iDk1ftqg8HT+RG7wS047X942XEFgZnDqP0m6o/9iYRj/qD1X1ZWihFAQB3K0RjiuCHik
         3g7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OkEYVU3Cm/LM5ebOcVtGXk6iAJp6lU2LvbNEOfzsFMI=;
        b=BCIiHRCmSctfWhE5zOgVonuCPbgdjuVfNHV3yiZA8YUT4lM8+L36jsplV4FlqN5/nx
         l8LXKkRahf22WkZQ6PoVEj0WED6tr7vCNuUS72qZZjzpEOctKqH8Gi7HDPMNQQllfxaR
         5FhPmP76RJt9vw3jUkInXmp3ltwKcv6Rmbb2mGHXwrfifOnamHwjF+qsRhxFRUA00X4t
         mmmck1Pni2xawXoJiOCK78JzWU+EwtM/gOedWLHW8o1Btb+8J53+EsSlKu+q/AYJMeOH
         VuTEN/1YTZJ83wtvSIjEYmtvjdlU1/DthMBDOuIRzLF4d7MLD7UkP78IFUk2nWd3/L+3
         x8pQ==
X-Gm-Message-State: APjAAAURx2NQqQu7uyC6Ksqiwac4T2cr2uyH3oHVBWRdwHdPoJJHTI7A
        /LDsakc/DdvDqCy7UlfF98k=
X-Google-Smtp-Source: APXvYqyo5rAitBNi2nQMxbgrqpuBLRIrukM1Uy9SD4kQxt0hJnqqBmNJS6t8D3vdy7/V1tXmhv5rCw==
X-Received: by 2002:a7b:c247:: with SMTP id b7mr7545634wmj.13.1560933558428;
        Wed, 19 Jun 2019 01:39:18 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a8sm1016664wmf.28.2019.06.19.01.39.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 01:39:17 -0700 (PDT)
From:   tz.stoyanov@gmail.com
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] trace-cmd: Save the tracee memory map into the trace.dat file.
Date:   Wed, 19 Jun 2019 11:39:15 +0300
Message-Id: <20190619083915.2049-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

A new trace-cmd record option is added: "--mmap". When it is set with
combination of -F or -P options, the memory map of the traced applications
is stored in the trace.dat file. A new API tracecmd_search_task_mmap()
can be used to look up into stored memory maps. The map is retrieved from
/proc/<pid>/maps file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
[
 v3 changes:
   - Changed tracecmd_search_task_mmap() API to return not only the library
     name, but also the start and end memory addresses.
   - Renamed *tracee* to *task*
   - Improved resources cleanup, in case of an error.
   - Removed (this) changelog from the commit message.

 v2 changes:
   - Replaced usage of tracecmd_add_option_v() with tracecmd_add_option() API.
   - Added checks to prevent buffer overflow when sscanf (... "%s", buf) is used.
   - Return error in case memory allocation fails.
   - Return error if option string is not in the expected format.
   - Sort memory maps and use binary search to find matching library in the map.
]

 include/trace-cmd/trace-cmd.h  |   9 ++
 lib/trace-cmd/trace-input.c    | 149 ++++++++++++++++++++++++++++++-
 tracecmd/include/trace-local.h |  10 +++
 tracecmd/trace-record.c        | 158 +++++++++++++++++++++++++++++++++
 4 files changed, 323 insertions(+), 3 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6f62ab9..17edb9d 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -82,6 +82,7 @@ enum {
 	TRACECMD_OPTION_OFFSET,
 	TRACECMD_OPTION_CPUCOUNT,
 	TRACECMD_OPTION_VERSION,
+	TRACECMD_OPTION_PIDMMAPS,
 };
 
 enum {
@@ -97,6 +98,12 @@ struct tracecmd_ftrace {
 	int long_size;
 };
 
+struct lib_mem_map {
+	unsigned long long	start;
+	unsigned long long	end;
+	char			*lib_name;
+};
+
 typedef void (*tracecmd_show_data_func)(struct tracecmd_input *handle,
 					struct tep_record *record);
 typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
@@ -208,6 +215,8 @@ unsigned long long tracecmd_page_ts(struct tracecmd_input *handle,
 unsigned int tracecmd_record_ts_delta(struct tracecmd_input *handle,
 				      struct tep_record *record);
 
+struct lib_mem_map *tracecmd_search_task_mmap(struct tracecmd_input *handle,
+					      int pid, unsigned long long addr);
 #ifndef SWIG
 /* hack for function graph work around */
 extern __thread struct tracecmd_input *tracecmd_curr_thread_handle;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 61566ba..7acecf3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -101,6 +101,7 @@ struct tracecmd_input {
 	struct tracecmd_ftrace	finfo;
 
 	struct hook_list	*hooks;
+	struct pid_mem_maps	*pid_mmaps;
 	/* file information */
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
@@ -2134,6 +2135,147 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
 	handle->use_trace_clock = false;
 }
 
+static int trace_pid_mmap_cmp(const void *a, const void *b)
+{
+	struct lib_mem_map *map_a = (struct lib_mem_map *)a;
+	struct lib_mem_map *map_b = (struct lib_mem_map *)b;
+
+	if (map_a->start > map_b->start)
+		return 1;
+	if (map_a->start < map_b->start)
+		return -1;
+	return 0;
+}
+
+#define STR_MMAP_LINE_MAX	(PATH_MAX+34)
+static int trace_pid_mmap_load(struct tracecmd_input *handle, char *buf)
+{
+	struct pid_mem_maps *maps = NULL;
+	char mapname[STR_MMAP_LINE_MAX];
+	char *line;
+	int res;
+	int ret;
+	int i;
+
+	maps = calloc(1, sizeof(*maps));
+	if (!maps)
+		return -ENOMEM;
+
+	ret  = -EINVAL;
+	line = strchr(buf, '\n');
+	if (!line)
+		goto out_fail;
+
+	*line = '\0';
+	if (strlen(buf) > STR_MMAP_LINE_MAX)
+		goto out_fail;
+
+	res = sscanf(buf, "%x %x %s", &maps->pid, &maps->nr_lib_maps, mapname);
+	if (res != 3)
+		goto out_fail;
+
+	ret  = -ENOMEM;
+	maps->proc_name = strdup(mapname);
+	if (!maps->proc_name)
+		goto out_fail;
+
+	maps->lib_maps = calloc(maps->nr_lib_maps, sizeof(struct lib_mem_map));
+	if (!maps->lib_maps)
+		goto out_fail;
+
+	buf = line+1;
+	line = strchr(buf, '\n');
+	for (i = 0; i < maps->nr_lib_maps; i++) {
+		if (!line)
+			break;
+		*line = '\0';
+		if (strlen(buf) > STR_MMAP_LINE_MAX)
+			break;
+		res = sscanf(buf, "%llx %llx %s", &maps->lib_maps[i].start,
+			     &maps->lib_maps[i].end, mapname);
+		if (res != 3)
+			break;
+		maps->lib_maps[i].lib_name = strdup(mapname);
+		if (!maps->lib_maps[i].lib_name)
+			goto out_fail;
+		buf = line+1;
+		line = strchr(buf, '\n');
+	}
+
+	ret  = -EINVAL;
+	if (i != maps->nr_lib_maps)
+		goto out_fail;
+
+	qsort(maps->lib_maps, maps->nr_lib_maps,
+	      sizeof(*maps->lib_maps), trace_pid_mmap_cmp);
+
+	maps->next = handle->pid_mmaps;
+	handle->pid_mmaps = maps;
+
+	return 0;
+
+out_fail:
+	if (maps->lib_maps) {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		free(maps->lib_maps);
+	}
+	free(maps->proc_name);
+	free(maps);
+
+	return ret;
+}
+
+static int trace_pid_mmap_search(const void *a, const void *b)
+{
+	struct lib_mem_map *key = (struct lib_mem_map *)a;
+	struct lib_mem_map *map = (struct lib_mem_map *)b;
+
+	if (key->start >= map->end)
+		return 1;
+	if (key->start < map->start)
+		return -1;
+	return 0;
+}
+
+/**
+ * tracecmd_search_task_mmap - Search task memory address map
+ * @handle: input handle to the trace.dat file
+ * @pid: pid of the task
+ * @addr: address from the task memory space.
+ *
+ * Map of the task memory can be saved in the trace.dat file, using the option
+ * "--mmap". If there is such information, this API can be used to look up into
+ * this memory map to find what library is loaded at the given @addr.
+ *
+ * A pointer to struct lib_mem_map is returned, containing the name of
+ * the library at given task @addr and the library start and end addresses.
+ */
+struct lib_mem_map *tracecmd_search_task_mmap(struct tracecmd_input *handle,
+					      int pid, unsigned long long addr)
+{
+	struct pid_mem_maps *maps;
+	struct lib_mem_map *lib;
+	struct lib_mem_map key;
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
+	key.start = addr;
+	lib = bsearch(&key, maps->lib_maps, maps->nr_lib_maps,
+		      sizeof(*maps->lib_maps), trace_pid_mmap_search);
+
+	return lib;
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	unsigned long long offset;
@@ -2221,9 +2363,6 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_UNAME:
 			handle->uname = strdup(buf);
 			break;
-		case TRACECMD_OPTION_VERSION:
-			handle->version = strdup(buf);
-			break;
 		case TRACECMD_OPTION_HOOK:
 			hook = tracecmd_create_event_hook(buf);
 			hook->next = handle->hooks;
@@ -2233,6 +2372,10 @@ static int handle_options(struct tracecmd_input *handle)
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
 			break;
+		case TRACECMD_OPTION_PIDMMAPS:
+			if (buf[size] == '\0')
+				trace_pid_mmap_load(handle, buf);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 1cad3cc..ae1632c 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -157,6 +157,14 @@ struct func_list {
 	const char *mod;
 };
 
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
@@ -183,6 +191,8 @@ struct buffer_instance {
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
 
+	struct pid_mem_maps	*mem_maps;
+
 	char			*max_graph_depth;
 
 	int			flags;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5dc6f17..edabf53 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -84,6 +84,7 @@ static int max_kb;
 static bool use_tcp;
 
 static int do_ptrace;
+static int get_mmap;
 
 static int filter_task;
 static int filter_pid = -1;
@@ -1062,6 +1063,119 @@ static char *make_pid_filter(char *curr_filter, const char *field)
 	return filter;
 }
 
+static int get_pid_mmaps(int pid)
+{
+	struct buffer_instance *instance = &top_instance;
+	struct pid_mem_maps *maps = instance->mem_maps;
+	struct pid_mem_maps *m;
+	unsigned long long begin, end, inode, tmp;
+	struct lib_mem_map *map;
+	char mapname[PATH_MAX+1];
+	char fname[PATH_MAX+1];
+	char buf[PATH_MAX+100];
+	char perm[5];
+	char dev[6];
+	FILE *f;
+	int ret;
+	int res;
+	int i;
+
+	sprintf(fname, "/proc/%d/exe", pid);
+	ret = readlink(fname, mapname, PATH_MAX);
+	if (ret >= PATH_MAX || ret < 0)
+		return -ENOENT;
+
+	sprintf(fname, "/proc/%d/maps", pid);
+	f = fopen(fname, "r");
+	if (!f)
+		return -ENOENT;
+
+	while (maps) {
+		if (pid == maps->pid)
+			break;
+		maps = maps->next;
+	}
+
+	ret = -ENOMEM;
+	if (!maps) {
+		maps = calloc(1, sizeof(*maps));
+		if (!maps)
+			goto out_fail;
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
+	if (!maps->proc_name)
+		goto out;
+
+	while (fgets(buf, sizeof(buf), f)) {
+		mapname[0] = '\0';
+		res = sscanf(buf, "%llx-%llx %4s %llx %5s %lld %s",
+			     &begin, &end, perm, &tmp, dev, &inode, mapname);
+		if (res == 7 && mapname[0] != '\0') {
+			map = realloc(maps->lib_maps,
+				      (maps->nr_lib_maps+1)*sizeof(*map));
+			if (!map)
+				goto out_fail;
+			map[maps->nr_lib_maps].end = end;
+			map[maps->nr_lib_maps].start = begin;
+			map[maps->nr_lib_maps].lib_name = strdup(mapname);
+			if (!map[maps->nr_lib_maps].lib_name)
+				goto out_fail;
+			maps->lib_maps = map;
+			maps->nr_lib_maps++;
+		}
+	}
+out:
+	fclose(f);
+	return 0;
+
+out_fail:
+	fclose(f);
+	if (maps) {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		if (instance->mem_maps != maps) {
+			m = instance->mem_maps;
+			while (m) {
+				if (m->next == maps) {
+					m->next = maps->next;
+					break;
+				}
+				m = m->next;
+			}
+		} else
+			instance->mem_maps = maps->next;
+		free(maps->lib_maps);
+		maps->lib_maps = NULL;
+		maps->nr_lib_maps = 0;
+		free(maps->proc_name);
+		maps->proc_name = NULL;
+		free(maps);
+	}
+	return ret;
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
@@ -1070,6 +1184,9 @@ static void update_task_filter(void)
 	if (no_filter)
 		return;
 
+	if (get_mmap && filter_pids)
+		get_filter_pid_mmaps();
+
 	if (filter_task)
 		add_filter_pid(pid, 0);
 
@@ -1264,6 +1381,8 @@ static void ptrace_wait(enum trace_type type, int main_pid)
 				break;
 
 			case PTRACE_EVENT_EXIT:
+				if (get_mmap)
+					get_pid_mmaps(main_pid);
 				ptrace(PTRACE_GETEVENTMSG, pid, NULL, &cstatus);
 				ptrace(PTRACE_DETACH, pid, NULL, NULL);
 				break;
@@ -3094,6 +3213,33 @@ static void append_buffer(struct tracecmd_output *handle,
 	}
 }
 
+
+static void
+add_pid_mem_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
+{
+	struct pid_mem_maps *maps = instance->mem_maps;
+	struct trace_seq s;
+	int i;
+
+	trace_seq_init(&s);
+	while (maps) {
+		if (!maps->nr_lib_maps)
+			continue;
+		trace_seq_reset(&s);
+		trace_seq_printf(&s, "%x %x %s\n",
+				 maps->pid, maps->nr_lib_maps, maps->proc_name);
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			trace_seq_printf(&s, "%llx %llx %s\n",
+					maps->lib_maps[i].start,
+					maps->lib_maps[i].end,
+					maps->lib_maps[i].lib_name);
+		tracecmd_add_option(handle, TRACECMD_OPTION_PIDMMAPS,
+				    s.len+1, s.buffer);
+		maps = maps->next;
+	}
+	trace_seq_destroy(&s);
+}
+
 static void
 add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
@@ -3287,6 +3433,10 @@ static void record_data(struct common_record_context *ctx)
 		if (!no_top_instance() && !top_instance.msg_handle)
 			print_stat(&top_instance);
 
+		for_all_instances(instance) {
+			add_pid_mem_maps(handle, instance);
+		}
+
 		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
 
 		for (i = 0; i < max_cpu_count; i++)
@@ -4397,6 +4547,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 }
 
 enum {
+	OPT_mmap		= 244,
 	OPT_quiet		= 245,
 	OPT_debug		= 246,
 	OPT_no_filter		= 247,
@@ -4627,6 +4778,7 @@ static void parse_record_options(int argc,
 			{"debug", no_argument, NULL, OPT_debug},
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
+			{"mmap", no_argument, NULL, OPT_mmap},
 			{"module", required_argument, NULL, OPT_module},
 			{NULL, 0, NULL, 0}
 		};
@@ -4858,6 +5010,9 @@ static void parse_record_options(int argc,
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
+		case OPT_mmap:
+			get_mmap = 1;
+			break;
 		case OPT_date:
 			ctx->date = 1;
 			if (ctx->data_flags & DATA_FL_OFFSET)
@@ -4924,6 +5079,9 @@ static void parse_record_options(int argc,
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

