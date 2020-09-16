Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB824C43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 17:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC5D222E7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 17:29:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HFJmt1G6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgIPR3I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 13:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgIPR2l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:28:41 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47581C0698DD
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Sep 2020 04:47:21 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z4so6599489wrr.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Sep 2020 04:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lk8IoeI8y1RdU8bARSZNTgJ82CVqPIQZc0BIlBjMe2U=;
        b=HFJmt1G6KAvuosmzknaEUOJv9qTLtEW99XpWNAg6w//cCZs6rRRfsEKkzLsmaLuOKo
         xs8BtK5M/ER3aHYPuykd/H1q8ZEBj+dGGBtJCIwNo7ZdgRIRADJKLeLrXRTsr0ffeRY8
         h2Pu9dnn9vsbw2GT0khD0/FCEam1wmthr+WLCYT922jujSWCY7uKZnYCiFKETUnshizE
         zgNiTwRQ1mhf5+lbD4/Uv98SHUBcoyjb6WD3m14+gTuC4V8UJ7VlkrkI0OEgaWWN52dA
         qiTvbWHOXFM72TqIz+bxCLdikpkR6JHg6sIzJ4qf5vHrY9Xz2artluDgcdsqN0ur66sw
         bOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lk8IoeI8y1RdU8bARSZNTgJ82CVqPIQZc0BIlBjMe2U=;
        b=BBB4jJNyuhAbkDTe+3vvZTWRgJkvhoZ/LTNiKiSbplP7wjROJ6ZXwToBkcWZi/Cgzb
         6l+VfQl29lgOUpHh87aaoSPgwlm5oVaq/6QvNwA3IdksSFmuHnZntkXccw2q30a38cvA
         y039uDeMk5gkmWBTfbvWlHPTuRY8XsnNgYP+RmD5d81f1dse86WScJbmVYFhw52aJyJi
         b5538pycJd7act8BjiSbav9nzQV6ovmVsNomDAwCli+eiVHS5GBkY3D6UCEAodosz5kg
         ZFbqOCtH4+UvePWqa/zClr/HObV1YBiGkPnMAQFDuGQFoGPOiHvh29+SuZATUMuHRT8T
         8dWQ==
X-Gm-Message-State: AOAM533SmgZYGHHMZll/OpjVxk0yKFGh8Oou5YE3z/WP6BjpD7/05YNl
        rbhyRrO7bmv5FoMU3KjJdOoLJR+YIs/4JQ==
X-Google-Smtp-Source: ABdhPJwcVOTzHUMUyt4fkEANK1qASDfbO1sG7mywW2sKEYvKYFPjZ8SzkS6S8xdZDxnC2j4oXjVfiw==
X-Received: by 2002:adf:8b1d:: with SMTP id n29mr25296171wra.383.1600256834810;
        Wed, 16 Sep 2020 04:47:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z13sm32042040wro.97.2020.09.16.04.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 04:47:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/3] trace-cmd: [POC] Add support for uprobes
Date:   Wed, 16 Sep 2020 14:47:09 +0300
Message-Id: <20200916114709.291533-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916114709.291533-1-tz.stoyanov@gmail.com>
References: <20200916114709.291533-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial implementaton of trace-cmd support for ftrace uprobes.
Two new trace-cmd record / set argumemnts are introduced:
 --uprobe file:function
 --uprobe-ret file:function
The ftrace (return) probe is set on given function from the file.
Wildcards are supported in the function name:
 --uprobe file:*
will set uprobes on all functions from the given file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h  |   1 +
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  18 +++
 tracecmd/trace-record.c        |  86 ++++++++++++-
 tracecmd/trace-uprobes.c       | 221 +++++++++++++++++++++++++++++++++
 tracecmd/trace-usage.c         |   4 +
 6 files changed, 330 insertions(+), 1 deletion(-)
 create mode 100644 tracecmd/trace-uprobes.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 5ebd076e..47dc4c4e 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -7,6 +7,7 @@
 #define _TRACE_CMD_H
 
 #include "traceevent/event-parse.h"
