Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B887C5519F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Nov 2020 10:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2529E206E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Nov 2020 10:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f1CvM6//"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgKYKoa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Nov 2020 05:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbgKYKoa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Nov 2020 05:44:30 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D5DC0613D6
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 02:44:30 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t4so1390100wrr.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 02:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PCY7JCgMO/J9mvY26jb/iuUqLrIOsCoFGR/P9r95hWE=;
        b=f1CvM6//qNaaQO6SeUpAzL6GcOAPgSzgwva9f/TOBUbf5nMajUa0DSyvRb7+xJXyz8
         7oUUwnFTt+wuOJT9tFIlPdaN1n4n0GgLKoKk1m9qac2XFS3YMLgob4tU5rOM1+jWn9Zq
         ac46ocyiTWK/gV4MGJ6FW+tmHLz0uiSUw/ITfjKfkFJzVt4J01WHVzvjJimG1HTbKZcC
         SPbWqL6SYVq7XtZosjwXJo/5DAKOY02CTV6tjhY3QUvAJwhQ6M7w0G6R64s1pkdNs9D/
         OQBRg/g8ijdagw/zNTflSI3USivtQlHE3hrWmg50pipPjmgORq7OEdIaUC7a7OWiBARQ
         77qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PCY7JCgMO/J9mvY26jb/iuUqLrIOsCoFGR/P9r95hWE=;
        b=EI7OCGT/qVcJLBd8ZctBFQz0rK+qOk7NWnlcFNvqJfUbQ80qAq+6V6wCLvAF6Ytvcd
         FqF8iELJ3zEsb6a5JtPwqH1e3xWv8y877PIIR03738s1Ae8EQlQiZs6rKNOW4y8irjTm
         9I1ID39Y1sntXCnuEHpWqRm3/RoZjgKATpMaOE5ztZkWO2b0Txsav792vQ5Je4QdisDu
         7OddzQvB5TY8iQ0yQY4ohagkK/eKLbDl+FxLwgfxwb6It/AH1iAp6HQF0j/sM+v+2LAY
         xuSHXxs0OIeBDJpe9MZQwoii04653fBoOxVbhVi/dXBt0N0b3ZDBUYqb+OPK58DXanZs
         y2BA==
X-Gm-Message-State: AOAM533I/+OPthzjPdAEZ+bZbWRSPYasv7JV6kf/hu37/WbElH47JVRQ
        oaOPF++lHEJXe+nPqGHCDJtoNK+Cb6gshlZm
X-Google-Smtp-Source: ABdhPJyUtqP23GEKHHqQ+8X/rXMnpPaAf/PtGYWcEMwUbVNrSpBra2PsTsHOz30CSW85pQ0HpI7tpg==
X-Received: by 2002:adf:82cc:: with SMTP id 70mr3399651wrc.74.1606301068659;
        Wed, 25 Nov 2020 02:44:28 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s4sm4026243wro.10.2020.11.25.02.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 02:44:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/3] trace-cmd: [POC] Add support for uprobes
Date:   Wed, 25 Nov 2020 12:44:22 +0200
Message-Id: <20201125104422.823216-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201125104422.823216-1-tz.stoyanov@gmail.com>
References: <20201125104422.823216-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial implementaton of trace-cmd support for ftrace uprobes.
New trace-cmd record / set arguments are introduced:
 --uprobe file:function
 --uprobe-ret file:function
The ftrace (return) probe is set on the given function from the file.
Wildcards '*' and '?' are supported in the function name:
 --uprobe file:*
will set uprobes on all functions from the given file.
Set uprobes on related libraries:
 --libs
 --no-libs
When set before --uprobe/--uprobe-ret argument, specifies whether
to search or not for the given function in the libraries, that the
given executable file depends on. By default, uprobes are set only for
the matched functions in the given executable, no search in related
libraries. The --libs/--no-libs argument affects all --uprobe/--uprobe-ret
argumenst, specified after it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  18 +++
 tracecmd/trace-record.c        |  97 +++++++++++++-
 tracecmd/trace-uprobes.c       | 223 +++++++++++++++++++++++++++++++++
 tracecmd/trace-usage.c         |   8 ++
 5 files changed, 346 insertions(+), 1 deletion(-)
 create mode 100644 tracecmd/trace-uprobes.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index f9435558..37a5c42b 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -32,6 +32,7 @@ TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-obj-debug.o
+TRACE_CMD_OBJS += trace-uprobes.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-tsync.o
 endif
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 933360a5..d3b767cf 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -189,6 +189,21 @@ struct filter_pids {
 	int exclude;
 };
 
