Return-Path: <SRS0=Thka=BR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32178C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EE1220866
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLZFsOuP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgHGMHO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Aug 2020 08:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgHGMHE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Aug 2020 08:07:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DBBC061757
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 Aug 2020 05:07:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l2so1452218wrc.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Aug 2020 05:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M3hzJkZjkgXXQFYRJF/8lAeWfPtSbC+Z4PHet6vFAuk=;
        b=LLZFsOuPIcHcj3FmkHqtHtysTf7BSkpQZJARi4rCn+LtDvN9OEEkjQp4U2Zi8FZUt2
         TliWpipnoVMoiNDDb8f+EM6DkWAVAa/5n6E/QYhIACCFVbFRxiKXAZNAFQi04GirrsF0
         cKPn+BELQhnI+Pp+n0csW9cRIFEwzRiJNHQL5CwTpJWmeM8v5/hpSXwh6wjoEdPbmpBE
         iACpPb0mtzw2C4m+NPbu+YQXb5ANjQ4ck5fhN9ZP8rDhUyWIPNHoQU2KTE2jrVUbKD3l
         wW+E/xr28oCwBGbc+aPFL6zcXvXMAq4eMZ28lNruvjbuVc1UQ50upGhs+twArAZDOEKI
         bKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M3hzJkZjkgXXQFYRJF/8lAeWfPtSbC+Z4PHet6vFAuk=;
        b=OWLhQEvUKWrrKRtLIg444FE/gXQjDvx+a38XaHyflUM+D8/94bQA4ZmE3PCj7q5cKt
         g7YtyC1R8Ode+MZIo2JzHzA0asIvgmAII1jyShrVrXxG7aHj0lOMDze1uQ9/C4lq9Xwl
         kk7Z9N0JFahnxZrW3YvqzNQdkbMS1lBRU04L3kiovEDeDlXHkr65hz319BpXPjnvLjuZ
         BiGAPrxBAWJtKb4SjCP2/3I4PewG/1elYliouT7F8J/PueytGh/2zk5JR07VSI/JFEij
         4zN6AcB4FptW8zmCuXwkPWosoDD+n1ghq2ewHM7MBwY2A+D9pp2dPTMQxqXx79x2MO7a
         ayuA==
X-Gm-Message-State: AOAM5318Ty22kYdr1CQvFu8DLAFShhgKsNri68HFajOyPIL7jC5qLvjp
        cPKn0S2M5h6bMJ4fQI7JwBtHel5bpRM=
X-Google-Smtp-Source: ABdhPJxiRNkWOkgx6qsOnfg/Q3iPiOjwof42Dxtaz40XibcoE42qqygT/sfaRxAmxN4WErHm4M6feQ==
X-Received: by 2002:adf:fb87:: with SMTP id a7mr12766899wrr.390.1596802022224;
        Fri, 07 Aug 2020 05:07:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm10485303wmg.0.2020.08.07.05.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 05:07:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] trace-cmd: Add a new option in trace.dat file for the address to function name mapping