+#include "tracefs.h"
 
 #define TRACECMD_MAGIC { 23, 8, 68 }
 
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
index ccae61d4..8fc9f48c 100644
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
+int tracecmd_uprobe_new(struct tracecmd_uprobe **list, char *file, char *func);
+int tracecmd_uprobe_remove(struct tracecmd_uprobe *probes);
+void tracecmd_uprobe_free(struct tracecmd_uprobe *probes);
+int tracecmd_uprobe_create(struct tracecmd_uprobe *probes, bool uret);
+
 struct buffer_instance {
 	struct buffer_instance	*next;
 	struct tracefs_instance	*tracefs;
@@ -208,6 +223,9 @@ struct buffer_instance {
 	struct func_list	*filter_funcs;
 	struct func_list	*notrace_funcs;
 
+	struct tracecmd_uprobe	*uprobes;
+	struct tracecmd_uprobe	*uretprobes;
+
 	struct opt_list		*options;
 	struct filter_pids	*filter_pids;
 	struct filter_pids	*process_pids;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a48475b3..0fbc25e0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5023,7 +5023,8 @@ static void check_function_plugin(void)
 static int __check_doing_something(struct buffer_instance *instance)
 {
 	return is_guest(instance) || (instance->flags & BUFFER_FL_PROFILE) ||
-		instance->plugin || instance->events || instance->get_procmap;
+		instance->plugin || instance->events || instance->get_procmap ||
+		instance->uprobes || instance->uretprobes;
 }
 
 static void check_doing_something(void)
@@ -5438,6 +5439,8 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_retuprobe		= 239,
+	OPT_uprobe		= 240,
 	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
 	OPT_user		= 243,
@@ -5627,6 +5630,25 @@ void trace_reset(int argc, char **argv)
 	exit(0);
 }
 
+static int
+uprobe_param(struct buffer_instance *instance, char *param, bool pret)
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
+		return tracecmd_uprobe_new(&instance->uretprobes, file, func);
+	else
+		return tracecmd_uprobe_new(&instance->uprobes, file, func);
+}
+
 static void init_common_record_context(struct common_record_context *ctx,
 				       enum trace_cmd curr_cmd)
 {
@@ -5781,6 +5803,8 @@ static void parse_record_options(int argc,
 			{"module", required_argument, NULL, OPT_module},
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
+			{"uprobe", required_argument, NULL, OPT_uprobe},
+			{"uprobe-ret", required_argument, NULL, OPT_retuprobe},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6180,6 +6204,14 @@ static void parse_record_options(int argc,
 				die("--fork option used for 'start' command only");
 			fork_process = true;
 			break;
+		case OPT_uprobe:
+			check_instance_die(ctx->instance, "--uprobe");
+			uprobe_param(ctx->instance, optarg, false);
+			break;
+		case OPT_retuprobe:
+			check_instance_die(ctx->instance, "--uprobe-ret");
+			uprobe_param(ctx->instance, optarg, true);
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
@@ -6291,6 +6323,17 @@ static void finalize_record_trace(struct common_record_context *ctx)
 
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
@@ -6322,6 +6365,37 @@ static bool has_local_instances(void)
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
@@ -6365,6 +6439,16 @@ static void record_trace(int argc, char **argv,
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
index 00000000..87f8c148
--- /dev/null
+++ b/tracecmd/trace-uprobes.c
@@ -0,0 +1,221 @@
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
+ *
+ * Returns 0 on success or -1 on failure
+ */
+int tracecmd_uprobe_new(struct tracecmd_uprobe **list, char *file, char *func)
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
+		probe->debug = trace_debug_obj_create_file(file);
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
index 3f0b2d07..59708070 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -65,6 +65,8 @@ static struct usage_help usage_help[] = {
 		"               If a negative number is specified, timestamps synchronization is disabled"
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
+		"          --uprobe set the specified [file:function] as uprobe\n"
+		"          --uprobe-ret set the specified [file:function] as return uprobe\n"
 	},
 	{
 		"set",
@@ -101,6 +103,8 @@ static struct usage_help usage_help[] = {
 		"          --cmdlines-size change kernel saved_cmdlines_size\n"
 		"          --user execute the specified [command ...] as given user\n"
 		"          --fork return immediately if a command is specified\n"
+		"          --uprobe set the specified [file:function] as uprobe\n"
+		"          --uprobe-ret set the specified [file:function] as return uprobe\n"
 	},
 	{
 		"start",
-- 
2.26.2

