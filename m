Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2631FC433FF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFC8A2133F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ehih95R2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfHNIri (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41416 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfHNIrb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:31 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so8029293wrr.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WwCZXgEoC95RGyBux5AgUqA0qG36+Xat7hxaJI/F2mE=;
        b=ehih95R2ntsVNJOaE5sYxQSrDHxna1Ehjx/3231UYZ0sXgmNuVY83ZoT4b206QEYXB
         dW/uKjUrJu+K8JGN3OCCY9g34OJBxBhMZIdS1mZ+ljMNZIRzrbm+2B9QCb40nb2vKqtr
         B9nozHMK7TC+Kr2uxsWNMjNamsIhVdA90qLZoT/Dlg0qgE4VeOV2TKDFLUFt0r8ZKy6N
         525Sng7TT3Mdmd4fJ+JolZ3vZ+gfN2CH2/IjM9fEXP7F+1MuOGDDDaPQCRvs9H8ur/Fq
         +f/GhFKRhFHTrelYlGH3Mr03c15hvJlVXxx+t1e3Bfjg7S3W4rYW5LFovqZYCODfyFlX
         bjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WwCZXgEoC95RGyBux5AgUqA0qG36+Xat7hxaJI/F2mE=;
        b=WcX4KX3ywFbZ4hVBChpfsVFOSIj/zAw2DmM5xHkux8DuXthYu8hXd+LlRhDJ2QOpVE
         H4rq2r2k25AJ9yK2FVSV8luVwCOBX0aWqaUSOg4A9ug/1bcqtONKz8GHw9QPX/MioUu2
         QIXavoMs/dA8bAJT6y6LQc/p/8/sLEQK4ydsUgSDmxs6SncbETtKfc3kCq91Ao4CLFBk
         oEHTEtOnYSnkFKIBl3hTFGJqvyldZK4lFfzMh4Pju/nhCMU6OPpaO6JJj3AhC7WvumrD
         JHpwWdcw+p/Caru+my0cqIs/6qW870Q4vICgcV7n9ajAZ9Aavl8ajK2VoI/9ApzbVecq
         ZbvQ==
X-Gm-Message-State: APjAAAXMMUkMghspa61CuQvcC8M8wqkalFAu6aSdfUbLSdM9LE9XOZJW
        CtFbdShDg7SbRyJdcfqeF7m6kFLJIzg=
X-Google-Smtp-Source: APXvYqwjWe15kH7lndJiQa6n45WC7GbA1qHjCIO/9O7+1SBJOipK1agBjkl75uNu2UEW7bO7F/1gTQ==
X-Received: by 2002:a5d:6ccd:: with SMTP id c13mr53218820wrc.4.1565772447772;
        Wed, 14 Aug 2019 01:47:27 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 2/3] trace-cmd: Save the tracee address map into the trace.dat file.