+struct tracecmd_uprobe {
+	struct tracecmd_uprobe *next;
+
+	char *file;
+	int pcount;
+	struct trace_debug_object *debug;
+	char **events;
+	int ecount;
+	int esize;
+};
+int tracecmd_uprobe_new(struct tracecmd_uprobe **list, char *file, char *func, bool libs);
+int tracecmd_uprobe_remove(struct tracecmd_uprobe *probes);
+void tracecmd_uprobe_free(struct tracecmd_uprobe *probes);
+int tracecmd_uprobe_create(struct tracecmd_uprobe *probes, bool uret);
+
 struct buffer_instance {
 	struct buffer_instance	*next;
 	char			*name;
@@ -209,6 +224,9 @@ struct buffer_instance {
 	struct func_list	*filter_funcs;
 	struct func_list	*notrace_funcs;
 
+	struct tracecmd_uprobe	*uprobes;
+	struct tracecmd_uprobe	*uretprobes;
+
 	struct opt_list		*options;
 	struct filter_pids	*filter_pids;
 	struct filter_pids	*process_pids;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ea424339..b255a27e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5016,7 +5016,8 @@ static void check_function_plugin(void)
 static int __check_doing_something(struct buffer_instance *instance)
 {
 	return is_guest(instance) || (instance->flags & BUFFER_FL_PROFILE) ||
-		instance->plugin || instance->events || instance->get_procmap;
+		instance->plugin || instance->events || instance->get_procmap ||
+		instance->uprobes || instance->uretprobes;
 }
 
 static void check_doing_something(void)
@@ -5431,6 +5432,10 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_nolibs		= 237,
+	OPT_libs		= 238,
+	OPT_retuprobe		= 239,
+	OPT_uprobe		= 240,
 	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
 	OPT_user		= 243,
@@ -5620,6 +5625,25 @@ void trace_reset(int argc, char **argv)
 	exit(0);
 }
 
+static int
+uprobe_param(struct buffer_instance *instance, char *param, bool pret, bool libs)
+{
+	char *str, *file, *func;
+
+	if (!param)
+		return -1;
+
+	file = strtok_r(param, ":", &str);
+	func = strtok_r(NULL, ":", &str);
+
+	if (!file || !func)
+		return -1;
+	if (pret)
+		return tracecmd_uprobe_new(&instance->uretprobes, file, func, libs);
+	else
+		return tracecmd_uprobe_new(&instance->uprobes, file, func, libs);
+}
+
 static void init_common_record_context(struct common_record_context *ctx,
 				       enum trace_cmd curr_cmd)
 {
@@ -5744,6 +5768,7 @@ static void parse_record_options(int argc,
 	bool guest_sync_set = false;
 	int do_children = 0;
 	int fpids_count = 0;
+	bool libs = false;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5775,6 +5800,10 @@ static void parse_record_options(int argc,
 			{"module", required_argument, NULL, OPT_module},
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
+			{"uprobe", required_argument, NULL, OPT_uprobe},
+			{"uprobe-ret", required_argument, NULL, OPT_retuprobe},
+			{"libs", no_argument, NULL, OPT_libs},
+			{"no-libs", no_argument, NULL, OPT_nolibs},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6174,6 +6203,20 @@ static void parse_record_options(int argc,
 				die("--fork option used for 'start' command only");
 			fork_process = true;
 			break;
+		case OPT_libs:
+			libs = true;
+			break;
+		case OPT_nolibs:
+			libs = false;
+			break;
+		case OPT_uprobe:
+			check_instance_die(ctx->instance, "--uprobe");
+			uprobe_param(ctx->instance, optarg, false, libs);
+			break;
+		case OPT_retuprobe:
+			check_instance_die(ctx->instance, "--uprobe-ret");
+			uprobe_param(ctx->instance, optarg, true, libs);
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
@@ -6285,6 +6328,17 @@ static void finalize_record_trace(struct common_record_context *ctx)
 
 	set_plugin("nop");
 
+	for_all_instances(instance) {
+		if (instance->uprobes) {
+			tracecmd_uprobe_remove(instance->uprobes);
+			tracecmd_uprobe_free(instance->uprobes);
+		}
+		if (instance->uretprobes) {
+			tracecmd_uprobe_remove(instance->uretprobes);
+			tracecmd_uprobe_free(instance->uretprobes);
+		}
+	}
+
 	tracecmd_remove_instances();
 
 	/* If tracing_on was enabled before we started, set it on now */
@@ -6316,6 +6370,37 @@ static bool has_local_instances(void)
 	return false;
 }
 
+static int uprobes_set(struct buffer_instance *instance, bool ret_probe)
+{
+	struct tracecmd_uprobe *list;
+	struct event_list *event;
+	int i, ret;
+
+	if (ret_probe)
+		list = instance->uretprobes;
+	else
+		list = instance->uprobes;
+
+	ret = tracecmd_uprobe_create(list, ret_probe);
+	if (ret < 0)
+		return ret;
+	for (i = 0; i < list->ecount; i++) {
+		event = calloc(1, sizeof(*event));
+		if (!event)
+			break;
+
+		event->event = strdup(list->events[i]);
+		add_event(instance, event);
+
+		if (!recording_all_events())
+			list_event(event->event);
+	}
+
+	if (i < list->ecount)
+		return -1;
+	return 0;
+}
+
 /*
  * This function contains common code for the following commands:
  * record, start, stream, profile.
@@ -6359,6 +6444,16 @@ static void record_trace(int argc, char **argv,
 		/* Some instances may not be created yet */
 		if (instance->tracing_on_init_val < 0)
 			instance->tracing_on_init_val = 1;
+		if (instance->uprobes) {
+			ctx->events = 1;
+			if (uprobes_set(instance, false) < 0)
+				die("Failed to set uprobes");
+		}
+		if (instance->uretprobes) {
+			ctx->events = 1;
+			if (uprobes_set(instance, true) < 0)
+				die("Failed to set return uprobes");
+		}
 	}
 
 	if (ctx->events)
diff --git a/tracecmd/trace-uprobes.c b/tracecmd/trace-uprobes.c
new file mode 100644
index 00000000..b0641100
--- /dev/null
+++ b/tracecmd/trace-uprobes.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <linux/limits.h>
+#include <ctype.h>
+
+#include "tracefs.h"
+#include "trace-local.h"
+#include "trace-cmd.h"
+
+#define UPROBE_FILE "uprobe_events"
+
+static char *uprobe_event_name(char *file, char *func, bool pret)
+{
+	char *event = NULL;
+	char *fname;
+	int i;
+
+	fname = strrchr(file, '/');
+	if (fname)
+		fname++;
+	if (!fname || *fname == '\0')
+		fname = file;
+
+	asprintf(&event, "%c_%.*s_%.10s", pret ? 'r':'p', 10, fname, func);
+	if (event) {
+		for (i = 0; event[i]; i++) {
+			if (!isalpha(event[i]))
+				event[i] = '_';
+		}
+	}
+	return event;
+}
+
+/**
+ * tracecmd_uprobe_new - Add new uprobe in the uprobe list
+ * @list - list with uprobes, the new one will be added in this list
+ * @file - executable file that will be traced
+ * @func - function from @file
+ * @pret - indicate if this is return probe (true for return uprobe)
+ * @libs - indicate if to load the libraries that the given executable @file
+ *	   depends on, match the given @func and set uprobes on them too.
+ *
+ * Returns 0 on success or -1 on failure
+ */
+int tracecmd_uprobe_new(struct tracecmd_uprobe **list, char *file, char *func, bool libs)
+{
+	struct tracecmd_uprobe *probe = *list;
+	bool new_file = false;
+
+	while (probe) {
+		if (!strcmp(probe->file, file))
+			break;
+		probe = probe->next;
+	}
+
+	if (!probe) {
+		probe = calloc(1, sizeof(*probe));
+		if (!probe)
+			return -1;
+
+		probe->file = strdup(file);
+		probe->next = *list;
+		probe->debug = trace_debug_obj_create_file(file, libs);
+		if (!probe->debug)
+			goto error;
+		new_file = true;
+	}
+
+	if (trace_debug_add_resolve_symbol(probe->debug, 0, func) < 0)
+		goto error;
+	probe->pcount++;
+	if (new_file)
+		*list = probe;
+
+	return 0;
+
+error:
+	if (new_file) {
+		if (probe && probe->debug)
+			trace_debug_obj_destroy(probe->debug);
+		free(probe);
+	}
+
+	return -1;
+}
+
+/**
+ * tracecmd_uprobe_free - Free uprobe list
+ * @list - list with uprobes, that wil be freed
+ *
+ */
+void tracecmd_uprobe_free(struct tracecmd_uprobe *probes)
+{
+	struct tracecmd_uprobe *del;
+
+	while (probes) {
+		del = probes;
+		probes = probes->next;
+		trace_debug_obj_destroy(del->debug);
+		free(del->events);
+		free(del->file);
+		free(del);
+	}
+}
+
+struct uprobe_walk {
+	struct tracecmd_uprobe *probe;
+	bool uret;
+	int fd;
+};
+
+static int uprobe_write(struct tracecmd_debug_symbols *symbol, void *data)
+{
+	struct uprobe_walk *context = (struct uprobe_walk *)data;
+	char **events;
+	char probe_str[BUFSIZ];
+
+	if (!symbol->foffset || !symbol->name)
+		return 0;
+
+	if (context->probe->ecount == context->probe->esize) {
+		events = realloc(context->probe->events,
+				 (context->probe->esize + 1) * sizeof(char *));
+		if (events) {
+			context->probe->esize++;
+			context->probe->events = events;
+		}
+	}
+	if (!context->probe->events)
+		return -1;
+
+	context->probe->events[context->probe->ecount] = uprobe_event_name(symbol->fname, symbol->name, context->uret);
+	if (!context->probe->events[context->probe->ecount])
+		return -1;
+	snprintf(probe_str, BUFSIZ,
+		 "%c:%s %s:0x%llx", context->uret?'r':'p',
+		 context->probe->events[context->probe->ecount],
+		 symbol->fname, symbol->foffset);
+	write(context->fd, probe_str, strlen(probe_str));
+	context->probe->ecount++;
+
+	return 0;
+}
+
+/**
+ * tracecmd_uprobe_create - Create uprobes in ftrace
+ * @list - list with uprobes, that will be created
+ *
+ * Returns 0 on success or -1 on failure
+ */
+int tracecmd_uprobe_create(struct tracecmd_uprobe *probes, bool uret)
+{
+	char *ufile = tracefs_instance_get_file(NULL, UPROBE_FILE);
+	struct tracecmd_uprobe *probe = probes;
+	struct uprobe_walk context;
+
+	if (!ufile)
+		return -1;
+	context.uret = uret;
+	context.fd = open(ufile, O_WRONLY | O_APPEND);
+	tracefs_put_tracing_file(ufile);
+
+	while (probe) {
+		context.probe = probe;
+		if (trace_debug_resolve_symbols(probe->debug) == 0) {
+			if (!probe->events) {
+				probe->esize = probe->pcount;
+				probe->events = calloc(probe->esize, sizeof(char *));
+			}
+			trace_debug_walk_resolved_symbols(probe->debug,
+							  uprobe_write,
+							  (void *)&context);
+		}
+		probe = probe->next;
+	}
+	close(context.fd);
+
+	return 0;
+}
+
+/**
+ * tracecmd_uprobe_remove - Remove uprobes from ftrace
+ * @list - list with uprobes, that will be removed
+ *
+ * Returns 0 on success or -1 on failure
+ */
+int tracecmd_uprobe_remove(struct tracecmd_uprobe *probes)
+{
+	char *ufile = tracefs_instance_get_file(NULL, UPROBE_FILE);
+	struct tracecmd_uprobe *probe = probes;
+	char probe_str[BUFSIZ];
+	int fd;
+	int i;
+
+	if (!ufile)
+		return -1;
+	fd = open(ufile, O_WRONLY | O_APPEND);
+	tracefs_put_tracing_file(ufile);
+	if (fd < 0)
+		return -1;
+
+	while (probe) {
+		if (probe->events) {
+			for (i = 0; i < probe->ecount; i++) {
+				snprintf(probe_str, BUFSIZ,
+					 "-:%s", probe->events[i]);
+				write(fd, probe_str, strlen(probe_str));
+			}
+		}
+
+		probe = probe->next;
+	}
+
+	close(fd);
+	return 0;
+}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 3f0b2d07..49628d6b 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -65,6 +65,10 @@ static struct usage_help usage_help[] = {
 		"               If a negative number is specified, timestamps synchronization is disabled"
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
+		"          --uprobe set the specified [file:function] as uprobe\n"
+		"          --uprobe-ret set the specified [file:function] as return uprobe\n"
+		"          --libs affects all --uprobe/--uprobe-ret after it: set uprobes on the libraries, that the application depends on\n"
+		"          --no-libs affects all --uprobe/--uprobe-ret after it: do not set uprobes on the libraries, that the application depends on\n"
 	},
 	{
 		"set",
@@ -101,6 +105,10 @@ static struct usage_help usage_help[] = {
 		"          --cmdlines-size change kernel saved_cmdlines_size\n"
 		"          --user execute the specified [command ...] as given user\n"
 		"          --fork return immediately if a command is specified\n"
+		"          --uprobe set the specified [file:function] as uprobe\n"
+		"          --uprobe-ret set the specified [file:function] as return uprobe\n"
+		"          --libs affects all --uprobe/--uprobe-ret after it: set uprobes on the libraries, that the application depends on\n"
+		"          --no-libs affects all --uprobe/--uprobe-ret after it: do not set uprobes on the libraries, that the application depends on\n"
 	},
 	{
 		"start",
-- 
2.28.0