Date:   Fri,  7 Aug 2020 15:06:54 +0300
Message-Id: <20200807120655.797084-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200807120655.797084-1-tz.stoyanov@gmail.com>
References: <20200807120655.797084-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are cases where resolving a user space address recorded in the
trace file to function name is required, when this file is visualised.
This mapping is available during the trace. A new trace.dat file option
TRACECMD_OPTION_PID_SYMBOLS is added, for storing the mapping in the
file. A new API is introduced, to resolve address to name, using
information stored in the TRACECMD_OPTION_PID_SYMBOLS option:

 struct tracecmd_debug_symbols *
 tracecmd_search_task_symbol(struct tracecmd_input *handle,
			     int pid, unsigned long long addr);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |   5 ++
 lib/trace-cmd/trace-input.c   | 144 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-dump.c         |   3 +
 3 files changed, 152 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 5ebd076e..f47f6a19 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -112,6 +112,7 @@ enum {
 	TRACECMD_OPTION_TRACEID,
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
+	TRACECMD_OPTION_PID_SYMBOLS,
 };
 
 enum {
@@ -262,6 +263,10 @@ unsigned int tracecmd_record_ts_delta(struct tracecmd_input *handle,
 struct tracecmd_proc_addr_map *
 tracecmd_search_task_map(struct tracecmd_input *handle,
 			 int pid, unsigned long long addr);
+
+struct tracecmd_debug_symbols *
+tracecmd_search_task_symbol(struct tracecmd_input *handle,
+			    int pid, unsigned long long addr);
 #ifndef SWIG
 /* hack for function graph work around */
 extern __thread struct tracecmd_input *tracecmd_curr_thread_handle;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index af97883e..39da0cb8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -19,6 +19,8 @@
 #include "trace-local.h"
 #include "kbuffer.h"
 #include "list.h"
+#include "trace-hash.h"
+#include "trace-hash-local.h"
 
 #define _STRINGIFY(x) #x
 #define STRINGIFY(x) _STRINGIFY(x)
@@ -98,6 +100,18 @@ struct host_trace_info {
 	struct ts_offset_sample	*ts_samples;
 };
 
+struct pid_function_map {
+	struct trace_hash_item hash;
+	struct tracecmd_debug_symbols symb;
+};
+
+struct pid_symbol_maps {
+	struct pid_symbol_maps *next;
+	int pid;
+	int symb_count;
+	struct trace_hash symbols;
+};
+
 struct tracecmd_input {
 	struct tep_handle	*pevent;
 	struct tep_plugin_list	*plugin_list;
@@ -130,6 +144,7 @@ struct tracecmd_input {
 
 	struct hook_list	*hooks;
 	struct pid_addr_maps	*pid_maps;
+	struct pid_symbol_maps	*pid_symbols;
 	/* file information */
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
@@ -2430,6 +2445,92 @@ static int trace_pid_map_search(const void *a, const void *b)
 	return 0;
 }
 
+static void trace_pid_symbols_free(struct pid_symbol_maps *maps)
+{
+	struct pid_symbol_maps *del;
+	struct pid_function_map *fmap;
+	struct trace_hash_item **bucket;
+	struct trace_hash_item *item;
+
+	while (maps) {
+		del = maps;
+		maps = maps->next;
+		trace_hash_for_each_bucket(bucket, &del->symbols) {
+			trace_hash_while_item(item, bucket) {
+				trace_hash_del(item);
+				fmap = (struct pid_function_map *)item;
+				free(fmap->symb.name);
+				free(fmap->symb.fname);
+				free(fmap);
+			}
+		}
+		trace_hash_free(&del->symbols);
+	}
+}
+
+#define MAX_FUNC_NAME	256
+static int trace_pid_symbols_load(struct tracecmd_input *handle, char *buf)
+{
+	struct pid_symbol_maps *maps = NULL;
+	struct pid_function_map *s;
+	char file[PATH_MAX];
+	char fname[MAX_FUNC_NAME];
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
+	res = sscanf(buf, "%x %d", &maps->pid, &maps->symb_count);
+	if (res != 2)
+		goto out_fail;
+
+	ret  = -ENOMEM;
+	if (trace_hash_init(&maps->symbols, 64) < 0)
+		goto out_fail;
+
+	buf = line + 1;
+	line = strchr(buf, '\n');
+	for (i = 0; i < maps->symb_count; i++) {
+		if (!line)
+			break;
+		*line = '\0';
+		s = calloc(1, sizeof(*s));
+		if (!s)
+			goto out_fail;
+		res = sscanf(buf, "%"STRINGIFY(PATH_MAX)"s %"STRINGIFY(MAX_FUNC_NAME)"s %llx %llx",
+				file, fname, &s->symb.vma_start, &s->symb.vma_near);
+		if (res != 4)
+			break;
+		s->symb.fname = strdup(file);
+		s->symb.name = strdup(fname);
+		if (!s->symb.fname || !s->symb.name)
+			goto out_fail;
+		s->hash.key = trace_hash(s->symb.vma_near);
+		trace_hash_add(&maps->symbols, (struct trace_hash_item *)s);
+		buf = line + 1;
+		line = strchr(buf, '\n');
+	}
+
+	maps->next = handle->pid_symbols;
+	handle->pid_symbols = maps;
+
+	return 0;
+
+out_fail:
+	trace_pid_symbols_free(maps);
+	return ret;
+}
+
 /**
  * tracecmd_search_task_map - Search task memory address map
  * @handle: input handle to the trace.dat file
@@ -2469,6 +2570,43 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 	return lib;
 }
 
+/**
+ * tracecmd_search_task_symbol - Resolve address to function name
+ * @handle: input handle to the trace.dat file
+ * @pid: pid of the task, which function information is stored in the trace.dat
+ * @addr: address of the function
+ *
+ * Mapping of some functions to addresses of traced PIDs can be saved in the
+ * trace.dat file, using the "perf" sub command. If there is such information,
+ * this API can be used to look up into this function maps to find the name of
+ * the function and the name of the file where that function is loaded.
+ *
+ * A pointer to struct tracecmd_debug_symbols is returned, containing information
+ * about the reuquested @addr: the name of the function, its start address, the
+ * name of the binary file that contains the function.
+ */
+struct tracecmd_debug_symbols *
+tracecmd_search_task_symbol(struct tracecmd_input *handle,
+			    int pid, unsigned long long addr)
+{
+	struct pid_function_map *symb = NULL;
+	struct pid_symbol_maps	*map;
+
+	for (map = handle->pid_symbols; map; map = map->next) {
+		if (pid == map->pid)
+			break;
+	}
+
+	if (map)
+		symb = (struct pid_function_map *)trace_hash_find(&map->symbols,
+								  trace_hash(addr), NULL, NULL);
+
+	if (symb)
+		return &symb->symb;
+
+	return NULL;
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	long long offset;
@@ -2610,6 +2748,10 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_GUEST:
 			trace_guest_load(handle, buf, size);
 			break;
+		case TRACECMD_OPTION_PID_SYMBOLS:
+			if (buf[size-1] == '\0')
+				trace_pid_symbols_load(handle, buf);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
@@ -3352,6 +3494,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 
 	trace_pid_map_free(handle->pid_maps);
 	handle->pid_maps = NULL;
+	trace_pid_symbols_free(handle->pid_symbols);
+	handle->pid_symbols = NULL;
 
 	trace_tsync_offset_free(&handle->host);
 	trace_guests_free(handle);
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 5642f12a..5c6992c8 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -530,6 +530,9 @@ static void dump_options(int fd)
 		case TRACECMD_OPTION_GUEST:
 			dump_option_guest(fd, size);
 			break;
+		case TRACECMD_OPTION_PID_SYMBOLS:
+			dump_option_string(fd, size, "PIDSYMBOLS");
+			break;
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
-- 
2.26.2