Date:   Wed, 14 Aug 2019 11:47:11 +0300
Message-Id: <20190814084712.28188-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new trace-cmd record option is added: "--proc-map". When it is set
the address map of the traced applications is stored in the trace.dat
file. The traced applications can be specified using the option -P,
or as a given 'command'. A new API tracecmd_search_task_map() can be
used to look up into stored address maps. The map is retrieved from
/proc/<pid>/maps file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
[
 v5 changes:
   - Added new patch:
        "Extend ptrace logic to work with multiple filtered pids"
     It resolves "filter_pid" leftover in ptrace related logic.
   - "--proc-map" does not depend on option -F, it works with any command,
     specified as trace-cmd argument or option -P.
   - Renamed "mmap" to "proc-map" - the option name and the names of
     the functions, variables and defines related to this feature. 
 v4 changes:
   - Added description of the new "--mmap" trace-cmd option in the 
    program's help and the man page. (Suggested by Slavomir Kaslev)

  Problems, reported by Yordan Karadzhov:
   - Improved the parsing of /proc/<pid>/maps. Made it not so strict, as it
     failed on some machines due to different size of fields. 
   - Implemented trace_pid_mmap_free() cleanup function to free mmap
     related resources at trace-cmd exit.
   - Fixed potential problem with non-terminated string, returned by
     readlink().
   - Coding style fixes.
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

 Documentation/trace-cmd-record.1.txt |   3 +
 include/trace-cmd/trace-cmd.h        |  10 ++
 lib/trace-cmd/trace-input.c          | 172 ++++++++++++++++++++++++++-
 tracecmd/include/trace-local.h       |  10 ++
 tracecmd/trace-record.c              | 172 ++++++++++++++++++++++++++-
 tracecmd/trace-usage.c               |   1 +
 6 files changed, 364 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 26a8299..e697f03 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -288,6 +288,9 @@ OPTIONS
 
     '--module snd -n "*"' is equivalent to '-n :mod:snd'
 
+*--proc-map*::
+     Save the traced process address map into the trace.dat file. The traced
+     processes can be specified using the option *-P*, or as a given 'command'.
 
 *--profile*::
     With the *--profile* option, "trace-cmd" will enable tracing that can
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6f62ab9..c4a437a 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -82,6 +82,7 @@ enum {
 	TRACECMD_OPTION_OFFSET,
 	TRACECMD_OPTION_CPUCOUNT,
 	TRACECMD_OPTION_VERSION,
+	TRACECMD_OPTION_PROCMAPS,
 };
 
 enum {
@@ -97,6 +98,12 @@ struct tracecmd_ftrace {
 	int long_size;
 };
 
+struct tracecmd_proc_addr_map {
+	unsigned long long	start;
+	unsigned long long	end;
+	char			*lib_name;
+};
+
 typedef void (*tracecmd_show_data_func)(struct tracecmd_input *handle,
 					struct tep_record *record);
 typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
@@ -208,6 +215,9 @@ unsigned long long tracecmd_page_ts(struct tracecmd_input *handle,
 unsigned int tracecmd_record_ts_delta(struct tracecmd_input *handle,
 				      struct tep_record *record);
 
+struct tracecmd_proc_addr_map *
+tracecmd_search_task_map(struct tracecmd_input *handle,
+			 int pid, unsigned long long addr);
 #ifndef SWIG
 /* hack for function graph work around */
 extern __thread struct tracecmd_input *tracecmd_curr_thread_handle;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 654101f..a6fa7f5 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -101,6 +101,7 @@ struct tracecmd_input {
 	struct tracecmd_ftrace	finfo;
 
 	struct hook_list	*hooks;
+	struct pid_addr_maps	*pid_maps;
 	/* file information */
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
@@ -2136,6 +2137,167 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
 	handle->use_trace_clock = false;
 }
 
+static int trace_pid_map_cmp(const void *a, const void *b)
+{
+	struct tracecmd_proc_addr_map *m_a = (struct tracecmd_proc_addr_map *)a;
+	struct tracecmd_proc_addr_map *m_b = (struct tracecmd_proc_addr_map *)b;
+
+	if (m_a->start > m_b->start)
+		return 1;
+	if (m_a->start < m_b->start)
+		return -1;
+	return 0;
+}
+
+static void procmap_free(struct pid_addr_maps *maps)
+{
+	int i;
+
+	if (!maps)
+		return;
+	if (maps->lib_maps) {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		free(maps->lib_maps);
+	}
+	free(maps->proc_name);
+	free(maps);
+}
+
+#define STR_PROCMAP_LINE_MAX	(PATH_MAX+22)
+static int trace_pid_map_load(struct tracecmd_input *handle, char *buf)
+{
+	struct pid_addr_maps *maps = NULL;
+	char mapname[STR_PROCMAP_LINE_MAX];
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
+	if (strlen(buf) > STR_PROCMAP_LINE_MAX)
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
+	maps->lib_maps = calloc(maps->nr_lib_maps, sizeof(struct tracecmd_proc_addr_map));
+	if (!maps->lib_maps)
+		goto out_fail;
+
+	buf = line + 1;
+	line = strchr(buf, '\n');
+	for (i = 0; i < maps->nr_lib_maps; i++) {
+		if (!line)
+			break;
+		*line = '\0';
+		if (strlen(buf) > STR_PROCMAP_LINE_MAX)
+			break;
+		res = sscanf(buf, "%llx %llx %s", &maps->lib_maps[i].start,
+			     &maps->lib_maps[i].end, mapname);
+		if (res != 3)
+			break;
+		maps->lib_maps[i].lib_name = strdup(mapname);
+		if (!maps->lib_maps[i].lib_name)
+			goto out_fail;
+		buf = line + 1;
+		line = strchr(buf, '\n');
+	}
+
+	ret  = -EINVAL;
+	if (i != maps->nr_lib_maps)
+		goto out_fail;
+
+	qsort(maps->lib_maps, maps->nr_lib_maps,
+	      sizeof(*maps->lib_maps), trace_pid_map_cmp);
+
+	maps->next = handle->pid_maps;
+	handle->pid_maps = maps;
+
+	return 0;
+
+out_fail:
+	procmap_free(maps);
+	return ret;
+}
+
+static void trace_pid_map_free(struct pid_addr_maps *maps)
+{
+	struct pid_addr_maps *del;
+
+	while (maps) {
+		del = maps;
+		maps = maps->next;
+		procmap_free(del);
+	}
+}
+
+static int trace_pid_map_search(const void *a, const void *b)
+{
+	struct tracecmd_proc_addr_map *key = (struct tracecmd_proc_addr_map *)a;
+	struct tracecmd_proc_addr_map *map = (struct tracecmd_proc_addr_map *)b;
+
+	if (key->start >= map->end)
+		return 1;
+	if (key->start < map->start)
+		return -1;
+	return 0;
+}
+
+/**
+ * tracecmd_search_task_map - Search task memory address map
+ * @handle: input handle to the trace.dat file
+ * @pid: pid of the task
+ * @addr: address from the task memory space.
+ *
+ * Map of the task memory can be saved in the trace.dat file, using the option
+ * "--proc-map". If there is such information, this API can be used to look up
+ * into this memory map to find what library is loaded at the given @addr.
+ *
+ * A pointer to struct tracecmd_proc_addr_map is returned, containing the name
+ * of the library at given task @addr and the library start and end addresses.
+ */
+struct tracecmd_proc_addr_map *
+tracecmd_search_task_map(struct tracecmd_input *handle,
+			 int pid, unsigned long long addr)
+{
+	struct tracecmd_proc_addr_map *lib;
+	struct tracecmd_proc_addr_map key;
+	struct pid_addr_maps *maps;
+
+	if (!handle || !handle->pid_maps)
+		return NULL;
+
+	maps = handle->pid_maps;
+	while (maps) {
+		if (maps->pid == pid)
+			break;
+		maps = maps->next;
+	}
+	if (!maps || !maps->nr_lib_maps || !maps->lib_maps)
+		return NULL;
+	key.start = addr;
+	lib = bsearch(&key, maps->lib_maps, maps->nr_lib_maps,
+		      sizeof(*maps->lib_maps), trace_pid_map_search);
+
+	return lib;
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	unsigned long long offset;
@@ -2223,9 +2385,6 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_UNAME:
 			handle->uname = strdup(buf);
 			break;
-		case TRACECMD_OPTION_VERSION:
-			handle->version = strdup(buf);
-			break;
 		case TRACECMD_OPTION_HOOK:
 			hook = tracecmd_create_event_hook(buf);
 			hook->next = handle->hooks;
@@ -2235,6 +2394,10 @@ static int handle_options(struct tracecmd_input *handle)
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
 			break;
+		case TRACECMD_OPTION_PROCMAPS:
+			if (buf[size-1] == '\0')
+				trace_pid_map_load(handle, buf);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
@@ -2848,6 +3011,9 @@ void tracecmd_close(struct tracecmd_input *handle)
 	tracecmd_free_hooks(handle->hooks);
 	handle->hooks = NULL;
 
+	trace_pid_map_free(handle->pid_maps);
+	handle->pid_maps = NULL;
+
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
 	else {
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 1cad3cc..78c52dc 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -157,6 +157,14 @@ struct func_list {
 	const char *mod;
 };
 
+struct pid_addr_maps {
+	struct pid_addr_maps		*next;
+	struct tracecmd_proc_addr_map	*lib_maps;
+	unsigned int			nr_lib_maps;
+	char				*proc_name;
+	int				pid;
+};
+
 struct buffer_instance {
 	struct buffer_instance	*next;
 	const char		*name;
@@ -183,6 +191,8 @@ struct buffer_instance {
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
 
+	struct pid_addr_maps	*pid_maps;
+
 	char			*max_graph_depth;
 
 	int			flags;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e0fa07d..17c676c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -84,6 +84,8 @@ static int max_kb;
 static bool use_tcp;
 
 static int do_ptrace;
+static int do_children;
+static int get_procmap;
 
 static int filter_task;
 static bool no_filter = false;
@@ -1068,6 +1070,121 @@ static char *make_pid_filter(char *curr_filter, const char *field)
 	return filter;
 }
 
+#define _STRINGIFY(x) #x
+#define STRINGIFY(x) _STRINGIFY(x)
+
+static int get_pid_addr_maps(int pid)
+{
+	struct buffer_instance *instance = &top_instance;
+	struct pid_addr_maps *maps = instance->pid_maps;
+	struct tracecmd_proc_addr_map *map;
+	unsigned long long begin, end;
+	struct pid_addr_maps *m;
+	char mapname[PATH_MAX+1];
+	char fname[PATH_MAX+1];
+	char buf[PATH_MAX+100];
+	FILE *f;
+	int ret;
+	int res;
+	int i;
+
+	sprintf(fname, "/proc/%d/exe", pid);
+	ret = readlink(fname, mapname, PATH_MAX);
+	if (ret >= PATH_MAX || ret < 0)
+		return -ENOENT;
+	mapname[ret] = 0;
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
+		maps->next = instance->pid_maps;
+		instance->pid_maps = maps;
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
+		res = sscanf(buf, "%llx-%llx %*s %*x %*s %*d %"STRINGIFY(PATH_MAX)"s",
+			     &begin, &end, mapname);
+		if (res == 3 && mapname[0] != '\0') {
+			map = realloc(maps->lib_maps,
+				      (maps->nr_lib_maps + 1) * sizeof(*map));
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
+		if (instance->pid_maps != maps) {
+			m = instance->pid_maps;
+			while (m) {
+				if (m->next == maps) {
+					m->next = maps->next;
+					break;
+				}
+				m = m->next;
+			}
+		} else
+			instance->pid_maps = maps->next;
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
+static void get_filter_pid_maps(void)
+{
+	struct filter_pids *p;
+
+	for (p = filter_pids; p; p = p->next) {
+		if (p->exclude)
+			continue;
+		get_pid_addr_maps(p->pid);
+	}
+}
+
 static void update_task_filter(void)
 {
 	struct buffer_instance *instance;
@@ -1076,6 +1193,9 @@ static void update_task_filter(void)
 	if (no_filter)
 		return;
 
+	if (get_procmap && filter_pids)
+		get_filter_pid_maps();
+
 	if (filter_task)
 		add_filter_pid(pid, 0);
 
@@ -1287,6 +1407,8 @@ static void ptrace_wait(enum trace_type type)
 				break;
 
 			case PTRACE_EVENT_EXIT:
+				if (get_procmap)
+					get_pid_addr_maps(pid);
 				ptrace(PTRACE_GETEVENTMSG, pid, NULL, &cstatus);
 				ptrace(PTRACE_DETACH, pid, NULL, NULL);
 				break;
@@ -1363,6 +1485,7 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
 	}
 	if (do_ptrace) {
 		add_filter_pid(pid, 0);
+		ptrace_attach(pid);
 		ptrace_wait(type);
 	} else
 		trace_waitpid(type, pid, &status, 0);
@@ -3130,6 +3253,36 @@ static void append_buffer(struct tracecmd_output *handle,
 	}
 }
 
+
+static void
+add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
+{
+	struct pid_addr_maps *maps = instance->pid_maps;
+	struct trace_seq s;
+	int i;
+
+	trace_seq_init(&s);
+	while (maps) {
+		if (!maps->nr_lib_maps) {
+			maps = maps->next;
+			continue;
+		}
+		trace_seq_reset(&s);
+		trace_seq_printf(&s, "%x %x %s\n",
+				 maps->pid, maps->nr_lib_maps, maps->proc_name);
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			trace_seq_printf(&s, "%llx %llx %s\n",
+					maps->lib_maps[i].start,
+					maps->lib_maps[i].end,
+					maps->lib_maps[i].lib_name);
+		trace_seq_terminate(&s);
+		tracecmd_add_option(handle, TRACECMD_OPTION_PROCMAPS,
+				    s.len + 1, s.buffer);
+		maps = maps->next;
+	}
+	trace_seq_destroy(&s);
+}
+
 static void
 add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
@@ -3323,6 +3476,10 @@ static void record_data(struct common_record_context *ctx)
 		if (!no_top_instance() && !top_instance.msg_handle)
 			print_stat(&top_instance);
 
+		for_all_instances(instance) {
+			add_pid_maps(handle, instance);
+		}
+
 		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
 
 		for (i = 0; i < max_cpu_count; i++)
@@ -4433,6 +4590,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 }
 
 enum {
+	OPT_procmap		= 244,
 	OPT_quiet		= 245,
 	OPT_debug		= 246,
 	OPT_no_filter		= 247,
@@ -4663,6 +4821,7 @@ static void parse_record_options(int argc,
 			{"debug", no_argument, NULL, OPT_debug},
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
+			{"proc-map", no_argument, NULL, OPT_procmap},
 			{"module", required_argument, NULL, OPT_module},
 			{NULL, 0, NULL, 0}
 		};
@@ -4752,6 +4911,7 @@ static void parse_record_options(int argc,
 				die("-c invalid: ptrace not supported");
 #endif
 				do_ptrace = 1;
+				do_children = 1;
 			} else {
 				save_option("event-fork");
 				ctx->do_child = 1;
@@ -4894,6 +5054,9 @@ static void parse_record_options(int argc,
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
+		case OPT_procmap:
+			get_procmap = 1;
+			break;
 		case OPT_date:
 			ctx->date = 1;
 			if (ctx->data_flags & DATA_FL_OFFSET)
@@ -4960,7 +5123,7 @@ static void parse_record_options(int argc,
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
 
-	if (do_ptrace && !filter_task && !nr_filter_pids)
+	if (do_children && !filter_task && !nr_filter_pids)
 		die(" -c can only be used with -F (or -P with event-fork support)");
 	if (ctx->do_child && !filter_task && !nr_filter_pids)
 		die(" -c can only be used with -P or -F");
@@ -4974,6 +5137,13 @@ static void parse_record_options(int argc,
 			    "Did you mean 'record'?");
 		ctx->run_command = 1;
 	}
+
+	if (get_procmap) {
+		if (!ctx->run_command && !nr_filter_pids)
+			warning("--proc-map is ignored, no command or filtered PIDs are specified.");
+		else
+			do_ptrace = 1;
+	}
 }
 
 static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 406384c..7a67784 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -57,6 +57,7 @@ static struct usage_help usage_help[] = {
 		"             (use with caution)\n"
 		"          --max-graph-depth limit function_graph depth\n"
 		"          --no-filter include trace-cmd threads in the trace\n"
+		"          --proc-map save the traced processes address map into the trace.dat file\n"
 	},
 	{
 		"start",
-- 
2.21.0

